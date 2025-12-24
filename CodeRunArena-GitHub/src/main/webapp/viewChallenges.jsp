<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session == null || session.getAttribute("userName") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Challenges | CodeRunArena</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(to right, #e0eafc, #cfdef3);
        }

        .topbar {
            background: linear-gradient(90deg, #1f1c2c, #928dab);
            padding: 18px;
            color: white;
            font-size: 24px;
            text-align: center;
            font-weight: 600;
        }

        .container {
            max-width: 1000px;
            margin: 30px auto;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        h2 {
            text-align: center;
            font-size: 30px;
            margin-bottom: 30px;
            color: #333;
        }

        .search-filter-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 25px;
        }

        .search-filter-row input,
        .search-filter-row select {
            padding: 10px 14px;
            border-radius: 10px;
            border: 1px solid #ccc;
            font-size: 15px;
            width: 50%;
        }

        .challenge {
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            background: #f9fbfd;
            box-shadow: 0 6px 12px rgba(0,0,0,0.05);
        }

        .challenge h3 {
            margin: 0;
            color: #222;
        }

        .challenge .difficulty {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
            margin-top: 5px;
        }

        .easy { background: #e1f5e1; color: #2e7d32; }
        .medium { background: #fff4e1; color: #ef6c00; }
        .hard { background: #fdecea; color: #c62828; }

        .desc {
            margin-top: 15px;
            font-size: 15px;
            color: #555;
        }

        .btn {
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
            text-decoration: none;
            font-size: 14px;
            display: inline-block;
            margin-top: 10px;
        }

        .btn:hover {
            background-color: #0056b3;
        }
        .btn-dashboard {
    background-color: #1f4068;
    color: #fff;
    padding: 8px 16px;
    text-decoration: none;
    border-radius: 6px;
    font-weight: bold;
    transition: 0.3s ease;
}
.btn-dashboard:hover {
    background-color: #324e7b;
    transform: scale(1.05);
}
        
    </style>
    <script>
        function filterChallenges() {
            const searchVal = document.getElementById("search").value.toLowerCase();
            const diffVal = document.getElementById("difficulty").value.toLowerCase();
            const challenges = document.querySelectorAll(".challenge");

            challenges.forEach(c => {
                const title = c.querySelector("h3").innerText.toLowerCase();
                const diff = c.querySelector(".difficulty").innerText.toLowerCase();

                const matchesSearch = title.includes(searchVal);
                const matchesDiff = diffVal === "all" || diff === diffVal;

                c.style.display = (matchesSearch && matchesDiff) ? "block" : "none";
            });
        }
    </script>
</head>
<body>
<div class="topbar">🚀 CodeRunArena — Coding Challenges</div>
<div class="container">
    <h2>Available Challenges</h2>
    
    <div class>
    <div style="text-align: right; margin-bottom: 10px;">
        <a href="userHome.jsp" class="btn-dashboard">🏠 Back to Dashboard</a>
    </div>   
</div>
<div>
<h1></h1>
</div>
    <div class="search-filter-row">
        <input type="text" id="search" placeholder="Search challenges..." onkeyup="filterChallenges()">
        <select id="difficulty" onchange="filterChallenges()">
            <option value="all">All Difficulties</option>
            <option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
        </select>
    </div>

    <div id="challengeList">
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");
            ps = conn.prepareStatement("SELECT id, title, difficulty, description FROM challenges");
            rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String difficulty = rs.getString("difficulty").toLowerCase();
                String description = rs.getString("description");
    %>
    <div class="challenge">
        <h3><%= title %></h3>
        <span class="difficulty <%= difficulty %>"><%= difficulty.substring(0,1).toUpperCase() + difficulty.substring(1) %></span>
        <div class="desc"><%= description %></div>
        <a href="codeEditor.jsp?challengeId=<%= id %>" class="btn">Attempt Challenge</a>
    </div>
    <%
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    %>
    </div>
    
</div>


</body>
</html>
