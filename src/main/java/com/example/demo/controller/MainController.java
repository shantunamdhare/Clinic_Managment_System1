package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
public class MainController {

    @Autowired
    private UserRepository userRepository;

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
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String specialization,
            @RequestParam(required = false) Integer experience,
            @RequestParam(required = false) String licenseId,
            RedirectAttributes redirectAttributes) {

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("registerError", "Passwords do not match!");
            return "redirect:/#register-section";
        }

        // Check if email already exists
        if (userRepository.existsByEmail(email)) {
            redirectAttributes.addFlashAttribute("registerError", "Email already registered!");
            return "redirect:/#register-section";
        }

        // Create and save user
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole(role);
        
        if ("Doctor".equalsIgnoreCase(role)) {
            user.setPhone(phone);
            user.setSpecialization(specialization);
            user.setExperience(experience);
            user.setLicenseId(licenseId);
        }

        userRepository.save(user);

        redirectAttributes.addFlashAttribute("registerSuccess", "Registration successful! Please login.");
        return "redirect:/";
    }

    // ========================
    // User Login (with role dropdown)
    // ========================
    @PostMapping("/login")
    public String loginUser(
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String role,
            jakarta.servlet.http.HttpSession session,
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

        // Redirect based on role
        return redirectToDashboard(user.getRole(), user.getFullName(), redirectAttributes);
    }

    // ========================
    // User Logout
    // ========================
    @GetMapping("/logout")
    public String logout(jakarta.servlet.http.HttpSession session) {
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
    public String labDashboard() {
        return "lab-dashboard";
    }

    @GetMapping("/pharmacy-dashboard")
    public String pharmacyDashboard() {
        return "pharmacy-dashboard";
    }

    @GetMapping("/staff-dashboard")
    public String staffDashboard() {
        return "staff-dashboard";
    }

    // ========================
    // Helper: Redirect to Dashboard
    // ========================
    private String redirectToDashboard(String role, String fullName, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("userName", fullName);

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
            case "pharmacy":
                return "redirect:/pharmacy-dashboard";
            case "staff":
                return "redirect:/staff-dashboard";
            default:
                redirectAttributes.addFlashAttribute("loginError", "Unknown role!");
                return "redirect:/";
        }
    }
}
