<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");
    } catch(Exception e) {
        out.println("Database connection error: " + e);
    }
%>
