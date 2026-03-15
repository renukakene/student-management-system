<%@ page contentType="application/octet-stream" language="java" %>
    <%@ page import="java.io.*" %>
        <%@ page import="com.student.model.*" %>
            <% User user=(User) session.getAttribute("user"); if (user==null || !"student".equals(user.getRole())) {
                response.setContentType("text/html"); response.sendRedirect("login.jsp"); return; } // VULNERABILITY:
                Directory Traversal // The 'file' parameter is directly appended to the base directory path // without
                checking if it contains '../' or resolves to an outside directory. String
                fileName=request.getParameter("file"); if (fileName==null || fileName.isEmpty()) { out.println("No file
                specified to download."); return; } String materialsDir=getServletContext().getRealPath("/")
                + "materials" + File.separator; File downloadFile=new File(materialsDir + fileName); if
                (downloadFile.exists() && !downloadFile.isDirectory()) { try (FileInputStream inStream=new
                FileInputStream(downloadFile)) { // Get MIME type of the file String
                mimeType=getServletContext().getMimeType(downloadFile.getAbsolutePath()); if (mimeType==null) { // Set
                to binary type if MIME mapping not found mimeType="application/octet-stream" ; } // Modify response
                response.setContentType(mimeType); response.setContentLength((int) downloadFile.length()); // Force
                download String headerKey="Content-Disposition" ; String headerValue=String.format("attachment;
                filename=\"%s\"", downloadFile.getName()); response.setHeader(headerKey, headerValue); // Obtain
                response's output stream OutputStream outStream=response.getOutputStream(); byte[] buffer=new
                byte[4096]; int bytesRead=-1; while ((bytesRead=inStream.read(buffer)) !=-1) { outStream.write(buffer,
                0, bytesRead); } outStream.close(); } catch (Exception e) { out.println("Error downloading file: " + e.getMessage());
        }
    } else {
        out.println(" File not found: " + materialsDir + fileName);
    }
%>