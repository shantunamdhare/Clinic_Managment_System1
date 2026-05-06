package com.example.demo.config;

import com.example.demo.model.Patient;
import com.example.demo.model.User;
import com.example.demo.model.LabRequest;
import com.example.demo.model.LabTest;
import com.example.demo.repository.PatientRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.LabRequestRepository;
import com.example.demo.repository.LabTestRepository;
import com.example.demo.repository.AttendanceRepository;
import com.example.demo.repository.StaffShiftRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(PatientRepository patientRepository,
            UserRepository userRepository,
            LabRequestRepository labRequestRepo,
            LabTestRepository labTestRepo,
            AttendanceRepository attendanceRepo,
            StaffShiftRepository staffShiftRepo,
            PasswordEncoder passwordEncoder) {
        return args -> {
            // Clearing existing staff data as requested for a fresh start
            attendanceRepo.deleteAll();
            staffShiftRepo.deleteAll();

            // 1. Initialize Roles / Users
            seedUser(userRepository, passwordEncoder, "admin@gmail.com", "admin123", "Admin", "System Admin");
            seedUser(userRepository, passwordEncoder, "doctor@gmail.com", "1234", "Doctor", "Dr. Emily Chen");
            seedUser(userRepository, passwordEncoder, "receptionist@gmail.com", "1234", "Receptionist", "Sarah Receptionist");
            seedUser(userRepository, passwordEncoder, "pharmacy@gmail.com", "1234", "Pharmacy", "John Pharmacist");
            seedUser(userRepository, passwordEncoder, "delivery@gmail.com", "1234", "Delivery", "Mike Delivery");
            
            // Lab User with specific details
            if (userRepository.findByEmail("shyam@gmail.com").isEmpty()) {
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

            // 2. Initialize Lab Tests
            if (labTestRepo.count() == 0) {
                List<String> defaultTests = Arrays.asList(
                        "Complete Blood Count (CBC)",
                        "Basic Metabolic Panel (BMP)",
                        "Comprehensive Metabolic Panel (CMP)",
                        "Lipid Panel",
                        "Thyroid Stimulating Hormone (TSH)",
                        "Urinalysis",
                        "Hemoglobin A1C",
                        "Liver Function Test (LFT)",
                        "Vitamin D Test",
                        "Iron Panel",
                        "Lipid Profile"
                );

                for (String testName : defaultTests) {
                    LabTest test = new LabTest();
                    test.setName(testName);
                    labTestRepo.save(test);
                }
                System.out.println(">> Default Lab Tests seeded successfully!");
            }

            // 3. Initialize Patients
            if (patientRepository.count() == 0) {
                Patient p1 = new Patient();
                p1.setName("Emily Johnson");
                p1.setPatientId("PID-5042");
                p1.setGender("Female");
                p1.setDateOfBirth(LocalDate.of(1995, 5, 10));
                p1.setContactNumber("9876543210");
                p1.setTestType("Complete Blood Count (CBC)");
                p1.setPriority("High");
                p1.setDeliveryStatus("Pending Pickup");
                patientRepository.save(p1);
                
                Patient p2 = new Patient();
                p2.setName("Robert Wilson");
                p2.setPatientId("PID-6021");
                p2.setGender("Male");
                p2.setDateOfBirth(LocalDate.of(1982, 11, 22));
                p2.setContactNumber("9988776655");
                p2.setPriority("Normal");
                p2.setDeliveryStatus("Not Required");
                patientRepository.save(p2);
                
                System.out.println(">> Sample patients initialized.");
            }
            
            System.out.println(">> Database initialization complete and stable.");
        };
    }

    private void seedUser(UserRepository repo, PasswordEncoder encoder, String email, String password, String role, String name) {
        if (repo.findByEmail(email).isEmpty()) {
            User user = new User();
            user.setFullName(name);
            user.setEmail(email);
            user.setPassword(encoder.encode(password));
            user.setRole(role);
            if ("Doctor".equals(role)) {
                user.setSpecialization("General Physician");
            } else if ("Delivery".equals(role)) {
                user.setPhone("+91 9876543210");
            }
            repo.save(user);
            System.out.println(">> Created " + role + ": " + email);
        }
    }
}
