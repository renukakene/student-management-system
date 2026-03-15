package com.student.controller;

import com.student.dao.StudentDAO;
import com.student.model.Student;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/student")
public class StudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String fullName = request.getParameter("full_name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String division = request.getParameter("division");
                
                StudentDAO dao = new StudentDAO();
                Student s = dao.getStudentById(id);
                if(s != null) {
                    s.setFullName(fullName);
                    s.setEmail(email);
                    s.setPhone(phone);
                    s.setDivision(division);
                    // Marks are not editable by student
                    
                    dao.updateStudent(s);
                    response.sendRedirect("student_dashboard.jsp?msg=Profile Updated");
                } else {
                    response.sendRedirect("student_dashboard.jsp?error=Student Not Found");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("student_dashboard.jsp?error=Update Failed");
            }
        }
    }
}
