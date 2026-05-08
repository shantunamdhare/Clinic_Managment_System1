package com.example.demo.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "prescriptions")
public class Prescription {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String prescriptionId;

    @ManyToOne
    @JoinColumn(name = "visit_id", nullable = true)
    private Visit visit;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private User doctor;

    @Column(nullable = false)
    private String status; // Pending, Preparing, Ready, Dispensed, Draft

    @Column(columnDefinition = "TEXT")
    private String notes;

    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "prescription", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PrescriptionItem> items = new ArrayList<>();

    private Double consultationFee;

    // Compatibility fields (for existing logic)
    @Column(nullable = true)
    private String medicine;
    @Column(nullable = true)
    private String dosage;
    @Column(nullable = true)
    private String duration;
    @Column(nullable = true)
    private String instructions;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (status == null) status = "Draft";
        if (prescriptionId == null) {
            prescriptionId = "RX-" + System.currentTimeMillis();
        }
        // Fallback for legacy database columns that might be NOT NULL
        if (!items.isEmpty()) {
            PrescriptionItem first = items.get(0);
            if (this.medicine == null) this.medicine = first.getMedicine().getName();
            if (this.dosage == null) this.dosage = first.getDosage();
            if (this.duration == null) this.duration = first.getDuration();
            if (this.instructions == null) this.instructions = first.getNotes();
        } else {
            // Absolute fallback to avoid "Column cannot be null"
            if (this.medicine == null) this.medicine = "N/A";
            if (this.dosage == null) this.dosage = "N/A";
            if (this.duration == null) this.duration = "N/A";
            if (this.instructions == null) this.instructions = "N/A";
        }
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(String prescriptionId) { this.prescriptionId = prescriptionId; }

    public Visit getVisit() { return visit; }
    public void setVisit(Visit visit) { this.visit = visit; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public User getDoctor() { return doctor; }
    public void setDoctor(User doctor) { this.doctor = doctor; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<PrescriptionItem> getItems() { return items; }
    public void setItems(List<PrescriptionItem> items) { this.items = items; }

    public Double getConsultationFee() { return consultationFee; }
    public void setConsultationFee(Double consultationFee) { this.consultationFee = consultationFee; }

    public void addItem(PrescriptionItem item) {
        items.add(item);
        item.setPrescription(this);
    }

    // Compatibility Getters/Setters
    public String getMedicine() { return medicine; }
    public void setMedicine(String medicine) { this.medicine = medicine; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }
}

