package com.example.demo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "patient_lab_requests")
public class LabRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private User doctor;

    @ManyToOne
    @JoinColumn(name = "test_id", nullable = false)
    private LabTest test;

    @ManyToOne
    @JoinColumn(name = "lab_id", nullable = true) // true so existing data doesn't break
    private User lab;

    private String status; // Pending, Completed

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public User getDoctor() { return doctor; }
    public void setDoctor(User doctor) { this.doctor = doctor; }

    public LabTest getTest() { return test; }
    public void setTest(LabTest test) { this.test = test; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public User getLab() { return lab; }
    public void setLab(User lab) { this.lab = lab; }
}
