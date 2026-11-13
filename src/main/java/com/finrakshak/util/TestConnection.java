package com.finrakshak.util;

import java.sql.Date;

import com.finrakshak.dao.RentalRequestDAO;
import com.finrakshak.model.RentalRequest;

public class TestConnection {

    public static void main(String[] args) {

        RentalRequest request = new RentalRequest(
                0,
                1,
                1,
                Date.valueOf("2026-08-01"),
                Date.valueOf("2026-08-05"),
                "Pending"
        );

        RentalRequestDAO requestDAO = new RentalRequestDAO();

        boolean result = requestDAO.createRequest(request);

        if (result) {
            System.out.println("SUCCESS: Rental request created!");
        } else {
            System.out.println("FAILED: Rental request was not created!");
        }
    }
}
