<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,javax.servlet.*,javax.servlet.http.*" %>
<%
    if (session == null || session.getAttribute("userName") == null) {
        response.sendRedirect("login.jsp");
    }
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html>
<head>
    <title>CodeRunArena | Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: #f4f6fb;
            font-family: 'Segoe UI', sans-serif;
        }
        .navbar {
            background: linear-gradient(90deg, #1f4068, #1b1b2f);
        }
        .navbar-brand, .nav-link, .user-name {
            color: #fff !important;
        }
        .hero-section {
            background: url('https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?auto=format&fit=crop&w=1350&q=80') no-repeat center center/cover;
            padding: 80px 20px;
            color: white;
            text-align: center;
            border-bottom: 5px solid #1f4068;
        }
        .hero-section h1 {
            font-size: 48px;
            font-weight: bold;
        }
        .hero-section p {
            font-size: 20px;
            margin-top: 15px;
        }
        .dashboard-container {
            padding: 50px 20px;
        }
        .dashboard-card {
            border-radius: 15px;
            padding: 30px;
            color: #fff;
            transition: transform 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        .challenges-card { background: linear-gradient(135deg, #11998e, #38ef7d); }
        .history-card { background: linear-gradient(135deg, #fc4a1a, #f7b733); }
        .profile-card { background: linear-gradient(135deg, #8360c3, #2ebf91); }
        .leaderboard-card { background: linear-gradient(135deg, #f12711, #f5af19); }
        .logout-btn {
            background-color: #e63946;
            color: white;
            border: none;
        }
        .logout-btn:hover {
            background-color: #b71c1c;
        }
        footer {
            text-align: center;
            padding: 20px;
            background-color: #1b1b2f;
            color: white;
            margin-top: 50px;
        }
        .image-box {
            margin-top: 40px;
            text-align: center;
        }
        .image-box img {
            max-width: 100%;
            height: auto;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg px-4">
    <a class="navbar-brand fw-bold" href="#">CodeRunArena</a>
    <div class="ms-auto d-flex align-items-center">
        <a class="nav-link me-3" href="contact.jsp"><i class="fas fa-envelope"></i> Contact Us</a>
        <button class="btn btn-outline-light me-3" data-bs-toggle="modal" data-bs-target="#howItWorksModal">How it Works?</button>
        <span class="user-name me-3">Welcome, <%= userName %>!</span>
        <a href="LogoutServlet" class="btn logout-btn">Logout</a>
    </div>
</nav>

<!-- Hero / Intro Section -->
<div class="hero-section">
    <h1>Welcome to CodeRunArena</h1>
    <p>Where coding meets competition — rise through the ranks and sharpen your skills.</p>
</div>

<!-- Dashboard Cards -->
<div class="container dashboard-container">
    <div class="text-center mb-5">
        <h2 class="fw-bold text-dark">Your Personalized Coding Arena</h2>
        <p class="text-muted">Select a section to begin your journey!</p>
    </div>
    <div class="row g-4">
        <div class="col-md-6 col-lg-3">
            <div class="dashboard-card challenges-card text-center">
                <i class="fas fa-code fa-3x mb-3"></i>
                <h4>Start Challenges</h4>
                <p>Explore and solve curated coding problems of all levels.</p>
                <a href="viewChallenges.jsp" class="btn btn-light mt-2">Go</a>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="dashboard-card history-card text-center">
                <i class="fas fa-history fa-3x mb-3"></i>
                <h4>Submission History</h4>
                <p>Review your code attempts, scores, and performance trends.</p>
                <a href="submissionHistory.jsp" class="btn btn-light mt-2">Go</a>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="dashboard-card profile-card text-center">
                <i class="fas fa-user-circle fa-3x mb-3"></i>
                <h4>Profile</h4>
                <p>Update your personal info and view your coding achievements.</p>
                <a href="userProfile.jsp" class="btn btn-light mt-2">Go</a>
            </div>
        </div>
        <div class="col-md-6 col-lg-3">
            <div class="dashboard-card leaderboard-card text-center">
                <i class="fas fa-trophy fa-3x mb-3"></i>
                <h4>Leaderboard</h4>
                <p>Compare your score with others and climb the ranks.</p>
                <a href="leaderboard.jsp" class="btn btn-light mt-2">Go</a>
            </div>
        </div>
    </div>

    <!-- Additional Image in Body -->
    <div class="image-box mt-5">
        <h3 class="text-dark mb-4">Get Ready to Code. Compete. Conquer.</h3>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>© 2025 CodeRunArena. Built with passion for coders. 🚀</p>
</footer>

<!-- How it Works Modal -->
<div class="modal fade" id="howItWorksModal" tabindex="-1" aria-labelledby="howItWorksLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-dark text-white">
        <h5 class="modal-title" id="howItWorksLabel">How CodeRunArena Works</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <ol class="list-group list-group-numbered">
          <li class="list-group-item">Login or sign up to your account.</li>
          <li class="list-group-item">Visit <strong>Start Challenges</strong> to view and attempt coding problems.</li>
          <li class="list-group-item">Write your code in the online editor and submit it.</li>
          <li class="list-group-item">Your code is compiled and tested against multiple test cases.</li>
          <li class="list-group-item">Scores are calculated and stored in your submission history.</li>
          <li class="list-group-item">View your progress and compare with others in the <strong>Leaderboard</strong>.</li>
          <li class="list-group-item">Edit your profile anytime from the <strong>Profile</strong> section.</li>
        </ol>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-bs-dismiss="modal">Got it!</button>
      </div>
    </div>
  </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
