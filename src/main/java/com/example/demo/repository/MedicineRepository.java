package com.example.demo.repository;

import com.example.demo.model.Medicine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface MedicineRepository extends JpaRepository<Medicine, Long> {
    
    List<Medicine> findByStockLevelLessThan(Integer threshold);
    
    List<Medicine> findByExpiryDateBefore(LocalDate date);
    
    @Query("SELECT m FROM Medicine m WHERE m.expiryDate BETWEEN :start AND :end")
    List<Medicine> findExpiringSoon(LocalDate start, LocalDate end);
}
