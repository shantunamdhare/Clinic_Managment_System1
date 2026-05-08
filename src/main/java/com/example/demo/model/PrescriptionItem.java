package com.example.demo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "prescription_items")
public class PrescriptionItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "prescription_id", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Prescription prescription;

    @ManyToOne
    @JoinColumn(name = "medicine_id", nullable = false)
    private Medicine medicine;

    private String dosage; // e.g., 500mg
    private String frequency; // e.g., 1-0-1
    private String duration; // e.g., 5 days
    private Integer quantity;
    private String foodRelation; // Before Food, After Food
    private String notes;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Prescription getPrescription() { return prescription; }
    public void setPrescription(Prescription prescription) { this.prescription = prescription; }

    public Medicine getMedicine() { return medicine; }
    public void setMedicine(Medicine medicine) { this.medicine = medicine; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public String getFoodRelation() { return foodRelation; }
    public void setFoodRelation(String foodRelation) { this.foodRelation = foodRelation; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
