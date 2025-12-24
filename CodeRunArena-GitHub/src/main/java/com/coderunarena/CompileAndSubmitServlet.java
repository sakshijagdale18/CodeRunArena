package com.coderunarena;

import java.io.*;
import java.sql.*;
import javax.tools.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.*;

@WebServlet("/CompileAndSubmitServlet")
public class CompileAndSubmitServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userName = session.getAttribute("userName").toString();
        String code = request.getParameter("code");
        String challengeIdStr = request.getParameter("challengeId");

        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("error", "Code cannot be empty.");
            request.getRequestDispatcher("submitResult.jsp").forward(request, response);
            return;
        }

        int challengeId;
        try {
            challengeId = Integer.parseInt(challengeIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid challenge ID.");
            request.getRequestDispatcher("submitResult.jsp").forward(request, response);
            return;
        }

        // Save code to temp file
        String className = "UserSolution";
        File sourceFile = new File(System.getProperty("java.io.tmpdir"), className + ".java");
        try (FileWriter writer = new FileWriter(sourceFile)) {
            writer.write(code);
        }

        boolean compileSuccess;
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        if (compiler == null) {
            request.setAttribute("error", "Compiler not found. Make sure to use JDK.");
            request.getRequestDispatcher("submitResult.jsp").forward(request, response);
            return;
        }

        StringWriter compilerOutput = new StringWriter();
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(null, null, null);
        Iterable<? extends JavaFileObject> compilationUnits = fileManager.getJavaFileObjectsFromFiles(Collections.singletonList(sourceFile));
        JavaCompiler.CompilationTask task = compiler.getTask(compilerOutput, fileManager, null, null, null, compilationUnits);
        compileSuccess = task.call();
        fileManager.close();

        int totalCases = 0, passedCases = 0;
        List<String> results = new ArrayList<>();

        if (compileSuccess) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

                // Get user ID
                PreparedStatement psUser = conn.prepareStatement("SELECT id FROM users WHERE name = ?");
                psUser.setString(1, userName);
                ResultSet rs = psUser.executeQuery();
                int userId = 0;
                if (rs.next()) userId = rs.getInt("id");

                // Get test cases
                PreparedStatement psCases = conn.prepareStatement("SELECT input, expected_output FROM test_cases WHERE challenge_id = ?");
                psCases.setInt(1, challengeId);
                ResultSet testSet = psCases.executeQuery();

                while (testSet.next()) {
                    totalCases++;
                    String input = testSet.getString("input");
                    String expectedOutput = testSet.getString("expected_output").trim();

                    ProcessBuilder pb = new ProcessBuilder("java", "-cp", sourceFile.getParent(), className);
                    pb.redirectErrorStream(true);
                    Process process = pb.start();

                    BufferedWriter processInput = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()));
                    processInput.write(input);
                    processInput.newLine();
                    processInput.flush();
                    processInput.close();

                    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                    StringBuilder actualOutput = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        actualOutput.append(line).append("\n");
                    }

                    String userOutput = actualOutput.toString().trim();
                    if (userOutput.equals(expectedOutput)) {
                        passedCases++;
                        results.add("✅ Passed — Input: " + input);
                    } else {
                        results.add("❌ Failed — Input: " + input + " | Expected: " + expectedOutput + " | Got: " + userOutput);
                    }
                }

                int score = totalCases == 0 ? 0 : (passedCases * 100 / totalCases);

                // Save submission
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO submissions (challenge_id, user_id, submitted_code, status, score, submission_date) VALUES (?, ?, ?, ?, ?, NOW())"
                );
                ps.setInt(1, challengeId);
                ps.setInt(2, userId);
                ps.setString(3, code);
                ps.setString(4, compileSuccess ? "Success" : "Fail");
                ps.setInt(5, score);
                ps.executeUpdate();

                conn.close();

                request.setAttribute("message", "Compiled and executed successfully!");
                request.setAttribute("results", results);
                request.setAttribute("score", score);

            } catch (Exception e) {
                request.setAttribute("error", "Server Error: " + e.getMessage());
            }

        } else {
            String errorMsg = "Compilation failed:\n" + compilerOutput.toString();
            request.setAttribute("error", errorMsg);
        }

        request.getRequestDispatcher("submitResult.jsp").forward(request, response);
        sourceFile.delete();
    }
}
