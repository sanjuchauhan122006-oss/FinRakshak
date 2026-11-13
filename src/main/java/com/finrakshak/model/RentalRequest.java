package com.finrakshak.model;

import java.sql.Date;

public class RentalRequest {

    private int requestId;
    private int rentalId;
    private int renterId;
    private Date startDate;
    private Date endDate;
    private String status;

    public RentalRequest() {
    }

    public RentalRequest(int requestId, int rentalId, int renterId,
                          Date startDate, Date endDate, String status) {

        this.requestId = requestId;
        this.rentalId = rentalId;
        this.renterId = renterId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getRentalId() {
        return rentalId;
    }

    public void setRentalId(int rentalId) {
        this.rentalId = rentalId;
    }

    public int getRenterId() {
        return renterId;
    }

    public void setRenterId(int renterId) {
        this.renterId = renterId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
