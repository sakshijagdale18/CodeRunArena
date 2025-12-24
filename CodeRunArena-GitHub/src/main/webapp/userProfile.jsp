<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    if (session == null || session.getAttribute("userName") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = session.getAttribute("userName").toString();
    int userId = (int) session.getAttribute("userId");

    int totalScore = 0;
    int totalSubmissions = 0;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

        ps = conn.prepareStatement("SELECT COUNT(*) AS submissions, SUM(score) AS score FROM submissions WHERE user_id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            totalSubmissions = rs.getInt("submissions");
            totalScore = rs.getInt("score");
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Profile | CodeRunArena</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: url('images/bakground.jpg') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
        }

        .profile-container {
            background: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            width: 380px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);
            text-align: center;
        }

        .profile-container img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #ffffff;
            margin-bottom: 20px;
        }

        h2 {
            margin: 10px 0 5px;
            font-size: 26px;
            font-weight: 600;
            color: #ffffff;
        }

        .description {
            font-size: 14px;
            color: #cccccc;
            margin-bottom: 30px;
        }

        .stats {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 30px;
        }

        .stats div {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 12px;
            flex: 1;
        }

        .stats h3 {
            font-size: 22px;
            margin-bottom: 5px;
            color: #fff;
        }

        .stats span {
            font-size: 13px;
            color: #ccc;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .button-group a {
            padding: 10px 20px;
            text-decoration: none;
            color: #fff;
            border: 2px solid #fff;
            border-radius: 10px;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .button-group a:hover {
            background-color: #ffffff;
            color: #111;
        }

        @media (max-width: 480px) {
            .profile-container {
                width: 90%;
                padding: 30px;
            }

            .button-group {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>

<div class="profile-container">
    <img src="https://avatars.githubusercontent.com/u/9919?s=280&v=4" alt="User Profile">
    <h2><%= userName %></h2>
    <p class="description">Enthusiastic coder and explorer at CodeRunArena</p>

    <div class="stats">
        <div>
            <h3><%= totalSubmissions %></h3>
            <span>Submissions</span>
        </div>
        <div>
            <h3><%= totalScore %></h3>
            <span>Total Score</span>
        </div>
    </div>

    <div class="button-group">
        <a href="userHome.jsp">🏠 Dashboard</a>
        <a href="editProfile.jsp">✏️ Edit Profile</a>
    </div>
</div>

</body>
</html>
