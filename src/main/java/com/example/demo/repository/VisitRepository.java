package com.example.demo.repository;

import com.example.demo.model.Patient;
import com.example.demo.model.User;
import com.example.demo.model.Visit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VisitRepository extends JpaRepository<Visit, Long> {
    List<Visit> findByPatient(Patient patient);
    List<Visit> findByDoctorOrderByVisitDateDesc(User doctor);
}
