package com.example.demo.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.core.annotation.Order;

@Component
@Order(1) // Run before DataInitializer
public class DatabaseSchemaFixer implements CommandLineRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        try {
            System.out.println(">> Attempting to relax database constraints for Prescription table...");
            
            // Fix visit_id nullable
            jdbcTemplate.execute("ALTER TABLE prescriptions MODIFY COLUMN visit_id BIGINT NULL");
            
            // Fix legacy columns nullable just in case
            jdbcTemplate.execute("ALTER TABLE prescriptions MODIFY COLUMN medicine VARCHAR(255) NULL");
            jdbcTemplate.execute("ALTER TABLE prescriptions MODIFY COLUMN dosage VARCHAR(255) NULL");
            jdbcTemplate.execute("ALTER TABLE prescriptions MODIFY COLUMN duration VARCHAR(255) NULL");
            jdbcTemplate.execute("ALTER TABLE prescriptions MODIFY COLUMN instructions VARCHAR(255) NULL");
            
            System.out.println(">> Database constraints relaxed successfully.");
        } catch (Exception e) {
            System.err.println(">> Failed to relax database constraints: " + e.getMessage());
            // Continue anyway, maybe it's already fixed or not MySQL
        }
    }
}
