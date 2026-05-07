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
            StaffAttendanceRepository attendanceRepo) {
        
        return args -> {
            // 1. Initialize Users / Roles
            seedUser(userRepository, passwordEncoder, "admin@gmail.com", "admin123", "Admin", "System Admin");
            seedUser(userRepository, passwordEncoder, "doctor@gmail.com", "1234", "Doctor", "Dr. Emily Chen");
            seedUser(userRepository, passwordEncoder, "receptionist@gmail.com", "1234", "Receptionist", "Sarah Receptionist");
            seedUser(userRepository, passwordEncoder, "pharmacy@gmail.com", "1234", "Pharmacy", "John Pharmacist");
            seedUser(userRepository, passwordEncoder, "delivery@gmail.com", "1234", "Delivery", "Mike Delivery");
            seedUser(userRepository, passwordEncoder, "recep@gmail.com", "1234", "RECEPTIONIST", "Riya Sharma");
            seedUser(userRepository, passwordEncoder, "pharmacist@gmail.com", "1234", "Pharmacy", "Arjun Sharma");

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

            // Clear old dummy data from the persistent database (Selective)
            attendanceRepo.deleteAll();
            shiftRepo.deleteAll();
            labReportRepository.deleteAll();
            labRequestRepository.deleteAll();
            prescriptionRepository.deleteAll();
            visitRepository.deleteAll();
            appointmentRepository.deleteAll();
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
            if (patientRepository.count() == 0) {
                Patient p1 = new Patient();
                p1.setName("Emily Johnson");
                p1.setPatientId("PID-5042");
                p1.setGender("Female");
                p1.setDateOfBirth(LocalDate.of(1995, 8, 15));
                p1.setContactNumber("+91 98765 43210");
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
            
            // Initialize Pharmacy Medicines
            if (medicineRepo.count() == 0) {
                medicineRepo.save(new Medicine("Paracetamol 500mg", "Tablet", "GSK", 100, 20.0, LocalDate.now().plusYears(2), "BT-001"));
                medicineRepo.save(new Medicine("Amoxicillin 250mg", "Capsule", "Pfizer", 5, 150.0, LocalDate.now().plusMonths(1), "BT-002"));
                medicineRepo.save(new Medicine("Cough Syrup", "Syrup", "Abbott", 50, 85.0, LocalDate.now().plusMonths(6), "BT-003"));
                medicineRepo.save(new Medicine("Insulin Glargine", "Injection", "Sanofi", 12, 1200.0, LocalDate.now().plusDays(15), "BT-004"));
                System.out.println(">> Sample medicines initialized.");
            }

            // Initialize Staff Shifts and Attendance for some users
            userRepository.findByEmail("pharmacist@gmail.com").ifPresent(pharmacist -> {
                if (shiftRepo.findByUser(pharmacist).isEmpty()) {
                    StaffShift shift = new StaffShift();
                    shift.setUser(pharmacist);
                    shift.setDayOfWeek("Monday");
                    shift.setStartTime(LocalTime.of(9, 0));
                    shift.setEndTime(LocalTime.of(17, 0));
                    shiftRepo.save(shift);
                }
                if (attendanceRepo.findByStaff(pharmacist).isEmpty()) {
                    StaffAttendance att = new StaffAttendance();
                    att.setStaff(pharmacist);
                    att.setDate(LocalDate.now());
                    att.setCheckIn(LocalTime.now().minusHours(1));
                    att.setStatus("Present");
                    attendanceRepo.save(att);
                }
            });

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
