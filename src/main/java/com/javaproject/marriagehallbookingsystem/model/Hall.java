package com.javaproject.marriagehallbookingsystem.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Hall {
    private int hallId;
    private int ownerId;
    private String ownerName;
    private String hallName;
    private String location;
    private String city;
    private int seatingCapacity;
    private BigDecimal pricePerDay;
    private String description;
    private String facilities;
    private String contactNumber;
    private String imageUrl;
    private String status;
    private Timestamp createdAt;

    public Hall() {}

    // Getters and Setters
    public int getHallId() { return hallId; }
    public void setHallId(int hallId) { this.hallId = hallId; }
    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }
    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }
    public String getHallName() { return hallName; }
    public void setHallName(String hallName) { this.hallName = hallName; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public int getSeatingCapacity() { return seatingCapacity; }
    public void setSeatingCapacity(int seatingCapacity) { this.seatingCapacity = seatingCapacity; }
    public BigDecimal getPricePerDay() { return pricePerDay; }
    public void setPricePerDay(BigDecimal pricePerDay) { this.pricePerDay = pricePerDay; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getFacilities() { return facilities; }
    public void setFacilities(String facilities) { this.facilities = facilities; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
