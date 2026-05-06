package com.example.demo.controller;

import com.example.demo.model.LabRequest;
import com.example.demo.model.LabTest;
import com.example.demo.model.Patient;
import com.example.demo.model.User;
import com.example.demo.repository.PatientRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.LabRequestRepository;
import com.example.demo.repository.LabTestRepository;
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
import java.util.stream.Collectors;

@Controller
public class MainController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private LabRequestRepository labRequestRepo;

    @Autowired
    private LabTestRepository labTestRepo;

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
            @RequestParam(required = false) String pharmacyName,
            @RequestParam(required = false) String pharmacyAddress,
            @RequestParam(required = false) String pharmacyLicense,
            @RequestParam(required = false) String gender,
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
        } else if ("Pharmacy".equalsIgnoreCase(role)) {
            user.setPharmacyName(pharmacyName);
            user.setPharmacyAddress(pharmacyAddress);
            user.setPharmacyLicense(pharmacyLicense);
        }

        user.setGender(gender);

        userRepository.save(user);
        redirectAttributes.addFlashAttribute("registerSuccess", "Registration successful! Please login.");
        return "redirect:/";
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

    @GetMapping("/lab-dashboard")
    public String labDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Lab".equals(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        model.addAttribute("patients", patientRepository.findAll());
        model.addAttribute("deliveryPartners", userRepository.findByRole("Delivery"));
        model.addAttribute("allTests", labTestRepo.findAll());
        model.addAttribute("doctorRequests", labRequestRepo.findByStatus("Pending"));
        
        return "lab-dashboard";
    }

    @GetMapping("/delivery-dashboard")
    public String deliveryDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Delivery".equals(user.getRole())) return "redirect:/";
        
        String fullName = user.getFullName();
        model.addAttribute("user", user);
        model.addAttribute("tasks", patientRepository.findAll().stream()
                .filter(p -> p.getDeliveryAssignedTo() != null && 
                             p.getDeliveryAssignedTo().trim().equalsIgnoreCase(fullName.trim()))
                .collect(Collectors.toList()));
        return "delivery-dashboard";
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
        Optional<LabRequest> r = labRequestRepo.findById(id);
        if (r.isPresent()) {
            r.get().setStatus("Processed");
            labRequestRepo.save(r.get());
            redirectAttributes.addFlashAttribute("successMessage", "Request accepted!");
        }
        return "redirect:/lab-dashboard";
    }

    @GetMapping("/admin-dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Admin".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "admin-dashboard";
    }

    @GetMapping("/receptionist-dashboard")
    public String receptionistDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Receptionist".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "receptionist-dashboard";
    }

    @GetMapping("/patient-dashboard")
    public String patientDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Patient".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "patient-dashboard";
    }



    @GetMapping("/staff-dashboard")
    public String staffDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Staff".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "staff-dashboard";
    }

    @GetMapping("/doctor-dashboard")
    public String doctorDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Doctor".equalsIgnoreCase(user.getRole())) return "redirect:/";
        
        // This will lead to the view doctor-dashboard.jsp
        model.addAttribute("doctor", user);
        return "doctor-dashboard";
    }

    private String redirectToDashboard(String role) {
        switch (role.toLowerCase()) {
            case "doctor": return "redirect:/doctor-dashboard";
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
