<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div class="main-wrapper bg-gradient-login"> <!-- Added wrapper for gradient and centering -->
            <div class="container d-flex justify-content-center align-items-center" style="min-height: 80vh;">
                <div class="card card-glass login-container">
                    <div class="card-header bg-transparent text-center border-0 pt-4">
                        <i class="fas fa-university fa-3x text-primary mb-3"></i>
                        <h4 class="text-primary fw-bold">University Portal</h4>
                        <p class="text-muted small">Login to access your dashboard</p>
                    </div>
                    <div class="card-body p-4 pt-2">
                        <% if(request.getParameter("error") !=null) { %>
                            <div class="alert alert-danger shadow-sm border-0">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <%= request.getParameter("error") %>
                            </div>
                            <% } %>
                                <% if(request.getParameter("msg") !=null) { %>
                                    <div class="alert alert-success shadow-sm border-0">
                                        <i class="fas fa-check-circle me-2"></i>
                                        <%= request.getParameter("msg") %>
                                    </div>
                                    <% } %>

                                        <form action="login" method="post">
                                            <div class="mb-3">
                                                <label class="form-label text-muted fw-bold small">USERNAME</label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light border-end-0"><i
                                                            class="fas fa-user text-muted"></i></span>
                                                    <input type="text" name="username"
                                                        class="form-control bg-light border-start-0"
                                                        placeholder="Enter username" required>
                                                </div>
                                            </div>
                                            <div class="mb-4">
                                                <label class="form-label text-muted fw-bold small">PASSWORD</label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light border-end-0"><i
                                                            class="fas fa-lock text-muted"></i></span>
                                                    <input type="password" name="password"
                                                        class="form-control bg-light border-start-0"
                                                        placeholder="Enter password" required>
                                                </div>
                                            </div>
                                            <button type="submit" class="btn btn-primary w-100 py-2 shadow-sm">
                                                Login <i class="fas fa-arrow-right ms-2"></i>
                                            </button>
                                        </form>

                                        <div class="mt-4 text-center">
                                            <p class="text-muted small mb-1">Don't have an account?</p>
                                            <a href="register.jsp"
                                                class="fw-bold text-decoration-none text-primary">Create an Account</a>
                                            <div class="mt-3">
                                                <a href="index.jsp" class="text-muted small text-decoration-none"><i
                                                        class="fas fa-home me-1"></i> Back to Home</a>
                                            </div>
                                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>