package com.finrakshak.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.finrakshak.dao.BudgetDAO;
import com.finrakshak.model.Budget;
import com.finrakshak.model.User;

@WebServlet("/budget")
public class BudgetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        // Check login
        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.html");

            return;
        }

        String action = request.getParameter("action");

        BudgetDAO budgetDAO = new BudgetDAO();

        try {

            // =====================================
            // ADD BUDGET
            // =====================================

            if ("add".equals(action)) {

                String category =
                        request.getParameter("category");

                double amount =
                        Double.parseDouble(
                                request.getParameter("amount"));

                String month =
                        request.getParameter("month");

                Budget budget = new Budget();

                budget.setUserId(
                        user.getUserId());

                budget.setCategory(category);

                budget.setAmount(amount);

                budget.setMonth(month);

                budgetDAO.addBudget(budget);
            }


            // =====================================
            // UPDATE BUDGET
            // =====================================

            else if ("update".equals(action)) {

                int budgetId =
                        Integer.parseInt(
                                request.getParameter("budgetId"));

                String category =
                        request.getParameter("category");

                double amount =
                        Double.parseDouble(
                                request.getParameter("amount"));

                String month =
                        request.getParameter("month");

                Budget budget = new Budget();

                budget.setBudgetId(budgetId);

                budget.setCategory(category);

                budget.setAmount(amount);

                budget.setMonth(month);

                budgetDAO.updateBudget(
                        budget,
                        user.getUserId());
            }


            // =====================================
            // DELETE BUDGET
            // =====================================

            else if ("delete".equals(action)) {

                int budgetId =
                        Integer.parseInt(
                                request.getParameter("budgetId"));

                budgetDAO.deleteBudget(
                        budgetId,
                        user.getUserId());
            }


            // =====================================
            // BACK TO DASHBOARD
            // =====================================

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "Error processing budget: "
                    + e.getMessage());
        }
    }
}
