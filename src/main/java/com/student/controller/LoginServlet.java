package com.student.controller;

import com.student.dao.UserDAO;
import com.student.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        
        UserDAO dao = new UserDAO();
        try {
            // VULNERABLE: Determine user validity via vulnerable DAO (SQLi)
            User user = dao.validate(u, p);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                if ("admin".equals(user.getRole())) {
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    response.sendRedirect("student_dashboard.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=Invalid Credentials");
            }
        } catch (Exception e) {
            // VULNERABLE: Unhandled DB exceptions expose stack traces and DB structure to the attacker
            throw new ServletException("Database execution failed", e);
        }
    }
}
