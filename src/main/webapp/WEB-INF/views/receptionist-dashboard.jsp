<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receptionist Dashboard | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');
        body { font-family:'Inter',sans-serif; background:#0f0e17; color:#e0e0e0; min-height:100vh; padding: 20px; }
        .dashboard-container { max-width: 1200px; margin: 0 auto; }
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-top: 20px; }
        .stat-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(108,99,255,0.1); padding: 15px; border-radius: 12px; text-align: center; }
        .stat-card h4 { color: #6C63FF; font-size: 11px; text-transform: uppercase; margin-bottom: 5px; }
        .stat-card .value { font-size: 18px; font-weight: 700; }
        .badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .badge-present { background: rgba(16,185,129,0.15); color: #34d399; }
        .stars { color: #fbbf24; font-size: 20px; }
        .header { display: flex; justify-content: space-between; align-items: center; padding: 20px; background: rgba(255,255,255,0.02); border-radius: 16px; margin-bottom: 20px; }
        .btn-logout { background: rgba(239,68,68,0.1); color: #ef4444; border: 1px solid rgba(239,68,68,0.2); padding: 8px 20px; border-radius: 10px; cursor: pointer; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <div>
                <h1 style="font-size: 24px; font-weight: 800; color: #fff;">&#x1F4CB; Receptionist Panel</h1>
                <p style="color: #64748b; font-size: 14px;">Welcome back, ${user.fullName}</p>
            </div>
            <a href="/logout" class="btn-logout">Logout</a>
        </div>

        <!-- Staff Personal Stats (Managed by Admin) -->
        <div class="stats-grid">
            <div class="stat-card">
                <h4>Your Attendance</h4>
                <div class="value">
                    <c:choose>
                        <c:when test="${user.attendanceStatus == 'Present'}"><span class="badge badge-present">Present</span></c:when>
                        <c:otherwise><span class="badge" style="background:rgba(255,255,255,0.05); color:#64748b;">${user.attendanceStatus != null ? user.attendanceStatus : 'Not Marked'}</span></c:otherwise>
                    </c:choose>
                </div>
                <div style="font-size: 10px; color: #64748b; margin-top: 8px;">
                    In: ${user.checkInTime != null ? user.checkInTime : '--:--'} | Out: ${user.checkOutTime != null ? user.checkOutTime : '--:--'}
                </div>
            </div>
            <div class="stat-card">
                <h4>Assigned Shift</h4>
                <div class="value" style="color: #a78bfa;">${user.shiftTiming != null ? user.shiftTiming : 'Not Assigned'}</div>
            </div>
            <div class="stat-card">
                <h4>Performance Rating</h4>
                <div class="stars">
                    <c:choose>
                        <c:when test="${user.performanceRating != null}">
                            <c:forEach begin="1" end="${user.performanceRating}">&#x2B50;</c:forEach>
                        </c:when>
                        <c:otherwise><span style="font-size: 12px; color: #64748b;">No Rating</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div style="margin-top: 30px; background: rgba(255,255,255,0.02); padding: 40px; border-radius: 20px; text-align: center; border: 1px solid rgba(255,255,255,0.05);">
            <div style="font-size: 40px; margin-bottom: 20px;">&#x1F4CB;</div>
            <h2>Front Desk Operations</h2>
            <p style="color: #64748b; margin-top: 10px;">Manage patient check-ins, registrations, and appointments from here.</p>
        </div>
    </div>
</body>
</html>
