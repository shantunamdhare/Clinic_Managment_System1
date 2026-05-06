package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/doctor")
public class DoctorDashboardController {

    @Autowired private AppointmentRepository appointmentRepo;
    @Autowired private PatientRepository patientRepo;
    @Autowired private VisitRepository visitRepo;
    @Autowired private PrescriptionRepository prescriptionRepo;
    @Autowired private LabTestRepository labTestRepo;
    @Autowired private LabRequestRepository labRequestRepo;
    @Autowired private LabReportRepository labReportRepo;
    @Autowired private AvailabilityRepository availabilityRepo;
    @Autowired private UserRepository userRepository;

    // -------------------------------------------------------
    // Helper: Get Logged-in Doctor from Session
    // -------------------------------------------------------
    private User getLoggedInDoctor(HttpSession session) {
        return (User) session.getAttribute("loggedInDoctor");
    }

    // -------------------------------------------------------
    // Dashboard Overview
    // -------------------------------------------------------
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        
        // Refresh from DB to avoid detached entity issues
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);

        long totalPatients = patientRepo.count();
        long todayAppointments = appointmentRepo.countByDoctorAndAppointmentDate(doctor, LocalDate.now());
        long pendingLabReports = labRequestRepo.countByDoctorAndStatus(doctor, "Pending");

        model.addAttribute("doctor", doctor);
        model.addAttribute("totalPatients", totalPatients);
        model.addAttribute("todayAppointments", todayAppointments);
        model.addAttribute("pendingLabReports", pendingLabReports);
        return "doctor-dashboard";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";
        model.addAttribute("doctor", doctor);
        return "doctor/doctor-profile";
    }

    @PostMapping("/profile/save")
    public String saveProfile(@RequestParam String fullName,
                              @RequestParam String phone,
                              @RequestParam String specialization,
                              @RequestParam Integer experience,
                              @RequestParam String licenseId,
                              HttpSession session, RedirectAttributes ra) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";

        // Refresh from DB to ensure we have latest
        User dbDoctor = userRepository.findById(doctor.getId()).orElse(null);
        if (dbDoctor != null) {
            dbDoctor.setFullName(fullName);
            dbDoctor.setPhone(phone);
            dbDoctor.setSpecialization(specialization);
            dbDoctor.setExperience(experience);
            dbDoctor.setLicenseId(licenseId);
            userRepository.save(dbDoctor);
            
            // Update session
            session.setAttribute("loggedInDoctor", dbDoctor);
            ra.addFlashAttribute("success", "Profile updated successfully.");
        }
        return "redirect:/doctor/profile";
    }

    // -------------------------------------------------------
    // Today's Appointments
    // -------------------------------------------------------
    @GetMapping("/appointments")
    public String appointments(HttpSession session, Model model) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);

        List<Appointment> appointments = appointmentRepo.findByDoctorAndAppointmentDate(doctor, LocalDate.now());
        model.addAttribute("doctor", doctor);
        model.addAttribute("appointments", appointments);
        return "doctor/appointments";
    }

    @PostMapping("/appointments/complete/{id}")
    public String markComplete(@PathVariable Long id, RedirectAttributes ra) {
        appointmentRepo.findById(id).ifPresent(a -> {
            a.setStatus("Completed");
            appointmentRepo.save(a);
        });
        ra.addFlashAttribute("success", "Appointment marked as completed.");
        return "redirect:/doctor/appointments";
    }

    // -------------------------------------------------------
    // Patients
    // -------------------------------------------------------
    @GetMapping("/patients")
    public String patients(@RequestParam(required = false) String search,
                           HttpSession session, Model model) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);

        List<Patient> patients;
        if (search != null && !search.isBlank()) {
            patients = patientRepo.findByNameContainingIgnoreCase(search.trim());
        } else {
            patients = patientRepo.findAll();
        }
        model.addAttribute("doctor", doctor);
        model.addAttribute("patients", patients);
        model.addAttribute("search", search);
        return "doctor/patients";
    }

    @GetMapping("/patients/{id}")
    public String patientDetail(@PathVariable Long id, HttpSession session, Model model) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";

        Optional<Patient> optPatient = patientRepo.findById(id);
        if (optPatient.isEmpty()) return "redirect:/doctor/patients";

        Patient patient = optPatient.get();
        List<Visit> visits = visitRepo.findByPatient(patient);

        model.addAttribute("doctor", doctor);
        model.addAttribute("patient", patient);
        model.addAttribute("visits", visits);
        return "doctor/patient-detail";
    }

    @GetMapping("/patients/add")
    public String addPatientForm(HttpSession session, Model model) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";
        model.addAttribute("doctor", doctor);
        return "doctor/patient-form";
    }

    @PostMapping("/patients/save")
    public String savePatient(@RequestParam String name,
                              @RequestParam Integer age,
                              @RequestParam String gender,
                              @RequestParam String contact,
                              RedirectAttributes ra) {
        Patient p = new Patient();
        p.setName(name);
        p.setAge(age);
        p.setGender(gender);
        p.setContact(contact);
        p.setContactNumber(contact);
        
        // Generate missing mandatory fields
        p.setPatientId("PID-" + (int)(Math.random() * 9000 + 1000));
        p.setDateOfBirth(LocalDate.now().minusYears(age)); // Approximate DOB from age
        
        patientRepo.save(p);
        ra.addFlashAttribute("success", "Patient added successfully.");
        return "redirect:/doctor/patients";
    }

    // -------------------------------------------------------
    // EMR (Electronic Medical Records / Visits)
    // -------------------------------------------------------
    @GetMapping("/emr")
    public String emrForm(HttpSession session, Model model) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);

        model.addAttribute("doctor", doctor);
        model.addAttribute("patients", patientRepo.findAll());
        return "doctor/emr";
    }

    @PostMapping("/emr/save")
    public String saveEMR(@RequestParam Long patientId,
                          @RequestParam String symptoms,
                          @RequestParam String diagnosis,
                          @RequestParam String notes,
                          HttpSession session,
                          RedirectAttributes ra) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";

        Patient patient = patientRepo.findById(patientId).orElse(null);
        if (patient == null) {
            ra.addFlashAttribute("error", "Patient not found.");
            return "redirect:/doctor/emr";
        }

        Visit visit = new Visit();
        visit.setPatient(patient);
        visit.setDoctor(doctor);
        visit.setSymptoms(symptoms);
        visit.setDiagnosis(diagnosis);
        visit.setNotes(notes);
        visit.setVisitDate(LocalDate.now());
        visitRepo.save(visit);

        ra.addFlashAttribute("success", "EMR record saved successfully.");
        return "redirect:/doctor/prescriptions?visitId=" + visit.getId();
    }

    // -------------------------------------------------------
    // Prescriptions
    // -------------------------------------------------------
    @GetMapping("/prescriptions")
    public String prescriptions(@RequestParam(required = false) Long visitId,
                                HttpSession session, Model model) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);

        List<Visit> recentVisits = visitRepo.findByDoctorOrderByVisitDateDesc(doctor);
        model.addAttribute("doctor", doctor);
        model.addAttribute("visits", recentVisits);

        if (visitId != null) {
            visitRepo.findById(visitId).ifPresent(v -> {
                model.addAttribute("selectedVisit", v);
                model.addAttribute("prescriptions", prescriptionRepo.findByVisit(v));
            });
        }
        return "doctor/prescriptions";
    }

    @PostMapping("/prescriptions/save")
    public String savePrescription(@RequestParam Long visitId,
                                   @RequestParam String medicine,
                                   @RequestParam String dosage,
                                   @RequestParam String duration,
                                   @RequestParam String instructions,
                                   RedirectAttributes ra) {
        Visit visit = visitRepo.findById(visitId).orElse(null);
        if (visit == null) {
            ra.addFlashAttribute("error", "Visit not found.");
            return "redirect:/doctor/prescriptions";
        }

        Prescription p = new Prescription();
        p.setVisit(visit);
        p.setMedicine(medicine);
        p.setDosage(dosage);
        p.setDuration(duration);
        p.setInstructions(instructions);
        prescriptionRepo.save(p);

        ra.addFlashAttribute("success", "Prescription saved.");
        return "redirect:/doctor/prescriptions?visitId=" + visitId;
    }

    @GetMapping("/prescriptions/print/{visitId}")
    public String printPrescription(@PathVariable Long visitId,
                                    HttpSession session, Model model) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";

        visitRepo.findById(visitId).ifPresent(v -> {
            model.addAttribute("visit", v);
            model.addAttribute("prescriptions", prescriptionRepo.findByVisit(v));
        });
        model.addAttribute("doctor", doctor);
        return "doctor/prescription-print";
    }

    // -------------------------------------------------------
    // Lab Test Requests
    // -------------------------------------------------------
    @GetMapping("/lab-requests")
    public String labRequests(HttpSession session, Model model) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);

        model.addAttribute("doctor", doctor);
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("labTests", labTestRepo.findAll());
        model.addAttribute("laboratories", userRepository.findByRole("Lab"));
        model.addAttribute("requests", labRequestRepo.findByDoctor(doctor));
        return "doctor/lab-requests";
    }

    @PostMapping("/lab-requests/save")
    public String saveLabRequest(@RequestParam Long patientId,
                                 @RequestParam Long testId,
                                 @RequestParam(required = false) Long labId,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";

        Patient patient = patientRepo.findById(patientId).orElse(null);
        LabTest test = labTestRepo.findById(testId).orElse(null);
        User lab = labId != null ? userRepository.findById(labId).orElse(null) : null;

        if (patient == null || test == null) {
            ra.addFlashAttribute("error", "Invalid patient or test selection.");
            return "redirect:/doctor/lab-requests";
        }

        LabRequest req = new LabRequest();
        req.setPatient(patient);
        req.setDoctor(doctor);
        req.setTest(test);
        req.setLab(lab);
        req.setStatus("Pending");
        labRequestRepo.save(req);

        ra.addFlashAttribute("success", "Lab test requested successfully.");
        return "redirect:/doctor/lab-requests";
    }

    // -------------------------------------------------------
    // Lab Reports
    // -------------------------------------------------------
    @GetMapping("/lab-reports")
    public String labReports(HttpSession session, Model model) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);

        List<LabReport> reports = labReportRepo.findByRequest_Doctor(doctor);
        model.addAttribute("doctor", doctor);
        model.addAttribute("reports", reports);
        return "doctor/lab-reports";
    }

    @GetMapping("/reports/view/{id}")
    public String viewReport(@PathVariable Long id, HttpSession session, Model model) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";
        
        labReportRepo.findById(id).ifPresent(report -> {
            model.addAttribute("report", report);
            model.addAttribute("doctor", doctor);
        });
        return "doctor/report-view";
    }

    // -------------------------------------------------------
    // Availability
    // -------------------------------------------------------
    @GetMapping("/availability")
    public String availability(HttpSession session, Model model) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);

        List<Availability> slots = availabilityRepo.findByDoctorOrderByAvailableDateAscStartTimeAsc(doctor);
        model.addAttribute("doctor", doctor);
        model.addAttribute("slots", slots);
        return "doctor/availability";
    }

    @PostMapping("/availability/save")
    public String saveAvailability(@RequestParam String availableDate,
                                   @RequestParam String startTime,
                                   @RequestParam String endTime,
                                   HttpSession session,
                                   RedirectAttributes ra) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";

        LocalDate date = LocalDate.parse(availableDate);
        LocalTime start = LocalTime.parse(startTime);
        LocalTime end = LocalTime.parse(endTime);

        if (!end.isAfter(start)) {
            ra.addFlashAttribute("error", "End time must be after start time.");
            return "redirect:/doctor/availability";
        }

        boolean overlaps = availabilityRepo
                .existsByDoctorAndAvailableDateAndStartTimeLessThanAndEndTimeGreaterThan(
                        doctor, date, end, start);
        if (overlaps) {
            ra.addFlashAttribute("error", "This slot overlaps with an existing slot.");
            return "redirect:/doctor/availability";
        }

        Availability slot = new Availability();
        slot.setDoctor(doctor);
        slot.setAvailableDate(date);
        slot.setStartTime(start);
        slot.setEndTime(end);
        availabilityRepo.save(slot);

        ra.addFlashAttribute("success", "Availability slot saved.");
        return "redirect:/doctor/availability";
    }

    @PostMapping("/availability/delete/{id}")
    public String deleteAvailability(@PathVariable Long id, RedirectAttributes ra) {
        availabilityRepo.deleteById(id);
        ra.addFlashAttribute("success", "Slot deleted.");
        return "redirect:/doctor/availability";
    }
}
