package com.example.demo.config;

import com.example.demo.model.User;
import com.example.demo.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(PatientRepository patientRepository, 
                                    UserRepository userRepository, 
                                    PasswordEncoder passwordEncoder,
                                    LabRequestRepository labRequestRepository,
                                    LabReportRepository labReportRepository,
                                    AppointmentRepository appointmentRepository,
                                    PrescriptionRepository prescriptionRepository,
                                    VisitRepository visitRepository,
                                    DepartmentRepository departmentRepository) {
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
            // Must delete in order of dependency to avoid FK constraint violations
            labReportRepository.deleteAll();
            labRequestRepository.deleteAll();
            prescriptionRepository.deleteAll();
            visitRepository.deleteAll();
            appointmentRepository.deleteAll();
            patientRepository.deleteAll();
            System.out.println(">> Cleared all fake patient data and dependent records from database.");

            // Initialize Default Doctor
            Optional<User> existingDoctor = userRepository.findByEmail("doctor@gmail.com");
            if (existingDoctor.isEmpty()) {
                User doc = new User();
                doc.setFullName("Test Doctor");
                doc.setEmail("doctor@gmail.com");
                doc.setPassword(passwordEncoder.encode("1234"));
                doc.setRole("Doctor");
                doc.setSpecialization("Cardiologist");
                doc.setExperience(10);
                doc.setPhone("1234567890");
                doc.setLicenseId("DOC-12345");
                userRepository.save(doc);
                System.out.println(">> Created Default Doctor User: doctor@gmail.com / 1234");
            } else {
                User d = existingDoctor.get();
                d.setPassword(passwordEncoder.encode("1234"));
                d.setRole("Doctor");
                userRepository.save(d);
                System.out.println(">> Updated Default Doctor User password to: 1234");
            }

            // Initialize Default Receptionist
            Optional<User> existingReceptionist = userRepository.findByEmail("recep@gmail.com");
            if (existingReceptionist.isEmpty()) {
                User recep = new User();
                recep.setFullName("Riya Sharma");
                recep.setEmail("recep@gmail.com");
                recep.setPassword(passwordEncoder.encode("1234"));
                recep.setRole("RECEPTIONIST");
                recep.setPhone("9876543210");
                userRepository.save(recep);
                System.out.println(">> Created Default Receptionist User: recep@gmail.com / 1234");
            } else {
                User r = existingReceptionist.get();
                r.setPassword(passwordEncoder.encode("1234"));
                r.setRole("RECEPTIONIST");
                userRepository.save(r);
                System.out.println(">> Updated Default Receptionist User password to: 1234");
            }

            // Initialize Default Departments
            if (departmentRepository.count() == 0) {
                departmentRepository.save(new com.example.demo.model.Department("General Medicine", "Primary healthcare services"));
                departmentRepository.save(new com.example.demo.model.Department("Cardiology", "Heart related conditions"));
                departmentRepository.save(new com.example.demo.model.Department("Orthopedics", "Bone and joint care"));
                departmentRepository.save(new com.example.demo.model.Department("Pediatrics", "Children's health"));
                System.out.println(">> Initialized default departments.");
            }
        };
    }
}
