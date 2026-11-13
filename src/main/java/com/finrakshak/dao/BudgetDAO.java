package com.finrakshak.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.finrakshak.model.Budget;
import com.finrakshak.util.DBConnection;

public class BudgetDAO {

    // ==========================================
    // ADD BUDGET
    // ==========================================

    public boolean addBudget(Budget budget) {

        String sql =
                "INSERT INTO budgets "
              + "(user_id, category, amount, month) "
              + "VALUES (?, ?, ?, ?)";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, budget.getUserId());
            ps.setString(2, budget.getCategory());
            ps.setDouble(3, budget.getAmount());
            ps.setString(4, budget.getMonth());

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
    // UPDATE BUDGET
    // ==========================================

    public boolean updateBudget(
            Budget budget,
            int userId) {

        String sql =
                "UPDATE budgets "
              + "SET category = ?, amount = ?, month = ? "
              + "WHERE budget_id = ? "
              + "AND user_id = ?";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, budget.getCategory());
            ps.setDouble(2, budget.getAmount());
            ps.setString(3, budget.getMonth());
            ps.setInt(4, budget.getBudgetId());
            ps.setInt(5, userId);

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
    // DELETE BUDGET
    // ==========================================

    public boolean deleteBudget(
            int budgetId,
            int userId) {

        String sql =
                "DELETE FROM budgets "
              + "WHERE budget_id = ? "
              + "AND user_id = ?";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, budgetId);
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
    // GET TOTAL BUDGET FOR MONTH
    // ==========================================

    public double getTotalBudget(
            int userId,
            String month) {

        double total = 0;

        String sql =
                "SELECT COALESCE(SUM(amount), 0) "
              + "FROM budgets "
              + "WHERE user_id = ? "
              + "AND month = ?";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setString(2, month);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                total =
                        rs.getDouble(1);
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
    // GET BUDGET BREAKDOWN
    // ==========================================

    public List<Budget> getBudgetsByUserIdAndMonth(
            int userId,
            String month) {

        List<Budget> budgets =
                new ArrayList<>();

        String sql =
                "SELECT budget_id, user_id, category, amount, month "
              + "FROM budgets "
              + "WHERE user_id = ? "
              + "AND month = ? "
              + "ORDER BY category ASC";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setString(2, month);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Budget budget =
                        new Budget();

                budget.setBudgetId(
                        rs.getInt("budget_id"));

                budget.setUserId(
                        rs.getInt("user_id"));

                budget.setCategory(
                        rs.getString("category"));

                budget.setAmount(
                        rs.getDouble("amount"));

                budget.setMonth(
                        rs.getString("month"));

                budgets.add(budget);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return budgets;
    }
    public java.util.Map<String, Double> getBudgetBreakdown(
            int userId,
            String month) {

        java.util.Map<String, Double> breakdown =
                new java.util.LinkedHashMap<>();

        String sql =
                "SELECT category, SUM(amount) AS total_amount " +
                "FROM budgets " +
                "WHERE user_id = ? AND month = ? " +
                "GROUP BY category " +
                "ORDER BY category";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setString(2, month);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                String category =
                        rs.getString("category");

                double amount =
                        rs.getDouble("total_amount");

                breakdown.put(category, amount);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return breakdown;
    }
}