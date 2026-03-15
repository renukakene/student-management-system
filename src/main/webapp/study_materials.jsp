<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.student.model.*" %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"student".equals(user.getRole())) {
            response.sendRedirect("login.jsp"); return; } %>

            <%@ include file="includes/header.jsp" %>
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">
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
                                <h2>Study Materials Library</h2>
                                <p class="text-muted">Access your semester notes, reference books, and assignments
                                    securely.</p>

                                <div class="row g-4 mt-2">
                                    <div class="col-md-4">
                                        <div class="card shadow-sm h-100 border-top border-primary border-4">
                                            <div class="card-body text-center">
                                                <i class="fas fa-file-pdf fa-3x text-danger mb-3"></i>
                                                <h5 class="card-title">Computer Science 101 Notes</h5>
                                                <p class="card-text text-muted small">Introduction to programming logic
                                                    and data structures.</p>
                                                <!-- VULNERABILITY: Directly referencing file names in URL, allowing directory traversal -->
                                                <a href="download.jsp?file=cs101_notes.pdf"
                                                    class="btn btn-sm btn-outline-primary">Download PDF</a>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="card shadow-sm h-100 border-top border-success border-4">
                                            <div class="card-body text-center">
                                                <i class="fas fa-file-code fa-3x text-success mb-3"></i>
                                                <h5 class="card-title">Java Programming Lab Manual</h5>
                                                <p class="card-text text-muted small">Code snippets and experiments for
                                                    semester 4.</p>
                                                <a href="download.jsp?file=java_lab.pdf"
                                                    class="btn btn-sm btn-outline-success">Download PDF</a>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="card shadow-sm h-100 border-top border-warning border-4">
                                            <div class="card-body text-center">
                                                <i class="fas fa-file-word fa-3x text-warning mb-3"></i>
                                                <h5 class="card-title">Project Guidelines</h5>
                                                <p class="card-text text-muted small">Formatting rules and presentation
                                                    guidelines for final year project.</p>
                                                <a href="download.jsp?file=project_guidelines.docx"
                                                    class="btn btn-sm btn-outline-warning">Download DOCX</a>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="card shadow-sm h-100 border-top border-info border-4">
                                            <div class="card-body text-center">
                                                <i class="fas fa-image fa-3x text-info mb-3"></i>
                                                <h5 class="card-title">Campus Map</h5>
                                                <p class="card-text text-muted small">High-resolution map of the updated
                                                    university campus.</p>
                                                <a href="download.jsp?file=campus_map.png"
                                                    class="btn btn-sm btn-outline-info">Download Map</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </main>
                    </div>
                </div>
                <%@ include file="includes/footer.jsp" %>