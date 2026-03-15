<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*, com.student.util.DBConnection" %>
        <html>

        <head>
            <title>System Debugger</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body class="container mt-5">
            <h1>System Debugger</h1>
            <hr>

            <h3>1. Database Connection</h3>
            <% Connection conn=null; try { conn=DBConnection.getConnection(); if(conn !=null) { out.println("<div
                class='alert alert-success'>Connection Successful!</div>");
                } else {
                out.println("<div class='alert alert-danger'>Connection Failed! Returns null.</div>");
                }
                } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Connection Exception: " + e.getMessage() + "</div>");
                }
                %>

                <h3>2. Table Checks</h3>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Table</th>
                            <th>Count</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% String[] tables={"users", "students" , "attendance" }; if(conn !=null) { for(String table :
                            tables) { out.println("<tr>
                            <td>" + table + "</td>");
                            try {
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT count(*) FROM " + table);
                            if(rs.next()) {
                            int count = rs.getInt(1);
                            out.println("<td>" + count + "</td>");
                            out.println("<td class='text-success'>OK</td>");
                            }
                            rs.close();
                            } catch(Exception e) {
                            out.println("<td>Error</td>");
                            out.println("<td class='text-danger'>" + e.getMessage() + "</td>");
                            }
                            out.println("</tr>");
                            }
                            }
                            %>
                    </tbody>
                </table>

                <h3>3. Session Info</h3>
                <% Object user=session.getAttribute("user"); if(user !=null) { out.println("<div
                    class='alert alert-info'>Logged in as: " + user.toString() + "</div>");
                    } else {
                    out.println("<div class='alert alert-warning'>Not Logged In</div>");
                    }
                    %>

                    <a href="index.jsp" class="btn btn-primary">Back to Home</a>
        </body>

        </html>