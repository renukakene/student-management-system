<nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link <%= (request.getRequestURI().contains("admin_dashboard") && request.getParameter("division") == null) ? "active" : "" %>"
                    href="admin_dashboard.jsp">
                    <i class="fas fa-users me-2"></i> All Students
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= ("A".equals(request.getParameter("division"))) ? "active" : "" %>"
                    href="admin_dashboard.jsp?division=A">
                    <i class="fas fa-user-graduate me-2"></i> Division A
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= ("B".equals(request.getParameter("division"))) ? "active" : "" %>"
                    href="admin_dashboard.jsp?division=B">
                    <i class="fas fa-user-graduate me-2"></i> Division B
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= (request.getRequestURI().contains(" admin_add_student")) ? "active" : "" %>"
                    href="admin_add_student.jsp">
                    <i class="fas fa-user-plus me-2"></i> Add Student
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= (request.getRequestURI().contains(" admin_announcements")) ? "active" : "" %>"
                    href="admin_announcements.jsp">
                    <i class="fas fa-bullhorn me-2"></i> Announcements
                </a>
            </li>
        </ul>
    </div>
</nav>