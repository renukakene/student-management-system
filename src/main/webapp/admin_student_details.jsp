<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.student.model.*, com.student.dao.*, java.util.Map" %>
        <%@ include file="includes/header.jsp" %>

            <% User user=(User) session.getAttribute("user"); if(user==null || !"admin".equals(user.getRole())) {
                response.sendRedirect("admin_login.jsp"); return; } int id=0; try {
                id=Integer.parseInt(request.getParameter("id")); } catch(NumberFormatException e) {
                response.sendRedirect("admin_dashboard.jsp"); return; } StudentDAO dao=new StudentDAO(); Student
                student=dao.getStudentById(id); AttendanceDAO attDao=new AttendanceDAO(); Map<String, Integer>
                attendance = attDao.getAttendanceSummary(id);
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
                        <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
                            <div class="position-sticky pt-3">
                                <ul class="nav flex-column">
                                    <li class="nav-item">
                                        <a class="nav-link active" href="admin_dashboard.jsp">
                                            <i class="fas fa-users me-2"></i> Students
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="admin_add_student.jsp">
                                            <i class="fas fa-user-plus me-2"></i> Add Student
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </nav>

                        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">

                            <% if(student !=null) { %>
                                <div
                                    class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                                    <h1 class="h2">
                                        <%= student.getFullName() %>
                                    </h1>
                                    <div class="btn-toolbar mb-2 mb-md-0">
                                        <a href="admin_edit_student.jsp?id=<%= student.getId() %>"
                                            class="btn btn-sm btn-outline-warning me-2">
                                            <i class="fas fa-edit"></i> Edit Profile
                                        </a>
                                    </div>
                                </div>

                                <% if(request.getParameter("msg") !=null) { %>
                                    <div class="alert alert-success">
                                        <%= request.getParameter("msg") %>
                                    </div>
                                    <% } %>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="card shadow-sm mb-4">
                                                    <div class="card-header bg-primary text-white">
                                                        <h5 class="mb-0">Personal Information</h5>
                                                    </div>
                                                    <div class="card-body">
                                                        <p><strong>Email:</strong>
                                                            <%= student.getEmail() %>
                                                        </p>
                                                        <p><strong>Phone:</strong>
                                                            <%= student.getPhone() %>
                                                        </p>
                                                        <p><strong>Division:</strong>
                                                            <%= student.getDivision() %>
                                                        </p>
                                                        <p><strong>Marks:</strong> <span class="badge bg-success">
                                                                <%= student.getMarks() %>
                                                            </span></p>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="card shadow-sm mb-4">
                                                    <div class="card-header bg-success text-white">
                                                        <h5 class="mb-0">Attendance Summary</h5>
                                                    </div>
                                                    <div class="card-body text-center">
                                                        <div class="row">
                                                            <div class="col-4">
                                                                <h3>
                                                                    <%= attendance.getOrDefault("Present", 0) %>
                                                                </h3>
                                                                <p class="text-muted">Present</p>
                                                            </div>
                                                            <div class="col-4">
                                                                <h3>
                                                                    <%= attendance.getOrDefault("Absent", 0) %>
                                                                </h3>
                                                                <p class="text-muted">Absent</p>
                                                            </div>
                                                            <div class="col-4">
                                                                <h3>
                                                                    <%= attendance.getOrDefault("Total", 0) %>
                                                                </h3>
                                                                <p class="text-muted">Total Days</p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card shadow-sm">
                                                    <div class="card-header bg-secondary text-white">
                                                        <h5 class="mb-0">Mark Attendance</h5>
                                                    </div>
                                                    <div class="card-body">
                                                        <form action="admin" method="post">
                                                            <input type="hidden" name="action" value="attendance">
                                                            <input type="hidden" name="student_id"
                                                                value="<%= student.getId() %>">

                                                            <div class="row">
                                                                <div class="col-md-6 mb-3">
                                                                    <input type="date" name="date" class="form-control"
                                                                        require>
                                                                </div>
                                                                <div class="col-md-6 mb-3">
                                                                    <select name="status" class="form-select">
                                                                        <option value="Present">Present</option>
                                                                        <option value="Absent">Absent</option>
                                                                        <option value="Late">Late</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <button type="submit" class="btn btn-dark w-100">Update
                                                                Attendance</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <% } else { %>
                                            <div class="alert alert-danger">Student not found.</div>
                                            <% } %>
                        </main>
                    </div>
                </div>
                <%@ include file="includes/footer.jsp" %>