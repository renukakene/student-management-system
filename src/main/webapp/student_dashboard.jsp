<%@ page import="com.student.model.*" %>
    <%@ page import="com.student.dao.*" %>
        <%@ page import="java.util.Map" %>
            <%@ include file="includes/header.jsp" %>

                <% User user=(User) session.getAttribute("user"); if(user==null || !"student".equals(user.getRole())) {
                    response.sendRedirect("login.jsp"); return; } StudentDAO dao=new StudentDAO(); Student student=null;
                    /* VULNERABILITY: IDOR (Insecure Direct Object Reference) */ String
                    idParam=request.getParameter("id"); if(idParam !=null && !idParam.isEmpty()) { try { int
                    id=Integer.parseInt(idParam); student=dao.getStudentById(id); } catch(NumberFormatException e) { /*
                    ignore invalid id */ } } /* Fallback: If no ID in URL, show logged-in user's profile */
                    if(student==null) { student=dao.getStudentByUserId(user.getId()); } AttendanceDAO attDao=new
                    AttendanceDAO(); Map<String, Integer> att = null;
                    if(student != null) {
                    att = attDao.getAttendanceSummary(student.getId());
                    }
                    %>

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
                                    <h2>Dashboard</h2>
                                    <% if(request.getParameter("msg") !=null) { %>
                                        <div class="alert alert-success">
                                            <%= request.getParameter("msg") %>
                                        </div>
                                        <% } %>

                                            <% if(student !=null) { %>
                                                <div class="row">
                                                    <div class="col-md-6 mb-4">
                                                        <div class="card shadow-sm h-100">
                                                            <div class="card-header bg-primary text-white">
                                                                <h5 class="mb-0">My Profile</h5>
                                                            </div>
                                                            <div class="card-body">
                                                                <div class="text-center mb-3">
                                                                    <% if (student.getProfilePic() !=null &&
                                                                        !student.getProfilePic().isEmpty()) { %>
                                                                        <img src="<%= request.getContextPath() %>/<%= student.getProfilePic() %>"
                                                                            alt="Profile Picture"
                                                                            class="rounded-circle img-thumbnail"
                                                                            style="width: 120px; height: 120px; object-fit: cover;">
                                                                        <% } else { %>
                                                                            <div class="rounded-circle bg-secondary d-inline-flex justify-content-center align-items-center text-white"
                                                                                style="width: 120px; height: 120px;">
                                                                                <i class="fas fa-user fa-4x"></i>
                                                                            </div>
                                                                            <% } %>
                                                                </div>
                                                                <h5 class="card-title text-center">
                                                                    <%= student.getFullName() %>
                                                                </h5>
                                                                <p class="card-text text-center">
                                                                    <strong>Email:</strong>
                                                                    <%= student.getEmail() %><br>
                                                                        <strong>Phone:</strong>
                                                                        <%= student.getPhone() %><br>
                                                                            <strong>Division:</strong>
                                                                            <%= student.getDivision() %><br>
                                                                                <strong>Student ID:</strong>
                                                                                <%= student.getId() %>
                                                                </p>
                                                                <div class="text-center">
                                                                    <a href="upload_profile.jsp"
                                                                        class="btn btn-outline-primary btn-sm mb-2"><i
                                                                            class="fas fa-camera me-1"></i> Change
                                                                        Photo</a><br>
                                                                    <a href="student_update.jsp"
                                                                        class="btn btn-primary btn-sm">Edit Profile
                                                                        Details</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-6 mb-4">
                                                        <div class="card shadow-sm h-100">
                                                            <div class="card-header bg-success text-white">
                                                                <h5 class="mb-0">Attendance & Performance</h5>
                                                            </div>
                                                            <div class="card-body text-center">
                                                                <div class="row">
                                                                    <div class="col-6">
                                                                        <h3 class="text-success">
                                                                            <%= att.getOrDefault("Present", 0) %>
                                                                        </h3>
                                                                        <p>Days Present</p>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <h3 class="text-danger">
                                                                            <%= att.getOrDefault("Absent", 0) %>
                                                                        </h3>
                                                                        <p>Days Absent</p>
                                                                    </div>
                                                                </div>
                                                                <hr>
                                                                <div class="d-grid gap-2">
                                                                    <a href="student_marks.jsp"
                                                                        class="btn btn-outline-success">View Detailed
                                                                        Marks</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row mt-4">
                                                    <div class="col-12">
                                                        <div class="card shadow-sm">
                                                            <div
                                                                class="card-header bg-info text-dark d-flex align-items-center">
                                                                <i class="fas fa-bullhorn fa-lg me-2"></i>
                                                                <h5 class="mb-0">Latest Announcements</h5>
                                                            </div>
                                                            <div class="card-body p-0">
                                                                <div class="list-group list-group-flush">
                                                                    <% AnnouncementDAO announcementDAO=new
                                                                        AnnouncementDAO(); java.util.List<Announcement>
                                                                        announcements =
                                                                        announcementDAO.getAllAnnouncements();
                                                                        if(announcements != null &&
                                                                        !announcements.isEmpty()) {
                                                                        for(int i=0; i < Math.min(3,
                                                                            announcements.size()); i++) { Announcement
                                                                            a=announcements.get(i); %>
                                                                            <div
                                                                                class="list-group-item list-group-item-action p-3">
                                                                                <div
                                                                                    class="d-flex w-100 justify-content-between">
                                                                                    <h6
                                                                                        class="mb-1 text-primary fw-bold">
                                                                                        <%= a.getTitle() %>
                                                                                    </h6>
                                                                                    <small class="text-muted">
                                                                                        <%= a.getDatePosted().toLocalDate()
                                                                                            %>
                                                                                    </small>
                                                                                </div>
                                                                                <!-- VULNERABILITY: Stored XSS -->
                                                                                <p class="mb-1 small">
                                                                                    <%= a.getContent() %>
                                                                                </p>
                                                                            </div>
                                                                            <% } } else { %>
                                                                                <div
                                                                                    class="list-group-item p-3 text-center text-muted">
                                                                                    No recent announcements.</div>
                                                                                <% } %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <% } else { %>
                                                    <div class="alert alert-warning">Profile details not found. Please
                                                        contact admin.</div>
                                                    <% } %>
                                </main>
                        </div>
                    </div>
                    <%@ include file="includes/footer.jsp" %>