<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Leaderboard | CodeRunArena</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #fff;
            min-height: 100vh;
            padding-top: 50px;
        }

        .leaderboard-container {
            background-color: rgba(255,255,255,0.05);
            border-radius: 16px;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
            width: 95%;
            max-width: 1000px;
            margin: auto;
            padding: 30px 40px;
        }

        h2 {
            text-align: center;
            font-weight: 700;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 15px;
            text-align: center;
            font-size: 15px;
        }

        th {
            background-color: #00bcd4;
            color: #fff;
            text-transform: uppercase;
        }

        tr:nth-child(even) {
            background-color: rgba(255,255,255,0.05);
        }

        tr:hover {
            background-color: rgba(255,255,255,0.15);
            transition: 0.3s;
        }

        .badge {
            font-weight: bold;
            font-size: 18px;
        }

        .first::before {
            content: "\1F947 ";
        }
        .second::before {
            content: "\1F948 ";
        }
        .third::before {
            content: "\1F949 ";
        }

        .filters {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            margin-bottom: 20px;
            gap: 10px;
        }

        .filters input[type="text"] {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 6px;
            outline: none;
        }

        .filters select {
            padding: 10px;
            border: none;
            border-radius: 6px;
            outline: none;
        }

        .back-btn {
            text-align: center;
            margin-top: 30px;
        }

        .back-btn a {
            background-color: #00bcd4;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: bold;
            transition: 0.3s;
        }

        .back-btn a:hover {
            background-color: #0097a7;
        }

        .scroll-box {
            max-height: 450px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
<div class="leaderboard-container">
    <h2><i class="fas fa-trophy"></i> Global Leaderboard - CodeRunArena</h2>

    <div class="filters">
        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Search by username...">
        <select id="scoreFilter" onchange="filterTable()">
            <option value="">All Scores</option>
            <option value="200">200 & above</option>
            <option value="300">300 & above</option>
            <option value="500">500 & above</option>
        </select>
    </div>

    <div class="scroll-box">
    <table id="leaderboard">
        <thead>
        <tr>
            <th>Rank</th>
            <th>User</th>
            <th>Total Score</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

                String query = "SELECT u.name, SUM(s.score) AS total_score " +
                               "FROM users u JOIN submissions s ON u.id = s.user_id " +
                               "GROUP BY u.id " +
                               "ORDER BY total_score DESC";

                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();

                int rank = 1;
                while (rs.next()) {
                    String name = rs.getString("name");
                    int score = rs.getInt("total_score");
                    String rankClass = rank == 1 ? "first" : rank == 2 ? "second" : rank == 3 ? "third" : "";
        %>
        <tr>
            <td class="badge <%= rankClass %>"><%= rank %></td>
            <td><%= name %></td>
            <td><%= score %></td>
        </tr>
        <%
                    rank++;
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='3' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
        </tbody>
    </table>
    </div>

    <div class="back-btn">
        <a href="userHome.jsp">← Back to Dashboard</a>
    </div>
</div>

<script>
    function filterTable() {
        const input = document.getElementById("searchInput").value.toLowerCase();
        const scoreFilter = parseInt(document.getElementById("scoreFilter").value);
        const table = document.getElementById("leaderboard");
        const rows = table.getElementsByTagName("tr");

        for (let i = 1; i < rows.length; i++) {
            const name = rows[i].cells[1].textContent.toLowerCase();
            const score = parseInt(rows[i].cells[2].textContent);
            const matchName = name.includes(input);
            const matchScore = isNaN(scoreFilter) || score >= scoreFilter;
            rows[i].style.display = (matchName && matchScore) ? "" : "none";
        }
    }
</script>
</body>
</html>
