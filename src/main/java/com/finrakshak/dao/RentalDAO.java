package com.finrakshak.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.finrakshak.model.Rental;
import com.finrakshak.util.DBConnection;

public class RentalDAO {

    // ==========================================
    // ADD RENTAL ITEM
    // ==========================================

    public boolean addRental(Rental rental) {

        String sql =
                "INSERT INTO rentals "
              + "(owner_id, item_name, description, price, availability) "
              + "VALUES (?, ?, ?, ?, ?)";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, rental.getOwnerId());
            ps.setString(2, rental.getItemName());
            ps.setString(3, rental.getDescription());
            ps.setDouble(4, rental.getPrice());
            ps.setString(5, rental.getAvailability());

            int rows =
                    ps.executeUpdate();

            ps.close();
            con.close();

            return rows > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // ==========================================
    // GET ALL RENTAL ITEMS
    // ==========================================

    public List<Rental> getAllRentals() {

        List<Rental> rentals =
                new ArrayList<>();

        String sql =
                "SELECT * FROM rentals "
              + "ORDER BY created_at DESC";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Rental rental =
                        new Rental();

                rental.setRentalId(
                        rs.getInt("rental_id"));

                rental.setOwnerId(
                        rs.getInt("owner_id"));

                rental.setItemName(
                        rs.getString("item_name"));

                rental.setDescription(
                        rs.getString("description"));

                rental.setPrice(
                        rs.getDouble("price"));

                rental.setAvailability(
                        rs.getString("availability"));

                rental.setCreatedAt(
                        rs.getTimestamp("created_at"));

                rentals.add(rental);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return rentals;
    }


    // ==========================================
    // GET AVAILABLE RENTALS
    // ==========================================

    public List<Rental> getAvailableRentals() {

        List<Rental> rentals =
                new ArrayList<>();

        String sql =
                "SELECT * FROM rentals "
              + "WHERE availability = 'Available' "
              + "ORDER BY created_at DESC";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Rental rental =
                        new Rental();

                rental.setRentalId(
                        rs.getInt("rental_id"));

                rental.setOwnerId(
                        rs.getInt("owner_id"));

                rental.setItemName(
                        rs.getString("item_name"));

                rental.setDescription(
                        rs.getString("description"));

                rental.setPrice(
                        rs.getDouble("price"));

                rental.setAvailability(
                        rs.getString("availability"));

                rental.setCreatedAt(
                        rs.getTimestamp("created_at"));

                rentals.add(rental);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return rentals;
    }


    // ==========================================
    // UPDATE AVAILABILITY
    // ==========================================

    public boolean updateAvailability(
            int rentalId,
            int ownerId,
            String availability) {

        String sql =
                "UPDATE rentals "
              + "SET availability = ? "
              + "WHERE rental_id = ? "
              + "AND owner_id = ?";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, availability);
            ps.setInt(2, rentalId);
            ps.setInt(3, ownerId);

            int rows =
                    ps.executeUpdate();

            ps.close();
            con.close();

            return rows > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // ==========================================
    // DELETE RENTAL
    // ==========================================

    public boolean deleteRental(
            int rentalId,
            int ownerId) {

        String sql =
                "DELETE FROM rentals "
              + "WHERE rental_id = ? "
              + "AND owner_id = ?";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, rentalId);
            ps.setInt(2, ownerId);

            int rows =
                    ps.executeUpdate();

            ps.close();
            con.close();

            return rows > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }
}