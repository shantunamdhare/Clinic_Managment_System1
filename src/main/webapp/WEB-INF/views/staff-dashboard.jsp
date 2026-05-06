<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');
        body { font-family:'Inter',sans-serif; background:#0f0e17; color:#e0e0e0; min-height:100vh; padding: 40px; }
        .dashboard-container { max-width: 1000px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header h1 { font-size: 28px; font-weight: 800; background: linear-gradient(135deg,#6C63FF,#8E2DE2); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(108,99,255,0.1); padding: 24px; border-radius: 16px; text-align: center; }
        .stat-card h3 { color: #6C63FF; font-size: 14px; text-transform: uppercase; margin-bottom: 10px; }
        .stat-card .value { font-size: 24px; font-weight: 700; color: #fff; }
        .performance-card { background: linear-gradient(135deg, rgba(108,99,255,0.1), rgba(142,45,226,0.1)); border: 1px solid rgba(108,99,255,0.2); padding: 30px; border-radius: 20px; margin-top: 30px; }
        .stars { color: #fbbf24; font-size: 32px; margin: 10px 0; }
        .badge { display: inline-block; padding: 6px 16px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .badge-present { background: rgba(16,185,129,0.15); color: #34d399; }
        .badge-absent { background: rgba(239,68,68,0.15); color: #f87171; }
        .btn-logout { background: rgba(239,68,68,0.1); color: #ef4444; border: 1px solid rgba(239,68,68,0.2); padding: 8px 20px; border-radius: 10px; cursor: pointer; text-decoration: none; font-size: 14px; transition: 0.3s; }
        .btn-logout:hover { background: rgba(239,68,68,0.2); }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h1>&#x1F465; Staff Dashboard</h1>
            <a href="/logout" class="btn-logout">Logout</a>
        </div>

        <div class="performance-card">
            <h2>Welcome back, ${user.fullName}!</h2>
            <p style="color: #94a3b8; margin-top: 5px;">Role: ${user.role}</p>
        </div>

        <div class="stats-grid" style="margin-top: 30px;">
            <div class="stat-card">
                <h3>Today's Attendance</h3>
                <div class="value">
                    <c:choose>
                        <c:when test="${user.attendanceStatus == 'Present'}"><span class="badge badge-present">Present</span></c:when>
                        <c:when test="${user.attendanceStatus == 'Absent'}"><span class="badge badge-absent">Absent</span></c:when>
                        <c:otherwise><span class="badge" style="background:rgba(255,255,255,0.05); color:#94a3b8;">Not Marked</span></c:otherwise>
                    </c:choose>
                </div>
                <p style="font-size: 12px; color: #64748b; margin-top: 10px;">
                    In: ${user.checkInTime != null ? user.checkInTime : '--:--'} | 
                    Out: ${user.checkOutTime != null ? user.checkOutTime : '--:--'}
                </p>
            </div>
            <div class="stat-card">
                <h3>Current Shift</h3>
                <div class="value" style="font-size: 18px; color: #a78bfa;">
                    ${user.shiftTiming != null ? user.shiftTiming : 'Not Assigned'}
                </div>
            </div>
            <div class="stat-card">
                <h3>Performance Rating</h3>
                <div class="stars">
                    <c:choose>
                        <c:when test="${user.performanceRating != null}">
                            <c:forEach begin="1" end="${user.performanceRating}">&#x2B50;</c:forEach>
                        </c:when>
                        <c:otherwise>
                            <span style="font-size: 14px; color: #64748b;">No Rating Yet</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="card" style="background:rgba(255,255,255,0.02); border:1px solid rgba(255,255,255,0.05); padding:24px; border-radius:16px;">
            <h3>Daily Tasks & Notifications</h3>
            <p style="color: #64748b; font-size: 14px; margin-top: 10px;">Check with Admin for special assignments today.</p>
        </div>
    </div>
</body>
</html>
