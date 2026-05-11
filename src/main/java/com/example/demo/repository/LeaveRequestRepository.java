package com.example.demo.repository;

import com.example.demo.model.LeaveRequest;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, Long> {
    List<LeaveRequest> findByUserOrderByCreatedAtDesc(User user);
    List<LeaveRequest> findByStatus(String status);
}
