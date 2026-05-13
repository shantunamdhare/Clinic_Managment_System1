<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - MediCare+</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <style>
        body { background: #f1f5f9; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .otp-card { background: white; padding: 40px; border-radius: 24px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; }
        .otp-icon { width: 64px; height: 64px; background: #f0f7ff; color: #2563eb; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; font-size: 24px; }
        .otp-input { letter-spacing: 12px; font-size: 24px; text-align: center; font-weight: 800; border-radius: 12px; padding: 12px; border: 2px solid #e2e8f0; margin-bottom: 24px; }
        .otp-input:focus { border-color: #2563eb; outline: none; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
        .btn-verify { background: #2563eb; color: white; width: 100%; padding: 12px; border-radius: 12px; font-weight: 700; border: none; transition: 0.2s; }
        .btn-verify:hover { background: #1d4ed8; }
    </style>
</head>
<body>
    <div class="otp-card">
        <div class="otp-icon">✉️</div>
        <h3>Verify Email</h3>
        <p class="text-muted">We've sent a 6-digit code to <strong>${tempEmail}</strong></p>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger py-2 small">${error}</div>
        </c:if>

        <form action="/verify-otp" method="post">
            <input type="text" name="otp" class="form-control otp-input" maxlength="6" pattern="\d{6}" placeholder="------" required autofocus>
            <button type="submit" class="btn-verify">Verify & Register</button>
        </form>
        
        <p class="mt-4 mb-0 small text-muted">Didn't receive the code? <a href="/resend-otp" class="text-primary text-decoration-none fw-bold">Resend OTP</a></p>
    </div>
</body>
</html>
