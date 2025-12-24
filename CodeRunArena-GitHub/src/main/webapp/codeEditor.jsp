<%@ page import="java.sql.*, java.io.*, javax.servlet.*, javax.servlet.http.*" %>
<%

if (session == null || session.getAttribute("userName") == null) {
    response.sendRedirect("login.jsp");
    return;
}


    String challengeIdStr = request.getParameter("challengeId");
    int challengeId = 0;
    if (challengeIdStr != null && !challengeIdStr.isEmpty()) {
        try {
            challengeId = Integer.parseInt(challengeIdStr);
        } catch (NumberFormatException e) {
            out.println("<p style='color:red;'>Invalid Challenge ID</p>"); return;
        }
    } else {
        out.println("<p style='color:red;'>Challenge ID missing!</p>"); return;
    }

    String title = "", description = "", input = "", output = "", difficulty = "";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM challenges WHERE id = ?");
        ps.setInt(1, challengeId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            description = rs.getString("description");
            input = rs.getString("input");
            output = rs.getString("expected_output");
            difficulty = rs.getString("difficulty");
        } else {
            out.println("<p style='color:red;'>Challenge not found</p>"); return;
        }
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>DB Error: " + e.getMessage() + "</p>"); return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>CodeRunArena - Code Challenge</title>
    <style>
        body { font-family: Arial; background: #f1f3f6; margin: 0; padding: 0; }
        .wrapper { display: flex; height: 100vh; }
        .left, .right { padding: 20px; overflow-y: auto; }
        .left { width: 50%; background: #fff; }
        .right { width: 50%; background: #f9f9f9; }
        h2 { color: #333; }
        textarea { width: 100%; height: 300px; font-family: monospace; font-size: 16px; padding: 10px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; margin-right: 10px; cursor: pointer; }
        .output-box, .testcases, .timer, .score { margin-top: 20px; padding: 10px; background: #e9ecef; border-radius: 5px; }
    </style>
    <script>
        let startTime;
        function startTimer() {
            startTime = new Date().getTime();
        }
        function endTimer() {
            let endTime = new Date().getTime();
            let timeTaken = ((endTime - startTime) / 1000).toFixed(2);
            document.getElementById("timeTaken").innerText = timeTaken + " seconds";
        }
        window.onload = startTimer;
    </script>
</head>
<body>
<div class="wrapper">
    <div class="left">
        <h2><%= title %> (<%= difficulty %>)</h2>
        <p><b>Description:</b> <%= description %></p>
        <p><b>Input:</b> <%= input %></p>
        <p><b>Expected Output:</b> <%= output %></p>
        <div class="testcases">
            <h3>Sample Test Case</h3>
            <p><b>Input:</b> <%= input %></p>
            <p><b>Expected:</b> <%= output %></p>
        </div>
        <div class="timer">
            <h3>Time Taken:</h3>
            <p id="timeTaken">0 seconds</p>
        </div>
    </div>

    <div class="right">
        <form action="CompileCodeServlet" method="post" onsubmit="endTimer()">
            <textarea name="code" placeholder="Write your java code here..." required></textarea>
            <input type="hidden" name="challengeId" value="<%= challengeId %>">
            <button type="submit">Compile & Submit</button>
        </form>

        <% if (request.getAttribute("userOutput") != null) { %>
            <div class="output-box">
                <h3>Your Output:</h3>
                <pre><%= request.getAttribute("userOutput") %></pre>
            </div>
            <div class="output-box">
                <h3>Expected Output:</h3>
                <pre><%= output %></pre>
            </div>
            <div class="score">
                <h3>Score:</h3>
                <p><%= request.getAttribute("score") != null ? request.getAttribute("score") : 0 %></p>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
