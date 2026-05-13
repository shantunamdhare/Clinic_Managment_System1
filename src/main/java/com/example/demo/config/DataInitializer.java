package com.example.demo.config;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initData(
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
            NotificationRepository notificationRepo,
            LeaveRequestRepository leaveRequestRepository,
            AvailabilityRepository availabilityRepo,
            ScheduleRepository scheduleRepo,
            AttendanceRepository legacyAttendanceRepo,
            ShiftRepository legacyShiftRepo,
            PerformanceRepository performanceRepo,
            NoShowRecordRepository noShowRepo) {
        
        return args -> {
            System.out.println(">> Database initialization starting...");
            
            // Cleanup removed to ensure permanent storage as requested.
            
            // 1. Initialize Users / Roles
            seedUser(userRepository, passwordEncoder, "admin@gmail.com", "admin123", "Admin", "System Admin");
            
            // Seed default users only if they don't exist
            seedUser(userRepository, passwordEncoder, "doctor@gmail.com", "1234", "Doctor", "Dr. Sameer");
            seedUser(userRepository, passwordEncoder, "recep@gmail.com", "1234", "Receptionist", "Receptionist User");
            seedUser(userRepository, passwordEncoder, "pharmacist@gmail.com", "1234", "Pharmacy", "Pharmacist User");

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

            // Initialize Sample Staff and Leave Requests for Visibility
            if (userRepository.findByEmail("rahul.staff@gmail.com").isEmpty()) {
                User staffUser = new User();
                staffUser.setFullName("Rahul Sharma");
                staffUser.setEmail("rahul.staff@gmail.com");
                staffUser.setPassword(passwordEncoder.encode("1234"));
                staffUser.setRole("Staff");
                staffUser.setPhone("9876543210");
                staffUser = userRepository.save(staffUser);

                LeaveRequest lr1 = new LeaveRequest(staffUser, "Family emergency and personal reasons", LocalDate.now().plusDays(2), LocalDate.now().plusDays(5));
                lr1.setStatus("Pending");
                leaveRequestRepository.save(lr1);

                LeaveRequest lr2 = new LeaveRequest(staffUser, "Medical checkup and rest", LocalDate.now().minusDays(10), LocalDate.now().minusDays(8));
                lr2.setStatus("Approved");
                lr2.setAdminRemarks("Approved on health grounds");
                leaveRequestRepository.save(lr2);

                System.out.println(">> Seeded sample staff and leave requests for visibility.");
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
