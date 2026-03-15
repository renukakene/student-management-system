<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.student.model.*" %>
        <%@ include file="includes/header.jsp" %>

            <% User user=(User) session.getAttribute("user"); if(user==null || !"admin".equals(user.getRole())) {
                response.sendRedirect("admin_login.jsp"); return; } %>

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
                                <h2>Add New Student</h2>
                                <div class="card shadow-sm" style="max-width: 800px;">
                                    <div class="card-body">
                                        <% if(request.getParameter("error") !=null) { %>
                                            <div class="alert alert-danger">
                                                <%= request.getParameter("error") %>
                                            </div>
                                            <% } %>

                                                <form action="admin" method="post">
                                                    <input type="hidden" name="action" value="add">

                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Username (Login)</label>
                                                            <input type="text" name="username" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Default Password</label>
                                                            <input type="text" class="form-control" value="default123"
                                                                readonly>
                                                            <small class="text-muted">Password is set to
                                                                'default123'</small>
                                                        </div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Full Name</label>
                                                        <input type="text" name="full_name" class="form-control"
                                                            required>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Email</label>
                                                            <input type="email" name="email" class="form-control"
                                                                required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Phone</label>
                                                            <input type="text" name="phone" class="form-control"
                                                                required>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Division</label>
                                                            <select name="division" class="form-select" required>
                                                                <option value="">Select Division</option>
                                                                <option value="A">Division A</option>
                                                                <option value="B">Division B</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label">Marks/Grade (Optional)</label>
                                                            <input type="text" name="marks" class="form-control"
                                                                placeholder="e.g. 85 or A">
                                                        </div>
                                                    </div>

                                                    <div class="d-flex justify-content-between">
                                                        <a href="admin_dashboard.jsp"
                                                            class="btn btn-secondary">Cancel</a>
                                                        <button type="submit" class="btn btn-success px-4">Add
                                                            Student</button>
                                                    </div>
                                                </form>
                                    </div>
                                </div>
                            </main>
                    </div>
                </div>
                <%@ include file="includes/footer.jsp" %>