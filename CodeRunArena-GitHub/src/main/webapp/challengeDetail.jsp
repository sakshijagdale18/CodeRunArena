<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    if (session == null || session.getAttribute("userName") == null) {
        response.sendRedirect("login.jsp");
    }

    int challengeId = Integer.parseInt(request.getParameter("challengeId"));
    String title = "", description = "", input = "", output = "", difficulty = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "");
        ps = conn.prepareStatement("SELECT * FROM challenges WHERE id = ?");
        ps.setInt(1, challengeId);
        rs = ps.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            description = rs.getString("description");
            input = rs.getString("input");
            output = rs.getString("expected_output");
            difficulty = rs.getString("difficulty");
        }
    } catch (Exception e) {
        out.println("<p class='text-danger'>Error loading challenge: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Challenge Detail - <%= title %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            margin-top: 50px;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .difficulty-badge {
            font-size: 14px;
            padding: 5px 10px;
            border-radius: 10px;
            color: white;
        }
        .easy { background-color: #28a745; }
        .medium { background-color: #ffc107; }
        .hard { background-color: #dc3545; }
    </style>
</head>
<body>

<div class="container">
    <div class="card p-5">
        <h2 class="mb-3"><%= title %></h2>
        <span class="difficulty-badge <%= difficulty.toLowerCase() %>"><%= difficulty %></span>
        <hr>

        <h5 class="mt-4">📝 Description:</h5>
        <p><%= description.replaceAll("\n", "<br>") %></p>

        <h5 class="mt-4">📥 Input Format:</h5>
        <p><%= input.replaceAll("\n", "<br>") %></p>

        <h5 class="mt-4">📤 Expected Output:</h5>
        <p><%= output.replaceAll("\n", "<br>") %></p>

        <div class="text-end mt-5">
            <a href="codeEditor.jsp?challengeId=<%= challengeId %>" class="btn btn-primary btn-lg">Start Solving</a>
        </div>
    </div>
</div>

</body>
</html>
