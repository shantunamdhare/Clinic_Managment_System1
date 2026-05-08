package com.example.demo.repository;

import com.example.demo.model.Notification;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByUserOrderByCreatedAtDesc(com.example.demo.model.User user);
    List<Notification> findByUserAndIsReadOrderByCreatedAtDesc(com.example.demo.model.User user, boolean isRead);
    List<Notification> findByUserAndIsReadFalseOrderByCreatedAtDesc(com.example.demo.model.User user);
    long countByUserAndIsRead(com.example.demo.model.User user, boolean isRead);
}
