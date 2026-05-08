package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PharmacyService {

    @Autowired
    private MedicineRepository medicineRepo;

    @Autowired
    private InvoiceRepository invoiceRepo;

    @Autowired
    private UserRepository userRepository;

    public List<Medicine> getAllMedicines() {
        return medicineRepo.findAll();
    }

    public List<Medicine> getLowStockMedicines() {
        return medicineRepo.findByStockLevelLessThan(10);
    }

    public List<Medicine> getExpiringMedicines() {
        return medicineRepo.findExpiringSoon(LocalDate.now(), LocalDate.now().plusMonths(3));
    }

    public Double getDailyRevenue() {
        LocalDateTime start = LocalDate.now().atStartOfDay();
        LocalDateTime end = LocalDateTime.now();
        Double revenue = invoiceRepo.calculateRevenueBetween(start, end);
        return revenue != null ? revenue : 0.0;
    }

    public List<Invoice> getPendingPayments() {
        return invoiceRepo.findByPaymentStatus("Pending");
    }

    @Transactional
    public Invoice generateInvoice(Patient patient, List<InvoiceItem> items, String paymentMethod, Double consultationFee) {
        Invoice invoice = new Invoice();
        invoice.setPatient(patient);
        invoice.setPaymentMethod(paymentMethod);
        invoice.setPaymentStatus("Paid"); // Assume paid for simple billing
        invoice.setInvoiceNumber("INV-" + System.currentTimeMillis());
        invoice.setConsultationFee(consultationFee != null ? consultationFee : 0.0);
        
        double subtotal = 0;
        for (InvoiceItem item : items) {
            Medicine med = item.getMedicine();
            if (med.getStockLevel() < item.getQuantity()) {
                throw new RuntimeException("Insufficient stock for " + med.getName());
            }
            med.setStockLevel(med.getStockLevel() - item.getQuantity());
            medicineRepo.save(med);
            
            item.setSubtotal(item.getQuantity() * item.getUnitPrice());
            invoice.addItem(item);
            subtotal += item.getSubtotal();
        }
        
        subtotal += (consultationFee != null ? consultationFee : 0.0);
        double tax = subtotal * 0.05; // 5% GST
        invoice.setTaxAmount(tax);
        invoice.setTotalAmount(subtotal + tax);
        invoice.setBillingItems("Pharmacy & Consultation");
        return invoiceRepo.save(invoice);
    }
    @Autowired
    private PrescriptionRepository prescriptionRepo;

    @Autowired
    private NotificationRepository notificationRepo;

    @Transactional
    public void updatePrescriptionStatus(Long prescriptionId, String status, String pharmacistNotes) {
        Prescription p = prescriptionRepo.findById(prescriptionId)
                .orElseThrow(() -> new RuntimeException("Prescription not found"));
        
        p.setStatus(status);
        if (pharmacistNotes != null && !pharmacistNotes.trim().isEmpty()) {
            String currentNotes = p.getNotes() != null ? p.getNotes() : "";
            p.setNotes(currentNotes + (currentNotes.isEmpty() ? "" : "\n") + "Pharmacist Note: " + pharmacistNotes);
        }
        
        prescriptionRepo.save(p);

        // If dispensed, generate invoice and notify doctor
        if ("Dispensed".equals(status)) {
            List<InvoiceItem> invoiceItems = new java.util.ArrayList<>();
            for (PrescriptionItem item : p.getItems()) {
                Medicine med = item.getMedicine();
                if (med.getStockLevel() < item.getQuantity()) {
                    Notification alert = new Notification();
                    alert.setUser(p.getDoctor());
                    alert.setMessage("Low stock alert for " + med.getName());
                    alert.setType("Warning");
                    notificationRepo.save(alert);
                }
                
                InvoiceItem invItem = new InvoiceItem();
                invItem.setMedicine(med);
                invItem.setQuantity(item.getQuantity());
                invItem.setUnitPrice(med.getPrice());
                invoiceItems.add(invItem);
            }
            
            // Generate the bill automatically
            Invoice inv = generateInvoice(p.getPatient(), invoiceItems, "Cash", p.getConsultationFee()); 
            p.setNotes(p.getNotes() + "\nGenerated Invoice: " + inv.getInvoiceNumber());
        }

        // Notify Doctor
        Notification n = new Notification();
        n.setUser(p.getDoctor());
        n.setMessage("Prescription " + p.getPrescriptionId() + " status updated to: " + status);
        n.setType("Info");
        notificationRepo.save(n);
    }

    public List<Prescription> getActivePrescriptions() {
        return prescriptionRepo.findByStatusInOrderByCreatedAtDesc(List.of("Pending", "Preparing", "Ready"));
    }

    @Transactional
    public void updateUser(User user) {
        userRepository.save(user);
    }

    @Transactional
    public void checkAndGenerateAlerts() {
        List<Medicine> lowStock = getLowStockMedicines();
        List<Medicine> expiring = getExpiringMedicines();
        
        List<User> recipients = userRepository.findAll().stream()
                .filter(u -> "Admin".equalsIgnoreCase(u.getRole()) || "Pharmacy".equalsIgnoreCase(u.getRole()))
                .collect(java.util.stream.Collectors.toList());

        for (Medicine med : lowStock) {
            String msg = "Low Stock Alert: " + med.getName() + " (" + med.getBatchNumber() + ") has only " + med.getStockLevel() + " units remaining.";
            generateNotificationsIfNew(msg, "Warning", recipients);
        }

        for (Medicine med : expiring) {
            String msg = "Expiry Alert: " + med.getName() + " (" + med.getBatchNumber() + ") is expiring on " + med.getExpiryDate();
            generateNotificationsIfNew(msg, "Urgent", recipients);
        }
    }

    private void generateNotificationsIfNew(String message, String type, List<User> recipients) {
        LocalDate today = LocalDate.now();
        for (User user : recipients) {
            // Check if this specific user already has this message unread today
            // Note: In a larger app, we'd use a custom repository query for efficiency
            boolean exists = notificationRepo.findByUserAndIsReadFalseOrderByCreatedAtDesc(user).stream()
                    .anyMatch(n -> n.getMessage().equals(message) 
                                && n.getCreatedAt().toLocalDate().equals(today));
            
            if (!exists) {
                Notification n = new Notification();
                n.setUser(user);
                n.setMessage(message);
                n.setType(type);
                notificationRepo.save(n);
            }
        }
    }
}
