package com.example.demo.repository;

import com.example.demo.model.Patient;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

    @Query("SELECT DISTINCT a.patient FROM Appointment a WHERE a.doctor = :doctor")
    List<Patient> findByDoctor(@Param("doctor") User doctor);

    @Query("SELECT DISTINCT a.patient FROM Appointment a WHERE a.doctor = :doctor AND (LOWER(a.patient.name) LIKE LOWER(CONCAT('%', :name, '%')))")
    List<Patient> findByDoctorAndNameContaining(@Param("doctor") User doctor, @Param("name") String name);

    @Query("SELECT COUNT(DISTINCT a.patient) FROM Appointment a WHERE a.doctor = :doctor")
    long countByDoctor(@Param("doctor") User doctor);
}

