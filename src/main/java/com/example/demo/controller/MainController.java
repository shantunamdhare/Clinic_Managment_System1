package com.example.demo.controller;

import com.example.demo.model.LabRequest;
import com.example.demo.model.LabTest;
import com.example.demo.model.Patient;
import com.example.demo.model.User;
import com.example.demo.model.Appointment;
import com.example.demo.model.Availability;
import com.example.demo.model.Invoice;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
public class MainController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private LabRequestRepository labRequestRepository;

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
    private LabReportRepository labReportRepository;

    @Autowired
    private InvoiceRepository invoiceRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/")
    public String landingPage() {
        return "landing";
    }

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
            RedirectAttributes redirectAttributes) {

        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("registerError", "Passwords do not match!");
            return "redirect:/#login-section";
        }

        if (userRepository.existsByEmail(email)) {
            redirectAttributes.addFlashAttribute("registerError", "Email already registered!");
            return "redirect:/#login-section";
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole(role);

        if ("Lab".equalsIgnoreCase(role)) {
            user.setLabName(labName);
            user.setLabAddress(labAddress);
            user.setLabId(labId);
            user.setLabType(labType);
        } else if ("Doctor".equalsIgnoreCase(role)) {
            user.setPhone(phone);
            user.setSpecialization(specialization);
            user.setExperience(experience);
            user.setLicenseId(licenseId);
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
        }

        userRepository.save(user);
        redirectAttributes.addFlashAttribute("registerSuccess", "Registration successful! Please login.");
        return "redirect:/#login-section";
    }

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
            redirectAttributes.addFlashAttribute("loginError", "Unauthorized role!");
            return "redirect:/";
        }
        
        session.setAttribute("user", user);
        return redirectToDashboard(user.getRole());
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

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
        long totalDoctors = userRepository.countByRole("Doctor");
        long totalStaff = userRepository.countByRole("Staff");
        long totalReceptionists = userRepository.countByRole("Receptionist");
        long totalLabUsers = userRepository.countByRole("Lab");
        long totalPharmacy = userRepository.countByRole("Pharmacy");
        long totalDelivery = userRepository.countByRole("Delivery");
        long totalUsers = userRepository.count();
        model.addAttribute("totalDoctors", totalDoctors);
        model.addAttribute("totalStaff", totalStaff);
        model.addAttribute("totalReceptionists", totalReceptionists);
        model.addAttribute("totalLabUsers", totalLabUsers);
        model.addAttribute("totalPharmacy", totalPharmacy);
        model.addAttribute("totalDelivery", totalDelivery);
        model.addAttribute("totalUsers", totalUsers);

        // Doctor availability today
        List<Availability> todayAvailability = availabilityRepository.findByAvailableDateOrderByStartTimeAsc(today);
        model.addAttribute("todayAvailability", todayAvailability);

        // Doctors list
        List<User> doctors = userRepository.findByRole("Doctor");
        model.addAttribute("doctors", doctors);

        // All staff (non-admin users)
        List<User> allUsers = userRepository.findAll();
        model.addAttribute("allUsers", allUsers);

        // Recent appointments
        List<Appointment> recentAppointments = appointmentRepository.findTop10ByOrderByAppointmentDateDescAppointmentTimeDesc();
        model.addAttribute("recentAppointments", recentAppointments);

        // Today's appointments
        List<Appointment> todayAppointmentsList = appointmentRepository.findByAppointmentDateOrderByAppointmentTimeAsc(today);
        model.addAttribute("todayAppointmentsList", todayAppointmentsList);

        // Visits count
        long totalVisits = visitRepository.count();
        model.addAttribute("totalVisits", totalVisits);

        // System Alerts (Mocked for UI)
        List<Map<String, String>> alerts = new ArrayList<>();
        Map<String, String> a1 = new HashMap<>();
        a1.put("type", "Critical");
        a1.put("message", "Oxygen Cylinder stock below 10%");
        a1.put("time", "10 mins ago");
        alerts.add(a1);
        Map<String, String> a2 = new HashMap<>();
        a2.put("type", "Warning");
        a2.put("message", "Dr. Emily Chen requested leave for tomorrow");
        a2.put("time", "1 hour ago");
        alerts.add(a2);
        model.addAttribute("systemAlerts", alerts);

        // Low Stocks (Mocked for UI)
        List<Map<String, String>> lowStocks = new ArrayList<>();
        Map<String, String> s1 = new HashMap<>();
        s1.put("item", "Paracetamol 500mg");
        s1.put("count", "45 tabs");
        s1.put("status", "Reorder");
        lowStocks.add(s1);
        Map<String, String> s2 = new HashMap<>();
        s2.put("item", "Surgical Gloves (M)");
        s2.put("count", "12 pairs");
        s2.put("status", "Critical");
        lowStocks.add(s2);
        model.addAttribute("lowStocks", lowStocks);

        // Pending Bills (Mocked for UI)
        List<Map<String, String>> pendingBills = new ArrayList<>();
        Map<String, String> b1 = new HashMap<>();
        b1.put("patient", "Emily Johnson");
        b1.put("amount", "$120.00");
        b1.put("due", "2 days ago");
        pendingBills.add(b1);
        Map<String, String> b2 = new HashMap<>();
        b2.put("patient", "Robert Wilson");
        b2.put("amount", "$85.50");
        b2.put("due", "Today");
        pendingBills.add(b2);
        model.addAttribute("pendingBills", pendingBills);

        return "admin-dashboard";
    }



    @GetMapping("/receptionist-dashboard")
    public String receptionistDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Receptionist".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "receptionist-dashboard";
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
            // Mock empty or create one
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

        // Fetch actual doctors for booking
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
            e.printStackTrace();
        }
        
        return "redirect:/patient-dashboard";
    }

    @GetMapping("/lab-dashboard")
    public String labDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Lab".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        model.addAttribute("patients", patientRepository.findAll());
        model.addAttribute("deliveryPartners", userRepository.findByRole("Delivery"));
        model.addAttribute("allTests", labTestRepo.findAll());
        model.addAttribute("doctorRequests", labRequestRepository.findByStatus("Pending"));
        
        return "lab-dashboard";
    }

    @GetMapping("/pharmacy-dashboard")
    public String pharmacyDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "pharmacy-dashboard";
    }

    @GetMapping("/delivery-dashboard")
    public String deliveryDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Delivery".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        String fullName = user.getFullName();
        model.addAttribute("user", user);
        model.addAttribute("tasks", patientRepository.findAll().stream()
                .filter(p -> p.getDeliveryAssignedTo() != null && 
                             p.getDeliveryAssignedTo().trim().equalsIgnoreCase(fullName.trim()))
                .collect(Collectors.toList()));
        return "delivery-dashboard";
    }

    @GetMapping("/staff-dashboard")
    public String staffDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Staff".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "staff-dashboard";
    }

    @PostMapping("/assign-delivery")
    public String assignDelivery(
            @RequestParam Long patientId,
            @RequestParam(required = false) Long deliveryUserId,
            @RequestParam(required = false) String destinationType,
            RedirectAttributes redirectAttributes) {
        
        Optional<Patient> optionalPatient = patientRepository.findById(patientId);
        if (optionalPatient.isPresent()) {
            Patient patient = optionalPatient.get();
            if ("In-House".equals(destinationType)) {
                patient.setDeliveryStatus("Delivered");
                patient.setDeliveryAssignedTo("Not Required");
                patient.setDestinationHospital("In-House Lab");
                patient.setCurrentLocation("Lab Reception");
                patientRepository.save(patient);
                redirectAttributes.addFlashAttribute("successMessage", "Patient marked for In-House processing.");
            } else if (deliveryUserId != null) {
                Optional<User> optionalUser = userRepository.findById(deliveryUserId);
                if (optionalUser.isPresent()) {
                    User deliveryUser = optionalUser.get();
                    patient.setDeliveryAssignedTo(deliveryUser.getFullName());
                    patient.setDeliveryBoyPhone(deliveryUser.getPhone());
                    patient.setDeliveryStatus("In Transit");
                    patient.setCurrentLocation("En Route to Lab");
                    patientRepository.save(patient);
                    redirectAttributes.addFlashAttribute("successMessage", "Assigned to " + deliveryUser.getFullName());
                }
            }
        }
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/update-delivery-status")
    public String updateStatus(@RequestParam Long id, @RequestParam String status, RedirectAttributes redirectAttributes) {
        Optional<Patient> optionalPatient = patientRepository.findById(id);
        if (optionalPatient.isPresent()) {
            Patient p = optionalPatient.get();
            p.setDeliveryStatus(status);
            if ("Delivered".equals(status)) p.setCurrentLocation("At Lab");
            patientRepository.save(p);
            redirectAttributes.addFlashAttribute("successMessage", "Status updated to " + status);
        }
        return "redirect:/delivery-dashboard";
    }

    @PostMapping("/upload-report")
    public String uploadReport(@RequestParam Long patientId, RedirectAttributes redirectAttributes) {
        Optional<Patient> p = patientRepository.findById(patientId);
        if (p.isPresent()) {
            p.get().setDeliveryStatus("Completed");
            patientRepository.save(p.get());
            redirectAttributes.addFlashAttribute("successMessage", "Report uploaded and status set to Completed!");
        }
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/process-lab-request")
    public String processRequest(@RequestParam Long id, RedirectAttributes redirectAttributes) {
        Optional<LabRequest> r = labRequestRepository.findById(id);
        if (r.isPresent()) {
            r.get().setStatus("Processed");
            labRequestRepository.save(r.get());
            redirectAttributes.addFlashAttribute("successMessage", "Request accepted!");
        }
        return "redirect:/lab-dashboard";
    }

    @PostMapping("/admin/update-attendance")
    public String updateAttendance(
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
                if (checkIn != null && !checkIn.isEmpty()) staff.setCheckInTime(checkIn);
                if (checkOut != null && !checkOut.isEmpty()) staff.setCheckOutTime(checkOut);
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
            case "doctor": return "redirect:/doctor/dashboard";
            case "lab": return "redirect:/lab-dashboard";
            case "delivery": return "redirect:/delivery-dashboard";
            case "admin": return "redirect:/admin-dashboard";
            case "receptionist": return "redirect:/receptionist-dashboard";
            case "patient": return "redirect:/patient-dashboard";
            case "pharmacy": return "redirect:/pharmacy-dashboard";
            case "staff": return "redirect:/staff-dashboard";
            default: return "redirect:/";
        }
    }
}
