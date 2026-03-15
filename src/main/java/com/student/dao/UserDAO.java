package com.student.dao;

import com.student.model.User;
import com.student.util.DBConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class UserDAO {
    // VULNERABLE: Direct concatenation of input allows SQL Injection
    public User validate(String username, String password) throws Exception {
        User user = null;
        Connection conn = DBConnection.getConnection();
        Statement stmt = conn.createStatement();
        String sql = "SELECT * FROM users WHERE username = '" + username + "' AND password = '" + password + "'";
        System.out.println("Executing Query: " + sql); // For debugging/demo
        ResultSet rs = stmt.executeQuery(sql);
        if (rs.next()) {
            user = new User();
            user.setId(rs.getInt("id"));
            user.setUsername(rs.getString("username"));
            user.setRole(rs.getString("role"));
        }
        return user;
    }

    public boolean addUser(User user) {
        boolean isAdded = false;
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            String sql = "INSERT INTO users (username, password, role) VALUES ('" + user.getUsername() + "', '" + user.getPassword() + "', '" + user.getRole() + "')";
            int rows = stmt.executeUpdate(sql);
            if (rows > 0) isAdded = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isAdded;
    }
    
    public int getLastUserId() {
         int id = 0;
         try {
             Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT MAX(id) as id FROM users");
             if(rs.next()) id = rs.getInt("id");
         } catch(Exception e) {
             e.printStackTrace();
         }
         return id;
    }
}
