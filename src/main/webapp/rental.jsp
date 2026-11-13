<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.finrakshak.model.User" %>
<%@ page import="com.finrakshak.model.Rental" %>
<%@ page import="com.finrakshak.dao.RentalDAO" %>

<%
    // ==========================================
    // CHECK LOGIN
    // ==========================================

    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.html"
        );
        return;
    }


    // ==========================================
    // GET RENTAL DATA
    // ==========================================

    RentalDAO rentalDAO = new RentalDAO();

    List<Rental> rentals =
        rentalDAO.getAllRentals();
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>FinRakshak - Student Rentals</title>


    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            background: #eef4f8;
            color: #222;
        }


        /* ==============================
           NAVBAR
        ============================== */

        .navbar {
            height: 75px;
            background: white;

            display: flex;
            justify-content: space-between;
            align-items: center;

            padding: 0 40px;

            box-shadow:
                0 3px 12px rgba(0,0,0,0.08);
        }

        .logo {
            font-size: 30px;
            font-weight: bold;
            color: #11998e;
        }

        .user-name {
            font-weight: bold;
            color: #333;
        }


        /* ==============================
           MAIN CONTAINER
        ============================== */

        .container {
            max-width: 1200px;
            margin: 35px auto;
            padding: 20px;
        }


        /* ==============================
           HEADING
        ============================== */

        .heading {
            margin-bottom: 30px;
        }

        .heading h1 {
            font-size: 34px;
            margin-bottom: 8px;
        }

        .heading p {
            color: #666;
        }


        /* ==============================
           ADD RENTAL SECTION
        ============================== */

        .add-section {
            background: white;
            padding: 30px;
            border-radius: 18px;

            box-shadow:
                0 5px 18px rgba(0,0,0,0.06);

            margin-bottom: 35px;
        }

        .add-section h2 {
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }

        input,
        textarea {
            width: 100%;
            padding: 13px;

            border: 1px solid #ddd;
            border-radius: 8px;

            font-size: 15px;
            outline: none;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        input:focus,
        textarea:focus {
            border-color: #11998e;

            box-shadow:
                0 0 0 3px
                rgba(17,153,142,0.12);
        }

        .add-btn {
            padding: 13px 25px;

            border: none;
            border-radius: 8px;

            background:
                linear-gradient(
                    135deg,
                    #11998e,
                    #38ef7d
                );

            color: white;

            font-size: 16px;
            font-weight: bold;

            cursor: pointer;
        }

        .add-btn:hover {
            transform: translateY(-2px);

            box-shadow:
                0 8px 20px
                rgba(17,153,142,0.25);
        }


        /* ==============================
           RENTAL GRID
        ============================== */

        .rental-grid {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 25px;
        }

        .rental-card {
            background: white;

            padding: 25px;

            border-radius: 18px;

            box-shadow:
                0 5px 18px rgba(0,0,0,0.06);

            transition: 0.3s;
        }

        .rental-card:hover {
            transform: translateY(-5px);

            box-shadow:
                0 10px 25px
                rgba(0,0,0,0.12);
        }

        .rental-icon {
            font-size: 42px;
            margin-bottom: 15px;
        }

        .rental-card h2 {
            margin-bottom: 10px;
        }

        .description {
            color: #666;

            line-height: 1.5;

            min-height: 45px;

            margin-bottom: 15px;
        }

        .price {
            font-size: 22px;

            font-weight: bold;

            color: #11998e;

            margin-bottom: 12px;
        }


        /* ==============================
           AVAILABILITY
        ============================== */

        .available {
            display: inline-block;

            padding: 6px 12px;

            background: #e8f8f3;

            color: #11998e;

            border-radius: 20px;

            font-size: 13px;

            font-weight: bold;
        }

        .unavailable {
            display: inline-block;

            padding: 6px 12px;

            background: #ffeaea;

            color: #d9534f;

            border-radius: 20px;

            font-size: 13px;

            font-weight: bold;
        }


        /* ==============================
           ACTIONS
        ============================== */

        .actions {
            margin-top: 20px;

            display: flex;

            gap: 10px;

            flex-wrap: wrap;
        }

        .action-btn {
            padding: 9px 14px;

            border: none;

            border-radius: 7px;

            font-weight: bold;

            cursor: pointer;
        }

        .available-btn {
            background: #11998e;
            color: white;
        }

        .unavailable-btn {
            background: #f0ad4e;
            color: white;
        }

        .delete-btn {
            background: #ff5c5c;
            color: white;
        }


        /* ==============================
           EMPTY MESSAGE
        ============================== */

        .empty {
            background: white;

            padding: 40px;

            text-align: center;

            border-radius: 18px;

            color: #777;
        }


        /* ==============================
           BACK BUTTON
        ============================== */

        .back {
            display: inline-block;

            margin-top: 35px;

            padding: 12px 20px;

            background: #11998e;

            color: white;

            text-decoration: none;

            border-radius: 8px;

            font-weight: bold;
        }


        /* ==============================
           RESPONSIVE
        ============================== */

        @media(max-width: 900px) {

            .rental-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }
        }

        @media(max-width: 600px) {

            .rental-grid {
                grid-template-columns: 1fr;
            }

            .navbar {
                padding: 0 20px;
            }

            .logo {
                font-size: 24px;
            }
        }

    </style>

</head>


<body>


<!-- ==========================================
     NAVBAR
========================================== -->

<div class="navbar">

    <div class="logo">
        FinRakshak
    </div>

    <div class="user-name">
        👤 <%= user.getName() %>
    </div>

</div>



<div class="container">


    <!-- ======================================
         PAGE HEADING
    ======================================= -->

    <div class="heading">

        <h1>
            Student Rentals 🎒
        </h1>

        <p>
            Rent useful items from fellow students
            and share your unused items.
        </p>

    </div>



    <!-- ======================================
         ADD RENTAL
    ======================================= -->

    <div class="add-section">

        <h2>
            List an Item for Rent
        </h2>


        <form
            action="<%= request.getContextPath() %>/rental"
            method="post">


            <input
                type="hidden"
                name="action"
                value="add">


            <div class="form-group">

                <label for="itemName">
                    Item Name
                </label>

                <input
                    type="text"
                    id="itemName"
                    name="itemName"
                    placeholder="Example: Scientific Calculator"
                    required>

            </div>


            <div class="form-group">

                <label for="price">
                    Price Per Day (₹)
                </label>

                <input
                    type="number"
                    id="price"
                    name="price"
                    placeholder="Example: 20"
                    min="1"
                    step="0.01"
                    required>

            </div>


            <div class="form-group">

                <label for="description">
                    Description
                </label>

                <textarea
                    id="description"
                    name="description"
                    placeholder="Describe your item..."
                    required></textarea>

            </div>


            <button
                type="submit"
                class="add-btn">

                + Add Rental Item

            </button>

        </form>

    </div>



    <!-- ======================================
         RENTAL ITEMS
    ======================================= -->

    <h2 style="margin-bottom:20px;">

        Student Rental Items

    </h2>


    <%

        if (rentals != null &&
            !rentals.isEmpty()) {

    %>


    <div class="rental-grid">


        <%

            for (Rental rental : rentals) {

        %>


        <div class="rental-card">


            <div class="rental-icon">
                🎒
            </div>


            <h2>
                <%= rental.getItemName() %>
            </h2>


            <div class="description">

                <%= rental.getDescription() %>

            </div>


            <div class="price">

                ₹<%= String.format(
                    "%.2f",
                    rental.getPrice()
                ) %>

                / day

            </div>


            <%

                if ("Available".equalsIgnoreCase(
                    rental.getAvailability())) {

            %>

                <span class="available">
                    ● Available
                </span>

            <%

                } else {

            %>

                <span class="unavailable">
                    ● Unavailable
                </span>

            <%

                }

            %>



            <!-- ==============================
                 OWNER CONTROLS
            =============================== -->

            <%

                if (rental.getOwnerId()
                    == user.getUserId()) {

            %>


            <div class="actions">


                <!-- CHANGE AVAILABILITY -->

                <form
                    action="<%= request.getContextPath() %>/rental"
                    method="post">

                    <input
                        type="hidden"
                        name="action"
                        value="update">

                    <input
                        type="hidden"
                        name="rentalId"
                        value="<%= rental.getRentalId() %>">


                    <%

                        if ("Available".equalsIgnoreCase(
                            rental.getAvailability())) {

                    %>

                        <input
                            type="hidden"
                            name="availability"
                            value="Unavailable">

                        <button
                            type="submit"
                            class="action-btn unavailable-btn">

                            Mark Unavailable

                        </button>

                    <%

                        } else {

                    %>

                        <input
                            type="hidden"
                            name="availability"
                            value="Available">

                        <button
                            type="submit"
                            class="action-btn available-btn">

                            Mark Available

                        </button>

                    <%

                        }

                    %>

                </form>



                <!-- DELETE -->

                <form
                    action="<%= request.getContextPath() %>/rental"
                    method="post"
                    onsubmit="return confirm(
                        'Are you sure you want to delete this rental?'
                    );">


                    <input
                        type="hidden"
                        name="action"
                        value="delete">

                    <input
                        type="hidden"
                        name="rentalId"
                        value="<%= rental.getRentalId() %>">


                    <button
                        type="submit"
                        class="action-btn delete-btn">

                        Delete

                    </button>

                </form>


            </div>


            <%

                }

            %>


        </div>


        <%

            }

        %>


    </div>


    <%

        } else {

    %>


    <div class="empty">

        <h2>
            No rental items available yet.
        </h2>

        <p style="margin-top:10px;">

            Be the first student to list an item!

        </p>

    </div>


    <%

        }

    %>



    <!-- ======================================
         BACK TO DASHBOARD
    ======================================= -->

    <a
        href="<%= request.getContextPath() %>/dashboard.jsp"
        class="back">

        ← Back to Dashboard

    </a>


</div>


</body>

</html>


