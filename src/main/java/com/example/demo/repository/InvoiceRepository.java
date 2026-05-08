package com.example.demo.repository;

import com.example.demo.model.Invoice;
import com.example.demo.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {

    List<Invoice> findByPatient(Patient patient);

    List<Invoice> findByInvoiceDateBetween(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT SUM(i.totalAmount) FROM Invoice i WHERE i.invoiceDate BETWEEN :start AND :end")
    Double calculateRevenueBetween(LocalDateTime start, LocalDateTime end);
    
    List<Invoice> findByPaymentStatus(String status);
    
    List<Invoice> findAllByOrderByInvoiceDateDesc();
    List<Invoice> findByPatient_ContactNumberOrderByInvoiceDateDesc(String contactNumber);
}
