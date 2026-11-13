package com.finrakshak.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.finrakshak.dao.RentalDAO;
import com.finrakshak.model.Rental;
import com.finrakshak.model.User;

@WebServlet("/rental")
public class RentalServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ==========================================
    // ADD RENTAL
    // ==========================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        User user =
                (User) session.getAttribute("user");

        // Check login
        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.html");

            return;
        }

        String action =
                request.getParameter("action");

        RentalDAO rentalDAO =
                new RentalDAO();

        try {

            // ==================================
            // ADD ITEM
            // ==================================

            if ("add".equals(action)) {

                String itemName =
                        request.getParameter("itemName");

                String description =
                        request.getParameter("description");

                double price =
                        Double.parseDouble(
                                request.getParameter("price"));

                Rental rental =
                        new Rental();

                rental.setOwnerId(
                        user.getUserId());

                rental.setItemName(
                        itemName);

                rental.setDescription(
                        description);

                rental.setPrice(
                        price);

                rental.setAvailability(
                        "Available");

                rentalDAO.addRental(rental);

                response.sendRedirect(
                        request.getContextPath()
                        + "/rental.jsp");

                return;
            }


            // ==================================
            // UPDATE AVAILABILITY
            // ==================================

            if ("update".equals(action)) {

                int rentalId =
                        Integer.parseInt(
                                request.getParameter(
                                        "rentalId"));

                String availability =
                        request.getParameter(
                                "availability");

                rentalDAO.updateAvailability(
                        rentalId,
                        user.getUserId(),
                        availability);

                response.sendRedirect(
                        request.getContextPath()
                        + "/rental.jsp");

                return;
            }


            // ==================================
            // DELETE RENTAL
            // ==================================

            if ("delete".equals(action)) {

                int rentalId =
                        Integer.parseInt(
                                request.getParameter(
                                        "rentalId"));

                rentalDAO.deleteRental(
                        rentalId,
                        user.getUserId());

                response.sendRedirect(
                        request.getContextPath()
                        + "/rental.jsp");

                return;
            }


            // ==================================
            // INVALID ACTION
            // ==================================

            response.sendRedirect(
                    request.getContextPath()
                    + "/rental.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "Error processing rental: "
                    + e.getMessage());
        }
    }


    // ==========================================
    // VIEW RENTALS
    // ==========================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        User user =
                (User) session.getAttribute("user");

        // Check login
        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.html");

            return;
        }

        RentalDAO rentalDAO =
                new RentalDAO();

        request.setAttribute(
                "rentals",
                rentalDAO.getAllRentals());

        request.getRequestDispatcher(
                "/rental.jsp")
                .forward(request, response);
    }
}
