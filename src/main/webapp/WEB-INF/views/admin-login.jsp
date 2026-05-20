<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body {
            background-color: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: 'Inter', sans-serif;
            background-image: radial-gradient(circle at top right, rgba(16,185,129,0.1), transparent 400px), radial-gradient(circle at bottom left, rgba(108,99,255,0.1), transparent 400px);
        }
        .login-card {
            background: #ffffff;
            border-radius: 24px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            text-align: center;
            border-top: 6px solid #10b981;
        }
        .login-card h2 {
            margin-bottom: 8px;
            color: #064e3b;
            font-size: 28px;
            font-weight: 800;
        }
        .login-card p {
            color: #64748b;
            margin-bottom: 24px;
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 20px;
            text-align: left;
            position: relative;
        }
        .form-input {
            width: 100%;
            padding: 14px 14px 14px 45px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            box-sizing: border-box;
            transition: all 0.3s;
        }
        .form-input:focus {
            border-color: #10b981;
            outline: none;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        }
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 18px;
        }
        .btn-login {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #ffffff;
            border: none;
            padding: 14px;
            width: 100%;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.4);
        }
        .alert-msg {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .error-msg {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div style="font-size:40px; margin-bottom:10px;">&#x1F3E5;</div>
        <h2>Clinic Admin</h2>
        <p>Administrative Portal Login</p>
        
        <c:if test="${not empty loginError}">
            <div class="alert-msg error-msg">
                <span>⚠️</span> ${loginError}
            </div>
        </c:if>

        <form action="/login" method="post">
            <input type="hidden" name="role" value="Admin">
            
            <div class="form-group">
                <span class="input-icon">&#x2709;</span>
                <input type="email" name="email" class="form-input" placeholder="Admin Email" required>
            </div>
            <div class="form-group">
                <span class="input-icon">&#x1F512;</span>
                <input type="password" name="password" class="form-input" placeholder="Password" required>
            </div>
            <button type="submit" class="btn-login">Login to Dashboard &#x27A1;</button>
        </form>
        
        <div style="margin-top: 20px; font-size: 13px;">
            <a href="/" style="color: #64748b; text-decoration: none;">&larr; Back to Home</a>
        </div>
    </div>
</body>
</html>
