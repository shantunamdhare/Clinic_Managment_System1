package com.example.demo.model;

import jakarta.persistence.*;
<<<<<<< HEAD
import java.time.LocalDate;
=======
import java.util.List;
>>>>>>> d47752b02d36ead22b434ee0b50971579c4440d6

@Entity
@Table(name = "patients")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

<<<<<<< HEAD
    @Column(nullable = false)
    private String patientId; // e.g., PID-1001

    @Column(nullable = false)
    private String gender;

    @Column(nullable = false)
    private LocalDate dateOfBirth;

    @Column(nullable = false)
    private String contactNumber;

    private String bloodGroup;

    private String lastVisit;

    // Delivery Boy Workflow Fields
    private String deliveryStatus; // Pending Pickup, In Transit, Delivered, Received
    private String deliveryAssignedTo;
    private String deliveryBoyPhone;
    private String pickupLocation;
    private String sourceHospital;
    private String destinationHospital;
    private String estimatedTime;
    private String currentLocation;

    public Patient() {
        this.deliveryStatus = "Pending Pickup";
    }

    public Patient(String name, String patientId, String gender, LocalDate dateOfBirth, String contactNumber, String bloodGroup, String lastVisit) {
        this.name = name;
        this.patientId = patientId;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.contactNumber = contactNumber;
        this.bloodGroup = bloodGroup;
        this.lastVisit = lastVisit;
        this.deliveryStatus = "Pending Pickup";
        this.sourceHospital = "City Central Hospital";
        this.destinationHospital = "MediCare Partner Lab";
        this.estimatedTime = "45 mins";
    }

    public Patient(String name, String patientId, String gender, LocalDate dateOfBirth, String contactNumber, String bloodGroup, String lastVisit, String deliveryAssignedTo, String pickupLocation) {
        this.name = name;
        this.patientId = patientId;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.contactNumber = contactNumber;
        this.bloodGroup = bloodGroup;
        this.lastVisit = lastVisit;
        this.deliveryStatus = "Pending Pickup";
        this.deliveryAssignedTo = deliveryAssignedTo;
        this.pickupLocation = pickupLocation;
    }
=======
    private Integer age;

    private String gender;

    private String contact;
>>>>>>> d47752b02d36ead22b434ee0b50971579c4440d6

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

<<<<<<< HEAD
    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }
=======
    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }
>>>>>>> d47752b02d36ead22b434ee0b50971579c4440d6

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

<<<<<<< HEAD
    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }

    public String getLastVisit() { return lastVisit; }
    public void setLastVisit(String lastVisit) { this.lastVisit = lastVisit; }

    public String getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(String deliveryStatus) { this.deliveryStatus = deliveryStatus; }

    public String getDeliveryAssignedTo() { return deliveryAssignedTo; }
    public void setDeliveryAssignedTo(String deliveryAssignedTo) { this.deliveryAssignedTo = deliveryAssignedTo; }

    public String getPickupLocation() { return pickupLocation; }
    public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }

    public String getDeliveryBoyPhone() { return deliveryBoyPhone; }
    public void setDeliveryBoyPhone(String deliveryBoyPhone) { this.deliveryBoyPhone = deliveryBoyPhone; }

    public String getSourceHospital() { return sourceHospital; }
    public void setSourceHospital(String sourceHospital) { this.sourceHospital = sourceHospital; }

    public String getDestinationHospital() { return destinationHospital; }
    public void setDestinationHospital(String destinationHospital) { this.destinationHospital = destinationHospital; }

    public String getEstimatedTime() { return estimatedTime; }
    public void setEstimatedTime(String estimatedTime) { this.estimatedTime = estimatedTime; }

    public String getCurrentLocation() { return currentLocation; }
    public void setCurrentLocation(String currentLocation) { this.currentLocation = currentLocation; }
=======
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
>>>>>>> d47752b02d36ead22b434ee0b50971579c4440d6
}
