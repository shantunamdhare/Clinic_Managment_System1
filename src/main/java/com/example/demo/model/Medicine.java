package com.example.demo.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "medicines")
public class Medicine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String category; // Tablet, Syrup, Injection, etc.

    @Column(nullable = false)
    private String manufacturer;

    @Column(nullable = false)
    private Integer stockLevel;

    @Column(nullable = false)
    private Double price;

    @Column(nullable = false)
    private LocalDate expiryDate;

    @Column(nullable = false)
    private String batchNumber;

    public Medicine() {}

    public Medicine(String name, String category, String manufacturer, Integer stockLevel, Double price, LocalDate expiryDate, String batchNumber) {
        this.name = name;
        this.category = category;
        this.manufacturer = manufacturer;
        this.stockLevel = stockLevel;
        this.price = price;
        this.expiryDate = expiryDate;
        this.batchNumber = batchNumber;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public Integer getStockLevel() { return stockLevel; }
    public void setStockLevel(Integer stockLevel) { this.stockLevel = stockLevel; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }

    public String getBatchNumber() { return batchNumber; }
    public void setBatchNumber(String batchNumber) { this.batchNumber = batchNumber; }
}
