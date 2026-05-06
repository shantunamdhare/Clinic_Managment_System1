package com.example.demo.controller;

import com.example.demo.model.Patient;
import com.example.demo.model.User;
import com.example.demo.repository.PatientRepository;
import com.example.demo.repository.UserRepository;
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
import java.util.Optional;

@Controller
public class MainController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PatientRepository patientRepository;

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
            RedirectAttributes redirectAttributes) {

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("registerError", "Passwords do not match!");
            return "redirect:/#login-section";
        }

        // Check if email already exists
        if (userRepository.existsByEmail(email)) {
            redirectAttributes.addFlashAttribute("registerError", "Email already registered!");
            return "redirect:/#login-section";
        }

        // Create and save user
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
        }

        userRepository.save(user);

        redirectAttributes.addFlashAttribute("registerSuccess", "Registration successful! Please login.");
        return "redirect:/#login-section";
    }

    // ========================
    // User Login (with role dropdown)
    // ========================
    @PostMapping("/login")
    public String loginUser(
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String role,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<User> optionalUser = userRepository.findByEmail(email);

        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("loginError", "Invalid email or password!");
            return "redirect:/";
        }

        User user = optionalUser.get();

        if (!passwordEncoder.matches(password, user.getPassword())) {
            redirectAttributes.addFlashAttribute("loginError", "Invalid email or password!");
            return "redirect:/";
        }

        // Check if user has the selected role
        if (!user.getRole().equalsIgnoreCase(role)) {
            redirectAttributes.addFlashAttribute("loginError", "You are not authorized for the selected role!");
            return "redirect:/";
        }
        
        // Save to session
        session.setAttribute("loggedInUser", user);
        if (role.equalsIgnoreCase("doctor")) {
            session.setAttribute("loggedInDoctor", user);
        }

        // Store user in session
        session.setAttribute("user", user);

        // Redirect based on role
        return redirectToDashboard(user.getRole(), redirectAttributes);
    }

    // ========================
    // User Logout
    // ========================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // ========================
    // Dashboard Routes
    // ========================
    @GetMapping("/admin-dashboard")
    public String adminDashboard() {
        return "admin-dashboard";
    }

    @GetMapping("/doctor-dashboard")
    public String doctorDashboard() {
        return "redirect:/doctor/dashboard";
    }

    @GetMapping("/receptionist-dashboard")
    public String receptionistDashboard() {
        return "receptionist-dashboard";
    }

    @GetMapping("/patient-dashboard")
    public String patientDashboard() {
        return "patient-dashboard";
    }

    @GetMapping("/lab-dashboard")
    public String labDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Lab".equals(user.getRole())) {
            return "redirect:/";
        }
        model.addAttribute("user", user);
        model.addAttribute("patients", patientRepository.findAll());
        return "lab-dashboard";
    }

    @GetMapping("/pharmacy-dashboard")
    public String pharmacyDashboard() {
        return "pharmacy-dashboard";
    }

    @GetMapping("/delivery-dashboard")
    public String deliveryDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Delivery".equals(user.getRole())) {
            return "redirect:/";
        }
        model.addAttribute("user", user);
        // Delivery boy sees patients whose samples need to be picked up or are in transit
        model.addAttribute("tasks", patientRepository.findAll()); 
        return "delivery-dashboard";
    }

    @GetMapping("/staff-dashboard")
    public String staffDashboard() {
        return "staff-dashboard";
    }

    // ========================
    // Patient Management
    // ========================
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
            patient.setLastVisit(LocalDate.now().toString()); // Update last visit date
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
        
        // Parse dob yyyy-MM-dd
        String[] dobParts = dob.split("-");
        if (dobParts.length == 3) {
            patient.setDateOfBirth(LocalDate.of(Integer.parseInt(dobParts[0]), Integer.parseInt(dobParts[1]), Integer.parseInt(dobParts[2])));
        }
        
        patient.setGender(gender);
        patient.setBloodGroup(bloodGroup);
        patient.setPatientId("PID-" + (int)(Math.random() * 9000 + 1000));
        patient.setDeliveryStatus("Pending Pickup");
        patient.setDeliveryAssignedTo("Unassigned");
        patient.setSourceHospital("External Booking");
        patient.setDestinationHospital("MediCare Central Lab");
        patient.setLastVisit(LocalDate.now().toString());

        patientRepository.save(patient);
        redirectAttributes.addFlashAttribute("successMessage", "New test request created successfully!");
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
            redirectAttributes.addFlashAttribute("successMessage", "Delivery status updated to: " + status);
        }
        return "redirect:/delivery-dashboard";
    }

    // ========================
    // Helper: Redirect to Dashboard
    // ========================
    private String redirectToDashboard(String role, RedirectAttributes redirectAttributes) {
        switch (role.toLowerCase()) {
            case "admin":
                return "redirect:/admin-dashboard";
            case "doctor":
                return "redirect:/doctor/dashboard";
            case "receptionist":
                return "redirect:/receptionist-dashboard";
            case "patient":
                return "redirect:/patient-dashboard";
            case "lab":
                return "redirect:/lab-dashboard";
            case "delivery":
                return "redirect:/delivery-dashboard";
            case "pharmacy":
                return "redirect:/pharmacy-dashboard";
            case "staff":
                return "redirect:/staff-dashboard";
            default:
                return "redirect:/";
        }
    }
}
