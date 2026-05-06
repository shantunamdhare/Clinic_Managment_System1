<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff & Shifts | MediCare+ Pharmacy</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; color: #64748b; font-size: 13px; text-transform: uppercase; }
        td { padding: 14px 12px; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
        .badge-pill { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; background: #ecfdf5; color: #10b981; }
    </style>
</head>
<body>
    <div class="pharmacy-container">
        <aside class="sidebar">
            <div class="sidebar-logo"><i class="fas fa-plus-square"></i> <span>MediCare+ <span>Pharmacy</span></span></div>
            <nav class="sidebar-nav">
                <a href="/pharmacy-dashboard" class="nav-link"><i class="fas fa-th-large"></i> Dashboard</a>
                <a href="/pharmacy/inventory" class="nav-link"><i class="fas fa-pills"></i> Stock & Expiry</a>
                <a href="/pharmacy/billing" class="nav-link"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link active"><i class="fas fa-users"></i> Staff & Shifts</a>
            </nav>
            <div class="sidebar-footer"><a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></div>
        </aside>
        <main class="main-content">
            <header class="main-header">
                <div class="header-search"><i class="fas fa-search"></i><input type="text" placeholder="Search staff..."></div>
                <div class="header-user">
                    <div class="user-profile">
                        <c:choose>
                            <c:when test="${not empty user.profileImage}">
                                <img src="${user.profileImage}" alt="User">
                            </c:when>
                            <c:otherwise>
                                <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff" alt="User">
                            </c:otherwise>
                        </c:choose>
                        <div class="user-info"><span class="name">${user.fullName}</span><span class="role">Pharmacist</span></div>
                    </div>
                </div>
            </header>

            <div class="grid-card" style="margin-bottom: 24px; background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); color: white; border: none;">
                <div class="card-body" style="display: flex; align-items: center; justify-content: space-between; padding: 25px;">
                    <div>
                        <h1 style="font-size: 24px; margin-bottom: 5px;">Daily Attendance</h1>
                        <p style="opacity: 0.9;">Manage your daily shift presence and logs.</p>
                    </div>
                    <div style="display: flex; gap: 15px;">
                        <c:choose>
                            <c:when test="${empty todayAttendance}">
                                <form action="/pharmacy/check-in" method="POST">
                                    <button type="submit" style="padding: 12px 25px; background: white; color: #4f46e5; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                        <i class="fas fa-sign-in-alt"></i> Check-In Now
                                    </button>
                                </form>
                            </c:when>
                            <c:when test="${not empty todayAttendance and empty todayAttendance.checkOut}">
                                <form action="/pharmacy/check-out" method="POST">
                                    <button type="submit" style="padding: 12px 25px; background: #fbbf24; color: #78350f; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                        <i class="fas fa-sign-out-alt"></i> Finish Shift / Check-Out
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 12px 25px; background: #10b981; color: white; border-radius: 8px; font-weight: 700; display: flex; align-items: center; gap: 8px;">
                                    <i class="fas fa-check-double"></i> Shift Completed
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1.5fr; gap: 24px;">
                <div class="grid-card">
                    <div class="card-header"><h2><i class="fas fa-id-card"></i> Staff Profile</h2></div>
                    <div class="card-body" style="text-align: center;">
                        <img src="https://placehold.co/400x250/4f46e5/ffffff?text=Chief+Pharmacist\nArjun+Sharma" alt="ID Card" style="width: 100%; border-radius: 12px; margin-bottom: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                        <div style="padding: 15px; background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0;">
                            <h3 style="margin: 0; color: #1e293b;">${user.fullName}</h3>
                            <p style="color: #64748b; font-size: 14px; margin: 5px 0 0 0;">Pharmacy License: #PH-2024-089</p>
                        </div>
                    </div>
                    <div class="card-header" style="border-top: 1px solid #f1f5f9;"><h2><i class="fas fa-clock"></i> Current Shifts</h2></div>
                    <div class="card-body">
                        <c:forEach var="shift" items="${allShifts}">
                            <div style="padding: 15px; background: #f8fafc; border-radius: 12px; margin-bottom: 12px; border: 1px solid #e2e8f0;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <img src="https://ui-avatars.com/api/?name=${shift.staff.fullName}&background=random" style="width: 32px; height: 32px; border-radius: 50%;">
                                    <div>
                                        <strong style="display: block;">${shift.staff.fullName}</strong>
                                        <small style="color: #64748b;">${shift.dayOfWeek} | ${shift.startTime} - ${shift.endTime}</small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <div class="grid-card">
                    <div class="card-header"><h2><i class="fas fa-calendar-check"></i> Attendance Log</h2></div>
                    <div class="card-body">
                        <table>
                            <thead>
                                <tr>
                                    <th>Staff Name</th>
                                    <th>Date</th>
                                    <th>Check-In</th>
                                    <th>Check-Out</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="att" items="${allAttendance}">
                                    <tr>
                                        <td><strong>${att.staff.fullName}</strong></td>
                                        <td>${att.date}</td>
                                        <td>${att.checkIn}</td>
                                        <td>${att.checkOut != null ? att.checkOut : '--'}</td>
                                        <td><span class="badge-pill">${att.status}</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
