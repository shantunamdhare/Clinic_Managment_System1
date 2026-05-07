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
    public Invoice generateInvoice(Patient patient, List<InvoiceItem> items, String paymentMethod) {
        Invoice invoice = new Invoice();
        invoice.setPatient(patient);
        invoice.setPaymentMethod(paymentMethod);
        invoice.setPaymentStatus("Paid"); // Assume paid for simple billing
        invoice.setInvoiceNumber("INV-" + System.currentTimeMillis());
        
        double total = 0;
        for (InvoiceItem item : items) {
            Medicine med = item.getMedicine();
            if (med.getStockLevel() < item.getQuantity()) {
                throw new RuntimeException("Insufficient stock for " + med.getName());
            }
            med.setStockLevel(med.getStockLevel() - item.getQuantity());
            medicineRepo.save(med);
            
            item.setSubtotal(item.getQuantity() * item.getUnitPrice());
            invoice.addItem(item);
            total += item.getSubtotal();
        }
        
        invoice.setTotalAmount(total);
        return invoiceRepo.save(invoice);
    }
    @Transactional
    public void updateUser(User user) {
        userRepository.save(user);
    }
}
