package com.finrakshak.controller;

import java.io.IOException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.finrakshak.dao.ExpenseDAO;
import com.finrakshak.model.Expense;
import com.finrakshak.model.User;

@WebServlet("/addExpense")
public class ExpenseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session
        HttpSession session = request.getSession();

        // Get logged-in user
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.html"
            );
            return;
        }

        try {

            // Get form data
            String category = request.getParameter("category");
            String amountString = request.getParameter("amount");
            String description = request.getParameter("description");
            String dateString = request.getParameter("expenseDate");

            // Convert amount
            double amount = Double.parseDouble(amountString);

            // Convert date
            Date expenseDate = Date.valueOf(dateString);

            // Create Expense object
            Expense expense = new Expense();

            expense.setUserId(user.getUserId());
            expense.setCategory(category);
            expense.setAmount(amount);
            expense.setDescription(description);
            expense.setExpenseDate(expenseDate);

            // Create DAO
            ExpenseDAO expenseDAO = new ExpenseDAO();

            // Save expense into database
            boolean result = expenseDAO.addExpense(expense);

            if (result) {

                // Expense successfully added
                response.sendRedirect(
                    request.getContextPath() + "/dashboard.jsp"
                );

            } else {

                response.getWriter().println(
                    "Failed to add expense."
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                "Error adding expense: " + e.getMessage()
            );
        }
    }
}