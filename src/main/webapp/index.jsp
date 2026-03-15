<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>
    <%
        // FOR DEMO PURPOSES: Set a non-HttpOnly cookie that XSS can "steal"
        javax.servlet.http.Cookie demoCookie = new javax.servlet.http.Cookie("secret_token", "SESSION_ABC123_PROTECT_ME");
        demoCookie.setHttpOnly(false); // Make it vulnerable to XSS
        response.addCookie(demoCookie);
    %>

        <div class="main-wrapper">
            <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
                <div class="container">
                    <a class="navbar-brand fw-bold" href="#"><i class="fas fa-graduation-cap me-2"></i>Student
                        Portal</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <div class="navbar-nav ms-auto">
                            <a class="nav-link active" href="index.jsp">Home</a>
                            <a class="nav-link" href="login.jsp">Login</a>
                        </div>
                    </div>
                </div>
            </nav>

            <!-- Modern Hero Carousel -->
            <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"
                        aria-current="true" aria-label="Slide 1"></button>
                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"
                        aria-label="Slide 2"></button>
                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"
                        aria-label="Slide 3"></button>
                </div>
                <div class="carousel-inner">
                    <div class="carousel-item active hero-slide"
                        style="background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=80');">
                        <div class="carousel-caption d-flex flex-column justify-content-center h-100">
                            <h1 class="display-3 fw-bold mb-3 animate-up">Welcome to Modern University Portal</h1>
                            <p class="lead mb-4 opacity-75 animate-up delay-1">Your academic journey, beautifully
                                streamlined.</p>
                            <div class="animate-up delay-2">
                                <a href="login.jsp" class="btn btn-primary btn-lg px-5 me-3 shadow-lg hover-lift">
                                    <i class="fas fa-sign-in-alt me-2"></i>Portal Login
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="carousel-item hero-slide"
                        style="background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1509062522246-3755977927d7');">
                        <div class="carousel-caption d-flex flex-column justify-content-center h-100">
                            <h1 class="display-3 fw-bold mb-3">Empowering Education</h1>
                            <p class="lead mb-4 opacity-75">Connect, collaborate, and succeed with tailored tools.</p>
                        </div>
                    </div>
                    <div class="carousel-item hero-slide"
                        style="background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=80');">
                        <div class="carousel-caption d-flex flex-column justify-content-center h-100">
                            <h1 class="display-3 fw-bold mb-3">Stay Updated</h1>
                            <p class="lead mb-4 opacity-75">Instant access to grades, announcements, and your profile.
                            </p>
                        </div>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>


            <div class="container mt-5 mb-5">
                <div class="row mb-5">
                    <div class="col-12">
                        <div class="card shadow-sm border-0 bg-white">
                            <div class="card-header bg-primary text-white d-flex align-items-center">
                                <i class="fas fa-bullhorn fa-lg me-2"></i>
                                <h4 class="mb-0">Campus Notice Board</h4>
                            </div>
                            <div class="card-body p-0">
                                <ul class="list-group list-group-flush">
                                    <%@ page import="com.student.dao.*" %>
                                        <%@ page import="com.student.model.*" %>
                                            <%@ page import="java.util.List" %>
                                                <% AnnouncementDAO announcementDAO=new AnnouncementDAO();
                                                    List<Announcement> announcements =
                                                    announcementDAO.getAllAnnouncements();
                                                    if(announcements != null && !announcements.isEmpty()) {
                                                    for(int i=0; i < Math.min(5, announcements.size()); i++) {
                                                        Announcement a=announcements.get(i); %>
                                                        <li class="list-group-item p-4">
                                                            <div class="d-flex w-100 justify-content-between">
                                                                <h5 class="mb-1 text-primary">
                                                                    <%= a.getTitle() %>
                                                                </h5>
                                                                <small class="text-muted">
                                                                    <%= a.getDatePosted().toLocalDate() %>
                                                                </small>
                                                            </div>
                                                            <!-- VULNERABILITY: Displaying raw content without escaping -->
                                                            <p class="mb-1">
                                                                <%= a.getContent() %>
                                                            </p>
                                                        </li>
                                                        <% } } else { %>
                                                            <li class="list-group-item p-4 text-center text-muted">No
                                                                new announcements at this time.</li>
                                                            <% } %>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="card h-100 text-center p-4">
                            <div class="card-body">
                                <div class="icon-box mb-4 text-primary">
                                    <i class="fas fa-id-card fa-4x"></i>
                                </div>
                                <h4 class="card-title fw-bold">Student Profile</h4>
                                <p class="card-text text-muted">Securely manage your personal information. Update your
                                    contact details anytime.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 text-center p-4">
                            <div class="card-body">
                                <div class="icon-box mb-4 text-success">
                                    <i class="fas fa-chart-line fa-4x"></i>
                                </div>
                                <h4 class="card-title fw-bold">Marks & Grades</h4>
                                <p class="card-text text-muted">Instant access to your semester results. Track your
                                    academic performance graph.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100 text-center p-4">
                            <div class="card-body">
                                <div class="icon-box mb-4 text-danger">
                                    <i class="fas fa-users-cog fa-4x"></i>
                                </div>
                                <h4 class="card-title fw-bold">Admin Control</h4>
                                <p class="card-text text-muted">Comprehensive tools for administrators to manage student
                                    records and results.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>