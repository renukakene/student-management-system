package com.student.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/students_db";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Default XAMPP password usually empty

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("----- DB CONNECTION SUCCESS -----");
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("----- DB CONNECTION FAILED: " + e.getMessage() + " -----");
            e.printStackTrace();
        }
        return conn;
    }
}
