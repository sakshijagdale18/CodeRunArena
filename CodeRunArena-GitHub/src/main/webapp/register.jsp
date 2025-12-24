<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>CodeRunArena - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f6d365, #fda085);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-box {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 500px;
        }
        .register-box h2 {
            font-weight: bold;
            margin-bottom: 25px;
            color: #d85757;
        }
        .btn-custom {
            background-color: #d85757;
            color: white;
        }
        .btn-custom:hover {
            background-color: #962c2c;
        }
    </style>
</head>
<body>
    <div class="register-box">
        <h2 class="text-center">Create Your CodeRunArena Account</h2>
        <form action="RegisterServlet" method="post">
            <div class="mb-3">
                <label>Full Name</label>
                <input type="text" class="form-control" name="name" required/>
            </div>
            <div class="mb-3">
                <label>Email</label>
                <input type="email" class="form-control" name="email" required/>
            </div>
            <div class="mb-3">
                <label>Password</label>
                <input type="password" class="form-control" name="password" required/>
            </div>
            <button type="submit" class="btn btn-custom w-100">Register</button>
            <div class="mt-3 text-center">
                <span>Already have an account? <a href="login.jsp">Login</a></span>
            </div>
        </form>
    </div>
</body>
</html>
