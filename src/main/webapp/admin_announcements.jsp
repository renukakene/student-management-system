<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.student.model.*" %>
        <%@ page import="com.student.dao.*" %>
            <%@ page import="java.util.List" %>
                <% User user=(User) session.getAttribute("user"); if (user==null || !"admin".equals(user.getRole())) {
                    response.sendRedirect("admin_login.jsp"); return; } String msg=request.getParameter("msg") !=null ?
                    request.getParameter("msg") : "" ; String msgType=request.getParameter("error") !=null ? "danger"
                    : "success" ; if ("POST".equalsIgnoreCase(request.getMethod())) { 
                        String title=request.getParameter("title"); 
                        String content=request.getParameter("content"); 
                        if(title !=null && content !=null && !title.isEmpty() && !content.isEmpty()) { 
                            Announcement announcement=new Announcement(); 
                            announcement.setTitle(title); 
                            /* VULNERABILITY: Stored XSS - content is saved exactly as inputted */
                            announcement.setContent(content); 
                            AnnouncementDAO dao=new AnnouncementDAO();
                            if(dao.addAnnouncement(announcement)) { 
                                msg="Announcement posted successfully!"; 
                                msgType="success";
                            } else { 
                                msg="Failed to post announcement."; 
                                msgType="danger"; 
                            } 
                        } else {
                            msg="Title and Content are required."; 
                            msgType="warning"; 
                        } 
                    } %>

                    <%@ include file="includes/header.jsp" %>
                        <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
                            <div class="container-fluid">
                                <a class="navbar-brand" href="#">Admin Portal</a>
                                <div class="d-flex">
                                    <span class="navbar-text text-white me-3">Welcome, Admin</span>
                                    <a href="logout" class="btn btn-outline-light btn-sm">Logout</a>
                                </div>
                            </div>
                        </nav>

                        <div class="container-fluid">
                            <div class="row">
                                <%@ include file="includes/sidebar_admin.jsp" %>

                                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4 mb-5">
                                        <h2>Manage Announcements</h2>

                                        <% if(!msg.isEmpty()) { %>
                                            <div class="alert alert-<%= msgType %>">
                                                <%= msg %>
                                            </div>
                                            <% } %>

                                                <div class="card shadow-sm mt-4">
                                                    <div class="card-header bg-dark text-white">
                                                        <h5 class="mb-0">Post New Announcement</h5>
                                                    </div>
                                                    <div class="card-body">
                                                        <form action="admin_announcements.jsp" method="post">
                                                            <div class="mb-3">
                                                                <label for="title" class="form-label">Title</label>
                                                                <input type="text" class="form-control" id="title"
                                                                    name="title" required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="content" class="form-label">Announcement
                                                                    Content</label>
                                                                <!-- VULNERABILITY: Explicitly allowing HTML encourages users to input scripts -->
                                                                <textarea class="form-control" id="content"
                                                                    name="content" rows="4" required></textarea>
                                                                <div class="form-text">You can use basic HTML tags like
                                                                    &lt;b&gt;, &lt;i&gt;, or links here.</div>
                                                            </div>


                                                            <button type="submit" class="btn btn-primary">Post
                                                                Announcement</button>
                                                        </form>
                                                    </div>
                                                </div>

                                                <h3 class="mt-5">Recent Announcements</h3>
                                                <% AnnouncementDAO dao=new AnnouncementDAO(); List<Announcement>
                                                    announcements = dao.getAllAnnouncements();
                                                    if(announcements != null && !announcements.isEmpty()) {
                                                    for(Announcement a : announcements) {
                                                    %>
                                                    <div
                                                        class="card mt-3 shadow-sm border-start border-primary border-4">
                                                        <div class="card-body">
                                                            <div
                                                                class="d-flex justify-content-between align-items-center mb-2">
                                                                <h5 class="card-title text-primary mb-0">
                                                                    <%= a.getTitle() %>
                                                                </h5>
                                                                <div>
                                                                    <a href="admin_edit_announcement.jsp?id=<%= a.getId() %>"
                                                                        class="btn btn-sm btn-outline-warning me-2"><i
                                                                            class="fas fa-edit"></i> Edit</a>
                                                                    <!-- VULNERABILITY: Delete is a GET request causing easy CSRF -->
                                                                    <a href="admin?action=delete_announcement&id=<%= a.getId() %>"
                                                                        class="btn btn-sm btn-outline-danger"
                                                                        onclick="return confirm('Delete this announcement?');"><i
                                                                            class="fas fa-trash"></i> Delete</a>
                                                                </div>
                                                            </div>
                                                            <h6 class="card-subtitle mb-3 text-muted">
                                                                <%= a.getDatePosted() %>
                                                            </h6>
                                                            <!-- VULNERABILITY: Displaying raw content without escaping -->
                                                            <p class="card-text">
                                                                <%= a.getContent() %>
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <% } } else { %>
                                                        <p class="text-muted mt-3">No announcements found.</p>
                                                        <% } %>

                                    </main>
                            </div>
                        </div>
                        <%@ include file="includes/footer.jsp" %>