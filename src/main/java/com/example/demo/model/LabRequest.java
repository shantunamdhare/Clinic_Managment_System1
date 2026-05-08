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

    private String status; // Pending, Collected, In-Transit, Completed
    private String processingType; // In-House, External
    
    @ManyToOne
    @JoinColumn(name = "delivery_partner_id", nullable = true)
    private User deliveryPartner;
    
    private String sampleType;
    private String collectionDate;
    private String pickupDate;
    private String deliveryDate;

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

    public String getProcessingType() { return processingType; }
    public void setProcessingType(String processingType) { this.processingType = processingType; }

    public User getDeliveryPartner() { return deliveryPartner; }
    public void setDeliveryPartner(User deliveryPartner) { this.deliveryPartner = deliveryPartner; }

    public String getSampleType() { return sampleType; }
    public void setSampleType(String sampleType) { this.sampleType = sampleType; }

    public String getCollectionDate() { return collectionDate; }
    public void setCollectionDate(String collectionDate) { this.collectionDate = collectionDate; }

    public String getPickupDate() { return pickupDate; }
    public void setPickupDate(String pickupDate) { this.pickupDate = pickupDate; }

    public String getDeliveryDate() { return deliveryDate; }
    public void setDeliveryDate(String deliveryDate) { this.deliveryDate = deliveryDate; }
}
