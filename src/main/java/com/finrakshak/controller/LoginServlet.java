package com.finrakshak.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.finrakshak.dao.UserDAO;
import com.finrakshak.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        // Get email and password from login form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Create UserDAO object
        UserDAO userDAO = new UserDAO();

        // Check login credentials
        User user = userDAO.loginUser(email, password);

        if (user != null) {

            // Create a session for the logged-in user
            HttpSession session = request.getSession();

            // Store user object in session
            session.setAttribute("user", user);

            // Login successful
            response.sendRedirect("dashboard.jsp");

        } else {

            // Login failed
            response.sendRedirect("login.html?error=invalid");
        }
    }
}
