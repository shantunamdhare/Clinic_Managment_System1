package com.example.demo.repository;

import com.example.demo.model.NoShowRecord;
import com.example.demo.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NoShowRecordRepository extends JpaRepository<NoShowRecord, Long> {
    List<NoShowRecord> findByPatient(Patient patient);
    long countByPatient(Patient patient);
}
