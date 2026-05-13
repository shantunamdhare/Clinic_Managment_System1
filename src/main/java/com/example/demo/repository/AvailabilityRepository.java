package com.example.demo.repository;

import com.example.demo.model.Availability;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public interface AvailabilityRepository extends JpaRepository<Availability, Long> {

    List<Availability> findByDoctorOrderByAvailableDateAscStartTimeAsc(User doctor);

    List<Availability> findByDoctorAndAvailableDateOrderByStartTimeAsc(User doctor, LocalDate date);

    List<Availability> findByAvailableDateOrderByStartTimeAsc(LocalDate date);

    // Check for overlapping slots
    boolean existsByDoctorAndAvailableDateAndStartTimeLessThanAndEndTimeGreaterThan(
            User doctor, LocalDate date, LocalTime endTime, LocalTime startTime);

    // Fetch all upcoming availability slots
    List<Availability> findByAvailableDateGreaterThanEqualOrderByAvailableDateAscStartTimeAsc(LocalDate date);

    // Returns count of slots covering the given time (COUNT > 0 comparison is invalid JPQL)
    @Query("SELECT COUNT(a) FROM Availability a WHERE a.doctor = :doctor AND a.availableDate = :date AND a.startTime <= :time AND a.endTime >= :time")
    long countAvailableSlots(@Param("doctor") User doctor, @Param("date") LocalDate date, @Param("time") LocalTime time);
}
