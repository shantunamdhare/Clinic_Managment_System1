package com.example.demo.config;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(PatientRepository patientRepository, 
                                     UserRepository userRepository, 
                                     LabRequestRepository labRequestRepo,
                                     LabTestRepository labTestRepo,
                                     MedicineRepository medicineRepo,
                                     InvoiceRepository invoiceRepo,
                                     StaffShiftRepository shiftRepo,
                                     StaffAttendanceRepository attendanceRepo,
                                     PasswordEncoder passwordEncoder) {
        return args -> {
            // Data is now persistent. No more clearing on startup.
            // labRequestRepo.deleteAll();
            // labTestRepo.deleteAll();
            // patientRepository.deleteAll();

            // Initialize Lab User
            Optional<User> existingUser = userRepository.findByEmail("shyam@gmail.com");
            if (existingUser.isEmpty()) {
                User labUser = new User();
                labUser.setFullName("Shyam");
                labUser.setEmail("shyam@gmail.com");
                labUser.setPassword(passwordEncoder.encode("1234"));
                labUser.setRole("Lab");
                labUser.setLabType("In-House");
                labUser.setLabName("MediCare Central Lab");
                labUser.setLabAddress("Main Wing, 2nd Floor");
                labUser.setLabId("LAB-7001");
                userRepository.save(labUser);
            }

            // Initialize Delivery Partner
            Optional<User> existingDelivery = userRepository.findByEmail("delivery@gmail.com");
            if (existingDelivery.isEmpty()) {
                User deliveryUser = new User();
                deliveryUser.setFullName("John Logistics");
                deliveryUser.setEmail("delivery@gmail.com");
                deliveryUser.setPassword(passwordEncoder.encode("1234"));
                deliveryUser.setRole("Delivery");
                deliveryUser.setPhone("+91 9876543210");
                userRepository.save(deliveryUser);
            }

            // Create a dummy doctor if not exists
            Optional<User> existingDoctor = userRepository.findByEmail("doctor@gmail.com");
            User doctor;
            if (existingDoctor.isEmpty()) {
                doctor = new User();
                doctor.setFullName("Dr. Emily Chen");
                doctor.setEmail("doctor@gmail.com");
                doctor.setPassword(passwordEncoder.encode("1234"));
                doctor.setRole("Doctor");
                userRepository.save(doctor);
            } else {
                doctor = existingDoctor.get();
            }

            // Initialize Lab Tests only if they don't exist
            if (labTestRepo.count() == 0) {
                LabTest test1 = new LabTest();
                test1.setName("Lipid Profile");
                labTestRepo.save(test1);
                
                LabTest test2 = new LabTest();
                test2.setName("Complete Blood Count (CBC)");
                labTestRepo.save(test2);
                
                System.out.println(">> Sample tests initialized.");
            }

            // Initialize Patients only if they don't exist
            if (patientRepository.count() == 0) {
                Patient p1 = new Patient();
                p1.setName("Emily Johnson");
                p1.setPatientId("PID-5042");
                p1.setGender("Female");
                p1.setDateOfBirth(LocalDate.of(1995, 8, 15));
                p1.setContactNumber("+91 98765 43210");
                p1.setTestType("Complete Blood Count (CBC)");
                p1.setPriority("High");
                p1.setDeliveryStatus("Pending Pickup");
                patientRepository.save(p1);
                
                System.out.println(">> Sample patients initialized.");
            }
            
            // Initialize Pharmacy Medicines
            if (medicineRepo.count() == 0) {
                medicineRepo.save(new Medicine("Paracetamol 500mg", "Tablet", "GSK", 100, 20.0, LocalDate.now().plusYears(2), "BT-001"));
                medicineRepo.save(new Medicine("Amoxicillin 250mg", "Capsule", "Pfizer", 5, 150.0, LocalDate.now().plusMonths(1), "BT-002")); // Low stock & Expiring
                medicineRepo.save(new Medicine("Cough Syrup", "Syrup", "Abbott", 50, 85.0, LocalDate.now().plusMonths(6), "BT-003"));
                medicineRepo.save(new Medicine("Insulin Glargine", "Injection", "Sanofi", 12, 1200.0, LocalDate.now().plusDays(15), "BT-004")); // Expiring
                System.out.println(">> Sample medicines initialized.");
            }

            // Initialize Pharmacy Staff user
            Optional<User> existingPharmacist = userRepository.findByEmail("pharmacist@gmail.com");
            if (existingPharmacist.isEmpty()) {
                User pharmacist = new User();
                pharmacist.setFullName("Arjun Sharma");
                pharmacist.setEmail("pharmacist@gmail.com");
                pharmacist.setPassword(passwordEncoder.encode("1234"));
                pharmacist.setRole("Pharmacy");
                userRepository.save(pharmacist);
                
                // Add shift
                StaffShift shift = new StaffShift();
                shift.setStaff(pharmacist);
                shift.setDayOfWeek("Monday");
                shift.setStartTime(java.time.LocalTime.of(9, 0));
                shift.setEndTime(java.time.LocalTime.of(17, 0));
                shiftRepo.save(shift);
                
                // Add attendance
                StaffAttendance attendance = new StaffAttendance();
                attendance.setStaff(pharmacist);
                attendance.setDate(LocalDate.now());
                attendance.setCheckIn(java.time.LocalTime.of(8, 55));
                attendance.setStatus("Present");
                attendanceRepo.save(attendance);
                
                System.out.println(">> Pharmacy staff and shifts initialized.");

                // Initialize Sample Invoice
                if (invoiceRepo.count() == 0 && !patientRepository.findAll().isEmpty()) {
                    Patient p = patientRepository.findAll().get(0);
                    Invoice inv = new Invoice();
                    inv.setPatient(p);
                    inv.setTotalAmount(500.0);
                    inv.setPaymentMethod("Cash");
                    inv.setPaymentStatus("Paid");
                    inv.setInvoiceNumber("INV-SAMPLE-001");
                    inv.setInvoiceDate(LocalDateTime.now());
                    invoiceRepo.save(inv);
                }
            }
            
            System.out.println(">> Database ready and stable.");
        };
    }
}
