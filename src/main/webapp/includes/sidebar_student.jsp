<nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link <%= (request.getRequestURI().contains(" student_dashboard")) ? "active" : "" %>"
                    href="student_dashboard.jsp">
                    <i class="fas fa-user me-2"></i> Profile
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= (request.getRequestURI().contains(" student_marks")) ? "active" : "" %>"
                    href="student_marks.jsp">
                    <i class="fas fa-chart-bar me-2"></i> My Marks
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= (request.getRequestURI().contains(" student_update")) ? "active" : "" %>"
                    href="student_update.jsp">
                    <i class="fas fa-user-edit me-2"></i> Update Profile
                </a>
            </li>
        </ul>
    </div>
</nav>