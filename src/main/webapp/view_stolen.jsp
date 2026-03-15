<%@ page import="java.io.*" %>
<html>
<head>
    <title>Hacker Command & Control Center</title>
    <style>
        body { background-color: black; color: #00ff00; font-family: 'Courier New', Courier, monospace; padding: 30px; }
        h1 { color: red; text-align: center; border-bottom: 2px solid red; padding-bottom: 10px; }
        .log-box { border: 1px solid #00ff00; padding: 20px; min-height: 400px; background: #050505; white-space: pre-wrap; word-wrap: break-word;}
        .refresh-btn { display: block; width: 200px; margin: 20px auto; padding: 10px; background: red; color: white; text-align: center; text-decoration: none; font-weight: bold; border-radius: 5px; }
        .refresh-btn:hover { background: darkred; }
    </style>
</head>
<body>
    <h1>[+] HACKER C2 SERVER: STOLEN DATA LOGS [+]</h1>
    
    <div class="log-box">
<%
    String fileName = application.getRealPath("/") + "stolen_data.txt";
    try {
        BufferedReader br = new BufferedReader(new FileReader(fileName));
        String line;
        boolean hasData = false;
        while ((line = br.readLine()) != null) {
            out.println(line);
            hasData = true;
        }
        br.close();
        
        if (!hasData) {
            out.println("Waiting for victims... No data stolen yet.");
        }
    } catch (FileNotFoundException e) {
        out.println("Waiting for victims... No data stolen yet.");
    } catch (IOException e) {
        out.println("Error reading log.");
    }
%>
    </div>
    
    <a href="view_stolen.jsp" class="refresh-btn">REFRESH LOGS</a>
</body>
</html>
