package com.example.demo.config;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DebugUserIds implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("--- DEBUG: ALL USERS IN DB ---");
        List<User> users = userRepository.findAll();
        for (User u : users) {
            System.out.println("ID: " + u.getId() + " | Name: " + u.getFullName() + " | Role: " + u.getRole());
        }
        System.out.println("------------------------------");
    }
}
