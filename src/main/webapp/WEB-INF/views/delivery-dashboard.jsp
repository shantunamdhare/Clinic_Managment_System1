<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Boy Dashboard | Clinic Management System</title>
    
    <!-- Google Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    
    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #60a5fa;
            --primary-dark: #1d4ed8;
            --secondary: #0f172a;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --gray-50: #f8f9fa;
            --gray-100: #f1f3f5;
            --gray-200: #e9ecef;
            --gray-300: #dee2e6;
            --gray-400: #ced4da;
            --gray-500: #adb5bd;
            --gray-600: #868e96;
            --gray-700: #495057;
            --gray-800: #343a40;
            --gray-900: #212529;
            --white: #ffffff;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.07);
            --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 20px;
            --sidebar-width: 280px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: #f4f7fe;
            color: var(--gray-800);
            overflow-x: hidden;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */
        .sidebar {
            width: var(--sidebar-width);
            background: #0f172a;
            border-right: 1px solid rgba(255,255,255,0.05);
            padding: 32px 24px;
            display: flex;
            flex-direction: column;
            position: fixed;
            height: 100vh;
            z-index: 100;
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 48px;
            padding: 0 8px;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
        }

        .logo-text {
            font-size: 20px;
            font-weight: 800;
            color: #fff;
            letter-spacing: -0.5px;
        }

        .sidebar-nav {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            text-decoration: none;
            color: #94a3b8;
            border-radius: var(--radius-md);
            transition: all 0.3s ease;
            font-weight: 600;
            cursor: pointer;
        }

        .nav-item:hover, .nav-item.active {
            background: rgba(255,255,255,0.05);
            color: #fff;
        }

        .nav-item.active {
            background: rgba(37, 99, 235, 0.1);
            color: #fff;
        }

        /* MAIN CONTENT */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 32px 40px;
        }

        /* TOP HEADER */
        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }

        .welcome-section h1 {
            font-size: 28px;
            font-weight: 800;
            color: var(--gray-900);
            margin-bottom: 4px;
        }

        .welcome-section p {
            color: var(--gray-500);
            font-weight: 500;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 16px;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .user-profile:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .user-profile img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid var(--primary-light);
        }

        .user-info .user-name {
            display: block;
            font-weight: 700;
            font-size: 14px;
            color: var(--gray-900);
        }

        .user-info .user-role {
            font-size: 11px;
            color: var(--gray-500);
            font-weight: 600;
        }

        /* DASHBOARD SECTIONS */
        .section-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 32px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--gray-900);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* TABLE STYLES */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        th {
            text-align: left;
            padding: 16px;
            color: var(--gray-500);
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid var(--gray-100);
        }

        td {
            padding: 20px 16px;
            border-bottom: 1px solid var(--gray-50);
            font-size: 14px;
            font-weight: 500;
            color: var(--gray-700);
        }

        tr:last-child td {
            border-bottom: none;
        }

        /* STATUS BADGES */
        .status-badge {
            padding: 6px 12px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-pending { background: #fff4e6; color: #d9480f; }
        .status-transit { background: #e7f5ff; color: #1971c2; }
        .status-delivered { background: #e6fcf5; color: #087f5b; }
        .status-received { background: #f3f0ff; color: #6741d9; }

        /* BUTTONS */
        .btn-action {
            padding: 8px 16px;
            border-radius: var(--radius-sm);
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .btn-update {
            background: var(--primary);
            color: var(--white);
        }

        .btn-update:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        /* TIMELINE STYLES */
        .delivery-timeline {
            display: flex;
            justify-content: space-between;
            margin: 20px 0;
            position: relative;
        }

        .delivery-timeline::before {
            content: '';
            position: absolute;
            top: 15px;
            left: 50px;
            right: 50px;
            height: 2px;
            background: var(--gray-200);
            z-index: 1;
        }

        .timeline-step {
            position: relative;
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            width: 120px;
        }

        .step-icon {
            width: 32px;
            height: 32px;
            background: var(--white);
            border: 2px solid var(--gray-300);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gray-400);
            transition: all 0.3s ease;
        }

        .timeline-step.active .step-icon {
            border-color: var(--primary);
            background: var(--primary);
            color: var(--white);
            box-shadow: 0 0 0 4px rgba(67, 97, 238, 0.1);
        }

        .timeline-step.completed .step-icon {
            border-color: var(--success);
            background: var(--success);
            color: var(--white);
        }

        .step-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--gray-500);
            text-align: center;
        }

        .timeline-step.active .step-label { color: var(--primary); }
        .timeline-step.completed .step-label { color: var(--success); }

        /* Profile Styles */
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .profile-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
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
            box-shadow: var(--shadow-sm);
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

        /* Receipt Modal */
        .receipt-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            backdrop-filter: blur(4px);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .receipt-card {
            background: var(--white);
            width: 400px;
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
            position: relative;
        }
        .receipt-badge {
            background: #e6fcf5;
            color: #087f5b;
            padding: 4px 12px;
            border-radius: 100px;
            font-size: 10px;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 16px;
            display: inline-block;
        }
    </style>
</head>
<body>

    <div class="dashboard-container">
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <div class="logo-section">
                <div class="logo-icon">
                    <span class="material-symbols-outlined">local_shipping</span>
                </div>
                <span class="logo-text">MEDICARE LOGISTICS</span>
            </div>
            
            <nav class="sidebar-nav">
                <a class="nav-item active" id="nav-active" onclick="showSection('active-section')">
                    <span class="material-symbols-outlined">dashboard</span>
                    My Deliveries
                </a>
                <a class="nav-item" id="nav-history" onclick="showSection('history-section')">
                    <span class="material-symbols-outlined">history</span>
                    Delivery History
                </a>
                <a class="nav-item" id="nav-profile" onclick="showSection('profile-section')">
                    <span class="material-symbols-outlined">person</span>
                    Profile
                </a>
                <a class="nav-item" id="nav-leave" onclick="showSection('leave-section')">
                    <span class="material-symbols-outlined">event_busy</span>
                    Leave Request
                </a>
                <a href="/logout" class="nav-item" style="margin-top: auto; color: var(--danger);">
                    <span class="material-symbols-outlined">logout</span>
                    Logout
                </a>
            </nav>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <header class="top-header">
                <div class="welcome-section">
                    <h1 id="page-title">Active Assignments</h1>
                    <p id="page-subtitle">Track and update sample collection tasks</p>
                </div>
                
                <div class="header-actions">
                    <div class="user-profile" onclick="document.getElementById('editProfileModal').style.display='flex'">
                        <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=Delivery" alt="Delivery Boy">
                        <div class="user-info">
                            <span class="user-name">${user.fullName}</span>
                            <span class="user-role">Logistics Executive</span>
                        </div>
                    </div>
                </div>
            </header>

            <div class="dashboard-container-inner">
                <!-- STATS CARDS -->
                <c:set var="activeCount" value="0"/>
                <c:set var="historyCount" value="0"/>
                <c:forEach var="t" items="${tasks}">
                    <c:choose>
                        <c:when test="${t.deliveryStatus == 'Received' || t.deliveryStatus == 'Delivered' || t.deliveryStatus == 'Completed'}">
                            <c:set var="historyCount" value="${historyCount + 1}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="activeCount" value="${activeCount + 1}"/>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <div id="stats-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 32px;">
                    <div class="section-card" style="margin-bottom: 0; cursor: pointer;" onclick="showSection('active-section')">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <div style="background: rgba(67, 97, 238, 0.1); color: var(--primary); padding: 12px; border-radius: var(--radius-md);">
                                <span class="material-symbols-outlined">pending_actions</span>
                            </div>
                            <div>
                                <span style="font-size: 24px; font-weight: 800; display: block;">${activeCount}</span>
                                <span style="font-size: 13px; color: var(--gray-500); font-weight: 600;">Active Tasks</span>
                            </div>
                        </div>
                    </div>
                    <div class="section-card" style="margin-bottom: 0; cursor: pointer;" onclick="showSection('history-section')">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <div style="background: rgba(76, 201, 240, 0.1); color: #087f5b; padding: 12px; border-radius: var(--radius-md);">
                                <span class="material-symbols-outlined">history</span>
                            </div>
                            <div>
                                <span style="font-size: 24px; font-weight: 800; display: block;">${historyCount}</span>
                                <span style="font-size: 13px; color: var(--gray-500); font-weight: 600;">Deliveries</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TASKS SECTION -->
                <div id="active-section" class="dashboard-page">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">
                                <span class="material-symbols-outlined" style="color: var(--primary);">assignment</span>
                                Current Tasks
                            </h2>
                        </div>

                        <table>
                            <thead>
                                <tr>
                                    <th>Patient / ID</th>
                                    <th>Pickup Location</th>
                                    <th>Test Information</th>
                                    <th>Current Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="task" items="${tasks}">
                                    <c:set var="status" value="${fn:trim(task.deliveryStatus)}"/>
                                    <c:if test="${status != 'Received' && status != 'Delivered' && status != 'Completed'}">
                                        <tr>
                                            <td>
                                                <div style="font-weight: 700; color: var(--gray-900);">${task.name}</div>
                                                <div style="font-size: 11px; color: var(--gray-500);">${task.patientId}</div>
                                            </td>
                                            <td>
                                                <div style="font-size: 13px; font-weight: 700; color: var(--primary);">
                                                    <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">upload</span> 
                                                    From: ${not empty task.sourceHospital ? task.sourceHospital : 'Main Clinic'}
                                                </div>
                                                <div style="font-size: 13px; font-weight: 700; color: var(--success); margin-top: 4px;">
                                                    <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">download</span> 
                                                    To: ${not empty task.destinationHospital ? task.destinationHospital : 'External Lab'}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="status-badge" style="background: var(--gray-100); color: var(--gray-700);">Blood Sample</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${task.deliveryStatus == 'Pending Pickup'}">
                                                        <span class="status-badge status-pending">Pending Pickup</span>
                                                    </c:when>
                                                    <c:when test="${task.deliveryStatus == 'Collected'}">
                                                        <span class="status-badge status-transit" style="background: #e6fcf5; color: #087f5b;">Collected</span>
                                                    </c:when>
                                                    <c:when test="${task.deliveryStatus == 'In Transit'}">
                                                        <span class="status-badge status-transit">In Transit</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-pending">${task.deliveryStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <form action="/update-delivery-status" method="POST" style="display: inline;">
                                                    <input type="hidden" name="id" value="${task.id}">
                                                    <c:choose>
                                                        <c:when test="${task.deliveryStatus == 'Pending Pickup'}">
                                                            <input type="hidden" name="status" value="Collected">
                                                            <button type="submit" class="btn-action btn-update">
                                                                <span class="material-symbols-outlined">hail</span>
                                                                Pick Up Sample
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${task.deliveryStatus == 'Collected'}">
                                                            <input type="hidden" name="status" value="In Transit">
                                                            <button type="submit" class="btn-action btn-update" style="background: var(--warning);">
                                                                <span class="material-symbols-outlined">local_shipping</span>
                                                                Start Transit
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${task.deliveryStatus == 'In Transit'}">
                                                            <input type="hidden" name="status" value="Delivered">
                                                            <button type="submit" class="btn-action btn-update" style="background: var(--secondary);">
                                                                <span class="material-symbols-outlined">check_circle</span>
                                                                Mark Delivered
                                                            </button>
                                                        </c:when>
                                                    </c:choose>
                                                </form>
                                            </td>
                                        </tr>
                                        
                                        <!-- PROGRESS TIMELINE FOR THIS TASK -->
                                        <tr>
                                            <td colspan="5" style="padding: 0 16px 24px 16px; border-bottom: 2px solid var(--gray-50);">
                                                <div class="delivery-timeline">
                                                    <div class="timeline-step completed">
                                                        <div class="step-icon"><span class="material-symbols-outlined">assignment</span></div>
                                                        <div class="step-label">Task Assigned</div>
                                                    </div>
                                                    <div class="timeline-step ${task.deliveryStatus != 'Pending Pickup' ? 'completed' : 'active'}">
                                                        <div class="step-icon"><span class="material-symbols-outlined">hail</span></div>
                                                        <div class="step-label">Sample Pickup</div>
                                                    </div>
                                                    <div class="timeline-step ${task.deliveryStatus == 'Collected' ? 'active' : (task.deliveryStatus == 'In Transit' || task.deliveryStatus == 'Delivered' || task.deliveryStatus == 'Received' ? 'completed' : '')}">
                                                        <div class="step-icon"><span class="material-symbols-outlined">science</span></div>
                                                        <div class="step-label">Collected</div>
                                                    </div>
                                                    <div class="timeline-step ${task.deliveryStatus == 'In Transit' ? 'active' : (task.deliveryStatus == 'Delivered' || task.deliveryStatus == 'Received' ? 'completed' : '')}">
                                                        <div class="step-icon"><span class="material-symbols-outlined">local_shipping</span></div>
                                                        <div class="step-label">In Transit</div>
                                                    </div>
                                                    <div class="timeline-step ${task.deliveryStatus == 'Delivered' ? 'active' : (task.deliveryStatus == 'Received' ? 'completed' : '')}">
                                                        <div class="step-icon"><span class="material-symbols-outlined">apartment</span></div>
                                                        <div class="step-label">Delivered</div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div> <!-- End Active Section -->

                <!-- HISTORY SECTION -->
                <div id="history-section" class="dashboard-page" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">
                                <span class="material-symbols-outlined" style="color: var(--success);">history</span>
                                Completed Deliveries
                            </h2>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th>Patient / ID</th>
                                    <th>Source → Destination</th>
                                    <th>Completed On</th>
                                    <th>Status</th>
                                    <th>Receipt</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="hasHistory" value="false"/>
                                <c:forEach var="task" items="${tasks}">
                                    <c:set var="status" value="${fn:trim(task.deliveryStatus)}"/>
                                    <c:if test="${status == 'Received' || status == 'Delivered' || status == 'Completed'}">
                                        <c:set var="hasHistory" value="true"/>
                                        <tr>
                                            <td>
                                                <div style="font-weight: 700; color: var(--gray-900);">${task.name}</div>
                                                <div style="font-size: 11px; color: var(--gray-500);">${task.patientId}</div>
                                            </td>
                                            <td>
                                                <div style="font-size: 13px; font-weight: 600;">${not empty task.sourceHospital ? task.sourceHospital : 'Main Clinic'}</div>
                                                <div style="font-size: 10px; color: var(--primary); font-weight: 700; display: flex; align-items: center; gap: 4px;">
                                                    <span class="material-symbols-outlined" style="font-size: 12px;">trending_flat</span>
                                                    ${not empty task.destinationHospital ? task.destinationHospital : 'External Lab'}
                                                </div>
                                            </td>
                                            <td>
                                                <div style="font-size: 13px;">${not empty task.lastVisit ? task.lastVisit : 'Today'}</div>
                                            </td>
                                            <td>
                                                <span class="status-badge ${task.deliveryStatus == 'Completed' ? 'status-received' : 'status-delivered'}">
                                                    ${task.deliveryStatus}
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn-action" style="background: var(--gray-100); color: var(--gray-700);" 
                                                        onclick="viewReceipt('${task.name}', '${task.patientId}', '${task.sourceHospital}', '${task.destinationHospital}', '${task.lastVisit}', '${task.deliveryStatus}')">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">description</span>
                                                    View Receipt
                                                </button>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!hasHistory}">
                                    <tr>
                                        <td colspan="5" style="text-align: center; padding: 60px; color: var(--gray-400);">
                                            <span class="material-symbols-outlined" style="font-size: 48px; margin-bottom: 16px; display: block;">history_toggle_off</span>
                                            <p>No delivery history found yet.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>


                <!-- LEAVE SECTION -->
                <div id="leave-section" class="dashboard-page" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">
                                <span class="material-symbols-outlined" style="color: var(--warning);">event_busy</span>
                                Leave Management
                            </h2>
                            <button class="btn-action btn-update" onclick="document.getElementById('leaveModal').style.display='flex'">
                                <span class="material-symbols-outlined">add</span>
                                Apply for Leave
                            </button>
                        </div>

                        <c:if test="${not empty successMessage}">
                            <div style="background: #e6fcf5; color: #087f5b; padding: 15px; border-radius: 12px; margin-bottom: 20px; font-weight: 600;">
                                ${successMessage}
                            </div>
                        </c:if>

                        <table>
                            <thead>
                                <tr>
                                    <th>Leave Period</th>
                                    <th>Type</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="lr" items="${leaveRequests}">
                                    <tr>
                                        <td>${lr.startDate} to ${lr.endDate}</td>
                                        <td><span class="status-badge status-received">${lr.leaveType != null ? lr.leaveType : 'Full Day'}</span></td>
                                        <td>${lr.reason}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${lr.status == 'Approved'}"><span class="status-badge status-delivered">Approved</span></c:when>
                                                <c:when test="${lr.status == 'Rejected'}"><span class="status-badge status-received" style="background:#fff5f5; color:#e03131;">Rejected</span></c:when>
                                                <c:otherwise><span class="status-badge status-pending">Pending</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty leaveRequests}">
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 40px; color: var(--gray-400);">No leave requests found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- PROFILE SECTION -->
                <div id="profile-section" class="dashboard-page" style="display: none;">
                    <div class="section-card" style="padding: 0; overflow: hidden; background: transparent; box-shadow: none;">
                        <div class="profile-container" style="max-width: 100%; margin: 0;">
                            <div class="profile-header" style="margin-bottom: 32px; box-shadow: var(--shadow-md);">
                                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=Delivery" class="profile-avatar-large" alt="Avatar">
                                <div style="flex: 1;">
                                    <h1 style="font-size: 32px; font-weight: 800; margin-bottom: 5px; color: white;">${user.fullName}</h1>
                                    <p style="font-size: 18px; opacity: 0.9; font-weight: 500; color: white;">Logistics Executive</p>
                                </div>
                                <button class="btn-action btn-update" style="background: white; color: var(--primary); padding: 12px 24px; border-radius: 12px; border: none; font-weight: 700;" onclick="document.getElementById('editProfileModal').style.display='flex'">
                                    <span class="material-symbols-outlined">edit</span>
                                    Edit Profile
                                </button>
                            </div>
                            
                            <div class="profile-info-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
                                <div class="profile-card">
                                    <p class="profile-label">Full Name</p>
                                    <p class="profile-value">${user.fullName}</p>
                                </div>
                                <div class="profile-card">
                                    <p class="profile-label">Email Address</p>
                                    <p class="profile-value">${user.email}</p>
                                </div>
                                <div class="profile-card">
                                    <p class="profile-label">Phone Number</p>
                                    <p class="profile-value">${not empty user.phone ? user.phone : 'Not Provided'}</p>
                                </div>
                                <div class="profile-card">
                                    <p class="profile-label">Vehicle Type</p>
                                    <p class="profile-value">${not empty user.vehicleType ? user.vehicleType : 'Not Provided'}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- LEAVE MODAL -->
    <div id="leaveModal" class="receipt-modal">
        <div class="receipt-card" style="width: 500px;">
            <div style="text-align: center; margin-bottom: 24px;">
                <h3 style="font-size: 20px; font-weight: 800; color: var(--gray-900);">Apply for Leave</h3>
                <p style="font-size: 13px; color: var(--gray-500);">Submit your request for Admin approval</p>
            </div>
            <form action="/delivery/leave/apply" method="POST">
                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">LEAVE TYPE</label>
                    <select name="leaveType" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200); font-weight: 600;" required>
                        <option value="Full Day">Full Day</option>
                        <option value="Half Day">Half Day</option>
                    </select>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                    <div>
                        <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">START DATE</label>
                        <input type="date" name="startDate" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200);" required>
                    </div>
                    <div>
                        <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">END DATE</label>
                        <input type="date" name="endDate" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200);" required>
                    </div>
                </div>
                <div style="margin-bottom: 24px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">REASON</label>
                    <textarea name="reason" rows="3" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200);" placeholder="Reason for leave..." required></textarea>
                </div>
                <div style="display: flex; gap: 12px;">
                    <button type="button" class="btn-action" style="flex: 1; justify-content: center; background: var(--gray-100); color: var(--gray-700);" onclick="document.getElementById('leaveModal').style.display='none'">Cancel</button>
                    <button type="submit" class="btn-action btn-update" style="flex: 1; justify-content: center;">Submit Request</button>
                </div>
            </form>
        </div>
    </div>

    <!-- EDIT PROFILE MODAL -->
    <div id="editProfileModal" class="receipt-modal">
        <div class="receipt-card" style="width: 500px; max-height: 90vh; overflow-y: auto;">
            <div style="text-align: center; margin-bottom: 24px;">
                <h3 style="font-size: 20px; font-weight: 800; color: var(--gray-900);">Edit Profile</h3>
                <p style="font-size: 13px; color: var(--gray-500);">Update your personal and vehicle details</p>
            </div>
            <form action="/delivery/profile/update" method="POST">
                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">FULL NAME</label>
                    <input type="text" name="fullName" value="${user.fullName}" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200);" required>
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">EMAIL ADDRESS</label>
                    <input type="email" name="email" value="${user.email}" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200);" required>
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">PHONE NUMBER</label>
                    <input type="text" name="phone" value="${user.phone}" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200);">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">VEHICLE TYPE</label>
                    <input type="text" name="vehicleType" value="${user.vehicleType}" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200);" placeholder="e.g. Motorcycle, Van">
                </div>
                
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid var(--gray-100);">
                
                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: var(--gray-500); margin-bottom: 8px;">CHANGE PASSWORD (LEAVE BLANK TO KEEP CURRENT)</label>
                    <input type="password" name="newPassword" placeholder="New Password" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200); margin-bottom: 10px;">
                    <input type="password" name="confirmPassword" placeholder="Confirm New Password" style="width: 100%; padding: 12px; border-radius: 12px; border: 1px solid var(--gray-200);">
                </div>

                <div style="display: flex; gap: 12px;">
                    <button type="button" class="btn-action" style="flex: 1; justify-content: center; background: var(--gray-100); color: var(--gray-700);" onclick="document.getElementById('editProfileModal').style.display='none'">Cancel</button>
                    <button type="submit" class="btn-action btn-update" style="flex: 1; justify-content: center;">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- RECEIPT MODAL -->
    <div id="receiptModal" class="receipt-modal">
        <div class="receipt-card">
            <div style="text-align: center; margin-bottom: 24px;">
                <div style="width: 60px; height: 60px; background: rgba(76, 201, 240, 0.1); color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                    <span class="material-symbols-outlined" style="font-size: 32px;">receipt_long</span>
                </div>
                <h3 style="font-size: 20px; font-weight: 800; color: var(--gray-900);">Digital Delivery Receipt</h3>
                <p style="font-size: 13px; color: var(--gray-500);">MediCare+ Logistics Network</p>
            </div>

            <div class="receipt-badge" id="receiptStatus">Delivered</div>

            <div style="display: flex; flex-direction: column; gap: 16px; border-top: 1px solid var(--gray-100); padding-top: 20px;">
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--gray-500); font-size: 12px; font-weight: 600;">Patient Name</span>
                    <span style="color: var(--gray-900); font-size: 13px; font-weight: 700;" id="receiptPatient">Michael Scott</span>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--gray-500); font-size: 12px; font-weight: 600;">Patient ID</span>
                    <span style="color: var(--primary); font-size: 13px; font-weight: 700;" id="receiptId">PID-2002</span>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--gray-500); font-size: 12px; font-weight: 600;">Origin</span>
                    <span style="color: var(--gray-900); font-size: 13px; font-weight: 700; text-align: right;" id="receiptSource">Regional Health Center</span>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--gray-500); font-size: 12px; font-weight: 600;">Destination</span>
                    <span style="color: var(--gray-900); font-size: 13px; font-weight: 700; text-align: right;" id="receiptDest">External Partner Lab</span>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--gray-500); font-size: 12px; font-weight: 600;">Completed On</span>
                    <span style="color: var(--gray-900); font-size: 13px; font-weight: 700;" id="receiptDate">May 06, 2024</span>
                </div>
            </div>

            <div style="margin-top: 32px; display: flex; gap: 12px;">
                <button class="btn-action btn-update" style="flex: 1; justify-content: center;" onclick="window.print()">
                    <span class="material-symbols-outlined">print</span>
                    Print
                </button>
                <button class="btn-action" style="flex: 1; justify-content: center; background: var(--gray-100); color: var(--gray-700);" onclick="closeReceipt()">
                    Close
                </button>
            </div>
        </div>
    </div>

    <script>
        function showSection(sectionId) {
            // Hide all sections
            document.querySelectorAll('.dashboard-page').forEach(page => {
                page.style.display = 'none';
            });
            
            // Show target section
            document.getElementById(sectionId).style.display = 'block';
            
            // Update sidebar active state
            document.querySelectorAll('.nav-item').forEach(item => {
                item.classList.remove('active');
            });
            
            const navIdMap = {
                'active-section': 'nav-active',
                'history-section': 'nav-history',
                'profile-section': 'nav-profile'
            };
            
            const navId = navIdMap[sectionId];
            if (navId) {
                document.getElementById(navId).classList.add('active');
            }
            
            // Update stats grid visibility (hide on profile)
            const statsGrid = document.getElementById('stats-grid');
            if (sectionId === 'profile-section') {
                statsGrid.style.display = 'none';
            } else {
                statsGrid.style.display = 'grid';
            }

            // Update titles
            const title = document.getElementById('page-title');
            const subtitle = document.getElementById('page-subtitle');
            
            if (sectionId === 'active-section') {
                title.innerText = 'Active Assignments';
                subtitle.innerText = 'Track and update sample collection tasks';
            } else if (sectionId === 'history-section') {
                title.innerText = 'Delivery History';
                subtitle.innerText = 'Review all your completed sample deliveries';
            } else if (sectionId === 'profile-section') {
                title.innerText = 'My Profile';
                subtitle.innerText = 'Manage your account and vehicle details';
            }
        }

        function viewReceipt(name, id, source, dest, date, status) {
            document.getElementById('receiptPatient').innerText = name;
            document.getElementById('receiptId').innerText = id;
            document.getElementById('receiptSource').innerText = source;
            document.getElementById('receiptDest').innerText = dest;
            document.getElementById('receiptDate').innerText = date || 'Today';
            document.getElementById('receiptStatus').innerText = status;
            document.getElementById('receiptModal').style.display = 'flex';
        }

        function closeReceipt() {
            document.getElementById('receiptModal').style.display = 'none';
        }

        window.onclick = function(event) {
            const modal = document.getElementById('receiptModal');
            if (event.target == modal) {
                closeReceipt();
            }
        }
    </script>
</body>
</html>
