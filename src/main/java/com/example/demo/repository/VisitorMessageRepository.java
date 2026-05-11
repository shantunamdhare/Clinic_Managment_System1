package com.example.demo.repository;

import com.example.demo.model.VisitorMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VisitorMessageRepository extends JpaRepository<VisitorMessage, Long> {
    List<VisitorMessage> findAllByOrderBySubmittedAtDesc();
}
