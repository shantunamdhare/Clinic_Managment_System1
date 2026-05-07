package com.example.demo.repository;

import com.example.demo.model.Performance;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PerformanceRepository extends JpaRepository<Performance, Long> {
    List<Performance> findByUserOrderByReviewDateDesc(User user);
}
