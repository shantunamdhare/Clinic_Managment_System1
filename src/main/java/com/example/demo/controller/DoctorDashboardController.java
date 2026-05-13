package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.PrescriptionPdfService;
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
import java.io.ByteArrayInputStream;

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
    @Autowired private MedicineRepository medicineRepo;
    @Autowired private NotificationRepository notificationRepo;
    @Autowired private PrescriptionPdfService pdfService;
    @Autowired private LeaveRequestRepository leaveRequestRepository;

    @GetMapping("/prescriptions/download/{id}")
    public org.springframework.http.ResponseEntity<org.springframework.core.io.InputStreamResource> downloadPdf(@PathVariable Long id) {
        Prescription rx = prescriptionRepo.findById(id).orElse(null);
        if (rx == null) return org.springframework.http.ResponseEntity.notFound().build();

        ByteArrayInputStream bis = pdfService.generatePrescriptionPdf(rx);

        org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
        headers.add("Content-Disposition", "attachment; filename=prescription_" + rx.getPrescriptionId() + ".pdf");

        return org.springframework.http.ResponseEntity
                .ok()
                .headers(headers)
                .contentType(org.springframework.http.MediaType.APPLICATION_PDF)
                .body(new org.springframework.core.io.InputStreamResource(bis));
    }


    // -------------------------------------------------------
    // Helper: Get Logged-in User from Session (Harmonized)
    // -------------------------------------------------------
    private User getLoggedInDoctor(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null && "Doctor".equalsIgnoreCase(user.getRole())) {
            return user;
        }
        return null;
    }

    @ModelAttribute("pendingAppointmentCount")
    public long getPendingAppointmentCount(HttpSession session) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return 0;
        // Count today's pending/scheduled appointments
        return appointmentRepo.findByDoctorAndAppointmentDate(doctor, LocalDate.now()).stream()
                .filter(a -> "Scheduled".equalsIgnoreCase(a.getStatus()) || "Pending".equalsIgnoreCase(a.getStatus()))
                .count();
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
        model.addAttribute("leaveRequests", leaveRequestRepository.findByUserOrderBySubmittedAtDesc(doctor));
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
            session.setAttribute("user", dbDoctor);
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
        model.addAttribute("patients", patientRepo.findAll());

        if (visitId != null) {
            visitRepo.findById(visitId).ifPresent(v -> {
                model.addAttribute("selectedVisit", v);
                model.addAttribute("selectedPatient", v.getPatient());
                model.addAttribute("prescriptions", prescriptionRepo.findByVisit(v));
            });
        }
        return "doctor/prescriptions";
    }

    @GetMapping("/prescriptions/api/search-medicines")
    @ResponseBody
    public List<Medicine> searchMedicines(@RequestParam String query) {
        return medicineRepo.findByNameContainingIgnoreCase(query);
    }

    @GetMapping("/prescriptions/save-full")
    public String saveFullPrescriptionGet() {
        return "redirect:/doctor/prescriptions";
    }

    @PostMapping("/prescriptions/save-full")
    public String saveFullPrescription(@RequestParam(required = false) Long patientId,
                                       @RequestParam(required = false) Long visitId,
                                       @RequestParam String status,
                                       @RequestParam(required = false) String notes,
                                       @RequestParam("medName[]") String[] medNames,
                                       @RequestParam("dosage[]") String[] dosages,
                                       @RequestParam("frequency[]") String[] frequencies,
                                       @RequestParam("duration[]") String[] durations,
                                       @RequestParam("quantity[]") Integer[] quantities,
                                       @RequestParam("food[]") String[] foods,
                                       @RequestParam(required = false) Double consultationFee,
                                       HttpSession session,
                                       RedirectAttributes ra) {
        User doctorSession = getLoggedInDoctor(session);
        if (doctorSession == null) return "redirect:/";
        
        // Refresh from DB to ensure we have the latest data (especially the fixed consultation fee)
        User doctor = userRepository.findById(doctorSession.getId()).orElse(doctorSession);
        
        if (patientId == null) {
            ra.addFlashAttribute("error", "Please select a patient.");
            return "redirect:/doctor/prescriptions" + (visitId != null ? "?visitId=" + visitId : "");
        }

        Patient patient = patientRepo.findById(patientId).orElse(null);
        if (patient == null) {
            ra.addFlashAttribute("error", "Patient not found.");
            return "redirect:/doctor/prescriptions";
        }

        Prescription p = new Prescription();
        p.setPatient(patient);
        p.setDoctor(doctor);
        p.setStatus(status);
        p.setNotes(notes);
        
        // Use the consultation fee fixed by the Admin
        p.setConsultationFee(doctor.getConsultationFee() != null ? doctor.getConsultationFee() : 500.0);
        
        if (visitId != null) {
            visitRepo.findById(visitId).ifPresent(p::setVisit);
        }

        if (medNames == null || medNames.length == 0) {
            ra.addFlashAttribute("error", "Please add at least one medicine.");
            return "redirect:/doctor/prescriptions";
        }

        for (int i = 0; i < medNames.length; i++) {
            if (medNames[i] == null || medNames[i].trim().isEmpty()) continue;
            List<Medicine> meds = medicineRepo.findByNameContainingIgnoreCase(medNames[i]);
            if (!meds.isEmpty()) {
                PrescriptionItem item = new PrescriptionItem();
                item.setMedicine(meds.get(0));
                item.setDosage(dosages[i]);
                item.setFrequency(frequencies[i]);
                item.setDuration(durations[i]);
                item.setQuantity(quantities[i]);
                item.setFoodRelation(foods[i]);
                p.addItem(item);
            }
        }

        prescriptionRepo.save(p);

        if ("Pending".equals(status)) {
            // Notify Pharmacy
            List<User> pharmacists = userRepository.findByRole("Pharmacy");
            for (User ph : pharmacists) {
                Notification n = new Notification();
                n.setUser(ph);
                n.setMessage("New Prescription Received: " + p.getPrescriptionId() + " for " + patient.getName());
                n.setType("Urgent");
                notificationRepo.save(n);
            }
        }

        ra.addFlashAttribute("success", "Prescription " + (status.equals("Draft") ? "saved as draft." : "sent to pharmacy."));
        return "redirect:/doctor/prescriptions";
    }

    @GetMapping("/prescriptions/status-updates")
    @ResponseBody
    public List<Prescription> getPrescriptionStatusUpdates(HttpSession session) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return List.of();
        return prescriptionRepo.findByDoctorOrderByCreatedAtDesc(doctor);
    }

    @GetMapping("/notifications/latest")
    @ResponseBody
    public List<Notification> getLatestNotifications(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return List.of();
        return notificationRepo.findByUserAndIsReadOrderByCreatedAtDesc(user, false);
    }

    @PostMapping("/notifications/mark-read")
    @ResponseBody
    public String markNotificationsRead(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            List<Notification> unread = notificationRepo.findByUserAndIsReadOrderByCreatedAtDesc(user, false);
            unread.forEach(n -> n.setRead(true));
            notificationRepo.saveAll(unread);
        }
        return "Success";
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

        // Robust retrieval: Get reports where doctor is assigned OR patients the doctor has seen
        final Long currentDoctorId = doctor.getId();
        final List<Appointment> doctorAppointments = appointmentRepo.findByDoctor(doctor);
        
        List<LabReport> reports = labReportRepo.findAll().stream()
            .filter(r -> {
                LabRequest req = r.getRequest();
                if (req == null) return false;
                // Directly assigned
                if (req.getDoctor() != null && req.getDoctor().getId().equals(currentDoctorId)) return true;
                // Same patient as doctor's appointments
                String patientName = req.getPatient() != null ? req.getPatient().getName() : null;
                if (patientName == null) return false;
                return doctorAppointments.stream()
                    .anyMatch(a -> a.getPatient() != null && patientName.equalsIgnoreCase(a.getPatient().getName()));
            })
            .collect(java.util.stream.Collectors.toList());

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

    @PostMapping("/leave/apply")
    public String applyLeave(@RequestParam String startDate,
                             @RequestParam String endDate,
                             @RequestParam String reason,
                             @RequestParam(required = false, defaultValue = "Full Day") String leaveType,
                             HttpSession session,
                             RedirectAttributes ra) {
        User doctor = getLoggedInDoctor(session);
        if (doctor == null) return "redirect:/";
        
        try {
            LeaveRequest lr = new LeaveRequest(doctor, reason, LocalDate.parse(startDate), LocalDate.parse(endDate), leaveType);
            leaveRequestRepository.save(lr);
            ra.addFlashAttribute("success", "Leave request submitted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Error submitting leave: " + e.getMessage());
        }
        return "redirect:/doctor/dashboard";
    }
}
