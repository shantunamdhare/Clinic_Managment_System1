package com.example.demo.repository;

import com.example.demo.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Long> {
    List<Patient> findByNameContainingIgnoreCase(String name);
    Patient findByPatientId(String patientId);
    Patient findByContactNumber(String contactNumber);
    List<Patient> findByPatientIdContainingOrContactNumberContaining(String patientId, String contactNumber);
    long countByRegistrationDate(java.time.LocalDate date);
    Patient findByName(String name);
}
