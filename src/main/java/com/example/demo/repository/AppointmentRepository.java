package com.example.demo.repository;

import com.example.demo.model.Appointment;
import com.example.demo.model.Patient;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByDoctorAndAppointmentDate(User doctor, LocalDate date);
    List<Appointment> findByDoctor_IdAndAppointmentDate(Long doctorId, LocalDate date);
    List<Appointment> findByDoctor(User doctor);
    List<Appointment> findByPatientOrderByAppointmentDateDesc(Patient patient);
    long countByDoctor(User doctor);
    long countByDoctorAndAppointmentDate(User doctor, LocalDate date);

    List<Appointment> findByAppointmentDate(LocalDate date);
    List<Appointment> findByAppointmentDateAndStatus(LocalDate date, String status);
    long countByAppointmentDate(LocalDate date);
    long countByAppointmentDateAndStatus(LocalDate date, String status);
    
    List<Appointment> findByDepartmentAndAppointmentDate(String department, LocalDate date);
    long countByDepartmentAndAppointmentDate(String department, LocalDate date);

    // New methods for Admin Dashboard
    long countByAppointmentDateBetween(LocalDate start, LocalDate end);
    long countByStatus(String status);
    List<Appointment> findByAppointmentDateOrderByAppointmentTimeAsc(LocalDate date);
    List<Appointment> findTop10ByOrderByAppointmentDateDescAppointmentTimeDesc();
    List<Appointment> findByPatient_ContactNumberOrderByAppointmentDateDesc(String contactNumber);
}
