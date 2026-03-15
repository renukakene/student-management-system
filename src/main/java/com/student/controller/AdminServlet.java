package com.student.controller;

import com.student.dao.AnnouncementDAO;
import com.student.dao.AttendanceDAO;
import com.student.dao.StudentDAO;
import com.student.dao.UserDAO;
import com.student.model.Announcement;
import com.student.model.Student;
import com.student.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        StudentDAO dao = new StudentDAO();
        UserDAO userDAO = new UserDAO();
        
        try {
            if ("add".equals(action)) {
                 String username = request.getParameter("username");
                 String fullName = request.getParameter("full_name");
                 String email = request.getParameter("email");
                 String phone = request.getParameter("phone");
                 String division = request.getParameter("division");
                 String marks = request.getParameter("marks");
                 
                 // Default password for added students
                 User u = new User(0, username, "default123", "student");
                 if(userDAO.addUser(u)) {
                     int userId = userDAO.getLastUserId();
                     Student s = new Student(0, userId, fullName, email, phone, division, marks);
                     dao.addStudent(s);
                     response.sendRedirect("admin_dashboard.jsp?msg=Student Added");
                 } else {
                     response.sendRedirect("admin_add_student.jsp?error=Add Failed");
                 }
                 
            } else if ("edit".equals(action)) {
                 int id = Integer.parseInt(request.getParameter("id"));
                 Student s = dao.getStudentById(id);
                 if(s != null) {
                     s.setFullName(request.getParameter("full_name"));
                     s.setEmail(request.getParameter("email"));
                     s.setPhone(request.getParameter("phone"));
                     s.setDivision(request.getParameter("division"));
                     s.setMarks(request.getParameter("marks"));
                     dao.updateStudent(s);
                     response.sendRedirect("admin_dashboard.jsp?msg=Student Updated");
                 }
            } else if ("delete".equals(action)) {
                 int id = Integer.parseInt(request.getParameter("id"));
                 dao.deleteStudent(id);
                 response.sendRedirect("admin_dashboard.jsp?msg=Student Deleted");
            } else if ("attendance".equals(action)) {
                 int studentId = Integer.parseInt(request.getParameter("student_id"));
                 String date = request.getParameter("date");
                 String status = request.getParameter("status");
                 
                 AttendanceDAO attDao = new AttendanceDAO();
                 if(attDao.markAttendance(studentId, date, status)) {
                     response.sendRedirect("admin_student_details.jsp?id=" + studentId + "&msg=Attendance Marked");
                 } else {
                     response.sendRedirect("admin_student_details.jsp?id=" + studentId + "&error=Failed to mark attendance");
                 }
            } else if ("edit_announcement".equals(action)) {
                 int id = Integer.parseInt(request.getParameter("id"));
                 String title = request.getParameter("title");
                 String content = request.getParameter("content");
                 
                 AnnouncementDAO aDAO = new AnnouncementDAO();
                 Announcement a = aDAO.getAnnouncementById(id);
                 if (a != null) {
                     a.setTitle(title);
                     a.setContent(content);
                     aDAO.updateAnnouncement(a);
                     response.sendRedirect("admin_announcements.jsp?msg=Announcement Updated");
                 }
            } else if ("delete_announcement".equals(action)) {
                 int id = Integer.parseInt(request.getParameter("id"));
                 AnnouncementDAO aDAO = new AnnouncementDAO();
                 aDAO.deleteAnnouncement(id);
                 response.sendRedirect("admin_announcements.jsp?msg=Announcement Deleted");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?error=Action Failed");
        }
    }
    
    // VULNERABLE: Allowing GET requests for state-changing actions (CSRF)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
