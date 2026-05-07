package com.example.demo.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "deprecated_attendance")
public class Attendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private LocalDate date;
    private LocalDateTime checkIn;
    private LocalDateTime checkOut;
    private String status; // Present, Late, Absent
    private String note;
    private boolean isVerified = false;

    public Attendance() {
        this.date = LocalDate.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }
    
    public LocalDateTime getCheckIn() { return checkIn; }
    public void setCheckIn(LocalDateTime checkIn) { this.checkIn = checkIn; }
    
    // Overload for LocalTime usage in ReceptionistService
    public void setCheckIn(LocalTime time) {
        if (this.date == null) this.date = LocalDate.now();
        this.checkIn = LocalDateTime.of(this.date, time);
    }
    
    public LocalDateTime getCheckOut() { return checkOut; }
    public void setCheckOut(LocalDateTime checkOut) { this.checkOut = checkOut; }
    
    // Overload for LocalTime usage in ReceptionistService
    public void setCheckOut(LocalTime time) {
        if (this.date == null) this.date = LocalDate.now();
        this.checkOut = LocalDateTime.of(this.date, time);
    }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    
    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }
}
