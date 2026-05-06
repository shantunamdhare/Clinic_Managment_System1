package com.example.demo.config;

import com.example.demo.model.Patient;
import com.example.demo.model.User;
import com.example.demo.model.LabRequest;
import com.example.demo.model.LabTest;
import com.example.demo.repository.PatientRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.LabRequestRepository;
import com.example.demo.repository.LabTestRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.Optional;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(PatientRepository patientRepository, 
                                     UserRepository userRepository, 
                                     LabRequestRepository labRequestRepo,
                                     LabTestRepository labTestRepo,
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
                p1.setTestType("Complete Blood Count (CBC)");
                p1.setPriority("High");
                p1.setDeliveryStatus("Pending Pickup");
                patientRepository.save(p1);
                
                System.out.println(">> Sample patients initialized.");
            }
            
            System.out.println(">> Database ready and stable.");
        };
    }
}
