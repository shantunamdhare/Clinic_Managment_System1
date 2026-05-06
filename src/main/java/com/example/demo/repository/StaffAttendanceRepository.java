package com.example.demo.repository;

import com.example.demo.model.StaffAttendance;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface StaffAttendanceRepository extends JpaRepository<StaffAttendance, Long> {
    List<StaffAttendance> findByDate(LocalDate date);
    List<StaffAttendance> findByStaff(User staff);
}
