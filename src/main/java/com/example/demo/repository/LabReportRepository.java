package com.example.demo.repository;

import com.example.demo.model.LabReport;
import com.example.demo.model.Patient;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LabReportRepository extends JpaRepository<LabReport, Long> {
    List<LabReport> findByRequest_Doctor(User doctor);
    List<LabReport> findByRequest_Patient(Patient patient);
}
