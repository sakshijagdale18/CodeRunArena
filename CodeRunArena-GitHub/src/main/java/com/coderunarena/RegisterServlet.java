package com.coderunarena;
import java.io.*;

import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/coderunarena", "root", "system");

            // Check if email already exists
            PreparedStatement check = con.prepareStatement("SELECT * FROM users WHERE email=?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                out.println("<script>alert('Email already registered!');location='register.jsp';</script>");
            } else {
                PreparedStatement ps = con.prepareStatement("INSERT INTO users(name, email, password) VALUES (?, ?, ?)");
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password); // Note: Use hashing in real projects!

                int i = ps.executeUpdate();
                if (i > 0) {
                    response.sendRedirect("login.jsp");
                } else {
                    out.println("<script>alert('Registration Failed');location='register.jsp';</script>");
                }
            }

            con.close();
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
