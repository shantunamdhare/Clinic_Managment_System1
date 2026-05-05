<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            --primary: #4361ee;
            --primary-light: #4895ef;
            --primary-dark: #3f37c9;
            --secondary: #7209b7;
            --success: #4cc9f0;
            --warning: #f72585;
            --danger: #e63946;
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
            background: var(--white);
            border-right: 1px solid var(--gray-200);
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
            background: linear-gradient(to right, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
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
            color: var(--gray-600);
            border-radius: var(--radius-md);
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .nav-item:hover, .nav-item.active {
            background: var(--gray-50);
            color: var(--primary);
        }

        .nav-item.active {
            background: rgba(67, 97, 238, 0.08);
            color: var(--primary);
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
                <a href="#" class="nav-item active">
                    <span class="material-symbols-outlined">dashboard</span>
                    My Deliveries
                </a>
                <a href="#" class="nav-item">
                    <span class="material-symbols-outlined">history</span>
                    Delivery History
                </a>
                <a href="#" class="nav-item">
                    <span class="material-symbols-outlined">person</span>
                    Profile
                </a>
                <a href="/" class="nav-item" style="margin-top: auto; color: var(--danger);">
                    <span class="material-symbols-outlined">logout</span>
                    Logout
                </a>
            </nav>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <header class="top-header">
                <div class="welcome-section">
                    <h1>Active Assignments</h1>
                    <p>Track and update sample collection tasks</p>
                </div>
                
                <div class="header-actions">
                    <div class="user-profile">
                        <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=Delivery" alt="Delivery Boy">
                        <div class="user-info">
                            <span class="user-name">${user.fullName}</span>
                            <span class="user-role">Logistics Executive</span>
                        </div>
                    </div>
                </div>
            </header>

            <!-- STATS CARDS -->
            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 32px;">
                <div class="section-card" style="margin-bottom: 0;">
                    <div style="display: flex; align-items: center; gap: 16px;">
                        <div style="background: rgba(67, 97, 238, 0.1); color: var(--primary); padding: 12px; border-radius: var(--radius-md);">
                            <span class="material-symbols-outlined">pending_actions</span>
                        </div>
                        <div>
                            <span style="font-size: 24px; font-weight: 800; display: block;">4</span>
                            <span style="font-size: 13px; color: var(--gray-500); font-weight: 600;">Pending Pickups</span>
                        </div>
                    </div>
                </div>
                <!-- Add more stats if needed -->
            </div>

            <!-- TASKS SECTION -->
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
                            <c:if test="${task.deliveryStatus != 'Received' && task.deliveryStatus != 'Delivered'}">
                                <tr>
                                    <td>
                                        <div style="font-weight: 700; color: var(--gray-900);">${task.name}</div>
                                        <div style="font-size: 11px; color: var(--gray-500);">${task.patientId}</div>
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 6px;">
                                            <span class="material-symbols-outlined" style="font-size: 18px; color: var(--danger);">location_on</span>
                                            <span>${not empty task.pickupLocation ? task.pickupLocation : 'Main Clinic - Floor 2'}</span>
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
                                                    <input type="hidden" name="status" value="In Transit">
                                                    <button type="submit" class="btn-action btn-update">
                                                        <span class="material-symbols-outlined">hail</span>
                                                        Pick Up Sample
                                                    </button>
                                                </c:when>
                                                <c:when test="${task.deliveryStatus == 'In Transit'}">
                                                    <input type="hidden" name="status" value="Delivered to Partner Lab">
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
                                            <div class="timeline-step ${task.deliveryStatus == 'In Transit' ? 'active' : (task.deliveryStatus == 'Delivered to Partner Lab' || task.deliveryStatus == 'Received' ? 'completed' : '')}">
                                                <div class="step-icon"><span class="material-symbols-outlined">local_shipping</span></div>
                                                <div class="step-label">In Transit</div>
                                            </div>
                                            <div class="timeline-step ${task.deliveryStatus == 'Delivered to Partner Lab' ? 'active' : (task.deliveryStatus == 'Received' ? 'completed' : '')}">
                                                <div class="step-icon"><span class="material-symbols-outlined">apartment</span></div>
                                                <div class="step-label">Partner Lab</div>
                                            </div>
                                            <div class="timeline-step ${task.deliveryStatus == 'Received' ? 'active' : ''}">
                                                <div class="step-icon"><span class="material-symbols-outlined">biotech</span></div>
                                                <div class="step-label">Lab Received</div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

</body>
</html>
