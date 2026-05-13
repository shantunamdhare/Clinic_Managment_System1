package com.example.demo.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import java.util.Random;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    public void sendOTP(String to, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(to);
        message.setSubject("MediCare+ - Your OTP Verification Code");
        message.setText("Welcome to MediCare+ Clinic Management System!\n\n" +
                "Your OTP for registration is: " + otp + "\n\n" +
                "This code is valid for 5 minutes. If you did not request this, please ignore this email.");
        mailSender.send(message);
    }

    public void sendWelcomeEmail(String to, String name, String role) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(to);
        message.setSubject("Registration Successful - MediCare+");
        message.setText("Dear " + name + ",\n\n" +
                "Welcome to MediCare+ Clinic Management System!\n\n" +
                "Your account has been successfully verified and created as a " + role + ".\n" +
                "You can now login to your dashboard using your registered email address.\n\n" +
                "Thank you for joining our medical community!\n\n" +
                "Best Regards,\n" +
                "The MediCare+ Team");
        mailSender.send(message);
    }
}
