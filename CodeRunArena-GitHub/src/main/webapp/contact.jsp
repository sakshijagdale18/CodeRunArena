<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String status = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");
            PreparedStatement ps = conn.prepareStatement("INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, message);
            ps.executeUpdate();
            conn.close();
            status = "success";
        } catch (Exception e) {
            status = "error";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us | CodeRunArena</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            margin: 0;
            padding: 0;
            color: #fff;
        }

        .container {
            background: #ffffff;
            color: #333;
            max-width: 700px;
            margin: 60px auto;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }

        h2 {
            text-align: center;
            color: #006d77;
            margin-bottom: 25px;
            font-size: 28px;
        }

        input, textarea {
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            margin-bottom: 20px;
            border-radius: 10px;
            border: 1px solid #ccc;
            font-size: 16px;
            transition: 0.3s ease;
        }

        input:focus, textarea:focus {
            border-color: #006d77;
            outline: none;
        }

        .btn-submit {
            background: linear-gradient(to right, #11998e, #38ef7d);
            border: none;
            padding: 12px 30px;
            color: white;
            font-size: 16px;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: block;
            margin: auto;
        }

        .btn-submit:hover {
            transform: scale(1.05);
            background: linear-gradient(to right, #38ef7d, #11998e);
        }

        .status {
            text-align: center;
            font-weight: bold;
            margin-top: 20px;
        }

        .success {
            color: green;
        }

        .error {
            color: red;
        }

        .back-btn {
            display: block;
            margin: 25px auto 0;
            padding: 10px 20px;
            background-color: #00b4d8;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            text-align: center;
            transition: 0.3s ease;
        }

        .back-btn:hover {
            background-color: #0077b6;
        }

        @media (max-width: 600px) {
            .container {
                margin: 20px;
                padding: 25px;
            }

            h2 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h2>📬 Contact the CodeRunArena Team</h2>
    <form method="post" action="contact.jsp">
        <label>Name</label>
        <input type="text" name="name" placeholder="Enter your name" required />

        <label>Email</label>
        <input type="email" name="email" placeholder="Enter your email" required />

        <label>Subject</label>
        <input type="text" name="subject" placeholder="Subject" required />

        <label>Message</label>
        <textarea name="message" placeholder="Write your message..." required></textarea>

        <button type="submit" class="btn-submit">Send Message</button>
    </form>

    <% if (status.equals("success")) { %>
        <div class="status success">✅ Thank you! Your message has been sent.</div>
    <% } else if (status.equals("error")) { %>
        <div class="status error">❌ Oops! Something went wrong. Please try again.</div>
    <% } %>

    <a href="userHome.jsp" class="back-btn">← Back to Dashboard</a>
</div>

</body>
</html>
