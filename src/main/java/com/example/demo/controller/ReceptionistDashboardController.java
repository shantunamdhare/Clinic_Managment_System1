package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.ReceptionistService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

@Controller
@RequestMapping("/receptionist")
public class ReceptionistDashboardController {

    @Autowired
    private ReceptionistService receptionistService;

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECEPTIONIST".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }

        model.addAttribute("user", user);
        model.addAttribute("stats", receptionistService.getDashboardStats());
        model.addAttribute("trends", receptionistService.getAppointmentTrends());
        model.addAttribute("todayAppointments", receptionistService.getAppointmentsByDate(LocalDate.now()));
        model.addAttribute("doctors", receptionistService.getAllDoctors());
        model.addAttribute("departments", receptionistService.getAllDepartments());
        
        // New Staff Features
        model.addAttribute("attendance", receptionistService.getTodayAttendance(user));
        model.addAttribute("shifts", receptionistService.getMyShifts(user));
        model.addAttribute("performance", receptionistService.getMyPerformance(user));
        
        return "receptionist-dashboard";
    }

    @PostMapping("/attendance/checkin")
    public String checkIn(HttpSession session) {
        User user = (User) session.getAttribute("user");
        receptionistService.checkIn(user);
        return "redirect:/receptionist/dashboard?checkin=success";
    }

    @PostMapping("/attendance/checkout")
    public String checkOut(HttpSession session) {
        User user = (User) session.getAttribute("user");
        receptionistService.checkOut(user);
        return "redirect:/receptionist/dashboard?checkout=success";
    }

    // --- Patient Registration ---
    @PostMapping("/patient/register")
    @ResponseBody
    public Patient registerPatient(@RequestBody Patient patient) {
        return receptionistService.registerPatient(patient);
    }

    @GetMapping("/patient/search")
    @ResponseBody
    public List<Patient> searchPatients(@RequestParam String query) {
        return receptionistService.searchPatients(query);
    }

    @Autowired
    private com.example.demo.repository.PatientRepository patientRepository;

    @Autowired
    private com.example.demo.repository.UserRepository userRepository;

    // --- Appointment Booking ---
    @PostMapping("/appointment/book")
    @ResponseBody
    public Appointment bookAppointment(@RequestBody Map<String, String> payload) {
        Long patientId = Long.parseLong(payload.get("patientId"));
        Long doctorId = Long.parseLong(payload.get("doctorId"));
        LocalDate date = LocalDate.parse(payload.get("date"));
        LocalTime time = LocalTime.parse(payload.get("time"));
        String department = payload.get("department");

        Patient patient = patientRepository.findById(patientId).orElseThrow();
        User doctor = userRepository.findById(doctorId).orElseThrow();

        Appointment appointment = new Appointment();
        appointment.setPatient(patient);
        appointment.setDoctor(doctor);
        appointment.setAppointmentDate(date);
        appointment.setAppointmentTime(time);
        appointment.setDepartment(department);
        appointment.setStatus("Waiting");

        return receptionistService.bookAppointment(appointment);
    }

    @GetMapping("/patients")
    public String patientsList(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECEPTIONIST".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }
        model.addAttribute("user", user);
        model.addAttribute("patients", receptionistService.getAllPatients());
        return "patients";
    }

    // --- Sidebar Module Placeholders ---
    @GetMapping("/queue")
    public String queueStatus(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECEPTIONIST".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }
        
        List<User> doctors = receptionistService.getAllDoctors();
        Map<String, Map<String, Object>> doctorQueues = new HashMap<>();
        
        for (User doc : doctors) {
            doctorQueues.put(doc.getId().toString(), receptionistService.getQueueStatus(doc, LocalDate.now()));
        }
        
        model.addAttribute("user", user);
        model.addAttribute("doctors", doctors);
        model.addAttribute("doctorQueues", doctorQueues);
        return "queue";
    }

    @GetMapping("/calendar")
    public String calendar(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECEPTIONIST".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "calendar";
    }

    @GetMapping("/reports")
    public String reports(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECEPTIONIST".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        model.addAttribute("stats", receptionistService.getDashboardStats());
        return "reports";
    }

    // --- Queue Management ---
    @PostMapping("/appointment/update-status")
    @ResponseBody
    public String updateStatus(@RequestParam Long id, @RequestParam String status) {
        receptionistService.updateAppointmentStatus(id, status);
        return "Success";
    }

    @GetMapping("/queue/status")
    @ResponseBody
    public Map<String, Object> getQueueStatus(@RequestParam Long doctorId) {
        // Find doctor and get status
        return Map.of(); // Placeholder
    }

    @GetMapping("/doctor/availability")
    @ResponseBody
    public List<Map<String, Object>> getAvailability(
            @RequestParam Long doctorId,
            @RequestParam @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) LocalDate date) {
        // Return a lightweight DTO instead of full Availability entity
        // to avoid Jackson serializing the embedded User (password, LONGTEXT profileImage, etc.)
        List<Availability> slots = receptionistService.getDoctorAvailability(doctorId, date);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Availability slot : slots) {
            Map<String, Object> dto = new HashMap<>();
            dto.put("id", slot.getId());
            dto.put("availableDate", slot.getAvailableDate().toString());
            dto.put("startTime", slot.getStartTime().toString());
            dto.put("endTime", slot.getEndTime().toString());
            result.add(dto);
        }
        return result;
    }

    // --- Rescheduling ---
    @PostMapping("/appointment/reschedule")
    public String reschedule(@RequestParam Long id, 
                           @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate newDate,
                           @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime newTime) {
        receptionistService.rescheduleAppointment(id, newDate, newTime);
        return "redirect:/receptionist/dashboard?rescheduled=true";
    }

    @GetMapping("/appointments/all")
    @ResponseBody
    public List<Map<String, Object>> getAllAppointmentsForCalendar() {
        List<Appointment> all = receptionistService.getAllAppointments();
        List<Map<String, Object>> events = new ArrayList<>();
        for (Appointment app : all) {
            Map<String, Object> event = new HashMap<>();
            event.put("id", app.getId());
            event.put("title", "Dr. " + app.getDoctor().getFullName() + " - " + app.getPatient().getName());
            event.put("start", app.getAppointmentDate().toString() + "T" + app.getAppointmentTime().toString());
            event.put("allDay", false);
            
            // Set colors based on status
            if ("Completed".equals(app.getStatus())) {
                event.put("backgroundColor", "#10b981");
                event.put("borderColor", "#10b981");
            } else if ("No-show".equals(app.getStatus())) {
                event.put("backgroundColor", "#ef4444");
                event.put("borderColor", "#ef4444");
            } else {
                event.put("backgroundColor", "#3b82f6");
                event.put("borderColor", "#3b82f6");
            }
            
            events.add(event);
        }
        return events;
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"RECEPTIONIST".equalsIgnoreCase(user.getRole())) return "redirect:/";
        model.addAttribute("user", user);
        return "profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User updatedUser, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return "redirect:/";
        
        currentUser.setFullName(updatedUser.getFullName());
        currentUser.setEmail(updatedUser.getEmail());
        currentUser.setPhone(updatedUser.getPhone());
        
        receptionistService.updateUser(currentUser);
        session.setAttribute("user", currentUser);
        
        return "redirect:/receptionist/profile?success=true";
    }
}
