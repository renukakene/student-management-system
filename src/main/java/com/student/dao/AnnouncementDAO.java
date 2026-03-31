package com.student.dao;

import com.student.model.Announcement;
import com.student.util.DBConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO {

    public List<Announcement> getAllAnnouncements() {
        List<Announcement> announcements = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM announcements ORDER BY date_posted DESC");
            while (rs.next()) {
                Announcement a = new Announcement(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getTimestamp("date_posted").toLocalDateTime()
                );
                announcements.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return announcements;
    }

    public boolean addAnnouncement(Announcement announcement) {
        try {
            Connection conn = DBConnection.getConnection();
            // VULNERABILITY: Stored XSS - content is saved exactly as inputted
            String sql = "INSERT INTO announcements (title, content) VALUES (?, ?)";
            java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, announcement.getTitle());
            pstmt.setString(2, announcement.getContent());
            pstmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Announcement getAnnouncementById(int id) {
        Announcement a = null;
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM announcements WHERE id=" + id);
            if (rs.next()) {
                a = new Announcement(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getTimestamp("date_posted").toLocalDateTime()
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return a;
    }

    public boolean updateAnnouncement(Announcement announcement) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE announcements SET title=?, content=? WHERE id=?";
            java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, announcement.getTitle());
            pstmt.setString(2, announcement.getContent());
            pstmt.setInt(3, announcement.getId());
            pstmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAnnouncement(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            stmt.executeUpdate("DELETE FROM announcements WHERE id=" + id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
