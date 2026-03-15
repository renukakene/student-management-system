<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>
        <div class="container mt-5 mb-5">
            <div class="card mx-auto shadow" style="max-width: 600px;">
                <div class="card-header bg-success text-white">
                    <h4 class="mb-0"><i class="fas fa-user-plus me-2"></i>Student Registration</h4>
                </div>
                <div class="card-body p-4">
                    <% if(request.getParameter("error") !=null) { %>
                        <div class="alert alert-danger">
                            <%= request.getParameter("error") %>
                        </div>
                        <% } %>
                            <form action="register" method="post" enctype="multipart/form-data">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Username</label>
                                        <input type="text" name="username" class="form-control" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Password</label>
                                        <input type="password" name="password" class="form-control" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" name="full_name" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" name="email" class="form-control" required>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Phone Number</label>
                                        <input type="text" name="phone" class="form-control" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Division</label>
                                        <select name="division" class="form-select" required>
                                            <option value="">Select Division</option>
                                            <option value="A">Division A</option>
                                            <option value="B">Division B</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Profile Picture (Optional)</label>
                                    <input type="file" name="profile_pic" class="form-control">
                                    <div class="form-text">Upload your avatar. Supported formats: JPG, PNG.</div>
                                </div>

                                <div class="d-grid gap-2 mt-3">
                                    <button type="submit" class="btn btn-success">Register Now</button>
                                    <a href="login.jsp" class="btn btn-outline-secondary">Already have an account?
                                        Login</a>
                                </div>
                            </form>
                </div>
            </div>
        </div>
        <%@ include file="includes/footer.jsp" %>