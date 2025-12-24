<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>CodeRunArena - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #1f1c2c, #928dab);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-box {
            background: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        .login-box h2 {
            font-weight: bold;
            margin-bottom: 25px;
            color: #4a4e69;
        }
        .btn-custom {
            background-color: #4a4e69;
            color: white;
        }
        .btn-custom:hover {
            background-color: #22223b;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2 class="text-center">Login to CodeRunArena</h2>
        <form action="LoginServlet" method="post">
            <div class="mb-3">
                <label>Email</label>
                <input type="email" class="form-control" name="email" required/>
            </div>
            <div class="mb-3">
                <label>Password</label>
                <input type="password" class="form-control" name="password" required/>
            </div>
            <button type="submit" class="btn btn-custom w-100">Login</button>
            <div class="mt-3 text-center">
                <span>Don't have an account? <a href="register.jsp">Register</a></span>
            </div>
        </form>
    </div>
</body>
</html>
