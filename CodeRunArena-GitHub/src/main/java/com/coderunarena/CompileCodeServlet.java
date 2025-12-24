package com.coderunarena;

import java.io.*;
import java.sql.*;
import javax.tools.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.*;

@WebServlet("/CompileCodeServlet")
public class CompileCodeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long startTime = System.currentTimeMillis();
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userName = session.getAttribute("userName").toString();
        String code = request.getParameter("code");
        String className = "UserSolution";
        String challengeIdStr = request.getParameter("challengeId");

        out.println("<!DOCTYPE html>");
        out.println("<html lang='en'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Execution Result - CodeRunArena</title>");
        out.println("<link href='https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&display=swap' rel='stylesheet'>");
        out.println("<script src='https://cdn.jsdelivr.net/npm/chart.js'></script>");
        out.println("<style>");
        out.println("body { background-color: #0f172a; color: #f1f5f9; font-family: 'Outfit', sans-serif; padding: 20px; }");
        out.println(".container { max-width: 800px; margin: auto; background-color: #1e293b; padding: 30px; border-radius: 10px; box-shadow: 0 0 15px rgba(0,0,0,0.3); }");
        out.println("h2 { text-align: center; margin-bottom: 20px; color: #38bdf8; }");
        out.println(".test-case { border-bottom: 1px solid #475569; padding: 15px 0; }");
        out.println(".test-case pre { background: #334155; padding: 10px; border-radius: 5px; color: #e2e8f0; }");
        out.println(".pass { color: #22c55e; font-weight: bold; }");
        out.println(".fail { color: #ef4444; font-weight: bold; }");
        out.println(".summary { margin-top: 30px; text-align: center; }");
        out.println("canvas { display: block; margin: 0 auto; max-width: 250px; }");
        out.println(".btn { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #38bdf8; color: #0f172a; font-weight: bold; border-radius: 5px; text-decoration: none; }");
        out.println("</style>");
        out.println("</head><body>");
        out.println("<div class='container'>");
        out.println("<h2>Compilation & Execution Result</h2>");

        if (code == null || code.trim().isEmpty()) {
            out.println("<p style='color:red;'>Code is empty!</p></body></html>");
            return;
        }

        int challengeId = 0;
        try {
            challengeId = Integer.parseInt(challengeIdStr);
        } catch (NumberFormatException e) {
            out.println("<p style='color:red;'>Invalid Challenge ID!</p></body></html>");
            return;
        }

        File sourceFile = new File(System.getProperty("java.io.tmpdir"), className + ".java");
        try (FileWriter writer = new FileWriter(sourceFile)) {
            writer.write(code);
        }

        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        if (compiler == null) {
            out.println("<p style='color:red;'>Compiler not available. Ensure JDK is used.</p></body></html>");
            return;
        }

        StringWriter compilerOutput = new StringWriter();
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(null, null, null);
        Iterable<? extends JavaFileObject> compilationUnits = fileManager.getJavaFileObjectsFromFiles(Arrays.asList(sourceFile));
        JavaCompiler.CompilationTask task = compiler.getTask(compilerOutput, fileManager, null, null, null, compilationUnits);
        boolean compiled = task.call();
        fileManager.close();

        if (!compiled) {
            out.println("<p style='color:red;'>Compilation Failed:</p><pre>" + compilerOutput.toString() + "</pre>");
            out.println("</body></html>");
            return;
        }

        int totalTests = 0, passedTests = 0, score = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

            // Get user ID
            PreparedStatement psUser = conn.prepareStatement("SELECT id FROM users WHERE name = ?");
            psUser.setString(1, userName);
            ResultSet rsUser = psUser.executeQuery();
            int userId = 0;
            if (rsUser.next()) userId = rsUser.getInt("id");

            // Run test cases
            PreparedStatement ps = conn.prepareStatement("SELECT test_input, expected_output FROM test_cases WHERE challenge_id = ?");
            ps.setInt(1, challengeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                totalTests++;
                String input = rs.getString("test_input").trim();
                String expected = rs.getString("expected_output").trim();

                ProcessBuilder pb = new ProcessBuilder("java", "-cp", sourceFile.getParent(), className);
                pb.redirectErrorStream(true);
                Process process = pb.start();

                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()));
                writer.write(input);
                writer.newLine();
                writer.flush();
                writer.close();

                BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                StringBuilder outputBuilder = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    outputBuilder.append(line.trim());
                }

                String actual = outputBuilder.toString().trim();

                out.println("<div class='test-case'>");
                out.println("<strong>Test Case " + totalTests + ":</strong><br>");
                out.println("Input:<pre>" + input + "</pre>");
                out.println("Expected:<pre>" + expected + "</pre>");
                out.println("Output:<pre>" + actual + "</pre>");

                if (actual.equals(expected)) {
                    passedTests++;
                    out.println("<p class='pass'>✅ Passed</p>");
                } else {
                    out.println("<p class='fail'>❌ Failed</p>");
                }
                out.println("</div>");
            }

            score = (passedTests * 100) / (totalTests == 0 ? 1 : totalTests);

            // Save submission
            PreparedStatement psSub = conn.prepareStatement(
                "INSERT INTO submissions (challenge_id, user_id, submitted_code, status, score, submission_date) VALUES (?, ?, ?, ?, ?, NOW())"
            );
            psSub.setInt(1, challengeId);
            psSub.setInt(2, userId);
            psSub.setString(3, code);
            psSub.setString(4, score == 100 ? "Success" : "Fail");
            psSub.setInt(5, score);
            psSub.executeUpdate();

            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Execution error: " + e.getMessage() + "</p>");
        }

        long endTime = System.currentTimeMillis();
        double durationSeconds = (endTime - startTime) / 1000.0;

        out.println("<div class='summary'>");
        out.println("<h3>Total Score: " + score + " / 100</h3>");
        out.println(String.format("<p><strong>Time Taken:</strong> %.2f seconds</p>", durationSeconds));
        out.println("<canvas id='resultChart'></canvas>");
        out.println("<a href='userHome.jsp' class='btn'>← Back to Dashboard</a>");
        out.println("</div>");
        out.println("</div>"); // container close

        // JS for Chart
        out.println("<script>");
        out.println("const ctx = document.getElementById('resultChart').getContext('2d');");
        out.println("new Chart(ctx, { type: 'pie', data: {");
        out.println("labels: ['Passed', 'Failed'],");
        out.println("datasets: [{ data: [" + passedTests + ", " + (totalTests - passedTests) + "],");
        out.println("backgroundColor: ['#22c55e', '#ef4444'], borderWidth: 1 }] },");
        out.println("options: { responsive: false, plugins: { legend: { position: 'bottom', labels: { color: '#f1f5f9' } } } } });");
        out.println("</script>");

        out.println("</body></html>");

        sourceFile.delete();
    }
}
