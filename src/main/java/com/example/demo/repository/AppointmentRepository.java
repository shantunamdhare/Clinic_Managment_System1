package com.example.demo.repository;

import com.example.demo.model.Appointment;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByDoctorAndAppointmentDate(User doctor, LocalDate date);
    List<Appointment> findByDoctor(User doctor);
    long countByDoctor(User doctor);
    long countByDoctorAndAppointmentDate(User doctor, LocalDate date);
}
