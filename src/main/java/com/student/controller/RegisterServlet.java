package com.student.controller;

import com.student.dao.StudentDAO;
import com.student.dao.UserDAO;
import com.student.model.Student;
import com.student.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.io.File;
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String u = "";
        String p = "";
        String fullName = "";
        String email = "";
        String phone = "";
        String division = "";
        String profilePicPath = "default_avatar.png"; // Default picture

        if (ServletFileUpload.isMultipartContent(request)) {
            try {
                List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);

                for (FileItem item : multiparts) {
                    if (item.isFormField()) {
                        String fieldName = item.getFieldName();
                        String fieldValue = item.getString();
                        switch (fieldName) {
                            case "username": u = fieldValue; break;
                            case "password": p = fieldValue; break;
                            case "full_name": fullName = fieldValue; break;
                            case "email": email = fieldValue; break;
                            case "phone": phone = fieldValue; break;
                            case "division": division = fieldValue; break;
                        }
                    } else if (!item.getName().isEmpty()) {
                        // VULNERABILITY: Insecure File Upload - accepting any file without validation
                        String fileName = new File(item.getName()).getName();
                        
                        // Ensure upload directory exists
                        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdir();

                        item.write(new File(uploadPath + File.separator + fileName));
                        profilePicPath = UPLOAD_DIRECTORY + "/" + fileName; // Path for database
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                response.sendRedirect("register.jsp?error=File Upload Failed");
                return;
            }
        } else {
            // Fallback for regular forms (just in case)
            u = request.getParameter("username");
            p = request.getParameter("password");
            fullName = request.getParameter("full_name");
            email = request.getParameter("email");
            phone = request.getParameter("phone");
            division = request.getParameter("division");
        }

        UserDAO userDAO = new UserDAO();
        User newUser = new User(0, u, p, "student");
        
        if (userDAO.addUser(newUser)) {
            int userId = userDAO.getLastUserId();
            Student student = new Student(0, userId, fullName, email, phone, division, "N/A", profilePicPath);
            
            StudentDAO studentDAO = new StudentDAO();
            studentDAO.addStudent(student);
            
            response.sendRedirect("login.jsp?msg=Registration Successful");
        } else {
            response.sendRedirect("register.jsp?error=Registration Failed");
        }
    }
}
