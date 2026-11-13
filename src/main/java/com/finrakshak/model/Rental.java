package com.finrakshak.model;

import java.sql.Timestamp;

public class Rental {

    private int rentalId;
    private int ownerId;
    private String itemName;
    private String description;
    private double price;
    private String availability;
    private Timestamp createdAt;

    public Rental() {
    }

    public Rental(int rentalId, int ownerId,
                  String itemName, String description,
                  double price, String availability,
                  Timestamp createdAt) {

        this.rentalId = rentalId;
        this.ownerId = ownerId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.availability = availability;
        this.createdAt = createdAt;
    }

    public int getRentalId() {
        return rentalId;
    }

    public void setRentalId(int rentalId) {
        this.rentalId = rentalId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getAvailability() {
        return availability;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}