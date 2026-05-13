package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.PharmacyService;
import com.example.demo.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import com.example.demo.service.InvoicePdfService;
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

    @Autowired
    private NotificationRepository notificationRepo;

    @Autowired
    private InvoicePdfService invoicePdfService;

    @Autowired
    private MedicineRepository medicineRepository;

    @Autowired
    private LeaveRequestRepository leaveRequestRepository;

    @GetMapping("/pharmacy-dashboard")
    public String dashboard(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        
        // Trigger alerts check
        pharmacyService.checkAndGenerateAlerts();
        
        // Explicitly calculate and add counts for the top boxes
        Double revenue = pharmacyService.getDailyRevenue();
        int lowStock = pharmacyService.getLowStockMedicines().size();
        int expiring = pharmacyService.getExpiringMedicines().size();
        int pending = pharmacyService.getPendingPayments().size();

        model.addAttribute("dailyRevenue", revenue != null ? revenue : 0.0);
        model.addAttribute("lowStockCount", lowStock);
        model.addAttribute("expiringSoonCount", expiring);
        model.addAttribute("pendingPaymentsCount", pending);
        
        // Add lists for other sections
        model.addAttribute("lowStockMedicines", pharmacyService.getLowStockMedicines());
        model.addAttribute("expiringMedicines", pharmacyService.getExpiringMedicines());
        model.addAttribute("medicines", pharmacyService.getAllMedicines());
        model.addAttribute("patients", patientRepository.findAll());
        model.addAttribute("recentInvoices", invoiceRepository.findAllByOrderByInvoiceDateDesc());
        model.addAttribute("allShifts", staffShiftRepository.findAll());
        model.addAttribute("allAttendance", staffAttendanceRepository.findAll());
        model.addAttribute("prescriptions", pharmacyService.getActivePrescriptions());
        model.addAttribute("notifications", notificationRepo.findByUserAndIsReadFalseOrderByCreatedAtDesc(user));
        
        return "pharmacy-dashboard";
    }

    @PostMapping("/pharmacy/update-prescription-status")
    public String updatePrescriptionStatus(@RequestParam Long id,
                                           @RequestParam String status,
                                           @RequestParam(required = false) String notes,
                                           RedirectAttributes ra) {
        try {
            pharmacyService.updatePrescriptionStatus(id, status, notes);
            ra.addFlashAttribute("successMessage", "Status updated to " + status);
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }
        return "redirect:/pharmacy-dashboard";
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

            pharmacyService.generateInvoice(patient, items, paymentMethod, 0.0);
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
        
        pharmacyService.checkAndGenerateAlerts();
        
        model.addAttribute("user", user);
        model.addAttribute("medicines", pharmacyService.getAllMedicines());
        model.addAttribute("lowStockMedicines", pharmacyService.getLowStockMedicines());
        List<Medicine> expiring = pharmacyService.getExpiringMedicines();
        model.addAttribute("expiringSoonMedicines", expiring);
        model.addAttribute("expiringIds", expiring.stream().map(Medicine::getId).collect(java.util.stream.Collectors.toSet()));
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
    public String sales(@RequestParam(required = false) String range, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        
        List<Invoice> invoices;
        if ("today".equals(range)) {
            invoices = invoiceRepository.findByInvoiceDateBetween(LocalDate.now().atStartOfDay(), LocalDateTime.now());
        } else if ("month".equals(range)) {
            invoices = invoiceRepository.findByInvoiceDateBetween(LocalDate.now().withDayOfMonth(1).atStartOfDay(), LocalDateTime.now());
        } else {
            invoices = invoiceRepository.findAllByOrderByInvoiceDateDesc();
        }
        
        model.addAttribute("recentInvoices", invoices);
        model.addAttribute("totalRevenue", invoices.stream().mapToDouble(Invoice::getTotalAmount).sum());
        return "pharmacy/sales";
    }

    @GetMapping("/pharmacy/patient-billing/{id}")
    public String patientBilling(@PathVariable Long id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        
        Patient patient = patientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        
        model.addAttribute("user", user);
        model.addAttribute("patient", patient);
        model.addAttribute("invoices", invoiceRepository.findByPatient(patient));
        return "pharmacy/patient-billing";
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

    @PostMapping("/pharmacy/dispense")
    public String dispensePrescription(@RequestParam Long prescriptionId,
                                     @RequestParam String paymentMethod,
                                     @RequestParam(required = false) String transactionId,
                                     @RequestParam(required = false) String cardNumber,
                                     @RequestParam(required = false) String cardHolder,
                                     RedirectAttributes ra) {
        try {
            StringBuilder notes = new StringBuilder("Medicines dispensed. Payment: " + paymentMethod);
            if (transactionId != null && !transactionId.isEmpty()) {
                notes.append(" (TXN ID: ").append(transactionId).append(")");
            }
            if (cardNumber != null && !cardNumber.isEmpty()) {
                notes.append(" (Card: ").append(cardNumber).append(", holder: ").append(cardHolder).append(")");
            }
            
            pharmacyService.updatePrescriptionStatus(prescriptionId, "Dispensed", notes.toString());
            ra.addFlashAttribute("successMessage", "Prescription dispensed successfully and invoice generated via " + paymentMethod);
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error during dispensing: " + e.getMessage());
        }
        return "redirect:/pharmacy-dashboard";
    }

    @GetMapping("/pharmacy/invoice/download")
    public org.springframework.http.ResponseEntity<org.springframework.core.io.InputStreamResource> downloadInvoice(@RequestParam Long id) {
        Invoice inv = invoiceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Invoice not found"));

        java.io.ByteArrayInputStream bis = invoicePdfService.generateInvoicePdf(inv);

        org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
        headers.add("Content-Disposition", "inline; filename=invoice_" + inv.getInvoiceNumber() + ".pdf");

        return org.springframework.http.ResponseEntity
                .ok()
                .headers(headers)
                .contentType(org.springframework.http.MediaType.APPLICATION_PDF)
                .body(new org.springframework.core.io.InputStreamResource(bis));
    }

    @PostMapping("/pharmacy/notifications/read-all")
    public String markNotificationsRead(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            List<Notification> unread = notificationRepo.findByUserAndIsReadFalseOrderByCreatedAtDesc(user);
            unread.forEach(n -> n.setRead(true));
            notificationRepo.saveAll(unread);
        }
        return "redirect:/pharmacy-dashboard";
    }

    @PostMapping("/pharmacy/inventory/add")
    public String addMedicine(@RequestParam String name,
                              @RequestParam String category,
                              @RequestParam String manufacturer,
                              @RequestParam Integer stockLevel,
                              @RequestParam Double price,
                              @RequestParam String expiryDate,
                              @RequestParam String batchNumber,
                              RedirectAttributes ra) {
        try {
            Medicine med = new Medicine();
            med.setName(name);
            med.setCategory(category);
            med.setManufacturer(manufacturer);
            med.setStockLevel(stockLevel);
            med.setPrice(price);
            med.setExpiryDate(java.time.LocalDate.parse(expiryDate));
            med.setBatchNumber(batchNumber);
            
            medicineRepository.save(med);
            ra.addFlashAttribute("successMessage", "Medicine " + name + " added successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error adding medicine: " + e.getMessage());
        }
        return "redirect:/pharmacy/inventory";
    }
    @GetMapping("/pharmacy/profile")
    public String profile(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "pharmacy/profile";
    }

    @PostMapping("/pharmacy/profile/update")
    public String updateProfile(@ModelAttribute User updatedUser, HttpSession session, RedirectAttributes ra) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Pharmacy".equals(currentUser.getRole())) return "redirect:/";
        
        currentUser.setFullName(updatedUser.getFullName());
        currentUser.setEmail(updatedUser.getEmail());
        currentUser.setPhone(updatedUser.getPhone());
        currentUser.setGender(updatedUser.getGender());
        currentUser.setPharmacyName(updatedUser.getPharmacyName());
        currentUser.setPharmacyAddress(updatedUser.getPharmacyAddress());
        currentUser.setPharmacyLicense(updatedUser.getPharmacyLicense());
        
        // Handle profile image if provided (assuming base64 for now as per model)
        if (updatedUser.getProfileImage() != null && !updatedUser.getProfileImage().isEmpty()) {
            currentUser.setProfileImage(updatedUser.getProfileImage());
        }
        
        pharmacyService.updateUser(currentUser);
        session.setAttribute("user", currentUser);
        ra.addFlashAttribute("successMessage", "Profile updated successfully!");
        
        return "redirect:/pharmacy/profile";
    }

    @GetMapping("/pharmacy/leave")
    public String leaveRequests(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Pharmacy".equals(user.getRole())) return "redirect:/";
        
        model.addAttribute("user", user);
        model.addAttribute("leaveRequests", leaveRequestRepository.findByUserOrderBySubmittedAtDesc(user));
        return "pharmacy/leave";
    }

    @PostMapping("/pharmacy/leave/submit")
    public String submitLeave(@RequestParam String startDate,
                              @RequestParam String endDate,
                              @RequestParam String reason,
                              @RequestParam(required = false, defaultValue = "Full Day") String leaveType,
                              HttpSession session,
                              RedirectAttributes ra) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";
        
        try {
            LeaveRequest lr = new LeaveRequest();
            lr.setUser(user);
            lr.setStartDate(LocalDate.parse(startDate));
            lr.setEndDate(LocalDate.parse(endDate));
            lr.setReason(reason);
            lr.setLeaveType(leaveType);
            lr.setStatus("Pending");
            leaveRequestRepository.save(lr);
            ra.addFlashAttribute("successMessage", "Leave request submitted successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error submitting leave: " + e.getMessage());
        }
        return "redirect:/pharmacy/leave";
    }
}
