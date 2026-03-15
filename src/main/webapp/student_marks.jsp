<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.student.model.*, com.student.dao.*" %>
        <%@ include file="includes/header.jsp" %>

            <% User user=(User) session.getAttribute("user"); if(user==null || !"student".equals(user.getRole())) {
                response.sendRedirect("login.jsp"); return; } StudentDAO dao=new StudentDAO(); Student
                student=dao.getStudentByUserId(user.getId()); %>

                <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                    <div class="container-fluid">
                        <a class="navbar-brand" href="#">Student Dashboard</a>
                        <div class="d-flex">
                            <span class="navbar-text text-white me-3">Welcome, <%= user.getUsername() %></span>
                            <a href="logout" class="btn btn-outline-light btn-sm">Logout</a>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid">
                    <div class="row">
                        <%@ include file="includes/sidebar_student.jsp" %>

                            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
                                <h2>My Marks</h2>
                                <div class="card shadow-sm">
                                    <div class="card-body">
                                        <% if(student !=null && student.getMarks() !=null) { %>
                                            <div class="alert alert-info">
                                                <h4>Current Score: <strong>
                                                        <%= student.getMarks() %>
                                                    </strong></h4>
                                                <p>This is your cumulative score for the current semester.</p>
                                            </div>
                                            <% } else { %>
                                                <div class="alert alert-secondary">No marks available yet.</div>
                                                <% } %>
                                    </div>
                                </div>
                            </main>
                    </div>
                </div>
                <%@ include file="includes/footer.jsp" %>