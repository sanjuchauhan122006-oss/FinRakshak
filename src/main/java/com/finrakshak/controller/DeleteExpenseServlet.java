package com.finrakshak.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.finrakshak.dao.ExpenseDAO;
import com.finrakshak.model.User;

@WebServlet("/deleteExpense")
public class DeleteExpenseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        // Check login
        if (user == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.html"
            );

            return;
        }

        try {

            // Get expense ID
            int expenseId = Integer.parseInt(
                request.getParameter("expenseId")
            );

            // Delete expense
            ExpenseDAO expenseDAO = new ExpenseDAO();

            boolean result =
                expenseDAO.deleteExpense(
                    expenseId,
                    user.getUserId()
                );

            // Return to dashboard
            response.sendRedirect(
                request.getContextPath() + "/dashboard.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                "Error deleting expense: " + e.getMessage()
            );
        }
    }
}
