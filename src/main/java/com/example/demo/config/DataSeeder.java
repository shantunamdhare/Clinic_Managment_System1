package com.example.demo.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * This class is deprecated and merged into DataInitializer.
 * It is kept empty to avoid logical conflicts during startup.
 */
@Component
public class DataSeeder implements CommandLineRunner {
    @Override
    public void run(String... args) throws Exception {
        // Functionality moved to DataInitializer
    }
}
