<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.student.model.*" %>
        <%@ page import="com.student.dao.*" %>
            <%@ page import="org.apache.commons.fileupload.*" %>
                <%@ page import="org.apache.commons.fileupload.disk.*" %>
                    <%@ page import="org.apache.commons.fileupload.servlet.*" %>
                        <%@ page import="java.io.*" %>
                            <%@ page import="java.util.*" %>
                                <% User user=(User) session.getAttribute("user"); if (user==null ||
                                    !"student".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }
                                    String msg="" ; String msgType="" ; // Check if we have a file upload request
                                    boolean isMultipart=ServletFileUpload.isMultipartContent(request); if (isMultipart)
                                    { /* Create a factory for disk-based file items */ DiskFileItemFactory factory=new
                                    DiskFileItemFactory(); /* VULNERABILITY: No temporary repository size limits set */
                                    /* Create a new file upload handler */ ServletFileUpload upload=new
                                    ServletFileUpload(factory); try { /* Parse the request */ List<FileItem> items =
                                    upload.parseRequest(request);

                                    for (FileItem item : items) {
                                    if (!item.isFormField()) {
                                    String fileName = new File(item.getName()).getName();

                                    // VULNERABILITY: INSECURE FILE UPLOAD
                                    // Absolutely no validation on file type, extension, or content.
                                    // An attacker can upload shell.jsp and execute commands on the server.

                                    // Create the upload directory path
                                    String uploadPath = getServletContext().getRealPath("") + File.separator +
                                    "uploads";
                                    File uploadDir = new File(uploadPath);
                                    if (!uploadDir.exists()) {
                                    uploadDir.mkdir();
                                    }

                                    // VULNERABILITY: No sanitization of the file name
                                    String filePath = uploadPath + File.separator + fileName;
                                    File storeFile = new File(filePath);

                                    // Save the file on disk
                                    item.write(storeFile);

                                    // Update Database
                                    StudentDAO dao = new StudentDAO();
                                    Student student = dao.getStudentByUserId(user.getId());
                                    if(student != null) {
                                    // Store relative path
                                    student.setProfilePic("uploads/" + fileName);
                                    dao.updateStudent(student);
                                    msg = "Profile picture updated successfully!";
                                    msgType = "success";
                                    }
                                    }
                                    }
                                    } catch (Exception ex) {
                                    msg = "There was an error: " + ex.getMessage();
                                    msgType = "danger";
                                    }
                                    }
                                    %>

                                    <%@ include file="includes/header.jsp" %>
                                        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                                            <div class="container-fluid">
                                                <a class="navbar-brand" href="#">Student Dashboard</a>
                                                <div class="d-flex">
                                                    <span class="navbar-text text-white me-3">Welcome, <%=
                                                            user.getUsername() %></span>
                                                    <a href="logout" class="btn btn-outline-light btn-sm">Logout</a>
                                                </div>
                                            </div>
                                        </nav>

                                        <div class="container-fluid">
                                            <div class="row">
                                                <%@ include file="includes/sidebar_student.jsp" %>
                                                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
                                                        <h2>Update Profile Picture</h2>

                                                        <% if(!msg.isEmpty()) { %>
                                                            <div class="alert alert-<%= msgType %>">
                                                                <%= msg %>
                                                            </div>
                                                            <% } %>

                                                                <div class="card shadow-sm mt-4"
                                                                    style="max-width: 500px;">
                                                                    <div class="card-header bg-primary text-white">
                                                                        <h5 class="mb-0">Upload New Avatar</h5>
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <p class="text-muted small">
                                                                            <!-- Intentionally misleading to users, but actually accepts anything -->
                                                                            Upload a new profile picture (JPG, PNG). Max
                                                                            size 5MB.
                                                                        </p>
                                                                        <form action="upload_profile.jsp" method="post"
                                                                            enctype="multipart/form-data">
                                                                            <div class="mb-3">
                                                                                <label for="profilePic"
                                                                                    class="form-label">Select
                                                                                    Image</label>
                                                                                <input class="form-control" type="file"
                                                                                    id="profilePic" name="profilePic"
                                                                                    required>
                                                                            </div>
                                                                            <button type="submit"
                                                                                class="btn btn-primary">Upload
                                                                                Picture</button>
                                                                            <a href="student_dashboard.jsp"
                                                                                class="btn btn-outline-secondary ms-2">Cancel</a>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                    </main>
                                            </div>
                                        </div>
                                        <%@ include file="includes/footer.jsp" %>