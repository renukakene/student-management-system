<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.student.model.*" %>
<%@ page import="com.student.dao.*" %>
<% 
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    AnnouncementDAO dao = new AnnouncementDAO();
    Announcement announcement = dao.getAnnouncementById(id);
    
    if (announcement == null) {
        response.sendRedirect("admin_announcements.jsp?error=Announcement not found");
        return;
    }
%>

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
            <h2>Edit Announcement</h2>

            <div class="card shadow-sm mt-4">
                <div class="card-body">
                    <form action="admin" method="post">
                        <input type="hidden" name="action" value="edit_announcement">
                        <input type="hidden" name="id" value="<%= announcement.getId() %>">
                        
                        <div class="mb-3">
                            <label for="title" class="form-label">Title</label>
                            <input type="text" class="form-control" id="title" name="title" value="<%= announcement.getTitle() %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="content" class="form-label">Announcement Content</label>
                            <textarea class="form-control" id="content" name="content" rows="6" required><%= announcement.getContent() %></textarea>
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <a href="admin_announcements.jsp" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">Update Announcement</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
<%@ include file="includes/footer.jsp" %>
