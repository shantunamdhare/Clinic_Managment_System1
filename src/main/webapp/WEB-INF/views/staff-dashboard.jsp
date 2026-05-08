<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard | MediCare+</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Icons -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <!-- Styles -->
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <style>
        :root {
            --staff-primary: #8E2DE2;
            --staff-secondary: #4A00E0;
            --staff-gradient: linear-gradient(135deg, #8E2DE2, #4A00E0);
        }

        .staff-bg-gradient {
            background: var(--staff-gradient);
            color: white;
        }

        .performance-bar {
            height: 8px;
            background: var(--gray-100);
            border-radius: 4px;
            overflow: hidden;
            margin-top: 8px;
        }

        .performance-fill {
            height: 100%;
            background: var(--staff-gradient);
            border-radius: 4px;
            transition: width 0.5s ease-out;
        }

        .shift-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            border-radius: var(--radius-md);
            background: var(--gray-50);
            margin-bottom: 12px;
            border-left: 4px solid var(--staff-primary);
        }

        .shift-time {
            font-weight: 700;
            color: var(--staff-primary);
            min-width: 140px;
        }

        .shift-details h4 {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 2px;
        }

        .shift-details p {
            font-size: 12px;
            color: var(--gray-500);
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
            animation: slideUp 0.4s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .attendance-status {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }

        .dot-present { background-color: var(--success); }
        .dot-absent { background-color: var(--error); }
        .dot-late { background-color: var(--warning); }
        
        .alert-success {
            background-color: #d1e7dd;
            color: #0f5132;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #842029;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
            align-items: center;
            justify-content: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background-color: white;
            padding: 30px;
            border-radius: 20px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: scaleIn 0.3s ease-out;
        }

        @keyframes scaleIn {
            from { transform: scale(0.9); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--gray-900);
        }

        .close-modal {
            cursor: pointer;
            color: var(--gray-400);
        }

        .close-modal:hover {
            color: var(--error);
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--gray-600);
            margin-bottom: 8px;
        }

        .btn-update {
            background: #EEF2FF;
            color: var(--staff-primary);
            border: 1px solid #C7D2FE;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-update:hover {
            background: var(--staff-primary);
            color: white;
        }

        /* Profile Styles */
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .profile-header {
            background: var(--staff-gradient);
            padding: 40px;
            border-radius: 24px;
            color: white;
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 30px;
        }
        .profile-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 5px solid rgba(255,255,255,0.2);
            object-fit: cover;
        }
        .profile-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .profile-card {
            background: white;
            padding: 24px;
            border-radius: 20px;
            border: 1px solid var(--gray-100);
        }
        .profile-label {
            font-size: 12px;
            font-weight: 600;
            color: var(--gray-400);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
        }
        .profile-value {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
        }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="logo-icon staff-bg-gradient">S</div>
                <h2>Staff Portal</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="#" class="nav-item active" id="nav-overview" onclick="switchTab(event, 'overview')">
                    <span class="material-symbols-outlined">dashboard</span>
                    Overview
                </a>
                <a href="#" class="nav-item" id="nav-attendance" onclick="switchTab(event, 'attendance')">
                    <span class="material-symbols-outlined">event_available</span>
                    Attendance
                </a>
                <a href="#" class="nav-item" id="nav-shifts" onclick="switchTab(event, 'shifts')">
                    <span class="material-symbols-outlined">schedule</span>
                    Shift Schedule
                </a>
                <a href="#" class="nav-item" id="nav-performance" onclick="switchTab(event, 'performance')">
                    <span class="material-symbols-outlined">trending_up</span>
                    Performance
                </a>
                <a href="#" class="nav-item" id="nav-profile" onclick="switchTab(event, 'profile')">
                    <span class="material-symbols-outlined">person</span>
                    My Profile
                </a>
            </nav>
            <div class="sidebar-footer" style="padding: 24px; border-top: 1px solid var(--gray-100); margin-top: auto;">
                <a href="/logout" class="nav-item" style="color: var(--error); border: none; padding: 12px 0;">
                    <span class="material-symbols-outlined">logout</span>
                    Sign Out
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Topbar -->
            <header class="topbar">
                <div class="topbar-search">
                    <span class="material-symbols-outlined">search</span>
                    <input type="text" placeholder="Search tasks, shifts...">
                </div>
                <div class="topbar-actions">
                    <button class="action-btn">
                        <span class="material-symbols-outlined">notifications</span>
                        <c:if test="${not empty shifts}">
                            <span class="badge">${fn:length(shifts)}</span>
                        </c:if>
                    </button>
                    <div class="user-profile" style="cursor: pointer;" onclick="switchTab(event, 'profile')">
                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=8E2DE2&color=fff" alt="User">
                        <div class="user-info">
                            <span class="user-name">${user.fullName}</span>
                            <span class="user-role">${user.role}</span>
                        </div>
                    </div>
                </div>
            </header>

            <div class="dashboard-container">
                <c:if test="${not empty successMessage}">
                    <div class="alert-success">
                        <span class="material-symbols-outlined">check_circle</span>
                        ${successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert-error">
                        <span class="material-symbols-outlined">error</span>
                        ${errorMessage}
                    </div>
                </c:if>

                <!-- Overview Tab -->
                <div id="overview" class="tab-content active">
                    <div class="page-header">
                        <h1 class="page-title">Staff Dashboard</h1>
                        <c:choose>
                            <c:when test="${empty todayAtt}">
                                <button onclick="openModal('attendanceModal')" class="btn-primary staff-bg-gradient">
                                    <span class="material-symbols-outlined">add</span>
                                    Mark Attendance
                                </button>
                            </c:when>
                            <c:when test="${not empty todayAtt and empty todayAtt.checkOut}">
                                <button onclick="openUpdateModal('${todayAtt.id}')" class="btn-primary" style="background: #ef4444; border: none;">
                                    <span class="material-symbols-outlined">logout</span>
                                    Check Out Now
                                </button>
                            </c:when>
                            <c:otherwise>
                                <div style="display: flex; align-items: center; gap: 8px; background: #ecfdf5; color: #059669; padding: 10px 16px; border-radius: 12px; font-weight: 700; font-size: 14px;">
                                    <span class="material-symbols-outlined">verified_user</span>
                                    Today's Attendance Completed
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Stats Grid -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-blue">
                                <span class="material-symbols-outlined">timer</span>
                            </div>
                            <div class="stat-content">
                                <h3>${fn:length(attendances) * 8}h</h3>
                                <p>Estimated Hours</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-green">
                                <span class="material-symbols-outlined">check_circle</span>
                            </div>
                            <div class="stat-content">
                                <h3>${fn:length(attendances) > 0 ? '100%' : '0%'}</h3>
                                <p>Attendance Rate</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-yellow">
                                <span class="material-symbols-outlined">assignment</span>
                            </div>
                            <div class="stat-content">
                                <h3>${fn:length(shifts)}</h3>
                                <p>Active Shifts</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-red">
                                <span class="material-symbols-outlined">star</span>
                            </div>
                            <div class="stat-content">
                                <h3>4.8</h3>
                                <p>Performance Rating</p>
                            </div>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px;">
                        <!-- Recent Shifts -->
                        <div class="section-card">
                            <div class="section-header">
                                <h2 class="section-title">Upcoming Shifts</h2>
                                <a href="#" class="section-action" onclick="switchTab(event, 'shifts')">View All</a>
                            </div>
                            <div class="section-body" style="padding: 20px;">
                                <c:choose>
                                    <c:when test="${not empty shifts}">
                                        <c:forEach var="shift" items="${shifts}">
                                            <div class="shift-item">
                                                <div class="shift-time">
                                                    <div style="font-size: 11px; opacity: 0.7;">FROM: ${shift.startTime}</div>
                                                    <div style="font-size: 11px; opacity: 0.7;">TO: ${shift.endTime}</div>
                                                </div>
                                                <div class="shift-details">
                                                    <h4>${shift.department}</h4>
                                                    <p>${shift.note}</p>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="text-align: center; color: var(--gray-400); padding: 40px;">No upcoming shifts assigned by admin.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Performance Snapshot -->
                        <div class="section-card">
                            <div class="section-header">
                                <h2 class="section-title">Performance Score</h2>
                            </div>
                            <div class="section-body" style="padding: 24px;">
                                <div style="text-align: center; margin-bottom: 24px;">
                                    <div style="font-size: 48px; font-weight: 800; color: var(--staff-primary);">85%</div>
                                    <p style="font-size: 14px; color: var(--gray-500);">Overall efficiency</p>
                                </div>
                                <div style="margin-bottom: 16px;">
                                    <div style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 600;">
                                        <span>Punctuality</span>
                                        <span>92%</span>
                                    </div>
                                    <div class="performance-bar"><div class="performance-fill" style="width: 92%;"></div></div>
                                </div>
                                <div style="margin-bottom: 16px;">
                                    <div style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 600;">
                                        <span>Patient Care</span>
                                        <span>88%</span>
                                    </div>
                                    <div class="performance-bar"><div class="performance-fill" style="width: 88%;"></div></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Attendance Tab -->
                <div id="attendance" class="tab-content">
                    <div class="page-header">
                        <h1 class="page-title">Attendance Logs</h1>
                        <c:choose>
                            <c:when test="${empty todayAtt}">
                                <button onclick="openModal('attendanceModal')" class="btn-primary staff-bg-gradient">
                                    <span class="material-symbols-outlined">add</span>
                                    Mark Attendance
                                </button>
                            </c:when>
                            <c:when test="${not empty todayAtt and empty todayAtt.checkOut}">
                                <button onclick="openUpdateModal('${todayAtt.id}')" class="btn-primary" style="background: #ef4444; border: none;">
                                    <span class="material-symbols-outlined">logout</span>
                                    Check Out Now
                                </button>
                            </c:when>
                        </c:choose>
                    </div>
                    <div class="section-card">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Check In</th>
                                    <th>Check Out</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="att" items="${attendances}">
                                    <tr>
                                        <td>${att.checkIn}</td>
                                        <td>${att.checkOut != null ? att.checkOut : '---'}</td>
                                        <td>
                                            <div class="attendance-status">
                                                <span class="status-dot dot-present"></span> ${att.status}
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${att.checkOut == null}">
                                                    <button class="btn-update" onclick="openUpdateModal('${att.id}')">
                                                        <span class="material-symbols-outlined" style="font-size: 16px;">logout</span>
                                                        Check Out
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="font-size: 12px; color: var(--success); font-weight: 600;">Completed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty attendances}">
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 60px; color: var(--gray-400);">
                                            <div style="margin-bottom: 16px;">
                                                <span class="material-symbols-outlined" style="font-size: 48px; opacity: 0.5;">event_busy</span>
                                            </div>
                                            <p>No attendance records found.</p>
                                            <button onclick="openModal('attendanceModal')" class="btn-primary staff-bg-gradient" style="margin: 16px auto;">
                                                <span class="material-symbols-outlined">add</span>
                                                Mark Your First Attendance
                                            </button>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Shifts Tab -->
                <div id="shifts" class="tab-content">
                    <div class="page-header">
                        <h1 class="page-title">Shift Schedule</h1>
                    </div>
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Your Assignments</h2>
                        </div>
                        <div style="padding: 24px;">
                            <c:choose>
                                <c:when test="${not empty shifts}">
                                    <c:forEach var="shift" items="${shifts}">
                                        <div class="shift-item" style="border-left-color: #6366f1;">
                                            <div class="shift-time">
                                                <div style="font-size: 11px; opacity: 0.7;">FROM: ${shift.startTime}</div>
                                                <div style="font-size: 11px; opacity: 0.7;">TO: ${shift.endTime}</div>
                                            </div>
                                            <div class="shift-details">
                                                <h4>${shift.department}</h4>
                                                <p>${shift.note}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align: center; padding: 60px; color: var(--gray-400);">
                                        <div style="margin-bottom: 16px;">
                                            <span class="material-symbols-outlined" style="font-size: 48px; opacity: 0.5;">calendar_today</span>
                                        </div>
                                        <p>No shifts assigned by admin yet.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Performance Tab -->
                <div id="performance" class="tab-content">
                    <div class="page-header">
                        <h1 class="page-title">Performance Analytics</h1>
                    </div>
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Genuine Progress</h2>
                        </div>
                        <div style="padding: 40px; text-align: center;">
                            <div style="width: 200px; height: 200px; border-radius: 50%; border: 15px solid #F3F4F6; border-top-color: var(--staff-primary); margin: 0 auto; display: flex; align-items: center; justify-content: center; position: relative;">
                                <div>
                                    <div style="font-size: 42px; font-weight: 800; color: var(--gray-900);">4.8</div>
                                    <div style="font-size: 14px; font-weight: 600; color: var(--gray-500);">Current Rating</div>
                                </div>
                            </div>
                            <p style="margin-top: 20px; color: var(--gray-600);">Performance metrics are calculated based on your attendance and task completion.</p>
                        </div>
                    </div>
                </div>

                <!-- Profile Tab -->
                <div id="profile" class="tab-content">
                    <div class="profile-container">
                        <div class="profile-header">
                            <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=fff&color=8E2DE2&size=128" class="profile-avatar-large" alt="Avatar">
                            <div>
                                <h1 style="font-size: 32px; font-weight: 800; margin-bottom: 5px;">${user.fullName}</h1>
                                <p style="font-size: 18px; opacity: 0.9; font-weight: 500;">${user.role} Account</p>
                            </div>
                        </div>
                        
                        <div class="profile-info-grid">
                            <div class="profile-card">
                                <p class="profile-label">Full Name</p>
                                <p class="profile-value">${user.fullName}</p>
                            </div>
                            <div class="profile-card">
                                <p class="profile-label">Email Address</p>
                                <p class="profile-value">${user.email}</p>
                            </div>
                            <div class="profile-card">
                                <p class="profile-label">Role</p>
                                <p class="profile-value">${user.role}</p>
                            </div>
                            <div class="profile-card">
                                <p class="profile-label">Phone Number</p>
                                <p class="profile-value">${not empty user.phone ? user.phone : 'Not Provided'}</p>
                            </div>
                            <div class="profile-card">
                                <p class="profile-label">Hospital/Clinic Name</p>
                                <p class="profile-value">${not empty user.hospitalName ? user.hospitalName : 'Not Provided'}</p>
                            </div>
                            <div class="profile-card">
                                <p class="profile-label">Staff Employee ID</p>
                                <p class="profile-value">${not empty user.staffId ? user.staffId : 'Not Provided'}</p>
                            </div>
                        </div>
                        
                        <c:if test="${user.role eq 'Doctor'}">
                            <div class="profile-card" style="margin-top: 20px;">
                                <p class="profile-label">Specialization</p>
                                <p class="profile-value">${user.specialization}</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Attendance Modal (Check-In) -->
    <div id="attendanceModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Check In</h3>
                <span class="material-symbols-outlined close-modal" onclick="closeModal('attendanceModal')">close</span>
            </div>
            <form action="/mark-attendance" method="post">
                <div class="form-group">
                    <label>Select Date</label>
                    <input type="date" name="date" class="form-input" required id="attDate">
                </div>
                <div class="form-group">
                    <label>Select Time</label>
                    <input type="time" name="time" class="form-input" required id="attTime">
                </div>
                <div style="margin-top: 25px;">
                    <button type="submit" class="btn-primary staff-bg-gradient" style="width: 100%; justify-content: center;">
                        Confirm Check In
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Update Attendance Modal (Check-Out) -->
    <div id="updateModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Check Out</h3>
                <span class="material-symbols-outlined close-modal" onclick="closeModal('updateModal')">close</span>
            </div>
            <form action="/update-attendance" method="post">
                <input type="hidden" name="id" id="updateId">
                <div class="form-group">
                    <label>Check Out Date</label>
                    <input type="date" name="date" class="form-input" required id="updateDate">
                </div>
                <div class="form-group">
                    <label>Check Out Time</label>
                    <input type="time" name="time" class="form-input" required id="updateTime">
                </div>
                <div style="margin-top: 25px;">
                    <button type="submit" class="btn-primary staff-bg-gradient" style="width: 100%; justify-content: center;">
                        Confirm Check Out
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function switchTab(event, tabId) {
            if (event) event.preventDefault();
            
            // Remove active class from all nav items and tabs
            document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
            
            // Add active class to selected tab
            document.getElementById(tabId).classList.add('active');
            
            // Sync sidebar selection
            const navId = 'nav-' + tabId;
            const navItem = document.getElementById(navId);
            if (navItem) navItem.classList.add('active');
        }

        function openModal(modalId) {
            document.getElementById(modalId).classList.add('active');
            const now = new Date();
            const dateStr = now.toISOString().split('T')[0];
            const timeStr = now.toTimeString().split(' ')[0].substring(0, 5);
            
            if (modalId === 'attendanceModal') {
                document.getElementById('attDate').value = dateStr;
                document.getElementById('attTime').value = timeStr;
            }
        }

        function openUpdateModal(id) {
            document.getElementById('updateId').value = id;
            document.getElementById('updateModal').classList.add('active');
            
            const now = new Date();
            document.getElementById('updateDate').value = now.toISOString().split('T')[0];
            document.getElementById('updateTime').value = now.toTimeString().split(' ')[0].substring(0, 5);
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('active');
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.classList.remove('active');
            }
        }
    </script>
</body>
</html>
