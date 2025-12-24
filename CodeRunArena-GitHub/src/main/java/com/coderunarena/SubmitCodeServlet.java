package com.coderunarena;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;

@WebServlet("/SubmitCodeServlet")
public class SubmitCodeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("name") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userName = session.getAttribute("name").toString();
        String submittedCode = request.getParameter("submitted_code");
        String challengeIdStr = request.getParameter("challengeId");

        if (submittedCode == null || submittedCode.trim().isEmpty()) {
            request.setAttribute("error", "Submitted code is empty.");
            request.getRequestDispatcher("submitResult.jsp").forward(request, response);
            return;
        }

        try {
            int challengeId = Integer.parseInt(challengeIdStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

            PreparedStatement psUser = conn.prepareStatement("SELECT id FROM users WHERE name = ?");
            psUser.setString(1, userName);
            ResultSet rs = psUser.executeQuery();
            int userId = 0;
            if (rs.next()) userId = rs.getInt("id");

            String result = "Submitted";

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO submissions (challenge_id, user_id, submitted_code, result) VALUES (?, ?, ?, ?)"
            );
            ps.setInt(1, challengeId);
            ps.setInt(2, userId);
            ps.setString(3, submittedCode);
            ps.setString(4, result);
            ps.executeUpdate();

            request.setAttribute("message", "Code submitted successfully!");
        } catch (Exception e) {
            request.setAttribute("error", "Server error: " + e.getMessage());
        }

        request.getRequestDispatcher("submitResult.jsp").forward(request, response);
    }
}
