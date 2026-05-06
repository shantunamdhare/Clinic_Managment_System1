package com.example.demo.repository;

import com.example.demo.model.LabRequest;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LabRequestRepository extends JpaRepository<LabRequest, Long> {
    List<LabRequest> findByDoctor(User doctor);
    List<LabRequest> findByDoctorAndStatus(User doctor, String status);
    List<LabRequest> findByStatus(String status);
    long countByDoctorAndStatus(User doctor, String status);
}
