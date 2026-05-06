package com.example.demo.config;

import com.example.demo.model.Patient;
import com.example.demo.model.User;
import com.example.demo.repository.PatientRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(PatientRepository patientRepository, UserRepository userRepository, PasswordEncoder passwordEncoder) {
        return args -> {
            // Initialize Users
            Optional<User> existingUser = userRepository.findByEmail("shyam@gmail.com");
            if (existingUser.isEmpty()) {
                User labUser = new User();
                labUser.setFullName("Shyam");
                labUser.setEmail("shyam@gmail.com");
                labUser.setPassword(passwordEncoder.encode("1234"));
                labUser.setRole("Lab");
                labUser.setLabType("External");
                labUser.setLabName("MediCare Central Lab");
                labUser.setLabAddress("Main Wing, 2nd Floor");
                labUser.setLabId("LAB-7001");
                userRepository.save(labUser);
                System.out.println(">> Created Default Lab User: shyam@gmail.com / 1234");
            } else {
                User u = existingUser.get();
                u.setPassword(passwordEncoder.encode("1234"));
                u.setRole("Lab");
                userRepository.save(u);
                System.out.println(">> Updated Default Lab User password to: 1234");
            }

            // Clear old dummy data from the persistent database
            patientRepository.deleteAll();
            System.out.println(">> Cleared all fake patient data from database.");

            // Initialize Receptionist
            if (userRepository.findByEmail("receptionist@gmail.com").isEmpty()) {
                User u = new User();
                u.setFullName("Sarah Receptionist");
                u.setEmail("receptionist@gmail.com");
                u.setPassword(passwordEncoder.encode("1234"));
                u.setRole("Receptionist");
                userRepository.save(u);
            }

            // Initialize Pharmacy
            if (userRepository.findByEmail("pharmacy@gmail.com").isEmpty()) {
                User u = new User();
                u.setFullName("John Pharmacist");
                u.setEmail("pharmacy@gmail.com");
                u.setPassword(passwordEncoder.encode("1234"));
                u.setRole("Pharmacy");
                userRepository.save(u);
            }

            // Initialize Delivery
            if (userRepository.findByEmail("delivery@gmail.com").isEmpty()) {
                User u = new User();
                u.setFullName("Mike Delivery");
                u.setEmail("delivery@gmail.com");
                u.setPassword(passwordEncoder.encode("1234"));
                u.setRole("Delivery");
                userRepository.save(u);
            }

            // Initialize Admin User
            Optional<User> existingAdmin = userRepository.findByEmail("admin@gmail.com");
            if (existingAdmin.isEmpty()) {
                User adminUser = new User();
                adminUser.setFullName("Admin");
                adminUser.setEmail("admin@gmail.com");
                adminUser.setPassword(passwordEncoder.encode("admin123"));
                adminUser.setRole("Admin");
                userRepository.save(adminUser);
                System.out.println(">> Created Default Admin User: admin@gmail.com / admin123");
            } else {
                User a = existingAdmin.get();
                a.setPassword(passwordEncoder.encode("admin123"));
                a.setRole("Admin");
                userRepository.save(a);
                System.out.println(">> Updated Default Admin User password to: admin123");
            }
        };
    }
}
