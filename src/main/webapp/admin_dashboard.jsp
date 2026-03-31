<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.student.model.*, com.student.dao.*, java.util.List, java.util.ArrayList" %>
        <%@ include file="includes/header.jsp" %>

            <% User user=(User) session.getAttribute("user"); if(user==null || !"admin".equals(user.getRole())) {
                response.sendRedirect("login.jsp"); return; } StudentDAO dao=new StudentDAO(); String
                query=request.getParameter("search"); String division=request.getParameter("division"); List<Student>
                students;
                if(query != null && !query.isEmpty()) {
                students = dao.searchStudents(query);
                } else if (division != null && !division.isEmpty()) {
                students = dao.getStudentsByDivision(division);
                } else {
                students = dao.getAllStudents();
                }
                %>

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
                                <div
                                    class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                                    <h1 class="h2">
                                        <% if (division !=null && !division.isEmpty()) { %>
                                            Division <%= division %> Students
                                                <% } else { %>
                                                    Student Management
                                                    <% } %>
                                    </h1>
                                    <div class="btn-toolbar mb-2 mb-md-0">
                                        <a href="admin_add_student.jsp" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-plus"></i> Add New Student
                                        </a>
                                    </div>
                                </div>

                                <% if(request.getParameter("msg") !=null) { %>
                                    <div class="alert alert-success">
                                        <%= request.getParameter("msg") %>
                                    </div>
                                    <% } %>
                                        <% if(request.getParameter("error") !=null) { %>
                                            <div class="alert alert-danger">
                                                <%= request.getParameter("error") %>
                                            </div>
                                            <% } %>

                                                <!-- Search Bar (Vulnerable Reflected XSS if query outputted without escaping) -->
                                                <form action="admin_dashboard.jsp" method="get" class="row g-3 mb-4">
                                                    <div class="col-auto">
                                                        <input type="text" name="search" class="form-control"
                                                            placeholder="Search by name or email"
                                                            value="<%= (query!=null)?query:"" %>">
                                                    </div>
                                                    <div class="col-auto">
                                                        <button type="submit"
                                                            class="btn btn-primary mb-3">Search</button>
                                                    </div>
                                                    <% if(query !=null) { %>
                                                        <div class="col-12">Search results for: <%= query %>
                                                        </div>
                                                        <% } %>
                                                </form>

                                                <div class="table-responsive">
                                                    <table class="table table-striped table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Full Name</th>
                                                                <th>Email</th>
                                                                <th>Phone</th>
                                                                <th>Division</th>
                                                                <th>Marks</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for(Student s : students) { %>
                                                                <tr>
                                                                    <td>
                                                                        <%= s.getId() %>
                                                                    </td>
                                                                    <td>
                                                                        <a
                                                                            href="admin_student_details.jsp?id=<%= s.getId() %>">
                                                                            <%= s.getFullName() %>
                                                                        </a>
                                                                    </td>
                                                                    <td>
                                                                        <%= s.getEmail() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= s.getPhone() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= s.getDivision() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= s.getMarks() %>
                                                                    </td>
                                                                    <td>
                                                                        <a href="admin_edit_student.jsp?id=<%= s.getId() %>"
                                                                            class="btn btn-sm btn-warning">Edit</a>
                                                                        <a href="admin?action=delete&id=<%= s.getId() %>"
                                                                            class="btn btn-sm btn-danger"
                                                                            onclick="return confirm('Are you sure?')">Delete</a>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                            </main>
                    </div>
                </div>
                <%@ include file="includes/footer.jsp" %>