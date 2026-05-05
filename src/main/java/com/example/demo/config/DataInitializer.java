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
        };
    }
}
