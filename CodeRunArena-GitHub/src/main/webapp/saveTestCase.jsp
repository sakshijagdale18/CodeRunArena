<%@ page import="java.sql.*" %>
<%
    String challengeId = request.getParameter("challenge_id");
    String testInput = request.getParameter("test_input");
    String expectedOutput = request.getParameter("expected_output");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

        PreparedStatement pst = conn.prepareStatement("INSERT INTO test_cases (challenge_id, test_input, expected_output) VALUES (?, ?, ?)");
        pst.setString(1, challengeId);
        pst.setString(2, testInput);
        pst.setString(3, expectedOutput);

        pst.executeUpdate();
        pst.close();
        conn.close();
        response.sendRedirect("manageTestCases.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Failed to add test case.'); window.history.back();</script>");
    }
%>
