package com.coderunarena;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AttemptChallengeServlet")
public class AttemptChallengeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userName") == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp?error=sessionExpired");
            return;
        }

        String userName = session.getAttribute("userName").toString();
        int userId = (int) session.getAttribute("userId");

        int challengeId = Integer.parseInt(request.getParameter("challengeId"));
        String submittedCode = request.getParameter("code");
        String customInput = request.getParameter("input");

        // Dummy evaluation logic for now (should be replaced with real compiler logic)
        String status = submittedCode != null && submittedCode.contains("public") ? "Passed" : "Failed";
        int score = status.equals("Passed") ? 10 : 0;

        try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/coderunarena", "root", "system");
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO submissions (user_id, challenge_id, submitted_code, status, score, submission_date) " +
                     "VALUES (?, ?, ?, ?, ?, NOW())")) {

            Class.forName("com.mysql.cj.jdbc.Driver");

            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            ps.setString(3, submittedCode);
            ps.setString(4, status);
            ps.setInt(5, score);

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect("submissionHistory.jsp?success=true&status=" + status + "&score=" + score);
            } else {
                response.sendRedirect("codeEditor.jsp?challengeId=" + challengeId + "&error=saveFailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("codeEditor.jsp?challengeId=" + challengeId + "&error=dbException");
        }
    }
}
