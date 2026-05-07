package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ReceptionistService {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private DepartmentRepository departmentRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private ShiftRepository shiftRepository;

    @Autowired
    private PerformanceRepository performanceRepository;

    @Autowired
    private NoShowRecordRepository noShowRecordRepository;

    // --- Patient Management ---

    public Patient registerPatient(Patient patient) {
        // Auto-generate patient ID: PID-1001, 1002, etc.
        long count = patientRepository.count();
        patient.setPatientId("PID-" + (1001 + count));
        patient.setRegistrationDate(LocalDate.now());
        
        // Handle missing dateOfBirth (calculate from age if available)
        if (patient.getDateOfBirth() == null && patient.getAge() != null) {
            patient.setDateOfBirth(LocalDate.now().minusYears(patient.getAge()));
        } else if (patient.getDateOfBirth() == null) {
            // Fallback default
            patient.setDateOfBirth(LocalDate.of(2000, 1, 1));
        }
        
        return patientRepository.save(patient);
    }

    public List<Patient> searchPatients(String query) {
        return patientRepository.findByPatientIdContainingOrContactNumberContaining(query, query);
    }

    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    public List<Appointment> getAllAppointments() {
        return appointmentRepository.findAll();
    }

    public void updateUser(User user) {
        userRepository.save(user);
    }

    // --- Appointment Management ---

    public Appointment bookAppointment(Appointment appointment) {
        // Auto-generate appointment ID
        long count = appointmentRepository.count();
        appointment.setAppointmentId("APP-" + (1001 + count));
        
        // Generate token number for that doctor/day
        long tokenCount = appointmentRepository.countByDoctorAndAppointmentDate(
                appointment.getDoctor(), appointment.getAppointmentDate());
        appointment.setTokenNumber((int) (tokenCount + 1));
        
        appointment.setStatus("Pending");
        return appointmentRepository.save(appointment);
    }

    public List<Appointment> getAppointmentsByDate(LocalDate date) {
        return appointmentRepository.findByAppointmentDate(date);
    }

    public void rescheduleAppointment(Long id, LocalDate newDate, LocalTime newTime) {
        Appointment appointment = appointmentRepository.findById(id).orElseThrow();
        appointment.setAppointmentDate(newDate);
        appointment.setAppointmentTime(newTime);
        // Reset token for new date
        long tokenCount = appointmentRepository.countByDoctorAndAppointmentDate(
                appointment.getDoctor(), newDate);
        appointment.setTokenNumber((int) (tokenCount + 1));
        appointmentRepository.save(appointment);
    }

    public void updateAppointmentStatus(Long id, String status) {
        Appointment appointment = appointmentRepository.findById(id).orElseThrow();
        appointment.setStatus(status);
        
        if ("No-show".equals(status)) {
            NoShowRecord record = new NoShowRecord();
            record.setPatient(appointment.getPatient());
            record.setAppointment(appointment);
            record.setReason("Patient did not arrive");
            noShowRecordRepository.save(record);
        }
        
        appointmentRepository.save(appointment);
    }

    // --- Queue Management ---

    public Map<String, Object> getQueueStatus(User doctor, LocalDate date) {
        List<Appointment> appointments = appointmentRepository.findByDoctor_IdAndAppointmentDate(doctor.getId(), date);
        
        long waiting = appointments.stream().filter(a -> "Waiting".equals(a.getStatus())).count();
        long inProgress = appointments.stream().filter(a -> "In Progress".equals(a.getStatus())).count();
        long completed = appointments.stream().filter(a -> "Completed".equals(a.getStatus())).count();
        
        Optional<Appointment> current = appointments.stream()
                .filter(a -> "In Progress".equals(a.getStatus()))
                .findFirst();

        Map<String, Object> status = new HashMap<>();
        status.put("total", appointments.size());
        status.put("waiting", waiting);
        status.put("inProgress", inProgress);
        status.put("completed", completed);
        status.put("currentToken", current.map(Appointment::getTokenNumber).orElse(0));
        
        return status;
    }

    // --- Analytics ---

    public Map<String, Long> getDashboardStats() {
        LocalDate today = LocalDate.now();
        Map<String, Long> stats = new HashMap<>();
        
        stats.put("totalAppointmentsToday", appointmentRepository.countByAppointmentDate(today));
        stats.put("walkinsToday", patientRepository.countByRegistrationDate(today));
        stats.put("pendingConsultations", appointmentRepository.countByAppointmentDateAndStatus(today, "Waiting"));
        stats.put("completedConsultations", appointmentRepository.countByAppointmentDateAndStatus(today, "Completed"));
        stats.put("noShowCount", appointmentRepository.countByAppointmentDateAndStatus(today, "No-show"));
        
        return stats;
    }

    public List<Map<String, Object>> getAppointmentTrends() {
        // Return stats for last 7 days
        List<Map<String, Object>> trends = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);
            Map<String, Object> data = new HashMap<>();
            data.put("date", date.toString());
            data.put("count", appointmentRepository.countByAppointmentDate(date));
            trends.add(data);
        }
        return trends;
    }

    // --- Helpers ---

    public List<User> getAllDoctors() {
        return userRepository.findByRole("Doctor");
    }

    public List<Department> getAllDepartments() {
        return departmentRepository.findAll();
    }

    // --- Attendance, Shifts & Performance ---

    public Attendance checkIn(User user) {
        Attendance attendance = attendanceRepository.findByUserAndDate(user, LocalDate.now())
                .orElse(new Attendance());
        attendance.setUser(user);
        attendance.setDate(LocalDate.now());
        if (attendance.getCheckIn() == null) {
            attendance.setCheckIn(LocalTime.now());
        }
        
        // Synchronize with User entity for Admin Dashboard
        user.setAttendanceStatus("Present");
        user.setCheckInTime(attendance.getCheckIn().toString());
        userRepository.save(user);

        return attendanceRepository.save(attendance);
    }

    public Attendance checkOut(User user) {
        Attendance attendance = attendanceRepository.findByUserAndDate(user, LocalDate.now())
                .orElseThrow(() -> new RuntimeException("Must check-in first"));
        attendance.setCheckOut(LocalTime.now());
        
        // Synchronize with User entity for Admin Dashboard
        user.setAttendanceStatus("Completed");
        user.setCheckOutTime(attendance.getCheckOut().toString());
        userRepository.save(user);

        return attendanceRepository.save(attendance);
    }

    public Attendance getTodayAttendance(User user) {
        return attendanceRepository.findByUserAndDate(user, LocalDate.now()).orElse(null);
    }

    public List<Shift> getMyShifts(User user) {
        return shiftRepository.findByUser(user);
    }

    public List<Performance> getMyPerformance(User user) {
        return performanceRepository.findByUserOrderByReviewDateDesc(user);
    }
}
