package com.example.demo.controller;

import com.example.demo.model.Clinic;
import com.example.demo.model.User;
import com.example.demo.repository.ClinicRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.PatientRepository;
import com.example.demo.repository.AppointmentRepository;
import com.example.demo.repository.InvoiceRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.Optional;

@Controller
@RequestMapping("/superadmin")
public class SuperAdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ClinicRepository clinicRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private InvoiceRepository invoiceRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/login")
    public String loginPage() {
        return "superadmin-login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password, HttpSession session, RedirectAttributes ra) {
        Optional<User> optUser = userRepository.findByEmail(email);
        if (optUser.isPresent() && passwordEncoder.matches(password, optUser.get().getPassword()) && "Super Admin".equalsIgnoreCase(optUser.get().getRole())) {
            session.setAttribute("superAdmin", optUser.get());
            return "redirect:/superadmin/dashboard";
        }
        ra.addFlashAttribute("loginError", "Invalid Super Admin credentials.");
        return "redirect:/superadmin/login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("superAdmin");
        return "redirect:/superadmin/login";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User superAdmin = (User) session.getAttribute("superAdmin");
        if (superAdmin == null) {
            return "redirect:/superadmin/login";
        }
        model.addAttribute("superAdmin", superAdmin);
        
        long totalClinics = clinicRepository.count();
        double totalRevenue = invoiceRepository.findAll().stream().mapToDouble(i -> i.getTotalAmount() != null ? i.getTotalAmount() : 0.0).sum();
        long totalAdmins = userRepository.countByRole("Admin");
        long totalDoctors = userRepository.countByRole("Doctor");
        long totalPatients = patientRepository.count();
        long totalAppointments = appointmentRepository.count();

        model.addAttribute("totalClinics", totalClinics);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("totalAdmins", totalAdmins);
        model.addAttribute("totalDoctors", totalDoctors);
        model.addAttribute("totalPatients", totalPatients);
        model.addAttribute("totalAppointments", totalAppointments);

        java.util.List<Clinic> allClinics = clinicRepository.findAll();
        model.addAttribute("clinics", allClinics);
        model.addAttribute("admins", userRepository.findByRoleIgnoreCase("Admin"));

        // Calculate specific stats per clinic
        java.util.List<User> allUsers = userRepository.findAll();
        java.util.List<com.example.demo.model.Appointment> allAppts = appointmentRepository.findAll();
        java.util.List<com.example.demo.model.Invoice> allInvs = invoiceRepository.findAll();
        java.util.Map<Long, java.util.Map<String, Object>> clinicStats = new java.util.HashMap<>();
        
        for (Clinic c : allClinics) {
            java.util.Map<String, Object> stats = new java.util.HashMap<>();
            long cUsers = allUsers.stream().filter(u -> c.getName().equalsIgnoreCase(u.getHospitalName())).count();
            long cDocs = allUsers.stream().filter(u -> "Doctor".equalsIgnoreCase(u.getRole()) && c.getName().equalsIgnoreCase(u.getHospitalName())).count();
            
            java.util.List<com.example.demo.model.Appointment> cAppts = allAppts.stream()
                .filter(a -> a.getDoctor() != null && c.getName().equalsIgnoreCase(a.getDoctor().getHospitalName()))
                .collect(java.util.stream.Collectors.toList());
            
            java.util.Set<Long> cPatientIds = cAppts.stream().map(a -> a.getPatient().getId()).collect(java.util.stream.Collectors.toSet());
            double cRev = allInvs.stream().filter(i -> i.getPatient() != null && cPatientIds.contains(i.getPatient().getId()))
                .mapToDouble(i -> i.getTotalAmount() != null ? i.getTotalAmount() : 0.0).sum();
            
            stats.put("users", cUsers);
            stats.put("doctors", cDocs);
            stats.put("appointments", cAppts.size());
            stats.put("patients", cPatientIds.size());
            stats.put("revenue", cRev);
            clinicStats.put(c.getId(), stats);
        }
        model.addAttribute("clinicStats", clinicStats);

        return "superadmin-dashboard";
    }

    @PostMapping("/clinic/add")
    public String addClinic(@ModelAttribute Clinic clinic, RedirectAttributes ra) {
        clinic.setRegistrationDate(LocalDate.now());
        clinic.setStatus("Active");
        clinicRepository.save(clinic);
        ra.addFlashAttribute("success", "Clinic added successfully.");
        return "redirect:/superadmin/dashboard";
    }

    @PostMapping("/clinic/update")
    public String updateClinic(@RequestParam Long id, @RequestParam String name, @RequestParam String address, @RequestParam String contactNumber, @RequestParam String email, RedirectAttributes ra) {
        Clinic clinic = clinicRepository.findById(id).orElse(null);
        if (clinic != null) {
            clinic.setName(name);
            clinic.setAddress(address);
            clinic.setContactNumber(contactNumber);
            clinic.setEmail(email);
            clinicRepository.save(clinic);
            ra.addFlashAttribute("success", "Clinic updated successfully.");
        }
        return "redirect:/superadmin/dashboard";
    }

    @PostMapping("/clinic/status")
    public String updateClinicStatus(@RequestParam Long id, @RequestParam String status, RedirectAttributes ra) {
        Clinic clinic = clinicRepository.findById(id).orElse(null);
        if (clinic != null) {
            clinic.setStatus(status);
            clinicRepository.save(clinic);
            ra.addFlashAttribute("success", "Clinic status updated to " + status + ".");
        }
        return "redirect:/superadmin/dashboard";
    }

    @PostMapping("/clinic/remove")
    public String removeClinic(@RequestParam Long id, RedirectAttributes ra) {
        clinicRepository.deleteById(id);
        ra.addFlashAttribute("success", "Clinic removed successfully.");
        return "redirect:/superadmin/dashboard";
    }

    @PostMapping("/admin/add")
    public String addAdmin(@RequestParam String fullName, @RequestParam String email, @RequestParam String password, @RequestParam String clinicName, RedirectAttributes ra) {
        if (userRepository.existsByEmail(email)) {
            ra.addFlashAttribute("error", "Email already exists.");
            return "redirect:/superadmin/dashboard";
        }
        User admin = new User();
        admin.setFullName(fullName);
        admin.setEmail(email);
        admin.setPassword(passwordEncoder.encode(password));
        admin.setRole("Admin");
        admin.setHospitalName(clinicName);
        userRepository.save(admin);
        ra.addFlashAttribute("success", "Admin account created successfully.");
        return "redirect:/superadmin/dashboard";
    }

    @PostMapping("/admin/update")
    public String updateAdmin(@RequestParam Long id, @RequestParam String fullName, @RequestParam String email, @RequestParam String clinicName, RedirectAttributes ra) {
        User admin = userRepository.findById(id).orElse(null);
        if (admin != null) {
            admin.setFullName(fullName);
            admin.setEmail(email);
            admin.setHospitalName(clinicName);
            userRepository.save(admin);
            ra.addFlashAttribute("success", "Admin details updated.");
        }
        return "redirect:/superadmin/dashboard";
    }

    @PostMapping("/admin/remove")
    public String removeAdmin(@RequestParam Long id, RedirectAttributes ra) {
        userRepository.deleteById(id);
        ra.addFlashAttribute("success", "Admin account removed.");
        return "redirect:/superadmin/dashboard";
    }

    @PostMapping("/admin/reset-password")
    public String resetAdminPassword(@RequestParam Long id, @RequestParam String newPassword, RedirectAttributes ra) {
        User admin = userRepository.findById(id).orElse(null);
        if (admin != null) {
            admin.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(admin);
            ra.addFlashAttribute("success", "Admin password reset successfully.");
        }
        return "redirect:/superadmin/dashboard";
    }
}
