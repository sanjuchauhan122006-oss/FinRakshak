<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="com.finrakshak.model.User" %>
<%@ page import="com.finrakshak.model.Expense" %>
<%@ page import="com.finrakshak.dao.ExpenseDAO" %>
<%@ page import="com.finrakshak.dao.BudgetDAO" %>
<%@ page import="com.finrakshak.util.DBConnection" %>


<%
    // =========================================================
    // CHECK LOGIN
    // =========================================================

    User user = (User) session.getAttribute("user");

    if (user == null) {

        response.sendRedirect(
            request.getContextPath() + "/login.html"
        );

        return;
    }


    // =========================================================
    // CURRENT MONTH
    // =========================================================

    LocalDate today = LocalDate.now();

    String currentMonth =
        today.getMonth().getDisplayName(
            TextStyle.FULL,
            Locale.ENGLISH
        );


    int currentYear =
        today.getYear();


    // =========================================================
    // EXPENSE DATA
    // =========================================================

    ExpenseDAO expenseDAO =
        new ExpenseDAO();


    List<Expense> expenses =
        expenseDAO.getExpensesByUserId(
            user.getUserId()
        );


    double totalExpenses =
        expenseDAO.getTotalExpenses(
            user.getUserId()
        );


    // =========================================================
    // CATEGORY-WISE EXPENSE CALCULATION
    // ONLY CURRENT MONTH
    // =========================================================

    Map<String, Double> categoryUsed =
        new HashMap<>();


    if (expenses != null) {

        for (Expense expense : expenses) {

            String category =
                expense.getCategory();


            if (category == null) {
                continue;
            }


            /*
             * Check whether expense belongs
             * to the current month.
             */
            boolean isCurrentMonth = true;


            try {

                String dateText =
                    String.valueOf(
                        expense.getExpenseDate()
                    );


                if (dateText.length() >= 10) {

                    LocalDate expenseDate =
                        LocalDate.parse(
                            dateText.substring(0, 10)
                        );


                    isCurrentMonth =
                        expenseDate.getMonthValue()
                            == today.getMonthValue()
                        &&
                        expenseDate.getYear()
                            == currentYear;
                }

            } catch (Exception e) {

                /*
                 * If date cannot be parsed,
                 * skip it from category calculation.
                 */
                isCurrentMonth = false;
            }


            if (isCurrentMonth) {

                double amount =
                    expense.getAmount();


                categoryUsed.put(
                    category,
                    categoryUsed.getOrDefault(
                        category,
                        0.0
                    ) + amount
                );
            }
        }
    }


    // =========================================================
    // BUDGET DATA
    // =========================================================

    BudgetDAO budgetDAO =
        new BudgetDAO();


    double monthlyBudget =
        budgetDAO.getTotalBudget(
            user.getUserId(),
            currentMonth
        );


    // =========================================================
    // CATEGORY-WISE BUDGET
    //
    // We read category budgets directly from the
    // existing budgets table.
    // =========================================================

    Map<String, Double> categoryBudgets =
        new HashMap<>();


    String budgetSQL =
        "SELECT category, amount " +
        "FROM budgets " +
        "WHERE user_id = ? " +
        "AND month = ? " +
        "ORDER BY budget_id ASC";


    try {

        Connection con =
            DBConnection.getConnection();


        PreparedStatement ps =
            con.prepareStatement(
                budgetSQL
            );


        ps.setInt(
            1,
            user.getUserId()
        );


        ps.setString(
            2,
            currentMonth
        );


        ResultSet rs =
            ps.executeQuery();


        while (rs.next()) {

            String category =
                rs.getString("category");


            double amount =
                rs.getDouble("amount");


            categoryBudgets.put(
                category,
                amount
            );
        }


        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {

        e.printStackTrace();
    }


    // =========================================================
    // SAVINGS
    // =========================================================

    double moneySaved =
        monthlyBudget - totalExpenses;


    double displayedSavings =
        moneySaved;
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        FinRakshak Dashboard
    </title>


    <style>

        /* =====================================================
           RESET
        ===================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }


        /* =====================================================
           BODY
        ===================================================== */

        body {

            background: #eef4f8;

            color: #222;

        }


        /* =====================================================
           NAVBAR
        ===================================================== */

        .navbar {

            height: 75px;

            background: white;

            display: flex;

            justify-content: space-between;

            align-items: center;

            padding: 0 40px;

            box-shadow:
                0 3px 12px rgba(0,0,0,0.08);

            position: sticky;

            top: 0;

            z-index: 100;

        }


        .logo {

            font-size: 30px;

            font-weight: bold;

            color: #11998e;

        }


        .user-name {

            font-weight: bold;

            color: #333;

            font-size: 16px;

        }


        /* =====================================================
           MAIN CONTAINER
        ===================================================== */

        .container {

            max-width: 1200px;

            margin: 35px auto;

            padding: 20px;

        }


        /* =====================================================
           WELCOME
        ===================================================== */

        .welcome {

            margin-bottom: 30px;

        }


        .welcome h1 {

            font-size: 34px;

            color: #222;

        }


        .welcome p {

            margin-top: 8px;

            color: #666;

        }


        /* =====================================================
           PROFILE
        ===================================================== */

        .profile {

            background: white;

            padding: 25px;

            border-radius: 18px;

            box-shadow:
                0 5px 18px rgba(0,0,0,0.06);

            margin-bottom: 35px;

        }


        .profile h2 {

            margin-bottom: 20px;

        }


        .profile-grid {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 20px;

        }


        .info {

            background: #f8fafc;

            padding: 15px;

            border-radius: 12px;

        }


        .info strong {

            display: block;

            margin-bottom: 8px;

            color: #333;

        }


        /* =====================================================
           STATISTICS
        ===================================================== */

        .stats {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 20px;

            margin-bottom: 35px;

        }


        .stat-card {

            background: white;

            padding: 22px;

            border-radius: 16px;

            box-shadow:
                0 5px 18px rgba(0,0,0,0.06);

            transition: 0.3s;

        }


        .stat-card:hover {

            transform:
                translateY(-4px);

            box-shadow:
                0 10px 25px
                rgba(0,0,0,0.10);

        }


        .stat-card h3 {

            font-size: 14px;

            color: #666;

            margin-bottom: 10px;

        }


        .stat-card h2 {

            font-size: 28px;

            color: #11998e;

        }


        /* =====================================================
           BUDGET BREAKDOWN
        ===================================================== */

        .budget-breakdown {

            background: white;

            padding: 35px;

            border-radius: 20px;

            box-shadow:
                0 5px 18px rgba(0,0,0,0.06);

            margin-bottom: 35px;

        }


        .budget-header {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 25px;

        }


        .budget-header h2 {

            font-size: 30px;

            color: #222;

        }


        .month-badge {

            background: #e8f8f5;

            color: #11998e;

            padding: 10px 20px;

            border-radius: 25px;

            font-weight: bold;

        }


        .budget-grid {

            display: grid;

            grid-template-columns:
                repeat(2, 1fr);

            gap: 25px;

        }


        .budget-card {

            background: #f8fafc;

            padding: 25px;

            border-radius: 16px;

            border-left:
                5px solid #11998e;

            transition: 0.3s;

        }


        .budget-card:hover {

            transform:
                translateY(-3px);

            box-shadow:
                0 8px 20px
                rgba(0,0,0,0.08);

        }


        .budget-top {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 15px;

        }


        .budget-top h3 {

            font-size: 21px;

            color: #222;

        }


        .budget-top h2 {

            font-size: 25px;

            color: #11998e;

        }


        /* =====================================================
           USED / REMAINING MONEY
        ===================================================== */

        .budget-money {

            display: flex;

            justify-content: space-between;

            margin-bottom: 12px;

            font-size: 15px;

        }


        .used-money {

            color: #555;

            font-weight: 600;

        }


        .remaining-money {

            color: #11998e;

            font-weight: 600;

        }


        /* =====================================================
           PERCENTAGE
        ===================================================== */

        .percentage-text {

            display: flex;

            justify-content: space-between;

            margin-bottom: 8px;

            color: #666;

            font-size: 14px;

            font-weight: 600;

        }


        /* =====================================================
           PROGRESS BAR
        ===================================================== */

        .progress-bar {

            width: 100%;

            height: 12px;

            background: #e4e8ec;

            border-radius: 20px;

            overflow: hidden;

        }


        .progress-used {

            height: 100%;

            background:
                linear-gradient(
                    90deg,
                    #11998e,
                    #38ef7d
                );

            border-radius: 20px;

            transition:
                width 0.5s ease;

        }


        /* =====================================================
           NO BUDGET
        ===================================================== */

        .no-budget {

            text-align: center;

            color: #777;

            padding: 25px;

            background: #f8fafc;

            border-radius: 12px;

        }


        /* =====================================================
           FEATURE CARDS
        ===================================================== */

        .cards {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 25px;

            margin-bottom: 40px;

        }


        .card {

            background: white;

            padding: 28px;

            border-radius: 18px;

            box-shadow:
                0 5px 18px rgba(0,0,0,0.06);

            transition: 0.3s;

        }


        .card:hover {

            transform:
                translateY(-6px);

            box-shadow:
                0 10px 25px
                rgba(0,0,0,0.12);

        }


        .icon {

            font-size: 40px;

            margin-bottom: 15px;

        }


        .card h2 {

            margin-bottom: 10px;

        }


        .card p {

            color: #666;

            margin-bottom: 20px;

            line-height: 1.5;

        }


        /* =====================================================
           BUTTON
        ===================================================== */

        .btn {

            display: inline-block;

            padding: 12px 20px;

            background:
                linear-gradient(
                    135deg,
                    #11998e,
                    #38ef7d
                );

            color: white;

            text-decoration: none;

            border-radius: 10px;

            font-weight: bold;

            transition: 0.3s;

        }


        .btn:hover {

            transform:
                translateY(-2px);

            box-shadow:
                0 7px 18px
                rgba(17,153,142,0.25);

        }


        /* =====================================================
           EXPENSE SECTION
        ===================================================== */

        .expense-section {

            background: white;

            padding: 28px;

            border-radius: 18px;

            box-shadow:
                0 5px 18px rgba(0,0,0,0.06);

        }


        .expense-section h2 {

            margin-bottom: 20px;

        }


        .table-container {

            overflow-x: auto;

        }


        table {

            width: 100%;

            border-collapse: collapse;

        }


        th {

            background: #f1f7f6;

            color: #333;

            text-align: left;

            padding: 14px;

        }


        td {

            padding: 14px;

            border-bottom:
                1px solid #eee;

        }


        .amount {

            color: #11998e;

            font-weight: bold;

        }


        .no-expense {

            text-align: center;

            color: #777;

            padding: 25px;

        }


        /* =====================================================
           DELETE BUTTON
        ===================================================== */

        .delete-btn {

            background: #ff5c5c;

            color: white;

            border: none;

            padding: 8px 14px;

            border-radius: 7px;

            cursor: pointer;

            font-weight: bold;

            transition: 0.3s;

        }


        .delete-btn:hover {

            background: #e04444;

            transform:
                translateY(-1px);

        }


        /* =====================================================
           FOOTER
        ===================================================== */

        footer {

            text-align: center;

            padding: 35px;

            color: #666;

        }


        /* =====================================================
           RESPONSIVE
        ===================================================== */

        @media(max-width: 900px) {

            .stats {

                grid-template-columns:
                    repeat(2, 1fr);

            }


            .cards {

                grid-template-columns: 1fr;

            }


            .profile-grid {

                grid-template-columns: 1fr;

            }


            .budget-grid {

                grid-template-columns: 1fr;

            }


            .navbar {

                padding: 0 20px;

            }


            .welcome h1 {

                font-size: 28px;

            }

        }


        @media(max-width: 600px) {

            .stats {

                grid-template-columns: 1fr;

            }


            .container {

                padding: 12px;

            }


            .navbar {

                height: 65px;

            }


            .logo {

                font-size: 24px;

            }


            .user-name {

                font-size: 14px;

            }


            .budget-header {

                flex-direction: column;

                align-items: flex-start;

                gap: 15px;

            }


            .budget-top {

                flex-direction: column;

                align-items: flex-start;

                gap: 8px;

            }


            .budget-money {

                flex-direction: column;

                gap: 5px;

            }


            .percentage-text {

                flex-direction: column;

                gap: 5px;

            }

        }

    </style>

</head>


<body>


<!-- =========================================================
     NAVBAR
========================================================= -->

<div class="navbar">

    <div class="logo">
        FinRakshak
    </div>


    <div class="user-name">

        👤 <%= user.getName() %>

    </div>

</div>



<!-- =========================================================
     MAIN CONTAINER
========================================================= -->

<div class="container">


    <!-- =====================================================
         WELCOME
    ====================================================== -->

    <div class="welcome">

        <h1>
            Welcome Back 👋
        </h1>


        <p>
            Manage your money smarter with FinRakshak.
        </p>

    </div>



    <!-- =====================================================
         PROFILE
    ====================================================== -->

    <div class="profile">

        <h2>
            Your Profile
        </h2>


        <div class="profile-grid">


            <div class="info">

                <strong>
                    Email
                </strong>

                <%= user.getEmail() %>

            </div>


            <div class="info">

                <strong>
                    Phone
                </strong>

                <%= user.getPhone() %>

            </div>


            <div class="info">

                <strong>
                    College
                </strong>

                <%= user.getCollege() %>

            </div>


        </div>

    </div>



    <!-- =====================================================
         STATISTICS
    ====================================================== -->

    <div class="stats">


        <!-- TOTAL EXPENSES -->

        <div class="stat-card">

            <h3>
                Total Expenses
            </h3>


            <h2>

                ₹<%= String.format(
                    "%.2f",
                    totalExpenses
                ) %>

            </h2>

        </div>



        <!-- MONTHLY BUDGET -->

        <div class="stat-card">

            <h3>
                Monthly Budget
            </h3>


            <h2>

                ₹<%= String.format(
                    "%.2f",
                    monthlyBudget
                ) %>

            </h2>

        </div>



        <!-- MONEY SAVED -->

        <div class="stat-card">

            <h3>
                Money Saved
            </h3>


            <h2>

                ₹<%= String.format(
                    "%.2f",
                    displayedSavings
                ) %>

            </h2>

        </div>



        <!-- CURRENT MONTH -->

        <div class="stat-card">

            <h3>
                Current Month
            </h3>


            <h2>

                <%= currentMonth %>

            </h2>

        </div>


    </div>



    <!-- =====================================================
         BUDGET BREAKDOWN
    ====================================================== -->

    <div class="budget-breakdown">


        <div class="budget-header">

            <h2>
                📊 Budget Breakdown
            </h2>


            <span class="month-badge">

                <%= currentMonth %>

            </span>

        </div>


        <div class="budget-grid">


        <%

            if (!categoryBudgets.isEmpty()) {


                for (
                    Map.Entry<String, Double> entry
                    : categoryBudgets.entrySet()
                ) {


                    String category =
                        entry.getKey();


                    double budgetAmount =
                        entry.getValue();


                    // -----------------------------------------
                    // USED AMOUNT
                    // -----------------------------------------

                    double usedAmount =
                        categoryUsed.getOrDefault(
                            category,
                            0.0
                        );


                    // -----------------------------------------
                    // REMAINING AMOUNT
                    // -----------------------------------------

                    double remainingAmount =
                        budgetAmount - usedAmount;


                    if (remainingAmount < 0) {

                        remainingAmount = 0;

                    }


                    // -----------------------------------------
                    // USED PERCENTAGE
                    // -----------------------------------------

                    double usedPercentage =
                        0;


                    if (budgetAmount > 0) {

                        usedPercentage =
                            (usedAmount
                                / budgetAmount)
                            * 100;

                    }


                    // -----------------------------------------
                    // REMAINING PERCENTAGE
                    // -----------------------------------------

                    double remainingPercentage =
                        100 - usedPercentage;


                    if (remainingPercentage < 0) {

                        remainingPercentage = 0;

                    }


                    // -----------------------------------------
                    // PROGRESS BAR
                    // -----------------------------------------

                    double progressPercentage =
                        usedPercentage;


                    if (progressPercentage > 100) {

                        progressPercentage = 100;

                    }

        %>


            <div class="budget-card">


                <!-- CATEGORY + BUDGET -->

                <div class="budget-top">

                    <h3>

                        <%= category %>

                    </h3>


                    <h2>

                        ₹<%= String.format(
                            "%.2f",
                            budgetAmount
                        ) %>

                    </h2>

                </div>



                <!-- USED + REMAINING MONEY -->

                <div class="budget-money">


                    <span class="used-money">

                        Used:

                        ₹<%= String.format(
                            "%.2f",
                            usedAmount
                        ) %>

                    </span>


                    <span class="remaining-money">

                        Remaining:

                        ₹<%= String.format(
                            "%.2f",
                            remainingAmount
                        ) %>

                    </span>


                </div>



                <!-- USED + REMAINING PERCENTAGE -->

                <div class="percentage-text">


                    <span>

                        <%= String.format(
                            "%.1f",
                            usedPercentage
                        ) %>% used

                    </span>


                    <span>

                        <%= String.format(
                            "%.1f",
                            remainingPercentage
                        ) %>% remaining

                    </span>


                </div>



                <!-- PROGRESS BAR -->

                <div class="progress-bar">

                    <div
                        class="progress-used"
                        style="width:<%= String.format(
                            "%.2f",
                            progressPercentage
                        ) %>%;">
                    </div>

                </div>


            </div>


        <%

                }

            } else {

        %>


            <div class="no-budget"
                 style="grid-column: 1 / -1;">

                No budget has been created for
                <%= currentMonth %> yet.

            </div>


        <%

            }

        %>


        </div>

    </div>



    <!-- =====================================================
         FEATURE CARDS
    ====================================================== -->

    <div class="cards">


        <!-- =================================================
             MANAGE EXPENSES
        ================================================== -->

        <div class="card">

            <div class="icon">
                💰
            </div>


            <h2>
                Manage Expenses
            </h2>


            <p>
                Add, edit and track your daily expenses.
            </p>


            <a
                href="<%= request.getContextPath() %>/expense.html"
                class="btn">

                Open

            </a>

        </div>



        <!-- =================================================
             BUDGET PLANNER
        ================================================== -->

        <div class="card">

            <div class="icon">
                📊
            </div>


            <h2>
                Budget Planner
            </h2>


            <p>
                Create monthly budgets and stay on track.
            </p>


            <a
                href="<%= request.getContextPath() %>/budget.html"
                class="btn">

                Open

            </a>

        </div>



        <!-- =================================================
             STUDENT RENTALS
        ================================================== -->

        <div class="card">

            <div class="icon">
                🎒
            </div>


            <h2>
                Student Rentals
            </h2>


            <p>
                Rent calculators, lab coats and
                study essentials from fellow students.
            </p>


            <a
                href="<%= request.getContextPath() %>/rental.jsp"
                class="btn">

                Explore

            </a>

        </div>


    </div>



    <!-- =====================================================
         RECENT EXPENSES
    ====================================================== -->

    <div class="expense-section">


        <h2>
            Recent Expenses
        </h2>


        <div class="table-container">


            <table>


                <thead>

                    <tr>

                        <th>
                            Category
                        </th>


                        <th>
                            Amount
                        </th>


                        <th>
                            Description
                        </th>


                        <th>
                            Date
                        </th>


                        <th>
                            Action
                        </th>

                    </tr>

                </thead>



                <tbody>


                <%

                    if (
                        expenses != null
                        &&
                        !expenses.isEmpty()
                    ) {


                        for (
                            Expense expense
                            : expenses
                        ) {

                %>


                    <tr>


                        <td>

                            <%= expense.getCategory() %>

                        </td>


                        <td class="amount">

                            ₹<%= String.format(
                                "%.2f",
                                expense.getAmount()
                            ) %>

                        </td>


                        <td>

                            <%= expense.getDescription() %>

                        </td>


                        <td>

                            <%= expense.getExpenseDate() %>

                        </td>


                        <td>


                            <form
                                action="<%= request.getContextPath() %>/deleteExpense"
                                method="post"
                                style="margin:0;">


                                <input
                                    type="hidden"
                                    name="expenseId"
                                    value="<%= expense.getExpenseId() %>">


                                <button
                                    type="submit"
                                    class="delete-btn"
                                    onclick="return confirm('Are you sure you want to delete this expense?');">

                                    Delete

                                </button>


                            </form>


                        </td>


                    </tr>


                <%

                        }

                    } else {

                %>


                    <tr>

                        <td
                            colspan="5"
                            class="no-expense">

                            No expenses added yet.

                        </td>

                    </tr>


                <%

                    }

                %>


                </tbody>


            </table>


        </div>

    </div>


</div>



<!-- =========================================================
     FOOTER
========================================================= -->

<footer>

    © 2026 FinRakshak — Smart Financial Management

</footer>


</body>

</html>