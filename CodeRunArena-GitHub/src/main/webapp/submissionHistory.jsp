<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    if (session.getAttribute("userName") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = session.getAttribute("userName").toString();
    int userId = 0;

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

    PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM users WHERE name = ?");
    userStmt.setString(1, userName);
    ResultSet userRs = userStmt.executeQuery();
    if (userRs.next()) {
        userId = userRs.getInt("id");
    }

    PreparedStatement ps = conn.prepareStatement(
        "SELECT s.id, c.title, s.score, s.status, s.submission_date, s.submitted_code " +
        "FROM submissions s JOIN challenges c ON s.challenge_id = c.id " +
        "WHERE s.user_id = ? ORDER BY s.submission_date DESC"
    );
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Submissions | CodeRunArena</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(to right, #f0f4f8, #d9e2ec);
        }

        header {
            background: linear-gradient(to right, #142850, #27496d);
            padding: 20px;
            color: white;
            text-align: center;
        }

        header h2 {
            margin: 0;
            font-size: 24px;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background-color: #0077b6;
            color: white;
            padding: 14px;
            text-align: center;
        }

        td {
            text-align: center;
            padding: 14px;
            border-bottom: 1px solid #eee;
            vertical-align: top;
        }

        .success {
            background: #e0f8e9;
            color: #2e7d32;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 16px;
        }

        .fail {
            background: #fce4e4;
            color: #c62828;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 16px;
        }

        .code-toggle {
            background-color: #f1f1f1;
            border: none;
            color: #0077b6;
            cursor: pointer;
            font-size: 14px;
            text-decoration: underline;
        }

        .code-box {
            display: none;
            background: #f8f8f8;
            font-family: monospace;
            padding: 15px;
            border-radius: 10px;
            margin: 10px 20px;
            text-align: left;
            white-space: pre-wrap;
            word-wrap: break-word;
            border: 1px solid #ccc;
        }

        .back-btn {
            display: inline-block;
            margin: 25px auto;
            background-color: #0077b6;
            color: white;
            padding: 12px 22px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: background 0.3s;
            text-align: center;
        }

        .back-btn:hover {
            background-color: #023e8a;
        }

        @media (max-width: 600px) {
            td, th {
                font-size: 14px;
                padding: 10px;
            }
            .code-box {
                margin: 10px;
            }
        }
    </style>
    <script>
        function toggleCode(id) {
            var el = document.getElementById("codeBox_" + id);
            if (el.style.display === "none") {
                el.style.display = "block";
            } else {
                el.style.display = "none";
            }
        }
    </script>
</head>
<body>

<header>
    <h2>👨‍💻 Welcome <%= userName %> — Your Submission History</h2>
</header>

<div class="container">
    <table>
        <thead>
            <tr>
                <th>id</th>
                <th>Challenge</th>
                <th>Status</th>
                <th>Score</th>
                <th>Date</th>
                <th>Code</th>
            </tr>
        </thead>
        <tbody>
            <%
                int count = 1;
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String title = rs.getString("title");
                    String status = rs.getString("status");
                    int score = rs.getInt("score");
                    Timestamp date = rs.getTimestamp("submission_date");
                    String code = rs.getString("submitted_code");
            %>
            <tr>
                <td><%= count++ %></td>
                <td><%= title %></td>
                <td><span class="<%= status.equalsIgnoreCase("Success") ? "success" : "fail" %>"><%= status %></span></td>
                <td><%= score %></td>
                <td><%= date %></td>
                <td>
                    <button class="code-toggle" onclick="toggleCode(<%= id %>)">View Code</button>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div id="codeBox_<%= id %>" class="code-box">
                        <%= code.replaceAll("<", "&lt;").replaceAll(">", "&gt;") %>
                    </div>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

<div style="text-align:center;">
    <a href="userHome.jsp" class="back-btn">← Back to Dashboard</a>
</div>

</body>
</html>

<%
    rs.close();
    ps.close();
    conn.close();
%>
