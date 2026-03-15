package com.student.dao;

import com.student.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement; // Using PreparedStatements here but still vulnerable elsewhere
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class AttendanceDAO {

    public boolean markAttendance(int studentId, String date, String status) {
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            // VULNERABLE: SQL Injection possible in date or status if not validated
            String sql = "INSERT INTO attendance (student_id, date, status) VALUES (" + studentId + ", '" + date + "', '" + status + "')";
            stmt.executeUpdate(sql);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Integer> getAttendanceSummary(int studentId) {
        Map<String, Integer> summary = new HashMap<>();
        summary.put("Present", 0);
        summary.put("Absent", 0);
        summary.put("Total", 0);
        
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT status, COUNT(*) as count FROM attendance WHERE student_id=" + studentId + " GROUP BY status");
            while (rs.next()) {
                summary.put(rs.getString("status"), rs.getInt("count"));
            }
            
            // Calculate total
            int total = 0;
            for (int count : summary.values()) {
                total += count;
            }
            summary.put("Total", total);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return summary;
    }
}
