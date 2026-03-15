package com.student.dao;

import com.student.model.Student;
import com.student.util.DBConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM students");
            while (rs.next()) {
                students.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return students;
    }

    public List<Student> getStudentsByDivision(String division) {
        List<Student> students = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            // VULNERABILITY: Potential SQLi depending on how the controller uses this, 
            // but we'll use simple concat for now to keep with the theme of the project.
            ResultSet rs = stmt.executeQuery("SELECT * FROM students WHERE division='" + division + "'");
            while (rs.next()) {
                students.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return students;
    }

    public boolean addStudent(Student student) {
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            String sql = "INSERT INTO students (user_id, full_name, email, phone, division, marks, profile_pic) VALUES (" 
                + student.getUserId() + ", '" + student.getFullName() + "', '" + student.getEmail() + "', '" 
                + student.getPhone() + "', '" + student.getDivision() + "', '" + student.getMarks() + "', '" + student.getProfilePic() + "')";
            stmt.executeUpdate(sql);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStudent(Student student) {
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            String sql = "UPDATE students SET full_name='" + student.getFullName() 
                + "', email='" + student.getEmail() 
                + "', phone='" + student.getPhone() 
                + "', division='" + student.getDivision() 
                + "', marks='" + student.getMarks() 
                + "', profile_pic='" + student.getProfilePic()
                + "' WHERE id=" + student.getId();
            stmt.executeUpdate(sql);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteStudent(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            // Get user_id first to delete the user (will cascade to student)
            ResultSet rs = stmt.executeQuery("SELECT user_id FROM students WHERE id=" + id);
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                stmt.executeUpdate("DELETE FROM users WHERE id=" + userId);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Student getStudentById(int id) {
        Student s = null;
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM students WHERE id=" + id);
            if (rs.next()) s = mapRow(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    public Student getStudentByUserId(int userId) {
        Student s = null;
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM students WHERE user_id=" + userId);
            if (rs.next()) s = mapRow(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    public List<Student> searchStudents(String query) {
        List<Student> students = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            String sql = "SELECT * FROM students WHERE full_name LIKE '%" + query + "%' OR email LIKE '%" + query + "%'";
            System.out.println("Executing Search Query: " + sql);
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                students.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("SQL Error in Search: " + e.getMessage(), e);
        }
        return students;
    }

    private Student mapRow(ResultSet rs) throws Exception {
        String profilePic = null;
        try {
            profilePic = rs.getString("profile_pic");
        } catch (Exception e) {
            // Column might not exist if DB wasn't updated
        }
        
        // VULNERABILITY: Lenient mapping allows UNION injected data (which might be all strings) to populate the object without throwing type casting errors. 
        int id = 0; try { id = rs.getInt("id"); } catch(Exception e){}
        int userId = 0; try { userId = rs.getInt("user_id"); } catch(Exception e){}
        
        return new Student(
            id,
            userId,
            rs.getString("full_name"),
            rs.getString("email"),
            rs.getString("phone"),
            rs.getString("division"), // Or course depending on DB state
            rs.getString("marks"),
            profilePic
        );
    }
}
