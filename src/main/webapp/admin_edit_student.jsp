<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.student.model.*, com.student.dao.*" %>
        <%@ include file="includes/header.jsp" %>

            <% User user=(User) session.getAttribute("user"); if(user==null || !"admin".equals(user.getRole())) {
                response.sendRedirect("admin_login.jsp"); return; } int id=0; try {
                id=Integer.parseInt(request.getParameter("id")); } catch(NumberFormatException e) {
                response.sendRedirect("admin_dashboard.jsp"); return; } StudentDAO dao=new StudentDAO(); Student
                student=dao.getStudentById(id); %>

                <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                    <div class="container-fluid">
                        <a class="navbar-brand" href="#">Admin Panel</a>
                        <div class="d-flex">
                            <span class="navbar-text text-white me-3">Admin: <%= user.getUsername() %></span>
                            <a href="logout" class="btn btn-outline-light btn-sm">Logout</a>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid">
                    <div class="row">
                        <%@ include file="includes/sidebar_admin.jsp" %>

                            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
                                <h2>Edit Student</h2>
                                <div class="card shadow-sm" style="max-width: 700px;">
                                    <div class="card-body">
                                        <% if(student !=null) { %>
                                            <form action="admin" method="post">
                                                <input type="hidden" name="action" value="edit">
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
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Phone</label>
                                                        <input type="text" name="phone" class="form-control"
                                                            value="<%= student.getPhone() %>" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Division</label>
                                                        <select name="division" class="form-select" required>
                                                            <option value="" <%= student.getDivision() == null ? "selected" : "" %>>Select Division</option>
                                                            <option value="A" <%= "A".equals(student.getDivision()) ? "selected" : "" %>>Division A</option>
                                                            <option value="B" <%= "B".equals(student.getDivision()) ? "selected" : "" %>>Division B</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Marks/Grade</label>
                                                    <input type="text" name="marks" class="form-control"
                                                        value="<%= student.getMarks() %>">
                                                </div>

                                                <button type="submit" class="btn btn-warning">Update Student</button>
                                                <a href="admin_dashboard.jsp" class="btn btn-secondary">Cancel</a>
                                            </form>
                                            <% } else { %>
                                                <div class="alert alert-warning">Student not found.</div>
                                                <% } %>
                                    </div>
                                </div>
                            </main>
                    </div>
                </div>
                <%@ include file="includes/footer.jsp" %>