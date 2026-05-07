package com.example.demo.controller;

import com.example.demo.service.PharmacyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PharmacyController {

    @Autowired
    private PharmacyService pharmacyService;

    @Autowired
    private com.example.demo.repository.PatientRepository patientRepository;

    @Autowired
    private com.example.demo.repository.InvoiceRepository invoiceRepository;

    @Autowired
    private com.example.demo.repository.StaffShiftRepository staffShiftRepository;

    @Autowired
    private com.example.demo.repository.StaffAttendanceRepository staffAttendanceRepository;

    @GetMapping("/pharmacy-dashboard")
    public String dashboard(Model model, jakarta.servlet.http.HttpSession session) {
        com.example.demo.model.User user = (com.example.demo.model.User) session.getAttribute("user");
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
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        
        try {
            com.example.demo.model.Patient patient = patientRepository.findById(patientId)
                    .orElseThrow(() -> new RuntimeException("Patient not found"));
            com.example.demo.model.Medicine medicine = pharmacyService.getAllMedicines().stream()
                    .filter(m -> m.getId().equals(medicineId))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Medicine not found"));

            com.example.demo.model.InvoiceItem item = new com.example.demo.model.InvoiceItem();
            item.setMedicine(medicine);
            item.setQuantity(quantity);
            item.setUnitPrice(medicine.getPrice());

            java.util.List<com.example.demo.model.InvoiceItem> items = new java.util.ArrayList<>();
            items.add(item);

            pharmacyService.generateInvoice(patient, items, paymentMethod);
            redirectAttributes.addFlashAttribute("successMessage", "Invoice generated successfully for " + patient.getName());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }
        
        return "redirect:/pharmacy/billing";
    }

    @GetMapping("/pharmacy/inventory")
    public String inventory(Model model, jakarta.servlet.http.HttpSession session) {
        com.example.demo.model.User user = (com.example.demo.model.User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("medicines", pharmacyService.getAllMedicines());
        return "pharmacy/inventory";
    }

    @GetMapping("/pharmacy/billing")
    public String billing(Model model, jakarta.servlet.http.HttpSession session) {
        com.example.demo.model.User user = (com.example.demo.model.User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("medicines", pharmacyService.getAllMedicines());
        model.addAttribute("patients", patientRepository.findAll());
        return "pharmacy/billing";
    }

    @GetMapping("/pharmacy/sales")
    public String sales(Model model, jakarta.servlet.http.HttpSession session) {
        com.example.demo.model.User user = (com.example.demo.model.User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("recentInvoices", invoiceRepository.findAllByOrderByInvoiceDateDesc());
        return "pharmacy/sales";
    }

    @GetMapping("/pharmacy/staff")
    public String staff(Model model, jakarta.servlet.http.HttpSession session) {
        com.example.demo.model.User user = (com.example.demo.model.User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("allShifts", staffShiftRepository.findAll());
        model.addAttribute("allAttendance", staffAttendanceRepository.findAll());
        
        // Check if current user is already checked in today
        java.util.Optional<com.example.demo.model.StaffAttendance> todayAtt = staffAttendanceRepository.findAll().stream()
                .filter(a -> a.getStaff().getId().equals(user.getId()) && a.getDate().equals(java.time.LocalDate.now()))
                .findFirst();
        model.addAttribute("todayAttendance", todayAtt.orElse(null));
        
        return "pharmacy/staff";
    }

    @PostMapping("/pharmacy/check-in")
    public String checkIn(jakarta.servlet.http.HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        com.example.demo.model.User user = (com.example.demo.model.User) session.getAttribute("user");
        if (user == null) return "redirect:/";
        
        com.example.demo.model.StaffAttendance att = new com.example.demo.model.StaffAttendance();
        att.setStaff(user);
        att.setDate(java.time.LocalDate.now());
        att.setCheckIn(java.time.LocalTime.now());
        att.setStatus("Present");
        staffAttendanceRepository.save(att);
        
        redirectAttributes.addFlashAttribute("successMessage", "Checked in successfully at " + att.getCheckIn());
        return "redirect:/pharmacy/staff";
    }

    @PostMapping("/pharmacy/check-out")
    public String checkOut(jakarta.servlet.http.HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        com.example.demo.model.User user = (com.example.demo.model.User) session.getAttribute("user");
        if (user == null) return "redirect:/";
        
        java.util.Optional<com.example.demo.model.StaffAttendance> todayAtt = staffAttendanceRepository.findAll().stream()
                .filter(a -> a.getStaff().getId().equals(user.getId()) && a.getDate().equals(java.time.LocalDate.now()))
                .findFirst();
                
        if (todayAtt.isPresent()) {
            com.example.demo.model.StaffAttendance att = todayAtt.get();
            att.setCheckOut(java.time.LocalTime.now());
            att.setStatus("Completed");
            staffAttendanceRepository.save(att);
            redirectAttributes.addFlashAttribute("successMessage", "Checked out successfully at " + att.getCheckOut());
        }
        
        return "redirect:/pharmacy/staff";
    }
}
