
package com.finrakshak.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/finrakshak";

    private static final String USER = "root";

    private static final String PASSWORD =
            System.getenv("FINRAKSHAK_DB_PASSWORD");

    public static Connection getConnection() {
        Connection con = null;

        try {
            if (PASSWORD == null || PASSWORD.isEmpty()) {
                throw new SQLException(
                    "Database password not configured!"
                );
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("Database connected successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return con;
    }
}
