package com.example.demo.repository;

import com.example.demo.model.Availability;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public interface AvailabilityRepository extends JpaRepository<Availability, Long> {
    List<Availability> findByDoctorOrderByAvailableDateAscStartTimeAsc(User doctor);

    // Check for overlapping slots
    boolean existsByDoctorAndAvailableDateAndStartTimeLessThanAndEndTimeGreaterThan(
            User doctor, LocalDate date, LocalTime endTime, LocalTime startTime);

    // Admin dashboard: doctors available today
    List<Availability> findByAvailableDateOrderByStartTimeAsc(LocalDate date);

    // Fetch all upcoming availability slots
    List<Availability> findByAvailableDateGreaterThanEqualOrderByAvailableDateAscStartTimeAsc(LocalDate date);
}
