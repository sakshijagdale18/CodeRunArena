<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>CodeRunArena | Home</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
  <style>
    body {
      background: #0c0f1d;
      color: white;
      font-family: 'Segoe UI', sans-serif;
    }

    /* NAVBAR */
    .navbar {
      background: transparent;
      padding-top: 1rem;
    }
    .nav-link, .navbar-brand {
      color: #ffffff;
      font-weight: 500;
      margin: 0 10px;
    }
    .nav-link:hover, .navbar-brand:hover {
      color: #00bcd4;
    }
    .btn-signup {
      background: linear-gradient(90deg, #007cf0, #00dfd8);
      color: white;
      font-weight: bold;
      border: none;
    }

    /* HERO */
    .hero {
  background: url('images/backgroundimage.avif') center/cover no-repeat;
  padding: 80px 20px 40px;
  text-align: center;
}
    
    .hero h1 {
      font-size: 48px;
      font-weight: bold;
    }
    .hero p {
      font-size: 18px;
      color: #ccc;
      margin: 20px 0 30px;
    }
    .hero .btn {
      margin: 0 10px;
      font-size: 16px;
      padding: 10px 20px;
    }

    /* FEATURES */
    .features-section {
      padding: 60px 20px;
      background-color: #0f172a;
    }
    .features-section h2 {
      text-align: center;
      margin-bottom: 40px;
    }
    .feature-card {
      background: linear-gradient(135deg, #1e3a8a, #3b82f6);
      padding: 30px;
      border-radius: 20px;
      text-align: center;
      color: #fff;
      transition: transform 0.3s;
    }
    .feature-card:hover {
      transform: translateY(-5px);
    }

    /* FOOTER */
    footer {
      padding: 30px 20px;
      background-color: #0a0a0a;
      color: #aaa;
      text-align: center;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero h1 { font-size: 36px; }
      .feature-card { margin-bottom: 20px; }
    }
  </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">CodeRunArena</a>
    <div class="ms-auto">
      <a class="nav-link d-inline" href="#">Home</a>
      <a class="nav-link d-inline" href="#features">Features</a>
      <a class="nav-link d-inline" href="#about">About Us</a>
      <a class="nav-link d-inline" href="#faqs">FAQs</a>
      <a class="nav-link d-inline" href="login.jsp">Login</a>
      <a class="btn btn-signup d-inline ms-2" href="register.jsp">Sign Up</a>
      <a class="nav-link d-inline ms-2" href="adminDashboard.jsp" title="Admin Dashboard">
        <i class="fas fa-user-shield"></i>
      </a>
    </div>
  </div>
</nav>


<!-- HERO SECTION -->
<section class="hero">
  <div class="container">
    <h1>Welcome to <span style="color:#00dfd8;">CodeRunArena</span></h1>
    <p>Sharpen your skills. Conquer challenges. Join the competition.</p>
    <a href="login.jsp" class="btn btn-primary">Login</a>
    <a href="register.jsp" class="btn btn-outline-info">Sign Up</a>
    <button class="btn btn-outline-light" data-bs-toggle="modal" data-bs-target="#howModal">How It Works</button>
  </div>
</section>


<!-- FEATURES SECTION -->
<section id="features" class="features-section">
  <div class="container">
    <h2 class="fw-bold mb-4">Why Choose Us</h2>
    <div class="row g-4">

      <!-- Start Challenges Card -->
      <div class="col-md-4">
        <div class="feature-card">
          <i class="fas fa-code fa-2x mb-3"></i>
          <h4>Start Challenges</h4>
          <p>Browse challenges with tiered difficulty levels</p>
          <button class="btn btn-light mt-2" onclick="showLoginMessage('loginMsg1')">Explore</button>
          <div id="loginMsg1" class="alert alert-warning mt-3 py-2 px-3 d-none" role="alert" style="font-size: 0.9rem;">
            <i class="fas fa-lock me-2"></i> Please login to access this feature.
          </div>
        </div>
      </div>

      <!-- Leaderboard Card -->
      <div class="col-md-4">
        <div class="feature-card" style="background: linear-gradient(135deg, #ef4444, #f59e0b);">
          <i class="fas fa-trophy fa-2x mb-3"></i>
          <h4>Leaderboard</h4>
          <p>See top performers, earn rankings</p>
          <button class="btn btn-light mt-2" onclick="showLoginMessage('loginMsg2')">View Rankings</button>
          <div id="loginMsg2" class="alert alert-warning mt-3 py-2 px-3 d-none" role="alert" style="font-size: 0.9rem;">
            <i class="fas fa-lock me-2"></i> Please login to access this feature.
          </div>
        </div>
      </div>

      <!-- Profile & Achievements Card -->
      <div class="col-md-4">
        <div class="feature-card" style="background: linear-gradient(135deg, #9333ea, #3b82f6);">
          <i class="fas fa-user fa-2x mb-3"></i>
          <h4>Profile & Achievements</h4>
          <p>Track your coding growth & customize your space</p>
          <button class="btn btn-light mt-2" onclick="showLoginMessage('loginMsg3')">Get Started</button>
          <div id="loginMsg3" class="alert alert-warning mt-3 py-2 px-3 d-none" role="alert" style="font-size: 0.9rem;">
            <i class="fas fa-lock me-2"></i> Please login to access this feature.
          </div>
        </div>
      </div>

    </div>
  </div>
</section>


<!-- HOW IT WORKS MODAL -->
<div class="modal fade" id="howModal" tabindex="-1" aria-labelledby="howModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content bg-dark text-white">
      <div class="modal-header border-bottom-0">
        <h5 class="modal-title" id="howModalLabel">How CodeRunArena Works</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <ol class="list-group list-group-numbered">
          <li class="list-group-item bg-dark text-white">Login or sign up to your account.</li>
          <li class="list-group-item bg-dark text-white">Visit <strong>Start Challenges</strong> to view problems.</li>
          <li class="list-group-item bg-dark text-white">Write code in the online editor and submit.</li>
          <li class="list-group-item bg-dark text-white">Your code is compiled and tested against test cases.</li>
          <li class="list-group-item bg-dark text-white">Scores are stored in your submission history.</li>
          <li class="list-group-item bg-dark text-white">Track your rank and progress in the Leaderboard.</li>
        </ol>
      </div>
      <div class="modal-footer border-top-0">
        <button class="btn btn-success" data-bs-dismiss="modal">Got It!</button>
      </div>
    </div>
  </div>
</div>

<!-- ABOUT US SECTION -->
<section id="about" class="features-section" style="background-color: #1e293b;">
  <div class="container">
    <h2 class="text-center fw-bold mb-4">About Us</h2>
    <p class="text-center" style="max-width: 800px; margin: auto; font-size: 1.1rem;">
      CodeRunArena is a platform built to help students and professionals enhance their coding skills through challenges, competitions, and real-time evaluation. 
      We believe in learning by doing. Our mission is to provide a gamified environment to make coding fun and rewarding.
    </p>
  </div>
</section>

<!-- FAQS SECTION -->
<section id="faqs" class="features-section">
  <div class="container">
    <h2 class="text-center fw-bold mb-4">FAQs</h2>
    <div class="accordion accordion-flush" id="faqAccordion">
      <div class="accordion-item bg-dark text-white border-0">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
            What is CodeRunArena?
          </button>
        </h2>
        <div id="faq1" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
          <div class="accordion-body">It is an online platform where users can solve coding challenges and improve their skills.</div>
        </div>
      </div>
      <div class="accordion-item bg-dark text-white border-0">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
            How can I join?
          </button>
        </h2>
        <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
          <div class="accordion-body">Simply sign up with your email and start solving challenges after logging in.</div>
        </div>
      </div>
      <div class="accordion-item bg-dark text-white border-0">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed bg-dark text-white" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
            Is it free to use?
          </button>
        </h2>
        <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
          <div class="accordion-body">Yes! CodeRunArena is completely free to use for all registered users.</div>
        </div>
      </div>
    </div>
  </div>
</section>


<!-- FOOTER -->
<footer>
  <p>© 2025 CodeRunArena. All rights reserved.</p>
</footer>

<!-- Bootstrap Script -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
  function showLoginMessage(id) {
    const msg = document.getElementById(id);
    msg.classList.remove('d-none');
    msg.classList.add('fade', 'show');

    // Auto-hide after 3 seconds
    setTimeout(() => {
      msg.classList.remove('show');
      msg.classList.add('d-none');
    }, 3000);
  }
</script>

</body>
</html>
