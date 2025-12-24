package com.coderunarena;
import java.io.*;

import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

            PreparedStatement ps = conn.prepareStatement("UPDATE users SET name=?, email=?, password=? WHERE id=?");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setInt(4, userId);
            ps.executeUpdate();

            session.setAttribute("userName", name); // Update session name
            response.sendRedirect("userProfile.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("editProfile.jsp?error=true");
        }
    }
}
