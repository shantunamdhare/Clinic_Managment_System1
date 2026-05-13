package com.example.demo.repository;

import com.example.demo.model.Patient;
import com.example.demo.model.Prescription;
import com.example.demo.model.Visit;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PrescriptionRepository extends JpaRepository<Prescription, Long> {
    List<Prescription> findByVisit(Visit visit);
    List<Prescription> findByVisit_Doctor_Id(Long doctorId);
    List<Prescription> findByVisit_Patient(Patient patient);
    List<Prescription> findByPatient(Patient patient);
    List<Prescription> findByStatus(String status);
    List<Prescription> findByDoctorOrderByCreatedAtDesc(User doctor);
    List<Prescription> findByPatient_ContactNumberOrderByCreatedAtDesc(String contactNumber);
    List<Prescription> findByStatusInOrderByCreatedAtDesc(List<String> statuses);
}
