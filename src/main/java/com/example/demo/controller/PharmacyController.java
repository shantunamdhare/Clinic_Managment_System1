package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.PharmacyService;
import com.example.demo.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
public class PharmacyController {

    @Autowired
    private PharmacyService pharmacyService;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private InvoiceRepository invoiceRepository;

    @Autowired
    private StaffShiftRepository staffShiftRepository;

    @Autowired
    private StaffAttendanceRepository staffAttendanceRepository;

    @GetMapping("/pharmacy-dashboard")
    public String dashboard(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        model.addAttribute("dailyRevenue", pharmacyService.getDailyRevenue());
        model.addAttribute("lowStockCount", pharmacyService.getLowStockMedicines().size());
        model.addAttribute("expiringSoonCount", pharmacyService.getExpiringMedicines().size());
        model.addAttribute("pendingPaymentsCount", pharmacyService.getPendingPayments().size());
        
        model.addAttribute("lowStockMedicines", pharmacyService.getLowStockMedicines());
        model.addAttribute("expiringMedicines", pharmacyService.getExpiringMedicines());
        model.addAttribute("medicines", pharmacyService.getAllMedicines());
        model.addAttribute("patients", patientRepository.findAll());
        model.addAttribute("recentInvoices", invoiceRepository.findAllByOrderByInvoiceDateDesc());
        model.addAttribute("allShifts", staffShiftRepository.findAll());
        model.addAttribute("allAttendance", staffAttendanceRepository.findAll());
        
        return "pharmacy-dashboard";
    }

    @PostMapping("/generate-invoice")
    public String generateInvoice(
            @RequestParam Long patientId,
            @RequestParam Long medicineId,
            @RequestParam Integer quantity,
            @RequestParam String paymentMethod,
            RedirectAttributes redirectAttributes) {
        
        try {
            Patient patient = patientRepository.findById(patientId)
                    .orElseThrow(() -> new RuntimeException("Patient not found"));
            Medicine medicine = pharmacyService.getAllMedicines().stream()
                    .filter(m -> m.getId().equals(medicineId))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Medicine not found"));

            InvoiceItem item = new InvoiceItem();
            item.setMedicine(medicine);
            item.setQuantity(quantity);
            item.setUnitPrice(medicine.getPrice());

            List<InvoiceItem> items = new ArrayList<>();
            items.add(item);

            pharmacyService.generateInvoice(patient, items, paymentMethod);
            redirectAttributes.addFlashAttribute("successMessage", "Invoice generated successfully for " + patient.getName());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        return "redirect:/pharmacy/billing";
    }

    @GetMapping("/pharmacy/inventory")
    public String inventory(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("medicines", pharmacyService.getAllMedicines());
        return "pharmacy/inventory";
    }

    @GetMapping("/pharmacy/billing")
    public String billing(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("medicines", pharmacyService.getAllMedicines());
        model.addAttribute("patients", patientRepository.findAll());
        return "pharmacy/billing";
    }

    @GetMapping("/pharmacy/sales")
    public String sales(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("recentInvoices", invoiceRepository.findAllByOrderByInvoiceDateDesc());
        return "pharmacy/sales";
    }

    @GetMapping("/pharmacy/staff")
    public String staff(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("allShifts", staffShiftRepository.findAll());
        model.addAttribute("allAttendance", staffAttendanceRepository.findAll());
        
        // Check if current user is already checked in today
        Optional<StaffAttendance> todayAtt = staffAttendanceRepository.findAll().stream()
                .filter(a -> a.getStaff().getId().equals(user.getId()) && a.getDate().equals(LocalDate.now()))
                .findFirst();
        model.addAttribute("todayAttendance", todayAtt.orElse(null));
        
        return "pharmacy/staff";
    }

    @PostMapping("/pharmacy/check-in")
    public String checkIn(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";
        
        StaffAttendance att = new StaffAttendance();
        att.setStaff(user);
        att.setDate(LocalDate.now());
        att.setCheckIn(LocalTime.now());
        att.setStatus("Present");
        staffAttendanceRepository.save(att);

        // Sync User entity for Admin Dashboard
        user.setAttendanceStatus("Present");
        user.setCheckInTime(att.getCheckIn().toString());
        pharmacyService.updateUser(user); // Using service to save
        
        redirectAttributes.addFlashAttribute("successMessage", "Checked in successfully at " + att.getCheckIn());
        return "redirect:/pharmacy/staff";
    }

    @PostMapping("/pharmacy/check-out")
    public String checkOut(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";
        
        Optional<StaffAttendance> todayAtt = staffAttendanceRepository.findAll().stream()
                .filter(a -> a.getStaff().getId().equals(user.getId()) && a.getDate().equals(LocalDate.now()))
                .findFirst();
                
        if (todayAtt.isPresent()) {
            StaffAttendance att = todayAtt.get();
            att.setCheckOut(LocalTime.now());
            att.setStatus("Completed");
            staffAttendanceRepository.save(att);

            // Sync User entity for Admin Dashboard
            user.setAttendanceStatus("Completed");
            user.setCheckOutTime(att.getCheckOut().toString());
            pharmacyService.updateUser(user);
            
            redirectAttributes.addFlashAttribute("successMessage", "Checked out successfully at " + att.getCheckOut());
        }
        
        return "redirect:/pharmacy/staff";
    }
}
