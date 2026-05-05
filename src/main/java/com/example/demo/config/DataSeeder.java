package com.example.demo.config;

import com.example.demo.model.LabTest;
import com.example.demo.repository.LabTestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
public class DataSeeder implements CommandLineRunner {

    @Autowired
    private LabTestRepository labTestRepository;

    @Override
    public void run(String... args) throws Exception {
        // Seed Lab Tests if the table is empty
        if (labTestRepository.count() == 0) {
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
                    "Iron Panel"
            );

            for (String testName : defaultTests) {
                LabTest test = new LabTest();
                test.setName(testName);
                labTestRepository.save(test);
            }
            
            System.out.println("Default Lab Tests seeded successfully!");
        }
    }
}
