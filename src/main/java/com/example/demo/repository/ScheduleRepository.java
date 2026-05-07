package com.example.demo.repository;

import com.example.demo.model.Schedule;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    List<Schedule> findByDoctor(User doctor);
    List<Schedule> findByDoctorAndDayOfWeek(User doctor, String dayOfWeek);
}
