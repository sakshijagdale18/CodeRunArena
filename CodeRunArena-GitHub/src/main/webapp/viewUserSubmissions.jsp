<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    String userId = request.getParameter("user_id");
    List<Map<String, String>> submissions = new ArrayList<>();

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coderunarena", "root", "system");

        String sql = "SELECT s.*, u.name AS user_name, c.title AS challenge_title, c.id AS challenge_id, c.difficulty " +
                     "FROM submissions s " +
                     "JOIN users u ON s.user_id = u.id " +
                     "JOIN challenges c ON s.challenge_id = c.id " +
                     "WHERE s.user_id = ?";
        pst = conn.prepareStatement(sql);
        pst.setString(1, userId);
        rs = pst.executeQuery();

        while (rs.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("id", rs.getString("id"));
            row.put("challenge_id", rs.getString("challenge_id"));
            row.put("challenge_title", rs.getString("challenge_title"));
            row.put("difficulty", rs.getString("difficulty"));
            row.put("status", rs.getString("status"));
            row.put("score", rs.getString("score"));
            row.put("submitted_code", rs.getString("submitted_code"));
            row.put("submission_date", rs.getString("submission_date"));
            row.put("user_name", rs.getString("user_name"));
            submissions.add(row);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Submissions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            margin-top: 50px;
        }
        .card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            background-color: #ffffff;
        }
        .card-header {
            background: linear-gradient(to right, #667eea, #764ba2);
            color: white;
            padding: 20px 30px;
            border-radius: 14px 14px 0 0;
        }
        .btn-back {
            background-color: #6c63ff;
            color: white;
        }
        .btn-back:hover {
            background-color: #574b90;
        }
        .modal-code {
            white-space: pre-wrap;
            font-family: monospace;
            background-color: #f7f7f7;
            padding: 15px;
            border-radius: 10px;
        }
        .badge-easy {
            background-color: #00c853;
        }
        .badge-medium {
            background-color: #ffab00;
        }
        .badge-hard {
            background-color: #d50000;
        }
        .badge-success {
            background-color: #4caf50;
        }
        .badge-fail {
            background-color: #f44336;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <div class="card-header">
            <h4>User: <%= (submissions.size() > 0) ? submissions.get(0).get("user_name") : "N/A" %> — Submissions</h4>
        </div>
        <div class="card-body p-4">
            <a href="manageSubmissions.jsp" class="btn btn-back mb-3">← Back to Submissions</a>
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Challenge ID</th>
                            <th>Challenge Title</th>
                            <th>Difficulty</th>
                            <th>Status</th>
                            <th>Score</th>
                            <th>Code</th>
                            <th>Submitted On</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (submissions.size() == 0) { %>
                        <tr><td colspan="8" class="text-center">No submissions found.</td></tr>
                    <% } else {
                        int modalCount = 0;
                        for (Map<String, String> sub : submissions) {
                            String modalId = "codeModal" + modalCount++;
                            String difficulty = sub.get("difficulty");
                            String badgeClass = difficulty.equals("Easy") ? "badge-easy" : 
                                                difficulty.equals("Medium") ? "badge-medium" : "badge-hard";

                            String statusBadge = sub.get("status").equalsIgnoreCase("Success") ? "badge-success" : "badge-fail";
                    %>
                        <tr>
                            <td><strong><%= sub.get("challenge_id") %></strong></td>
                            <td><%= sub.get("challenge_title") %></td>
                            <td><span class="badge <%= badgeClass %>"><%= difficulty %></span></td>
                            <td><span class="badge <%= statusBadge %>"><%= sub.get("status") %></span></td>
                            <td><%= sub.get("score") %></td>
                            <td>
                                <button class="btn btn-outline-info btn-sm" data-bs-toggle="modal" data-bs-target="#<%= modalId %>">
                                    View Code
                                </button>

                                <!-- Code Modal -->
                                <div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-labelledby="<%= modalId %>Label" aria-hidden="true">
                                  <div class="modal-dialog modal-lg modal-dialog-centered">
                                    <div class="modal-content">
                                      <div class="modal-header">
                                        <h5 class="modal-title" id="<%= modalId %>Label">Submitted Code</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                      </div>
                                      <div class="modal-body">
                                        <div class="modal-code"><%= sub.get("submitted_code") %></div>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                            </td>
                            <td><%= sub.get("submission_date") %></td>
                            <td>
                                <a href="deleteSubmission.jsp?id=<%= sub.get("id") %>&user_id=<%= userId %>"
                                   onclick="return confirm('Are you sure you want to delete this submission?')"
                                   class="btn btn-danger btn-sm">Delete</a>
                            </td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>
