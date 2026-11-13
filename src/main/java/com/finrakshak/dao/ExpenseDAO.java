package com.finrakshak.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.finrakshak.model.Expense;
import com.finrakshak.util.DBConnection;

public class ExpenseDAO {

    // ==========================================
    // ADD A NEW EXPENSE
    // ==========================================

    public boolean addExpense(Expense expense) {

        String sql = "INSERT INTO expenses "
                   + "(user_id, category, amount, description, expense_date) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, expense.getUserId());
            ps.setString(2, expense.getCategory());
            ps.setDouble(3, expense.getAmount());
            ps.setString(4, expense.getDescription());
            ps.setDate(5, expense.getExpenseDate());

            int rows = ps.executeUpdate();

            ps.close();
            con.close();

            return rows > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // ==========================================
    // GET ALL EXPENSES OF A USER
    // ==========================================

    public List<Expense> getExpensesByUserId(int userId) {

        List<Expense> expenses = new ArrayList<>();

        String sql = "SELECT * FROM expenses "
                   + "WHERE user_id = ? "
                   + "ORDER BY expense_date DESC";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Expense expense = new Expense();

                expense.setExpenseId(
                    rs.getInt("expense_id")
                );

                expense.setUserId(
                    rs.getInt("user_id")
                );

                expense.setCategory(
                    rs.getString("category")
                );

                expense.setAmount(
                    rs.getDouble("amount")
                );

                expense.setDescription(
                    rs.getString("description")
                );

                expense.setExpenseDate(
                    rs.getDate("expense_date")
                );

                expenses.add(expense);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return expenses;
    }


    // ==========================================
    // GET TOTAL EXPENSES OF A USER
    // ==========================================

    public double getTotalExpenses(int userId) {

        double total = 0;

        String sql = "SELECT SUM(amount) AS total "
                   + "FROM expenses "
                   + "WHERE user_id = ?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                total = rs.getDouble("total");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return total;
    }


    // ==========================================
    // GET CATEGORY EXPENSE FOR A PARTICULAR MONTH
    // ==========================================

    public double getCategoryExpense(
            int userId,
            String category,
            String month) {

        double total = 0;

        String sql = "SELECT SUM(amount) AS total "
                   + "FROM expenses "
                   + "WHERE user_id = ? "
                   + "AND category = ? "
                   + "AND MONTHNAME(expense_date) = ?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, userId);

            ps.setString(2, category);

            ps.setString(3, month);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                total = rs.getDouble("total");
            }

            rs.close();

            ps.close();

            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return total;
    }


    // ==========================================
    // DELETE AN EXPENSE
    // ==========================================

    public boolean deleteExpense(
            int expenseId,
            int userId) {

        String sql = "DELETE FROM expenses "
                   + "WHERE expense_id = ? "
                   + "AND user_id = ?";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, expenseId);

            ps.setInt(2, userId);

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
 // GET CATEGORY EXPENSES FOR A MONTH
 // ==========================================

 public double getCategoryExpenses(
         int userId,
         String category,
         String month) {

     double total = 0;

     String sql =
             "SELECT SUM(amount) AS total "
           + "FROM expenses "
           + "WHERE user_id = ? "
           + "AND category = ? "
           + "AND MONTHNAME(expense_date) = ?";

     try {

         Connection con =
                 DBConnection.getConnection();

         PreparedStatement ps =
                 con.prepareStatement(sql);

         ps.setInt(1, userId);
         ps.setString(2, category);
         ps.setString(3, month);

         ResultSet rs =
                 ps.executeQuery();

         if (rs.next()) {

             total = rs.getDouble("total");

         }

         rs.close();
         ps.close();
         con.close();

     } catch (Exception e) {

         e.printStackTrace();
     }

     return total;
 }

}
