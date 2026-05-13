package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import com.example.demo.service.EmailService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
public class MainController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

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
    private VisitorMessageRepository visitorMessageRepository;

    @Autowired
    private LeaveRequestRepository leaveRequestRepository;

    @Autowired
    private NewsletterRepository newsletterRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private com.example.demo.service.PharmacyService pharmacyService;

    @Autowired
    private NotificationRepository notificationRepo;

    @Autowired
    private com.example.demo.service.ReceptionistService receptionistService;

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
            @RequestParam(required = false) String govIdNumber,
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
        user.setPhone(phone);
        
        // Role specific mapping
        if ("Admin".equalsIgnoreCase(role)) {
            user.setStaffId(adminId);
            user.setHospitalName(clinicName);
            user.setPhone(phone);
        } else if ("Doctor".equalsIgnoreCase(role)) {
            user.setPhone(phone);
            user.setSpecialization(specialization);
            user.setExperience(experience);
            user.setLicenseId(licenseId);
        } else if ("Lab".equalsIgnoreCase(role)) {
            user.setLabName(labName);
            user.setLabAddress(labAddress);
            user.setLabId(labId);
            user.setLabType(labType);
            user.setPhone(phone);
        } else if ("Receptionist".equalsIgnoreCase(role) || "RECEPTIONIST".equalsIgnoreCase(role)) {
            user.setPhone(phone);
            user.setGovIdNumber(govIdNumber);
            user.setAddress(address);
        } else if ("Delivery".equalsIgnoreCase(role)) {
            user.setPhone(deliveryPhone);
            user.setVehicleType(vehicleType);
        } else if ("Patient".equalsIgnoreCase(role)) {
            user.setPhone(phone);
            user.setAddress(address);
        } else if ("Pharmacy".equalsIgnoreCase(role)) {
            user.setPharmacyName(pharmacyName);
            user.setPharmacyAddress(pharmacyAddress);
            user.setPharmacyLicense(pharmacyLicense);
            user.setPhone(phone);
        } else if ("Staff".equalsIgnoreCase(role)) {
            user.setPhone(staffPhone != null ? staffPhone : phone);
            user.setStaffId(staffId);
            user.setHospitalName(hospitalName);
        }
        
        // Store in session for OTP verification
        HttpSession session = (HttpSession) ((org.springframework.web.context.request.ServletRequestAttributes) org.springframework.web.context.request.RequestContextHolder.getRequestAttributes()).getRequest().getSession();
        session.setAttribute("tempUser", user);
        
        // Store additional patient info if needed
        if ("Patient".equalsIgnoreCase(role)) {
            Map<String, Object> patientInfo = new HashMap<>();
            patientInfo.put("age", age);
            patientInfo.put("gender", gender);
            session.setAttribute("patientInfo", patientInfo);
        }

        String otp = emailService.generateOTP();
        session.setAttribute("regOTP", otp);
        session.setAttribute("tempEmail", email);
        
        try {
            emailService.sendOTP(email, otp);
            return "redirect:/otp-verification";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("registerError", "Error sending OTP: " + e.getMessage());
            return "redirect:/#register-section";
        }
    }

    @GetMapping("/otp-verification")
    public String showOtpPage(HttpSession session, Model model) {
        String email = (String) session.getAttribute("tempEmail");
        if (email == null) return "redirect:/";
        model.addAttribute("tempEmail", email);
        return "otp-verification";
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String otp, HttpSession session, RedirectAttributes redirectAttributes) {
        String sessionOtp = (String) session.getAttribute("regOTP");
        User user = (User) session.getAttribute("tempUser");

        if (sessionOtp != null && sessionOtp.equals(otp)) {
            // Save user
            userRepository.save(user);

            // If patient, save to patient repository
            if ("Patient".equalsIgnoreCase(user.getRole())) {
                Map<String, Object> patientInfo = (Map<String, Object>) session.getAttribute("patientInfo");
                Patient p = new Patient();
                p.setName(user.getFullName());
                p.setAge((Integer) patientInfo.get("age"));
                p.setGender((String) patientInfo.get("gender"));
                p.setContactNumber(user.getPhone());
                p.setPatientId("PID-" + (1000 + patientRepository.count()));
                p.setDateOfBirth(LocalDate.now().minusYears(p.getAge() != null ? p.getAge() : 0));
                patientRepository.save(p);
            }

            // Send Welcome Email
            try {
                emailService.sendWelcomeEmail(user.getEmail(), user.getFullName(), user.getRole());
            } catch (Exception e) {
                // Log error but don't stop the flow since user is already saved
                System.err.println("Failed to send welcome email: " + e.getMessage());
            }

            session.removeAttribute("regOTP");
            session.removeAttribute("tempUser");
            session.removeAttribute("tempEmail");
            session.removeAttribute("patientInfo");

            redirectAttributes.addFlashAttribute("registerSuccess", "Registration successful! Please login.");
            return "redirect:/";
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid OTP. Please try again.");
            return "redirect:/otp-verification";
        }
    }

    @GetMapping("/resend-otp")
    public String resendOtp(HttpSession session, RedirectAttributes redirectAttributes) {
        String email = (String) session.getAttribute("tempEmail");
        if (email == null) return "redirect:/";

        String newOtp = emailService.generateOTP();
        session.setAttribute("regOTP", newOtp);
        
        try {
            emailService.sendOTP(email, newOtp);
            redirectAttributes.addFlashAttribute("success", "OTP resent successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error sending OTP: " + e.getMessage());
        }
        return "redirect:/otp-verification";
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
        
        pharmacyService.checkAndGenerateAlerts();
        
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

        // Doctor availability (all upcoming)
        model.addAttribute("todayAvailability", availabilityRepository.findByAvailableDateGreaterThanEqualOrderByAvailableDateAscStartTimeAsc(today));

        // Doctors list
        model.addAttribute("doctors", userRepository.findByRoleIgnoreCase("Doctor"));

        // All staff
        model.addAttribute("allUsers", userRepository.findAll());
        model.addAttribute("allAttendances", attendanceRepo.findAll());

        // Recent appointments
        model.addAttribute("recentAppointments", appointmentRepository.findTop10ByOrderByAppointmentDateDescAppointmentTimeDesc());

        // Today's appointments
        model.addAttribute("todayAppointmentsList", appointmentRepository.findByAppointmentDateOrderByAppointmentTimeAsc(today));

        // Visits count
        model.addAttribute("totalVisits", visitRepository.count());

        // Real System Alerts from Notifications for this Admin
        model.addAttribute("systemAlerts", notificationRepo.findByUserAndIsReadFalseOrderByCreatedAtDesc(user));

        // Real Low Stocks from PharmacyService
        List<Map<String, String>> lowStocks = pharmacyService.getLowStockMedicines().stream()
                .map(m -> {
                    Map<String, String> map = new HashMap<>();
                    map.put("item", m.getName());
                    map.put("count", m.getStockLevel().toString());
                    map.put("status", m.getStockLevel() <= 5 ? "Critical" : "Warning");
                    return map;
                })
                .collect(java.util.stream.Collectors.toList());
        model.addAttribute("lowStocks", lowStocks);

        // Real Pending Bills from PharmacyService
        List<Map<String, String>> pendingBills = pharmacyService.getPendingPayments().stream()
                .map(i -> {
                    Map<String, String> map = new HashMap<>();
                    map.put("patient", i.getPatient().getName());
                    map.put("due", i.getInvoiceDate().toLocalDate().toString());
                    map.put("amount", "₹" + i.getTotalAmount());
                    return map;
                })
                .collect(java.util.stream.Collectors.toList());
        model.addAttribute("pendingBills", pendingBills);

        // Visitor messages
        model.addAttribute("visitorMessages", visitorMessageRepository.findAllByOrderBySubmittedAtDesc());

        // Staff Leave Requests
        List<LeaveRequest> allLeaveRequests = leaveRequestRepository.findAllByOrderBySubmittedAtDesc();
        model.addAttribute("leaveRequests", allLeaveRequests);
        model.addAttribute("pendingLeaveCount", allLeaveRequests.stream().filter(r -> "Pending".equals(r.getStatus())).count());

        // Newsletter Subscriptions
        model.addAttribute("newsletterSubscriptions", newsletterRepository.findAllByOrderBySubscribedAtDesc());
        model.addAttribute("totalSubscribers", newsletterRepository.count());

        return "admin-dashboard";
    }

    @PostMapping("/admin/update-consultation-fee")
    public String updateConsultationFee(@RequestParam Long userId, @RequestParam Double fee, RedirectAttributes ra) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null && "Doctor".equalsIgnoreCase(user.getRole())) {
            user.setConsultationFee(fee);
            userRepository.save(user);
            ra.addFlashAttribute("successMessage", "Consultation fee for " + user.getFullName() + " updated to ₹" + fee);
        }
        return "redirect:/admin-dashboard#staff-section";
    }

    @PostMapping("/newsletter/subscribe")
    public String subscribeNewsletter(@RequestParam String email, RedirectAttributes ra) {
        if (newsletterRepository.findByEmail(email).isPresent()) {
            ra.addFlashAttribute("newsletterError", "This email is already subscribed!");
        } else {
            newsletterRepository.save(new Newsletter(email));
            ra.addFlashAttribute("newsletterSuccess", "Thank you for subscribing!");
        }
        return "redirect:/";
    }

    @PostMapping("/admin/newsletter/send")
    public String sendNewsletter(@RequestParam String subject, @RequestParam String message, RedirectAttributes ra) {
        // Logic to "send" emails (in a real app, this would use JavaMailSender)
        long count = newsletterRepository.count();
        ra.addFlashAttribute("newsletterSuccess", "Update successfully sent to " + count + " subscribers!");
        return "redirect:/admin-dashboard#newsletter-section";
    }

    @PostMapping("/admin/newsletter/remove/{id}")
    public String removeSubscriber(@PathVariable Long id, RedirectAttributes ra) {
        newsletterRepository.deleteById(id);
        ra.addFlashAttribute("newsletterSuccess", "Subscriber removed successfully.");
        return "redirect:/admin-dashboard#newsletter-section";
    }

    @PostMapping("/submit-contact")
    public String submitContact(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String message,
            RedirectAttributes redirectAttributes) {
        
        VisitorMessage visitorMessage = new VisitorMessage(name, email, message);
        visitorMessageRepository.save(visitorMessage);
        
        redirectAttributes.addFlashAttribute("contactSuccess", "Thank you for your message! We will get back to you soon.");
        return "redirect:/#contact";
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

        // Find the Patient record for this user (Robust identification)
        Patient patient = null;
        if (user.getPhone() != null && !user.getPhone().isBlank()) {
            patient = patientRepository.findByContactNumber(user.getPhone());
        }
        
        if (patient == null) {
            patient = patientRepository.findAll().stream()
                    .filter(p -> p.getName() != null && p.getName().equalsIgnoreCase(user.getFullName()))
                    .findFirst()
                    .orElse(null);
        }

        if (patient == null) {
            patient = new Patient();
            patient.setName(user.getFullName());
            patient.setContactNumber(user.getPhone() != null ? user.getPhone() : "N/A");
            patient.setPatientId("PID-" + (1000 + patientRepository.count()));
            patient.setDateOfBirth(LocalDate.now().minusYears(30));
            patient.setGender(user.getGender() != null ? user.getGender() : "Other");
            patient = patientRepository.save(patient);
        }
        model.addAttribute("patientDetails", patient);

        // Unified Data Retrieval (Using Phone Number for cross-profile history)
        String phone = patient.getContactNumber();
        if (phone != null && !phone.equalsIgnoreCase("N/A")) {
            model.addAttribute("prescriptions", prescriptionRepository.findByPatient_ContactNumberOrderByCreatedAtDesc(phone));
            model.addAttribute("paymentHistory", invoiceRepository.findByPatient_ContactNumberOrderByInvoiceDateDesc(phone));
            model.addAttribute("appointmentHistory", appointmentRepository.findByPatient_ContactNumberOrderByAppointmentDateDesc(phone));
        } else {
            model.addAttribute("prescriptions", prescriptionRepository.findByPatient(patient));
            model.addAttribute("paymentHistory", invoiceRepository.findByPatient(patient));
            model.addAttribute("appointmentHistory", appointmentRepository.findByPatientOrderByAppointmentDateDesc(patient));
        }
        
        // Robust Lab Report Retrieval (Match by ID or Patient Name)
        final Long finalPatientId = patient.getId();
        final String finalPatientName = patient.getName();
        List<LabReport> labReports = labReportRepository.findAll().stream()
            .filter(r -> {
                if (r.getRequest() == null || r.getRequest().getPatient() == null) return false;
                Patient p = r.getRequest().getPatient();
                return p.getId().equals(finalPatientId) || 
                       (p.getName() != null && p.getName().equalsIgnoreCase(finalPatientName));
            })
            .collect(java.util.stream.Collectors.toList());
            
        model.addAttribute("labReports", labReports);
        model.addAttribute("visitTimeline", visitRepository.findByPatientOrderByVisitDateDesc(patient));
        model.addAttribute("doctors", userRepository.findByRole("Doctor"));

        // Dynamic Stats Calculation
        LocalDate today = LocalDate.now();
        String phoneStr = patient.getContactNumber();
        
        // 1. Upcoming Appointment
        String upcomingApptStr = "No appointments";
        List<Appointment> allAppts;
        if (phoneStr != null && !phoneStr.equalsIgnoreCase("N/A")) {
            allAppts = appointmentRepository.findByPatient_ContactNumberOrderByAppointmentDateDesc(phoneStr);
        } else {
            allAppts = appointmentRepository.findByPatientOrderByAppointmentDateDesc(patient);
        }
        
        Optional<Appointment> nextAppt = allAppts.stream()
            .filter(a -> a.getAppointmentDate().isAfter(today) || (a.getAppointmentDate().isEqual(today) && a.getAppointmentTime().isAfter(LocalTime.now())))
            .sorted(Comparator.comparing(Appointment::getAppointmentDate).thenComparing(Appointment::getAppointmentTime))
            .findFirst();
        
        if (nextAppt.isPresent()) {
            upcomingApptStr = nextAppt.get().getAppointmentDate().format(DateTimeFormatter.ofPattern("MMM dd")) + ", " + 
                            nextAppt.get().getAppointmentTime().format(DateTimeFormatter.ofPattern("hh:mm a"));
        }
        model.addAttribute("upcomingApptStr", upcomingApptStr);

        // 2. Active Prescriptions
        long activeRXCount = 0;
        List<Prescription> allRX;
        if (phoneStr != null && !phoneStr.equalsIgnoreCase("N/A")) {
            allRX = prescriptionRepository.findByPatient_ContactNumberOrderByCreatedAtDesc(phoneStr);
        } else {
            allRX = prescriptionRepository.findByPatient(patient);
        }
        activeRXCount = allRX.stream()
            .filter(p -> !"Dispensed".equalsIgnoreCase(p.getStatus()))
            .count();
        model.addAttribute("activeRXCount", activeRXCount);

        // 3. Pending Bills
        double pendingAmount = 0;
        List<Invoice> allInvoices;
        if (phoneStr != null && !phoneStr.equalsIgnoreCase("N/A")) {
            allInvoices = invoiceRepository.findByPatient_ContactNumberOrderByInvoiceDateDesc(phoneStr);
        } else {
            allInvoices = invoiceRepository.findByPatient(patient);
        }
        pendingAmount = allInvoices.stream()
            .filter(i -> "Pending".equalsIgnoreCase(i.getPaymentStatus()) || "Partially Paid".equalsIgnoreCase(i.getPaymentStatus()))
            .mapToDouble(Invoice::getTotalAmount)
            .sum();
        model.addAttribute("pendingAmount", pendingAmount);

        return "patient-dashboard";
    }

    @PostMapping("/patient/profile/update")
    public String updatePatientProfile(
            @RequestParam String fullName,
            @RequestParam Integer age,
            @RequestParam String gender,
            @RequestParam String phone,
            @RequestParam(required = false) String bloodGroup,
            @RequestParam(required = false) String newPassword,
            @RequestParam(required = false) String confirmPassword,
            HttpSession session, RedirectAttributes ra) {
        
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null || !"Patient".equalsIgnoreCase(sessionUser.getRole())) return "redirect:/";
        
        // Refresh from DB
        final User user = userRepository.findById(sessionUser.getId()).orElse(sessionUser);
        
        // Find associated Patient record (Robust identification)
        Patient patient = null;
        if (user.getPhone() != null && !user.getPhone().isBlank()) {
            patient = patientRepository.findByContactNumber(user.getPhone());
        }
        if (patient == null) {
            patient = patientRepository.findAll().stream()
                    .filter(p -> p.getName() != null && p.getName().equalsIgnoreCase(user.getFullName()))
                    .findFirst()
                    .orElse(null);
        }

        // Update User info
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setGender(gender); // Sync gender to user as well
        
        // Password update if provided
        if (newPassword != null && !newPassword.isBlank()) {
            if (!newPassword.equals(confirmPassword)) {
                ra.addFlashAttribute("errorMessage", "Passwords do not match!");
                return "redirect:/patient-dashboard";
            }
            user.setPassword(passwordEncoder.encode(newPassword));
        }
        
        userRepository.save(user);
        session.setAttribute("user", user);

        // Update Patient info
        if (patient != null) {
            patient.setName(fullName);
            patient.setAge(age);
            patient.setGender(gender);
            patient.setContactNumber(phone);
            patient.setBloodGroup(bloodGroup);
            patientRepository.save(patient);
        }

        ra.addFlashAttribute("successMessage", "Profile updated successfully!");
        return "redirect:/patient-dashboard";
    }

    @PostMapping("/patient/book-appointment")
    public String bookAppointment(
            @RequestParam Long doctorId,
            @RequestParam String date,
            @RequestParam String time,
            @RequestParam(required = false) String purpose,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        final User user = (User) session.getAttribute("user");
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
                
                // Use service for validation and booking
                receptionistService.bookAppointment(appt);
                
                redirectAttributes.addFlashAttribute("successMessage", "Appointment booked successfully for " + date + " at " + time);
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Selected doctor not found.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error booking appointment: " + e.getMessage());
        }
        
        return "redirect:/patient-dashboard";
    }

    @PostMapping("/staff/profile/update")
    public String updateStaffProfile(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String hospitalName,
            @RequestParam(required = false) String staffId,
            @RequestParam(required = false) String newPassword,
            @RequestParam(required = false) String confirmPassword,
            HttpSession session, RedirectAttributes ra) {
        
        User user = (User) session.getAttribute("user");
        if (user == null || !"Staff".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        user = userRepository.findById(user.getId()).orElse(user);
        
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setHospitalName(hospitalName);
        user.setStaffId(staffId);
        
        if (newPassword != null && !newPassword.isBlank()) {
            if (!newPassword.equals(confirmPassword)) {
                ra.addFlashAttribute("errorMessage", "Passwords do not match!");
                return "redirect:/staff-dashboard";
            }
            user.setPassword(passwordEncoder.encode(newPassword));
        }
        
        userRepository.save(user);
        session.setAttribute("user", user);
        
        ra.addFlashAttribute("successMessage", "Profile updated successfully!");
        return "redirect:/staff-dashboard";
    }

    @PostMapping("/delivery/profile/update")
    public String updateDeliveryProfile(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String vehicleType,
            @RequestParam(required = false) String newPassword,
            @RequestParam(required = false) String confirmPassword,
            HttpSession session, RedirectAttributes ra) {
        
        User user = (User) session.getAttribute("user");
        if (user == null || !"Delivery".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        user = userRepository.findById(user.getId()).orElse(user);
        
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setVehicleType(vehicleType);
        
        if (newPassword != null && !newPassword.isBlank()) {
            if (!newPassword.equals(confirmPassword)) {
                ra.addFlashAttribute("errorMessage", "Passwords do not match!");
                return "redirect:/delivery-dashboard";
            }
            user.setPassword(passwordEncoder.encode(newPassword));
        }
        
        userRepository.save(user);
        session.setAttribute("user", user);
        
        ra.addFlashAttribute("successMessage", "Profile updated successfully!");
        return "redirect:/delivery-dashboard";
    }

    @GetMapping("/lab-dashboard")
    public String labDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Lab".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        List<LabRequest> labRequests = labRequestRepository.findAll();
        List<Patient> patients = patientRepository.findAll();
        
        // Ensure every patient has at least one request for the dashboard view
        if (labRequests.isEmpty() && !patients.isEmpty()) {
            for (Patient p : patients) {
                LabRequest lr = new LabRequest();
                lr.setPatient(p);
                lr.setStatus("Pending");
                lr.setProcessingType("In-House");
                p.setDeliveryStatus("Not Required");
                patientRepository.save(p);
                
                LabTest defaultTest = labTestRepo.findAll().isEmpty() ? null : labTestRepo.findAll().get(0);
                if (defaultTest == null) {
                    defaultTest = new LabTest();
                    defaultTest.setName("General Blood Test");
                    defaultTest.setPrice(500.0);
                    labTestRepo.save(defaultTest);
                }
                lr.setTest(defaultTest);
                
                List<User> doctors = userRepository.findByRole("Doctor");
                if (!doctors.isEmpty()) lr.setDoctor(doctors.get(0));
                
                labRequestRepository.save(lr);
            }
            labRequests = labRequestRepository.findAll();
        }

        model.addAttribute("labRequests", labRequests);
        model.addAttribute("patients", patients);
        model.addAttribute("doctors", userRepository.findByRoleIgnoreCase("Doctor"));
        model.addAttribute("deliveryPartners", userRepository.findByRoleIgnoreCase("Delivery"));
        model.addAttribute("allTests", labTestRepo.findAll());
        model.addAttribute("shifts", staffShiftRepo.findByUser(user));
        model.addAttribute("leaveRequests", leaveRequestRepository.findByUserOrderBySubmittedAtDesc(user));
        List<Attendance> userAttendance = attendanceRepo.findByUser(user);
        model.addAttribute("attendanceRecords", userAttendance);
        
        LocalDate today = LocalDate.now();
        boolean todayAttendanceExists = userAttendance.stream()
            .anyMatch(a -> a.getDate().equals(today));
        model.addAttribute("todayAttendanceExists", todayAttendanceExists);
        
        return "lab-dashboard";
    }
    @PostMapping("/lab/profile/update")
    public String updateLabProfile(@ModelAttribute User updatedUser, HttpSession session, RedirectAttributes ra) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Lab".equalsIgnoreCase(currentUser.getRole())) return "redirect:/";
        
        currentUser.setFullName(updatedUser.getFullName());
        currentUser.setEmail(updatedUser.getEmail());
        currentUser.setPhone(updatedUser.getPhone());
        currentUser.setLabName(updatedUser.getLabName());
        currentUser.setLabAddress(updatedUser.getLabAddress());
        currentUser.setLabId(updatedUser.getLabId());
        
        userRepository.save(currentUser);
        session.setAttribute("user", currentUser);
        
        ra.addFlashAttribute("successMessage", "Profile updated successfully!");
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/lab/leave/apply")
    public String applyLabLeave(@RequestParam String reason, 
                               @RequestParam String startDate, 
                               @RequestParam String endDate, 
                               @RequestParam(required = false, defaultValue = "Full Day") String leaveType,
                               HttpSession session, 
                               RedirectAttributes ra) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Lab".equalsIgnoreCase(user.getRole())) return "redirect:/";

        try {
            LeaveRequest lr = new LeaveRequest(user, reason, LocalDate.parse(startDate), LocalDate.parse(endDate), leaveType);
            leaveRequestRepository.save(lr);
            ra.addFlashAttribute("successMessage", "Leave request submitted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error submitting leave request: " + e.getMessage());
        }

        return "redirect:/lab-dashboard";
    }

    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session,
            RedirectAttributes ra) {
        
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";
        
        // Reload user to ensure we have the latest password from DB
        user = userRepository.findById(user.getId()).orElse(user);

        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            ra.addFlashAttribute("errorMessage", "Current password is incorrect!");
        } else if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("errorMessage", "New passwords do not match!");
        } else {
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);
            session.setAttribute("user", user);
            ra.addFlashAttribute("successMessage", "Password updated successfully!");
        }

        // Redirect based on role
        String role = user.getRole().toLowerCase();
        if ("lab".equals(role)) return "redirect:/lab-dashboard";
        if ("receptionist".equals(role)) return "redirect:/receptionist/dashboard";
        if ("doctor".equals(role)) return "redirect:/doctor-dashboard";
        if ("pharmacy".equals(role)) return "redirect:/pharmacy-dashboard";
        if ("delivery".equals(role)) return "redirect:/delivery-dashboard";
        if ("admin".equals(role)) return "redirect:/admin-dashboard";
        if ("patient".equals(role)) return "redirect:/patient-dashboard";
        
        return "redirect:/";
    }



    @GetMapping("/delivery-dashboard")
    public String deliveryDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Delivery".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        
        // Filter tasks assigned to this delivery boy specifically
        List<Patient> allPatients = patientRepository.findAll();
        List<Patient> myTasks = allPatients.stream()
                .filter(p -> user.getFullName().equalsIgnoreCase(p.getDeliveryAssignedTo()))
                .toList();
        
        model.addAttribute("tasks", myTasks); 
        model.addAttribute("leaveRequests", leaveRequestRepository.findByUserOrderBySubmittedAtDesc(user));
        return "delivery-dashboard";
    }

    @GetMapping("/staff-dashboard")
    public String staffDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Staff".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        List<Attendance> attendances = attendanceRepo.findByUser(user);
        model.addAttribute("attendances", attendances);
        model.addAttribute("shifts", staffShiftRepo.findByUser(user));
        
        // Find today's attendance record
        LocalDate today = LocalDate.now();
        Attendance todayAtt = attendances.stream()
                .filter(a -> a.getDate().equals(today))
                .findFirst()
                .orElse(null);
        model.addAttribute("todayAtt", todayAtt);
        
        // Staff Leave History
        model.addAttribute("myLeaveRequests", leaveRequestRepository.findByUserOrderBySubmittedAtDesc(user));
        
        return "staff-dashboard";
    }

    @PostMapping("/add-patient")
    public String addPatient(
            @RequestParam String name,
            @RequestParam String contactNumber,
            @RequestParam String dob,
            @RequestParam String gender,
            @RequestParam String bloodGroup,
            @RequestParam(required = false) String testType,
            @RequestParam(required = false) String processingType,
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
        patient.setDeliveryStatus("External".equalsIgnoreCase(processingType) ? "Pending Pickup" : "Not Required");
        patient.setLastVisit(LocalDate.now().toString());
        
        if ("External".equalsIgnoreCase(processingType)) {
            patient.setSourceHospital("MediCare+ Main Clinic");
            patient.setDestinationHospital("External Partner Lab");
        }

        patientRepository.save(patient);

        // Also create a LabRequest so it appears in the dashboard
        LabRequest lr = new LabRequest();
        lr.setPatient(patient);
        lr.setStatus("Pending");
        // Mocking a test for the new request
        LabTest defaultTest = labTestRepo.findAll().isEmpty() ? null : labTestRepo.findAll().get(0);
        if (defaultTest == null) {
            defaultTest = new LabTest();
            defaultTest.setName(testType != null ? testType : "General Blood Test");
            defaultTest.setPrice(500.0);
            labTestRepo.save(defaultTest);
        }
        lr.setTest(defaultTest);
        
        // Mocking a doctor for the request
        List<User> doctors = userRepository.findByRole("Doctor");
        if (!doctors.isEmpty()) {
            lr.setDoctor(doctors.get(0));
        }
        
        labRequestRepository.save(lr);

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
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Optional<Patient> optionalPatient = patientRepository.findById(id);
        if (optionalPatient.isPresent()) {
            Patient patient = optionalPatient.get();
            patient.setDeliveryStatus(status);
            patientRepository.save(patient);
            
            // Sync associated LabRequest status
            List<LabRequest> requests = labRequestRepository.findAll(); 
            for (LabRequest lr : requests) {
                if (lr.getPatient().getId().equals(id) && !"Completed".equals(lr.getStatus())) {
                    if ("Received".equalsIgnoreCase(status) || "Delivered to Partner Lab".equalsIgnoreCase(status)) {
                        lr.setStatus("Arrived at Lab");
                        lr.setDeliveryDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
                    } else if ("Delivered".equalsIgnoreCase(status)) {
                        lr.setStatus("Delivered (Pending Confirmation)");
                        lr.setDeliveryDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
                    } else if ("In Transit".equalsIgnoreCase(status)) {
                        lr.setStatus("In-Transit");
                    } else if ("Collected".equalsIgnoreCase(status)) {
                        lr.setStatus("Collected");
                        lr.setPickupDate(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
                    }
                    labRequestRepository.save(lr);
                }
            }
            
            redirectAttributes.addFlashAttribute("successMessage", "Delivery status updated to: " + status);
        }
        
        User user = (User) session.getAttribute("user");
        if (user != null && "Delivery".equalsIgnoreCase(user.getRole())) {
            return "redirect:/delivery-dashboard";
        }
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/lab/collect-sample")
    public String collectSample(@RequestParam(required = false) Long requestId,
                                @RequestParam(required = false) String patientName,
                                @RequestParam(required = false) String contactNumber,
                                @RequestParam(required = false) String dob,
                                @RequestParam(required = false) String gender,
                                @RequestParam(required = false) String bloodGroup,
                                @RequestParam(required = false) String testType,
                                @RequestParam String processingType,
                                @RequestParam(required = false) Long deliveryPartnerId,
                                @RequestParam(required = false) Long doctorId,
                                RedirectAttributes ra) {
        
        LabRequest request;
        if (requestId != null) {
            request = labRequestRepository.findById(requestId).orElse(new LabRequest());
        } else {
            request = new LabRequest();
            Patient patient = patientRepository.findByName(patientName);
            if (patient == null) {
                patient = new Patient();
                patient.setName(patientName);
                patient.setContactNumber(contactNumber);
                patient.setGender(gender);
                patient.setPatientId("LAB-PID-" + (int)(Math.random() * 9000 + 1000));
                patientRepository.save(patient);
            }
            request.setPatient(patient);
            
            LabTest test = labTestRepo.findByName(testType);
            if (test == null) {
                test = new LabTest();
                test.setName(testType);
                test.setPrice(500.0);
                labTestRepo.save(test);
            }
            request.setTest(test);
        }
        
        if (doctorId != null) {
            userRepository.findById(doctorId).ifPresent(request::setDoctor);
        } else if (request.getDoctor() == null) {
            List<User> doctors = userRepository.findByRoleIgnoreCase("Doctor");
            if (!doctors.isEmpty()) request.setDoctor(doctors.get(0));
        }

        request.setProcessingType(processingType);
        request.setCollectionDate(LocalDateTime.now().toString());
            
        if ("External".equalsIgnoreCase(processingType) && deliveryPartnerId != null) {
            Optional<User> optPartner = userRepository.findById(deliveryPartnerId);
            if (optPartner.isPresent()) {
                request.setDeliveryPartner(optPartner.get());
                request.setStatus("Awaiting Pickup");
                
                Patient patient = request.getPatient();
                patient.setDeliveryStatus("Pending Pickup");
                patient.setDeliveryAssignedTo(optPartner.get().getFullName());
                patient.setDeliveryBoyPhone(optPartner.get().getPhone());
                patient.setSourceHospital("MediCare+ Main Clinic");
                patient.setDestinationHospital("External Partner Lab");
                patientRepository.save(patient);
            }
        } else {
            request.setStatus("Collected");
            Patient patient = request.getPatient();
            patient.setDeliveryStatus("Not Required");
            patientRepository.save(patient);
        }
        
        labRequestRepository.save(request);
        ra.addFlashAttribute("successMessage", "Sample collected successfully! Processing: " + processingType);
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/lab/upload-report")
    public String uploadLabReport(
            @RequestParam Long requestId,
            @RequestParam String result,
            @RequestParam("reportFile") org.springframework.web.multipart.MultipartFile file,
            RedirectAttributes redirectAttributes) {
        
        Optional<LabRequest> optRequest = labRequestRepository.findById(requestId);
        if (optRequest.isPresent()) {
            LabRequest request = optRequest.get();
            
            LabReport report = new LabReport();
            report.setRequest(request);
            report.setResult(result);
            report.setReportDate(LocalDate.now());
            
            // Handle File Storage
            if (file != null && !file.isEmpty()) {
                try {
                    String fileName = "report_" + requestId + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
                    String uploadDir = "src/main/resources/static/uploads/";
                    java.io.File dir = new java.io.File(uploadDir);
                    if (!dir.exists()) dir.mkdirs();
                    
                    java.nio.file.Path path = java.nio.file.Paths.get(uploadDir + fileName);
                    java.nio.file.Files.copy(file.getInputStream(), path, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    
                    report.setFilePath("/uploads/" + fileName);
                } catch (java.io.IOException e) {
                    report.setFilePath("uploads/default_report.pdf");
                }
            } else {
                report.setFilePath("uploads/default_report.pdf");
            }
            
            labReportRepository.save(report);
            System.out.println(">> Lab Report Saved Successfully. Total Reports: " + labReportRepository.count());
            
            request.setStatus("Completed");
            labRequestRepository.save(request);
            
            redirectAttributes.addFlashAttribute("successMessage", "Lab report uploaded and shared with doctor and patient!");
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
            LocalDate today = LocalDate.parse(date);
            
            // Check if attendance already marked for today
            List<Attendance> allAttendance = attendanceRepo.findAll();
            boolean alreadyMarked = allAttendance.stream()
                .anyMatch(a -> a.getUser().getId().equals(user.getId()) && a.getDate().equals(today));
            
            if (alreadyMarked) {
                redirectAttributes.addFlashAttribute("errorMessage", "You have already marked attendance for today!");
                return "Lab".equalsIgnoreCase(user.getRole()) ? "redirect:/lab-dashboard" : "redirect:/staff-dashboard";
            }

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

    @PostMapping("/admin/update-profile")
    public String updateAdminProfile(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam(required = false) String currentPassword,
            @RequestParam(required = false) String newPassword,
            HttpSession session,
            RedirectAttributes ra) {
        
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) return "redirect:/";

        admin.setFullName(fullName);
        admin.setEmail(email);
        admin.setPhone(phone);

        if (currentPassword != null && !currentPassword.isEmpty() && newPassword != null && !newPassword.isEmpty()) {
            if (passwordEncoder.matches(currentPassword, admin.getPassword())) {
                admin.setPassword(passwordEncoder.encode(newPassword));
                ra.addFlashAttribute("successMessage", "Profile and password updated successfully!");
            } else {
                ra.addFlashAttribute("errorMessage", "Current password incorrect! Other details updated.");
            }
        } else {
            ra.addFlashAttribute("successMessage", "Profile details updated successfully!");
        }

        userRepository.save(admin);
        session.setAttribute("user", admin);
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

    @GetMapping("/view-report/{id}")
    public String viewReportGeneral(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";
        
        Optional<LabReport> optReport = labReportRepository.findById(id);
        if (optReport.isPresent()) {
            LabReport report = optReport.get();
            model.addAttribute("report", report);
            // In case the report-view template expects a 'doctor' attribute specifically
            if (report.getRequest() != null && report.getRequest().getDoctor() != null) {
                model.addAttribute("doctor", report.getRequest().getDoctor());
            }
            return "doctor/report-view";
        }
        return "redirect:/patient-dashboard";
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
    
    @GetMapping("/api/doctor/availability")
    @ResponseBody
    public List<Map<String, Object>> getPatientSideAvailability(@RequestParam Long doctorId, @RequestParam @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate date) {
        // Return a lightweight DTO instead of full Availability entity
        // to avoid Jackson serializing the embedded User (password, LONGTEXT profileImage, etc.)
        List<Availability> slots = receptionistService.getDoctorAvailability(doctorId, date);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Availability slot : slots) {
            Map<String, Object> dto = new HashMap<>();
            dto.put("id", slot.getId());
            dto.put("availableDate", slot.getAvailableDate().toString());
            dto.put("startTime", slot.getStartTime().toString());
            dto.put("endTime", slot.getEndTime().toString());
            result.add(dto);
        }
        return result;
    }
    
    @GetMapping("/api/test/create-availability")
    @ResponseBody
    public String createTestAvailability() {
        try {
            // Try to get doctor ID 9 specifically (Dr. doc5)
            User doctor = userRepository.findById(9L).orElse(null);
            if (doctor == null) {
                // Fallback to any doctor
                List<User> doctors = userRepository.findByRole("Doctor");
                if (doctors.isEmpty()) {
                    return "No doctors found in database. Please create a doctor account first.";
                }
                doctor = doctors.get(0);
            }
            
            LocalDate today = LocalDate.now();
            
            // Create multiple slots for today
            LocalTime[] startTimes = {LocalTime.of(9, 0), LocalTime.of(10, 30), LocalTime.of(14, 0), LocalTime.of(15, 30)};
            LocalTime[] endTimes = {LocalTime.of(10, 0), LocalTime.of(11, 30), LocalTime.of(15, 0), LocalTime.of(16, 30)};
            
            for (int i = 0; i < startTimes.length; i++) {
                Availability slot = new Availability();
                slot.setDoctor(doctor);
                slot.setAvailableDate(today);
                slot.setStartTime(startTimes[i]);
                slot.setEndTime(endTimes[i]);
                availabilityRepository.save(slot);
            }
            
            return "Created 4 availability slots for Dr. " + doctor.getFullName() + " (ID: " + doctor.getId() + ") for " + today;
        } catch (Exception e) {
            return "Error: " + e.getMessage() + " - Stack trace: " + e.toString();
        }
    }
    
    @GetMapping("/api/test/create-doc5-availability")
    @ResponseBody
    public String createDoc5Availability() {
        try {
            // Create availability specifically for doctor ID 9 (Dr. doc5)
            User doctor = userRepository.findById(9L).orElse(null);
            if (doctor == null) {
                return "Doctor with ID 9 not found";
            }
            
            LocalDate today = LocalDate.now();
            
            // Create multiple slots for today
            LocalTime[] startTimes = {LocalTime.of(9, 0), LocalTime.of(10, 30), LocalTime.of(14, 0), LocalTime.of(15, 30)};
            LocalTime[] endTimes = {LocalTime.of(10, 0), LocalTime.of(11, 30), LocalTime.of(15, 0), LocalTime.of(16, 30)};
            
            for (int i = 0; i < startTimes.length; i++) {
                Availability slot = new Availability();
                slot.setDoctor(doctor);
                slot.setAvailableDate(today);
                slot.setStartTime(startTimes[i]);
                slot.setEndTime(endTimes[i]);
                availabilityRepository.save(slot);
            }
            
            return "Created 4 availability slots for Dr. " + doctor.getFullName() + " (ID: 9) for " + today;
        } catch (Exception e) {
            return "Error: " + e.getMessage() + " - Stack trace: " + e.toString();
        }
    }
    
    @GetMapping("/api/test/check-data")
    @ResponseBody
    public String checkData() {
        try {
            List<User> doctors = userRepository.findByRole("Doctor");
            List<Availability> availabilities = availabilityRepository.findAll();
            
            StringBuilder result = new StringBuilder();
            result.append("Doctors: ").append(doctors.size()).append(", Availability slots: ").append(availabilities.size()).append("\n");
            
            for (User doctor : doctors) {
                result.append("Doctor ID: ").append(doctor.getId()).append(", Name: ").append(doctor.getFullName()).append("\n");
            }
            
            for (Availability slot : availabilities) {
                result.append("Slot: Doctor ID ").append(slot.getDoctor().getId())
                      .append(" on ").append(slot.getAvailableDate())
                      .append(" from ").append(slot.getStartTime()).append(" to ").append(slot.getEndTime()).append("\n");
            }
            
            return result.toString();
        } catch (Exception e) {
            return "Error checking data: " + e.getMessage();
        }
    }
    
    @GetMapping("/api/test/create-all-availability")
    @ResponseBody
    public String createAllAvailability() {
        try {
            List<User> doctors = userRepository.findByRole("Doctor");
            LocalDate today = LocalDate.now();
            
            StringBuilder result = new StringBuilder();
            
            for (User doctor : doctors) {
                // Create today's slots
                LocalTime[] startTimes = {LocalTime.of(9, 0), LocalTime.of(10, 30), LocalTime.of(14, 0), LocalTime.of(15, 30)};
                LocalTime[] endTimes = {LocalTime.of(10, 0), LocalTime.of(11, 30), LocalTime.of(15, 0), LocalTime.of(16, 30)};
                
                for (int i = 0; i < startTimes.length; i++) {
                    Availability slot = new Availability();
                    slot.setDoctor(doctor);
                    slot.setAvailableDate(today);
                    slot.setStartTime(startTimes[i]);
                    slot.setEndTime(endTimes[i]);
                    availabilityRepository.save(slot);
                }
                
                result.append("Created 4 slots for Dr. ").append(doctor.getFullName()).append(" (ID: ").append(doctor.getId()).append(") on ").append(today).append("\n");
            }
            
            return result.toString();
        } catch (Exception e) {
            return "Error creating availability: " + e.getMessage();
        }
    }
    
    @GetMapping("/api/test/create-doctor1-availability")
    @ResponseBody
    public String createDoctor1Availability() {
        try {
            User doctor = userRepository.findById(1L).orElse(null);
            if (doctor == null) {
                return "No doctor found with ID 1";
            }
            
            LocalDate today = LocalDate.now();
            
            // Create one simple slot for today
            Availability slot = new Availability();
            slot.setDoctor(doctor);
            slot.setAvailableDate(today);
            slot.setStartTime(LocalTime.of(9, 0));
            slot.setEndTime(LocalTime.of(10, 0));
            availabilityRepository.save(slot);
            
            return "Created availability slot for Dr. " + doctor.getFullName() + " (ID: 1) on " + today;
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }

    @PostMapping("/staff/apply-leave")
    public String applyLeave(
            @RequestParam String reason,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam(required = false, defaultValue = "Full Day") String leaveType,
            HttpSession session,
            RedirectAttributes ra) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        try {
            LeaveRequest lr = new LeaveRequest(user, reason, LocalDate.parse(startDate), LocalDate.parse(endDate), leaveType);
            leaveRequestRepository.save(lr);
            ra.addFlashAttribute("successMessage", "Leave request submitted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error submitting leave request: " + e.getMessage());
        }
        return "redirect:/staff-dashboard";
    }

    @PostMapping("/admin/approve-leave")
    public String approveLeave(@RequestParam Long id, RedirectAttributes ra) {
        Optional<LeaveRequest> opt = leaveRequestRepository.findById(id);
        if (opt.isPresent()) {
            LeaveRequest lr = opt.get();
            lr.setStatus("Approved");
            leaveRequestRepository.save(lr);
            ra.addFlashAttribute("successMessage", "Leave request approved!");
        }
        return "redirect:/admin-dashboard#staff-requests-section";
    }

    @PostMapping("/admin/reject-leave")
    public String rejectLeave(@RequestParam Long id, RedirectAttributes ra) {
        Optional<LeaveRequest> opt = leaveRequestRepository.findById(id);
        if (opt.isPresent()) {
            LeaveRequest lr = opt.get();
            lr.setStatus("Rejected");
            leaveRequestRepository.save(lr);
            ra.addFlashAttribute("successMessage", "Leave request rejected!");
        }
        return "redirect:/admin-dashboard#staff-requests-section";
    }

    @PostMapping("/delivery/leave/apply")
    public String applyDeliveryLeave(@RequestParam String startDate,
                                     @RequestParam String endDate,
                                     @RequestParam String reason,
                                     @RequestParam(required = false, defaultValue = "Full Day") String leaveType,
                                     HttpSession session,
                                     RedirectAttributes ra) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Delivery".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        try {
            LeaveRequest lr = new LeaveRequest(user, reason, LocalDate.parse(startDate), LocalDate.parse(endDate), leaveType);
            leaveRequestRepository.save(lr);
            ra.addFlashAttribute("successMessage", "Leave request submitted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error submitting leave: " + e.getMessage());
        }
        return "redirect:/delivery-dashboard";
    }
}
