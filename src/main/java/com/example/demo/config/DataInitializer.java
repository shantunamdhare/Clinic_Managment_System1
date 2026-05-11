package com.example.demo.config;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(
            PatientRepository patientRepository,
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            LabRequestRepository labRequestRepository,
            LabReportRepository labReportRepository,
            AppointmentRepository appointmentRepository,
            PrescriptionRepository prescriptionRepository,
            VisitRepository visitRepository,
            DepartmentRepository departmentRepository,
            LabTestRepository labTestRepo,
            MedicineRepository medicineRepo,
            InvoiceRepository invoiceRepo,
            StaffShiftRepository shiftRepo,
            StaffAttendanceRepository attendanceRepo,
            PrescriptionItemRepository prescriptionItemRepo,
            NotificationRepository notificationRepo,
            LeaveRequestRepository leaveRequestRepo) {
        
        return args -> {
            // 1. Initialize Users / Roles
            seedUser(userRepository, passwordEncoder, "admin@gmail.com", "admin123", "Admin", "System Admin");

            // --- Database Cleanup: Remove unwanted seed users from previous runs ---
            List<String> usersToDelete = List.of(
                "doctor@gmail.com", "receptionist@gmail.com", "pharmacy@gmail.com", 
                "delivery@gmail.com", "recep@gmail.com", "pharmacist@gmail.com"
            );
            for (String email : usersToDelete) {
                userRepository.findByEmail(email).ifPresent(u -> {
                    // Delete associated records first to avoid constraint violations
                    shiftRepo.deleteAll(shiftRepo.findByUser(u));
                    attendanceRepo.deleteAll(attendanceRepo.findByStaff(u));
                    notificationRepo.deleteAll(notificationRepo.findByUserOrderByCreatedAtDesc(u));
                    leaveRequestRepo.deleteAll(leaveRequestRepo.findByUserOrderBySubmittedAtDesc(u));
                    // Also delete prescriptions where this user is the doctor
                    prescriptionRepository.deleteAll(prescriptionRepository.findByDoctorOrderByCreatedAtDesc(u));
                    userRepository.delete(u);
                    System.out.println(">> Deleted unwanted user: " + email);
                });
            }
            // Lab User with specific details
            if (userRepository.findByEmail("shyam@gmail.com").isEmpty()) {
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
            }
       // Clear old dummy data only if specifically requested or if database is empty
            // notificationRepo.deleteAll();
            // attendanceRepo.deleteAll();
            // shiftRepo.deleteAll();
            // labReportRepository.deleteAll();
            // labRequestRepository.deleteAll();
            // prescriptionItemRepo.deleteAll(); 
            // prescriptionRepository.deleteAll();
            // invoiceRepo.deleteAll(); 
            // visitRepository.deleteAll();
            // appointmentRepository.deleteAll();
            // patientRepository.deleteAll();

            // Clear old dummy data from the persistent database (Selective)
            attendanceRepo.deleteAll();
            shiftRepo.deleteAll();
            labReportRepository.deleteAll();
            labRequestRepository.deleteAll();
            prescriptionRepository.deleteAll();
            visitRepository.deleteAll();
            appointmentRepository.deleteAll();
            invoiceRepo.deleteAll();
            patientRepository.deleteAll();


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
                    LabTest lt = new LabTest();
                    lt.setName(testName);
                    lt.setPrice(500.0);
                    labTestRepo.save(lt);
                }
                System.out.println(">> Initialized default lab tests.");
            }

            // Initialize Default Departments
            if (departmentRepository.count() == 0) {
                departmentRepository.save(new Department("General Medicine", "Primary healthcare services"));
                departmentRepository.save(new Department("Cardiology", "Heart related conditions"));
                departmentRepository.save(new Department("Orthopedics", "Bone and joint care"));
                departmentRepository.save(new Department("Pediatrics", "Children's health"));
                System.out.println(">> Initialized default departments.");
            }

            // 3. Initialize Patients

            
            // Initialize Pharmacy Medicines


            // Initialize Staff Shifts and Attendance for some users


            // Initialize Sample Invoice

            
            System.out.println(">> Database initialization complete and stable.");
        };
    }

    private void seedUser(UserRepository repo, PasswordEncoder encoder, String email, String password, String role, String fullName) {
        if (repo.findByEmail(email).isEmpty()) {
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(encoder.encode(password));
            user.setRole(role);
            repo.save(user);
            System.out.println(">> Created User: " + email + " [" + role + "]");
        }
    }
}
