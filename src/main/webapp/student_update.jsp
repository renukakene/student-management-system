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
                                <h2>Update Profile</h2>
                                <div class="card shadow-sm" style="max-width: 600px;">
                                    <div class="card-body">
                                        <% if(student !=null) { %>
                                            <form action="student" method="post">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="id" value="<%= student.getId() %>">

                                                <div class="mb-3">
                                                    <label class="form-label">Full Name</label>
                                                    <input type="text" name="full_name" class="form-control"
                                                        value="<%= student.getFullName() %>" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Email</label>
                                                    <input type="email" name="email" class="form-control"
                                                        value="<%= student.getEmail() %>" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Phone</label>
                                                    <input type="text" name="phone" class="form-control"
                                                        value="<%= student.getPhone() %>">
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Division</label>
                                                    <input type="text" name="division" class="form-control"
                                                        value="<%= student.getDivision() %>" readonly>
                                                    <small class="text-muted">You cannot change your division.</small>
                                                </div>

                                                <button type="submit" class="btn btn-primary">Update Profile</button>
                                            </form>
                                            <% } else { %>
                                                <div class="alert alert-warning">Student profile not found.</div>
                                                <% } %>
                                    </div>
                                </div>
                            </main>
                    </div>
                </div>
                <%@ include file="includes/footer.jsp" %>