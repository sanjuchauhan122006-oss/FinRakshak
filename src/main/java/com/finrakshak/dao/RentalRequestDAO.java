package com.finrakshak.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.finrakshak.model.RentalRequest;
import com.finrakshak.util.DBConnection;

public class RentalRequestDAO {

    // Create a rental request
    public boolean createRequest(RentalRequest request) {

        String sql = "INSERT INTO rental_requests "
                   + "(rental_id, renter_id, start_date, end_date, status) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, request.getRentalId());
            ps.setInt(2, request.getRenterId());
            ps.setDate(3, request.getStartDate());
            ps.setDate(4, request.getEndDate());
            ps.setString(5, request.getStatus());

            int rows = ps.executeUpdate();

            ps.close();
            con.close();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
