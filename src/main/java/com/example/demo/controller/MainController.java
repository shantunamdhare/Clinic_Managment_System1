package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.*;

@Controller
public class MainController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private LabRequestRepository labRequestRepository;

    @Autowired
    private LabReportRepository labReportRepository;

    @Autowired
    private LabTestRepository labTestRepo;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private AvailabilityRepository availabilityRepository;

    @Autowired
    private VisitRepository visitRepository;

    @Autowired
    private PrescriptionRepository prescriptionRepository;

    @Autowired
    private InvoiceRepository invoiceRepository;

    @Autowired
    private AttendanceRepository attendanceRepo;

    @Autowired
    private StaffShiftRepository staffShiftRepo;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ========================
    // Landing Page
    // ========================
    @GetMapping("/")
    public String landingPage() {
        return "landing";
    }

    // ========================
    // User Registration
    // ========================
    @PostMapping("/register")
    public String registerUser(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String role,
            @RequestParam(required = false) String labName,
            @RequestParam(required = false) String labAddress,
            @RequestParam(required = false) String labId,
            @RequestParam(required = false) String labType,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String specialization,
            @RequestParam(required = false) Integer experience,
            @RequestParam(required = false) String licenseId,
            @RequestParam(required = false) String deliveryPhone,
            @RequestParam(required = false) String vehicleType,
            @RequestParam(required = false) String adminId,
            @RequestParam(required = false) String clinicName,
            @RequestParam(required = false) Integer age,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String pharmacyName,
            @RequestParam(required = false) String pharmacyAddress,
            @RequestParam(required = false) String pharmacyLicense,
            @RequestParam(required = false) String staffPhone,
            @RequestParam(required = false) String staffId,
            @RequestParam(required = false) String hospitalName,
            RedirectAttributes redirectAttributes) {

        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("registerError", "Passwords do not match!");
            return "redirect:/#register-section";
        }

        if (userRepository.existsByEmail(email)) {
            redirectAttributes.addFlashAttribute("registerError", "Email already registered!");
            return "redirect:/#register-section";
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole(role);
        user.setGender(gender);
        
        // Role specific mapping
        if ("Doctor".equalsIgnoreCase(role)) {
            user.setPhone(phone);
            user.setSpecialization(specialization);
            user.setExperience(experience);
            user.setLicenseId(licenseId);
        } else if ("Lab".equalsIgnoreCase(role)) {
            user.setLabName(labName);
            user.setLabAddress(labAddress);
            user.setLabId(labId);
            user.setLabType(labType);
        } else if ("Receptionist".equalsIgnoreCase(role) || "RECEPTIONIST".equalsIgnoreCase(role)) {
            user.setPhone(phone);
        } else if ("Delivery".equalsIgnoreCase(role)) {
            user.setPhone(deliveryPhone);
            user.setVehicleType(vehicleType);
        } else if ("Patient".equalsIgnoreCase(role)) {
            user.setPhone(phone);
            // Also save to Patient entity for clinical records
            Patient p = new Patient();
            p.setName(fullName);
            p.setAge(age);
            p.setGender(gender);
            p.setContactNumber(phone);
            p.setPatientId("PID-" + (1000 + patientRepository.count()));
            p.setDateOfBirth(LocalDate.now().minusYears(age != null ? age : 0));
            patientRepository.save(p);
        } else if ("Pharmacy".equalsIgnoreCase(role)) {
            user.setPharmacyName(pharmacyName);
            user.setPharmacyAddress(pharmacyAddress);
            user.setPharmacyLicense(pharmacyLicense);
        } else if ("Staff".equalsIgnoreCase(role)) {
            user.setPhone(staffPhone);
            user.setStaffId(staffId);
            user.setHospitalName(hospitalName);
        }

        userRepository.save(user);
        redirectAttributes.addFlashAttribute("registerSuccess", "Registration successful! Please login.");
        return "redirect:/";
    }

    // ========================
    // User Login
    // ========================
    @PostMapping("/login")
    public String loginUser(
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String role,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<User> optionalUser = userRepository.findByEmail(email);

        if (optionalUser.isEmpty() || !passwordEncoder.matches(password, optionalUser.get().getPassword())) {
            redirectAttributes.addFlashAttribute("loginError", "Invalid email or password!");
            return "redirect:/";
        }

        User user = optionalUser.get();

        if (!user.getRole().equalsIgnoreCase(role)) {
            redirectAttributes.addFlashAttribute("loginError", "You are not authorized for the selected role!");
            return "redirect:/";
        }
        
        session.setAttribute("user", user);
        session.setAttribute("loggedInUser", user);
        if (role.equalsIgnoreCase("doctor")) {
            session.setAttribute("loggedInDoctor", user);
        }

        return redirectToDashboard(user.getRole());
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // ========================
    // Dashboard Routes
    // ========================
    @GetMapping("/admin-dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }
        model.addAttribute("user", user);

        LocalDate today = LocalDate.now();
        LocalDate monthStart = today.withDayOfMonth(1);

        // Patient stats
        long totalPatients = patientRepository.count();
        model.addAttribute("totalPatients", totalPatients);

        // Appointment stats
        long totalAppointments = appointmentRepository.count();
        long todayAppointments = appointmentRepository.countByAppointmentDate(today);
        long monthAppointments = appointmentRepository.countByAppointmentDateBetween(monthStart, today);
        long pendingAppointments = appointmentRepository.countByStatus("Pending");
        long completedAppointments = appointmentRepository.countByStatus("Completed");
        long cancelledAppointments = appointmentRepository.countByStatus("Cancelled");
        
        model.addAttribute("totalAppointments", totalAppointments);
        model.addAttribute("todayAppointments", todayAppointments);
        model.addAttribute("monthAppointments", monthAppointments);
        model.addAttribute("pendingAppointments", pendingAppointments);
        model.addAttribute("completedAppointments", completedAppointments);
        model.addAttribute("cancelledAppointments", cancelledAppointments);

        // User / Staff stats
        model.addAttribute("totalDoctors", userRepository.countByRole("Doctor"));
        model.addAttribute("totalStaff", userRepository.countByRole("Staff"));
        model.addAttribute("totalReceptionists", userRepository.countByRole("Receptionist"));
        model.addAttribute("totalLabUsers", userRepository.countByRole("Lab"));
        model.addAttribute("totalPharmacy", userRepository.countByRole("Pharmacy"));
        model.addAttribute("totalDelivery", userRepository.countByRole("Delivery"));
        model.addAttribute("totalUsers", userRepository.count());

        // Doctor availability today
        model.addAttribute("todayAvailability", availabilityRepository.findByAvailableDateOrderByStartTimeAsc(today));

        // Doctors list
        model.addAttribute("doctors", userRepository.findByRole("Doctor"));

        // All staff
        model.addAttribute("allUsers", userRepository.findAll());

        // Recent appointments
        model.addAttribute("recentAppointments", appointmentRepository.findTop10ByOrderByAppointmentDateDescAppointmentTimeDesc());

        // Today's appointments
        model.addAttribute("todayAppointmentsList", appointmentRepository.findByAppointmentDateOrderByAppointmentTimeAsc(today));

        // Visits count
        model.addAttribute("totalVisits", visitRepository.count());

        // System Alerts (Mocked)
        List<Map<String, String>> alerts = new ArrayList<>();
        Map<String, String> a1 = new HashMap<>();
        a1.put("type", "Critical");
        a1.put("message", "Oxygen Cylinder stock below 10%");
        a1.put("time", "10 mins ago");
        alerts.add(a1);
        model.addAttribute("systemAlerts", alerts);

        return "admin-dashboard";
    }

    @GetMapping("/doctor-dashboard")
    public String doctorDashboard() {
        return "redirect:/doctor/dashboard";
    }

    @GetMapping("/receptionist-dashboard")
    public String receptionistDashboard() {
        return "redirect:/receptionist/dashboard";
    }

    @GetMapping("/patient-dashboard")
    public String patientDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Patient".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);

        // Find the Patient record for this user
        List<Patient> patients = patientRepository.findAll();
        Patient patient = patients.stream()
                .filter(p -> p.getName() != null && p.getName().equalsIgnoreCase(user.getFullName()))
                .findFirst()
                .orElse(null);

        if (patient == null) {
            patient = new Patient();
            patient.setName(user.getFullName());
            patient.setContactNumber(user.getPhone() != null ? user.getPhone() : "N/A");
            patient.setPatientId("PID-" + (1000 + patientRepository.count()));
            patient.setDateOfBirth(LocalDate.now().minusYears(30));
            patient.setGender("Other");
            patient = patientRepository.save(patient);
        }
        model.addAttribute("patientDetails", patient);

        // Real Data from Repositories
        model.addAttribute("visitTimeline", visitRepository.findByPatientOrderByVisitDateDesc(patient));
        model.addAttribute("prescriptions", prescriptionRepository.findByVisit_Patient(patient));
        model.addAttribute("labReports", labReportRepository.findByRequest_Patient(patient));
        model.addAttribute("paymentHistory", invoiceRepository.findByPatient(patient));
        model.addAttribute("appointmentHistory", appointmentRepository.findByPatientOrderByAppointmentDateDesc(patient));
        model.addAttribute("doctors", userRepository.findByRole("Doctor"));

        return "patient-dashboard";
    }

    @PostMapping("/patient/book-appointment")
    public String bookAppointment(
            @RequestParam Long doctorId,
            @RequestParam String date,
            @RequestParam String time,
            @RequestParam(required = false) String purpose,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        if (user == null || !"Patient".equalsIgnoreCase(user.getRole())) return "redirect:/";

        try {
            Optional<User> optionalDoctor = userRepository.findById(doctorId);
            if (optionalDoctor.isPresent()) {
                List<Patient> patients = patientRepository.findAll();
                Patient patient = patients.stream()
                        .filter(p -> p.getName() != null && p.getName().equalsIgnoreCase(user.getFullName()))
                        .findFirst()
                        .orElse(null);

                if (patient == null) {
                    patient = new Patient();
                    patient.setName(user.getFullName());
                    patient.setContactNumber(user.getPhone() != null ? user.getPhone() : "N/A");
                    patient.setPatientId("PID-" + (1000 + patientRepository.count()));
                    patient.setDateOfBirth(LocalDate.now().minusYears(30));
                    patient.setGender("Other");
                    patient = patientRepository.save(patient);
                }

                Appointment appt = new Appointment();
                appt.setDoctor(optionalDoctor.get());
                appt.setPatient(patient);
                appt.setAppointmentDate(LocalDate.parse(date));
                appt.setAppointmentTime(LocalTime.parse(time));
                appt.setPurpose(purpose);
                appt.setStatus("Pending");
                appointmentRepository.save(appt);
                
                redirectAttributes.addFlashAttribute("successMessage", "Appointment booked successfully for " + date + " at " + time);
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Selected doctor not found.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error booking appointment: " + e.getMessage());
        }
        
        return "redirect:/patient-dashboard";
    }

    @GetMapping("/lab-dashboard")
    public String labDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Lab".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        model.addAttribute("patients", patientRepository.findAll());
        model.addAttribute("labRequests", labRequestRepository.findAll());
        model.addAttribute("deliveryPartners", userRepository.findByRole("Delivery"));
        model.addAttribute("allTests", labTestRepo.findAll());
        model.addAttribute("shifts", staffShiftRepo.findByUser(user));
        model.addAttribute("attendanceRecords", attendanceRepo.findByUser(user));
        
        return "lab-dashboard";
    }



    @GetMapping("/delivery-dashboard")
    public String deliveryDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Delivery".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("tasks", patientRepository.findAll()); 
        return "delivery-dashboard";
    }

    @GetMapping("/staff-dashboard")
    public String staffDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Staff".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        model.addAttribute("attendances", attendanceRepo.findByUser(user));
        model.addAttribute("shifts", staffShiftRepo.findByUser(user));
        
        return "staff-dashboard";
    }

    @PostMapping("/add-patient")
    public String addPatient(
            @RequestParam String name,
            @RequestParam String contactNumber,
            @RequestParam String dob,
            @RequestParam String gender,
            @RequestParam String bloodGroup,
            RedirectAttributes redirectAttributes) {
        
        Patient patient = new Patient();
        patient.setName(name);
        patient.setContactNumber(contactNumber);
        
        try {
            patient.setDateOfBirth(LocalDate.parse(dob));
        } catch (Exception e) {}
        
        patient.setGender(gender);
        patient.setBloodGroup(bloodGroup);
        patient.setPatientId("PID-" + (int)(Math.random() * 9000 + 1000));
        patient.setDeliveryStatus("Pending Pickup");
        patient.setLastVisit(LocalDate.now().toString());

        patientRepository.save(patient);
        redirectAttributes.addFlashAttribute("successMessage", "New test request created successfully!");
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/update-patient")
    public String updatePatient(
            @RequestParam Long id,
            @RequestParam String name,
            @RequestParam String contactNumber,
            @RequestParam String gender,
            @RequestParam String bloodGroup,
            RedirectAttributes redirectAttributes) {
        
        Optional<Patient> optionalPatient = patientRepository.findById(id);
        if (optionalPatient.isPresent()) {
            Patient patient = optionalPatient.get();
            patient.setName(name);
            patient.setContactNumber(contactNumber);
            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setLastVisit(LocalDate.now().toString());
            patientRepository.save(patient);
            redirectAttributes.addFlashAttribute("successMessage", "Patient record updated successfully!");
        }
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/delete-patient")
    public String deletePatient(@RequestParam Long id, RedirectAttributes redirectAttributes) {
        patientRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("successMessage", "Patient record deleted successfully!");
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/update-delivery-status")
    public String updateDeliveryStatus(
            @RequestParam Long id,
            @RequestParam String status,
            RedirectAttributes redirectAttributes) {
        
        Optional<Patient> optionalPatient = patientRepository.findById(id);
        if (optionalPatient.isPresent()) {
            Patient patient = optionalPatient.get();
            patient.setDeliveryStatus(status);
            patientRepository.save(patient);
            redirectAttributes.addFlashAttribute("successMessage", "Delivery status updated to: " + status);
        }
        return "redirect:/delivery-dashboard";
    }

    @PostMapping("/lab/upload-report")
    public String uploadLabReport(
            @RequestParam Long requestId,
            @RequestParam String result,
            RedirectAttributes redirectAttributes) {
        
        Optional<LabRequest> optRequest = labRequestRepository.findById(requestId);
        if (optRequest.isPresent()) {
            LabRequest request = optRequest.get();
            
            LabReport report = new LabReport();
            report.setRequest(request);
            report.setResult(result);
            report.setReportDate(LocalDate.now());
            report.setFilePath("uploads/report_" + requestId + ".pdf");
            
            labReportRepository.save(report);
            
            request.setStatus("Completed");
            labRequestRepository.save(request);
            
            redirectAttributes.addFlashAttribute("successMessage", "Lab report uploaded and shared with doctor!");
        }
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/mark-attendance")
    public String markAttendance(
            @RequestParam String date,
            @RequestParam String time,
            HttpSession session, 
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        try {
            LocalDateTime checkInDateTime = LocalDateTime.parse(date + "T" + time);
            Attendance attendance = new Attendance();
            attendance.setUser(user);
            attendance.setDate(LocalDate.parse(date));
            attendance.setCheckIn(checkInDateTime);
            attendance.setStatus("Present");
            attendanceRepo.save(attendance);

            // Sync User entity for Admin Dashboard
            user.setAttendanceStatus("Present");
            user.setCheckInTime(time);
            userRepository.save(user);

            redirectAttributes.addFlashAttribute("successMessage", "Attendance marked successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid date or time format!");
        }

        return "Lab".equalsIgnoreCase(user.getRole()) ? "redirect:/lab-dashboard" : "redirect:/staff-dashboard";
    }

    @PostMapping("/update-attendance")
    public String updateAttendance(
            @RequestParam Long id,
            @RequestParam String date,
            @RequestParam String time,
            HttpSession session, 
            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        Optional<Attendance> optionalAttendance = attendanceRepo.findById(id);
        if (optionalAttendance.isPresent() && optionalAttendance.get().getUser().getId().equals(user.getId())) {
            try {
                LocalDateTime checkOutDateTime = LocalDateTime.parse(date + "T" + time);
                Attendance att = optionalAttendance.get();
                att.setCheckOut(checkOutDateTime);
                attendanceRepo.save(att);

                // Sync User entity for Admin Dashboard
                user.setAttendanceStatus("Completed");
                user.setCheckOutTime(time);
                userRepository.save(user);

                redirectAttributes.addFlashAttribute("successMessage", "Attendance updated successfully!");
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid date or time format!");
            }
        }
        return "Lab".equalsIgnoreCase(user.getRole()) ? "redirect:/lab-dashboard" : "redirect:/staff-dashboard";
    }

    @PostMapping("/delete-attendance")
    public String deleteAttendance(@RequestParam Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        Optional<Attendance> att = attendanceRepo.findById(id);
        if (att.isPresent() && att.get().getUser().getId().equals(user.getId())) {
            if (!att.get().isVerified()) {
                attendanceRepo.delete(att.get());
                redirectAttributes.addFlashAttribute("successMessage", "Attendance record deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Cannot delete a verified record!");
            }
        }
        return "Lab".equalsIgnoreCase(user.getRole()) ? "redirect:/lab-dashboard" : "redirect:/staff-dashboard";
    }

    @PostMapping("/admin/update-attendance")
    public String adminUpdateAttendance(
            @RequestParam Long userId,
            @RequestParam String status,
            @RequestParam(required = false) String checkIn,
            @RequestParam(required = false) String checkOut,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) return "redirect:/";

        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isPresent()) {
            User staff = optionalUser.get();
            staff.setAttendanceStatus(status);
            if ("Absent".equalsIgnoreCase(status)) {
                staff.setCheckInTime(null);
                staff.setCheckOutTime(null);
            } else {
                if (checkIn != null) staff.setCheckInTime(checkIn);
                if (checkOut != null) staff.setCheckOutTime(checkOut);
            }
            userRepository.save(staff);
            redirectAttributes.addFlashAttribute("successMessage", "Attendance updated for " + staff.getFullName());
        }
        return "redirect:/admin-dashboard";
    }

    @PostMapping("/admin/assign-shift")
    public String assignShift(
            @RequestParam Long userId,
            @RequestParam String shiftType,
            @RequestParam String shiftDate,
            @RequestParam String startTime,
            @RequestParam String endTime,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) return "redirect:/";

        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isPresent()) {
            User staff = optionalUser.get();
            String fullShiftInfo = shiftType + " (" + shiftDate + ", " + startTime + " - " + endTime + ")";
            staff.setShiftTiming(fullShiftInfo);
            userRepository.save(staff);

            // Create actual StaffShift record for staff dashboard
            StaffShift shift = new StaffShift();
            shift.setUser(staff);
            shift.setDayOfWeek(LocalDate.parse(shiftDate).getDayOfWeek().name());
            shift.setStartTime(LocalTime.parse(startTime));
            shift.setEndTime(LocalTime.parse(endTime));
            shift.setNote(shiftType);
            shift.setDepartment(staff.getRole()); // Set department from user role
            
            // Set specific date times
            LocalDateTime startDT = LocalDateTime.parse(shiftDate + "T" + startTime);
            LocalDateTime endDT = LocalDateTime.parse(shiftDate + "T" + endTime);
            shift.setShiftStart(startDT);
            shift.setShiftEnd(endDT);
            
            staffShiftRepo.save(shift);

            redirectAttributes.addFlashAttribute("successMessage", "Shift assigned to " + staff.getFullName());
        }
        return "redirect:/admin-dashboard";
    }

    @PostMapping("/admin/update-performance")
    public String updatePerformance(
            @RequestParam Long userId,
            @RequestParam Integer rating,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) return "redirect:/";

        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isPresent()) {
            User staff = optionalUser.get();
            staff.setPerformanceRating(rating);
            userRepository.save(staff);
            redirectAttributes.addFlashAttribute("successMessage", "Performance rating updated for " + staff.getFullName());
        }
        return "redirect:/admin-dashboard";
    }

    private String redirectToDashboard(String role) {
        switch (role.toLowerCase()) {
            case "admin": return "redirect:/admin-dashboard";
            case "doctor": return "redirect:/doctor/dashboard";
            case "receptionist": return "redirect:/receptionist/dashboard";
            case "patient": return "redirect:/patient-dashboard";
            case "lab": return "redirect:/lab-dashboard";
            case "delivery": return "redirect:/delivery-dashboard";
            case "pharmacy": return "redirect:/pharmacy-dashboard";
            case "staff": return "redirect:/staff-dashboard";
            default: return "redirect:/";
        }
    }
}
