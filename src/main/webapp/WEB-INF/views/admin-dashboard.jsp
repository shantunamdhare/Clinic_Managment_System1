<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#f0fdf4; color:#1e293b; min-height:100vh; }

        .admin-layout { display:flex; min-height:100vh; }

        /* Sidebar */
        .admin-sidebar {
            width:260px; background:linear-gradient(180deg,#064e3b 0%,#065f46 100%);
            padding:24px 0; display:flex; flex-direction:column; position:fixed;
            top:0; left:0; height:100vh; z-index:100; border-right:1px solid rgba(16,185,129,0.15);
        }
        .sidebar-brand { padding:0 24px 28px; border-bottom:1px solid rgba(255,255,255,0.06); }
        .sidebar-brand h2 { font-size:22px; font-weight:800; background:linear-gradient(135deg,#10b981,#34d399);
            -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .sidebar-brand span { font-size:11px; color:#94a3b8; }
        .sidebar-nav { flex:1; padding:20px 12px; display:flex; flex-direction:column; gap:4px; overflow-y:auto; }
        .nav-item {
            display:flex; align-items:center; gap:12px; padding:11px 16px; border-radius:10px;
            color:#a7f3d0; font-size:14px; font-weight:500; cursor:pointer; transition:all .2s;
            text-decoration:none;
        }
        .nav-item:hover, .nav-item.active { background:rgba(220,252,231,0.12); color:#fff; }
        .nav-item.active { background:rgba(220,252,231,0.18); color:#fff; font-weight:600; border-left: 3px solid #10b981; }
        .nav-icon { font-size:18px; width:24px; text-align:center; }
        .sidebar-footer { padding:16px 24px; border-top:1px solid rgba(255,255,255,0.06); }
        .sidebar-footer a {
            display:flex; align-items:center; gap:10px; color:#ef4444; font-size:14px;
            font-weight:600; text-decoration:none; padding:10px 16px; border-radius:10px; transition:all .2s;
        }
        .sidebar-footer a:hover { background:rgba(239,68,68,0.1); }

        /* Main Content */
        .admin-main { flex:1; margin-left:260px; padding:28px 32px; }

        /* Top Bar */
        .top-bar {
            display:flex; justify-content:space-between; align-items:center;
            margin-bottom:28px; padding-bottom:20px; border-bottom:1px solid rgba(255,255,255,0.06);
        }
        .top-bar h1 { font-size:26px; font-weight:800; color:#064e3b; }
        .top-bar h1 span { color:#10b981; }
        .top-bar-right { display:flex; align-items:center; gap:16px; }
        .admin-badge {
            background:linear-gradient(135deg,#10b981,#34d399); color:#fff; padding:8px 18px;
            border-radius:20px; font-size:13px; font-weight:700;
        }
        .date-badge { color:#94a3b8; font-size:13px; font-weight:500; }

        /* Stats Grid */
        .stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:20px; margin-bottom:28px; }
        .stat-box {
            background:#ffffff;
            border:1px solid #DCFCE7; border-radius:16px; padding:24px;
            transition:transform .2s, box-shadow .2s; position:relative; overflow:hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .stat-box:hover { transform:translateY(-3px); box-shadow:0 8px 30px rgba(16,185,129,0.1); }
        .stat-box::before {
            content:''; position:absolute; top:0; left:0; right:0; height:3px;
            background:linear-gradient(90deg,#10b981,#34d399); border-radius:16px 16px 0 0;
        }
        .stat-box.green::before { background:linear-gradient(90deg,#10b981,#34d399); }
        .stat-box.orange::before { background:linear-gradient(90deg,#f59e0b,#fbbf24); }
        .stat-box.red::before { background:linear-gradient(90deg,#ef4444,#f87171); }
        .stat-box .stat-icon { font-size:32px; margin-bottom:12px; }
        .stat-box h3 { font-size:32px; font-weight:800; color:#064e3b; margin-bottom:4px; }
        .stat-box p { font-size:13px; color:#64748b; font-weight:500; }
        .stat-box .stat-sub { font-size:11px; color:#10b981; margin-top:6px; font-weight:600; }

        /* Section Title */
        .section-title {
            font-size:18px; font-weight:700; color:#064e3b; margin-bottom:16px;
            display:flex; align-items:center; gap:10px;
        }
        .section-title .title-icon { font-size:20px; }

        /* Cards Grid */
        .cards-row { display:grid; grid-template-columns:repeat(2,1fr); gap:20px; margin-bottom:28px; }

        .card {
            background:#ffffff;
            border:1px solid #DCFCE7; border-radius:16px; padding:24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .card-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; }
        .card-header h3 { font-size:16px; font-weight:700; color:#064e3b; }

        /* Table */
        .data-table { width:100%; border-collapse:collapse; }
        .data-table th {
            text-align:left; padding:10px 14px; font-size:12px; font-weight:600;
            color:#64748b; text-transform:uppercase; letter-spacing:.5px;
            border-bottom:1px solid rgba(255,255,255,0.06);
        }
        .data-table td {
            padding:12px 14px; font-size:13px; color:#cbd5e1;
            border-bottom:1px solid rgba(255,255,255,0.04);
        }
        .data-table tr:hover td { background:rgba(108,99,255,0.04); }

        /* Badges */
        .badge {
            display:inline-block; padding:4px 12px; border-radius:20px;
            font-size:11px; font-weight:700; text-transform:uppercase;
        }
        .badge-pending { background:rgba(245,158,11,0.15); color:#fbbf24; }
        .badge-completed { background:rgba(16,185,129,0.15); color:#34d399; }
        .badge-cancelled { background:rgba(239,68,68,0.15); color:#f87171; }
        .badge-role { background:rgba(108,99,255,0.15); color:#a78bfa; }

        /* Alerts Panel */
        .alert-item {
            display:flex; align-items:center; gap:12px; padding:12px 16px;
            border-radius:10px; margin-bottom:8px; font-size:13px; font-weight:500;
        }
        .alert-item.warning { background:rgba(245,158,11,0.08); color:#fbbf24; border-left:3px solid #f59e0b; }
        .alert-item.info { background:rgba(108,99,255,0.08); color:#a78bfa; border-left:3px solid #6C63FF; }
        .alert-item.danger { background:rgba(239,68,68,0.08); color:#f87171; border-left:3px solid #ef4444; }
        .alert-item.success { background:rgba(16,185,129,0.08); color:#34d399; border-left:3px solid #10b981; }
        .alert-icon { font-size:18px; }

        /* Staff Card */
        .staff-card {
            display:flex; align-items:center; gap:14px; padding:14px;
            border-radius:12px; background:rgba(255,255,255,0.03);
            border:1px solid rgba(255,255,255,0.04); margin-bottom:10px; transition:all .2s;
        }
        .staff-card:hover { background:rgba(108,99,255,0.06); border-color:rgba(108,99,255,0.15); }
        .staff-avatar {
            width:40px; height:40px; border-radius:10px;
            background:linear-gradient(135deg,#6C63FF,#8E2DE2);
            display:flex; align-items:center; justify-content:center;
            color:#fff; font-weight:700; font-size:16px; flex-shrink:0;
        }
        .staff-info h4 { font-size:14px; font-weight:600; color:#e2e8f0; }
        .staff-info p { font-size:12px; color:#64748b; }

        /* Availability Slot */
        .avail-slot {
            display:flex; align-items:center; justify-content:space-between;
            padding:12px 16px; border-radius:10px; background:rgba(16,185,129,0.06);
            border:1px solid rgba(16,185,129,0.12); margin-bottom:8px;
        }
        .avail-slot .doc-name { font-size:14px; font-weight:600; color:#34d399; }
        .avail-slot .doc-time { font-size:12px; color:#64748b; }

        /* Quick Stat Mini */
        .mini-stats { display:grid; grid-template-columns:repeat(3,1fr); gap:12px; margin-bottom:20px; }
        .mini-stat {
            text-align:center; padding:16px; border-radius:12px;
            background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.05);
        }
        .mini-stat h4 { font-size:22px; font-weight:800; color:#a78bfa; }
        .mini-stat p { font-size:11px; color:#64748b; margin-top:4px; }

        .empty-state { text-align:center; padding:32px; color:#475569; font-size:14px; }
        .empty-state .empty-icon { font-size:40px; margin-bottom:10px; opacity:0.5; }

        /* Triple grid */
        .cards-triple { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:28px; }

        /* Section Toggling */
        .content-section { display: none; }
        .content-section.active { display: block; animation: fadeIn 0.4s ease; }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Modal Styles */
        .modal {
            display: none; position: fixed; z-index: 1000; left: 0; top: 0;
            width: 100%; height: 100%; background: rgba(0,0,0,0.8); backdrop-filter: blur(5px);
        }
        .modal-content {
            background: #1a1a2e; margin: 10% auto; padding: 30px; border-radius: 16px;
            width: 400px; border: 1px solid rgba(108,99,255,0.2); box-shadow: 0 10px 40px rgba(0,0,0,0.5);
        }
        .modal-header { margin-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 15px; }
        .modal-header h3 { font-size: 18px; color: #f1f5f9; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 13px; color: #94a3b8; }
        .form-group input, .form-group select {
            width: 100%; padding: 10px; border-radius: 8px; background: #242444;
            border: 1px solid rgba(255,255,255,0.1); color: #fff; outline: none;
        }
        .form-group select option {
            background: #1a1a2e;
            color: #fff;
        }
        .modal-btn {
            width: 100%; padding: 12px; border-radius: 8px; border: none; cursor: pointer;
            font-weight: 700; color: #fff; background: linear-gradient(135deg,#6C63FF,#8E2DE2); transition: 0.3s;
        }
        .modal-btn:hover { opacity: 0.9; transform: translateY(-2px); }

        @media(max-width:1200px) { .stats-row { grid-template-columns:repeat(2,1fr); } .cards-triple { grid-template-columns:1fr; } }
        @media(max-width:900px) { .admin-sidebar { display:none; } .admin-main { margin-left:0; } .cards-row { grid-template-columns:1fr; } }
    </style>
</head>
<body>
<div class="admin-layout">
    <!-- Sidebar -->
    <aside class="admin-sidebar">
        <div class="sidebar-brand">
            <h2>&#x2695; MediCare+</h2>
            <span>Admin Control Panel</span>
        </div>
        <nav class="sidebar-nav">
            <a class="nav-item active" href="javascript:void(0)" onclick="showSection('dashboard-section', this)">
                <span class="nav-icon">&#x1F4CA;</span> Dashboard
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('staff-section', this)">
                <span class="nav-icon">&#x1F465;</span> Staff Management
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('staff-requests-section', this)">
                <span class="nav-icon">&#x1F4DD;</span> Staff Requests
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('visitors-messages-section', this)">
                <span class="nav-icon">&#x1F4E8;</span> Visitors Messages
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('appointments-section', this)">
                <span class="nav-icon">&#x1F4C5;</span> Appointments
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('doctors-section', this)">
                <span class="nav-icon">&#x1FA7A;</span> Doctors
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('alerts-section', this)">
                <span class="nav-icon">&#x1F514;</span> Alerts
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('health-section', this)">
                <span class="nav-icon">&#x1F6E1;</span> System Health
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('newsletter-section', this)">
                <span class="nav-icon">&#x1F4E7;</span> Newsletter
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('analytics-section', this)">
                <span class="nav-icon">&#x1F4C8;</span> Analytics
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="/logout">&#x1F6AA; Logout</a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
        <!-- Top Bar -->
        <div class="top-bar">
            <h1>Welcome, <span>${user.fullName}</span></h1>
            <div class="top-bar-right">
                <span class="date-badge">&#x1F4C5; <%= new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy").format(new java.util.Date()) %></span>
                <span class="admin-badge">&#x1F6E1; Administrator</span>
            </div>
        </div>

        <!-- Dashboard Section (Default) -->
        <div id="dashboard-section" class="content-section active">
            <!-- Primary Stats -->
            <div class="stats-row">
                <div class="stat-box">
                    <div class="stat-icon">&#x1F465;</div>
                    <h3>${totalPatients}</h3>
                    <p>Total Patients</p>
                    <div class="stat-sub">All registered patients</div>
                </div>
                <div class="stat-box green">
                    <div class="stat-icon">&#x1F4C5;</div>
                    <h3>${todayAppointments}</h3>
                    <p>Today's Appointments</p>
                    <div class="stat-sub" style="color:#10b981;">This month: ${monthAppointments}</div>
                </div>
                <div class="stat-box orange">
                    <div class="stat-icon">&#x1FA7A;</div>
                    <h3>${totalDoctors}</h3>
                    <p>Active Doctors</p>
                    <div class="stat-sub" style="color:#f59e0b;">Total Staff: ${totalUsers}</div>
                </div>
                <div class="stat-box red">
                    <div class="stat-icon">&#x1F4CB;</div>
                    <h3>${totalAppointments}</h3>
                    <p>Total Appointments</p>
                    <div class="stat-sub" style="color:#ef4444;">Pending: ${pendingAppointments}</div>
                </div>
            </div>


            <!-- Alerts, Stocks & Bills Row -->
            <div class="cards-triple" style="margin-top:20px;">
                <!-- System Alerts Summary -->
                <div class="card">
                    <div class="card-header">
                        <h3>&#x1F514; Recent Alerts</h3>
                        <a href="javascript:void(0)" onclick="showSection('alerts-section', document.querySelectorAll('.nav-item')[4])" style="font-size:12px; color:#6C63FF; text-decoration:none;">View All</a>
                    </div>
                    <div style="display:flex; flex-direction:column; gap:10px; margin-top:10px;">
                        <c:forEach var="alert" items="${systemAlerts}">
                            <div style="background:rgba(${alert.type == 'Urgent' ? '239,68,68' : alert.type == 'Warning' ? '245,158,11' : '108,99,255'},0.05); border-left:3px solid ${alert.type == 'Urgent' ? '#ef4444' : alert.type == 'Warning' ? '#f59e0b' : '#6C63FF'}; padding:10px; border-radius:4px; margin-bottom:8px;">
                                <div style="font-size:13px; font-weight:600; color:${alert.type == 'Urgent' ? '#ef4444' : alert.type == 'Warning' ? '#f59e0b' : '#6C63FF'};">${alert.type} Alert</div>
                                <div style="font-size:12px; color:#cbd5e1; margin-top:2px;">${alert.message}</div>
                                <div style="font-size:10px; color:#64748b; margin-top:6px;">${alert.createdAt}</div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty systemAlerts}">
                            <div style="text-align:center; padding:20px; color:#475569; font-size:12px;">No active alerts</div>
                        </c:if>
                    </div>
                </div>

                <!-- Low Stock Alert -->
                <div class="card">
                    <div class="card-header">
                        <h3>&#x1F4E6; Low Stocks</h3>
                        <span class="badge badge-cancelled" style="font-size:10px;">Attention</span>
                    </div>
                    <div style="display:flex; flex-direction:column; gap:10px; margin-top:10px;">
                        <c:forEach var="stock" items="${lowStocks}">
                            <div style="display:flex; justify-content:space-between; align-items:center; padding:10px; background:rgba(255,255,255,0.02); border-radius:8px;">
                                <div>
                                    <div style="font-size:13px; font-weight:600;">${stock.item}</div>
                                    <div style="font-size:11px; color:#94a3b8;">Left: ${stock.count}</div>
                                </div>
                                <span class="badge" style="background:${stock.status == 'Critical' ? 'rgba(239,68,68,0.1)' : 'rgba(245,158,11,0.1)'}; color:${stock.status == 'Critical' ? '#ef4444' : '#f59e0b'}; border:none; font-size:10px;">${stock.status}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Pending Bills -->
                <div class="card">
                    <div class="card-header">
                        <h3>&#x1F4B5; Pending Bills</h3>
                        <span class="badge badge-pending" style="font-size:10px;">Action</span>
                    </div>
                    <div style="display:flex; flex-direction:column; gap:10px; margin-top:10px;">
                        <c:forEach var="bill" items="${pendingBills}">
                            <div style="display:flex; justify-content:space-between; align-items:center; padding:10px; background:rgba(255,255,255,0.02); border-radius:8px;">
                                <div>
                                    <div style="font-size:13px; font-weight:600;">${bill.patient}</div>
                                    <div style="font-size:11px; color:#ef4444;">Due: ${bill.due}</div>
                                </div>
                                <div style="text-align:right;">
                                    <div style="font-weight:700; color:#34d399; font-size:13px;">${bill.amount}</div>
                                    <div style="font-size:9px; color:#64748b;">Pending</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Doctors Section -->
        <div id="doctors-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1FA7A;</span> Doctor Availability Today
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>&#x1FA7A; Doctors Schedule</h3>
                </div>
                <c:choose>
                    <c:when test="${not empty todayAvailability}">
                        <c:forEach var="slot" items="${todayAvailability}">
                            <div class="avail-slot">
                                <div>
                                    <div class="doc-name">Dr. ${slot.doctor.fullName}</div>
                                    <div class="doc-time">${slot.doctor.specialization != null ? slot.doctor.specialization : 'General'}</div>
                                </div>
                                <div class="doc-time">${slot.startTime} - ${slot.endTime}</div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty doctors}">
                                <c:forEach var="doc" items="${doctors}">
                                    <div class="avail-slot" style="border-color:rgba(100,116,139,0.15); background:rgba(100,116,139,0.06);">
                                        <div>
                                            <div class="doc-name" style="color:#94a3b8;">Dr. ${doc.fullName}</div>
                                            <div class="doc-time">${doc.specialization != null ? doc.specialization : 'General'} &bull; ${doc.phone != null ? doc.phone : 'N/A'}</div>
                                        </div>
                                        <span class="badge badge-pending">No Slots Set</span>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-icon">&#x1FA7A;</div>
                                    <p>No doctors registered yet</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Alerts Section -->
        <div id="alerts-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F514;</span> System Alerts & Notifications
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>&#x1F514; Important Alerts</h3>
                </div>
                <c:if test="${pendingAppointments > 0}">
                    <div class="alert-item warning">
                        <span class="alert-icon">&#x23F3;</span>
                        ${pendingAppointments} appointment(s) pending confirmation
                    </div>
                </c:if>
                <c:if test="${totalDoctors == 0}">
                    <div class="alert-item danger">
                        <span class="alert-icon">&#x26A0;</span>
                        No doctors registered - system needs at least one doctor
                    </div>
                </c:if>
                <c:if test="${pendingLabRequests > 0}">
                    <div class="alert-item info">
                        <span class="alert-icon">&#x1F9EA;</span>
                        ${pendingLabRequests} lab request(s) in the system
                    </div>
                </c:if>
                <c:if test="${totalPatients > 0}">
                    <div class="alert-item success">
                        <span class="alert-icon">&#x2705;</span>
                        ${totalPatients} patient record(s) in database
                    </div>
                </c:if>
                <div class="alert-item info">
                    <span class="alert-icon">&#x1F4CA;</span>
                    ${totalVisits} total patient visits recorded
                </div>
                <c:if test="${todayAppointments == 0}">
                    <div class="alert-item warning">
                        <span class="alert-icon">&#x1F4C5;</span>
                        No appointments scheduled for today
                    </div>
                </c:if>
                
                <hr style="border:0; border-top:1px solid rgba(255,255,255,0.05); margin:15px 0;">
                
                <c:forEach var="alert" items="${systemAlerts}">
                    <div class="alert-item ${alert.type == 'Urgent' ? 'danger' : alert.type == 'Warning' ? 'warning' : 'info'}">
                        <span class="alert-icon">${alert.type == 'Urgent' ? '&#x1F6A8;' : alert.type == 'Warning' ? '&#x26A0;' : '&#x1F4AC;'}</span>
                        <div>
                            <div style="font-weight:700;">${alert.type} Alert</div>
                            <div>${alert.message}</div>
                            <div style="font-size:10px; opacity:0.6; margin-top:4px;">${alert.createdAt}</div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty systemAlerts}">
                    <div class="empty-state">
                        <div class="empty-icon">&#x1F514;</div>
                        <p>No new system alerts</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Appointments Section -->
        <div id="appointments-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F4C5;</span> Appointment Records
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>&#x1F4C5; Recent Appointments</h3>
                </div>
                <c:choose>
                    <c:when test="${not empty recentAppointments}">
                        <table class="data-table">
                            <thead>
                                <tr><th>Patient</th><th>Doctor</th><th>Date</th><th>Status</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="apt" items="${recentAppointments}">
                                    <tr>
                                        <td>${apt.patient.name}</td>
                                        <td>Dr. ${apt.doctor.fullName}</td>
                                        <td>${apt.appointmentDate} ${apt.appointmentTime}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${apt.status == 'Completed'}"><span class="badge badge-completed">${apt.status}</span></c:when>
                                                <c:when test="${apt.status == 'Cancelled'}"><span class="badge badge-cancelled">${apt.status}</span></c:when>
                                                <c:otherwise><span class="badge badge-pending">${apt.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">&#x1F4C5;</div>
                            <p>No appointments recorded yet</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Newsletter Subscriptions Section -->
        <div id="newsletter-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F4E7;</span> Newsletter Management
            </div>
            
            <div class="cards-row">
                <div class="card" style="background: #ffffff; border: 1px solid #DCFCE7;">
                    <div class="card-header">
                        <h3 style="color: #064e3b;">&#x1F465; Community Overview</h3>
                        <span class="badge badge-role">${totalSubscribers} Subscribers</span>
                    </div>
                    <p style="font-size: 13px; color: #64748b; margin-bottom: 20px;">
                        Manage your newsletter community and keep your audience engaged with the latest updates.
                    </p>
                    
                    <div style="background: #f0fdf4; border: 1px solid #dcfce7; padding: 25px; border-left: 5px solid #10b981; border-radius: 16px;">
                        <h4 style="margin-bottom: 10px; color: #064e3b; font-weight: 800;">📢 Send Update to All</h4>
                        <p style="font-size: 12px; color: #64748b; margin-bottom: 15px;">Send a blast email to all ${totalSubscribers} subscribed users.</p>
                        <c:if test="${not empty newsletterSuccess}">
                            <div style="background: #ecfdf5; color: #065f46; padding: 12px; border-radius: 8px; margin-bottom: 15px; font-size: 13px; font-weight: 600; border: 1px solid #d1fae5;">
                                &#x2705; ${newsletterSuccess}
                            </div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/admin/newsletter/send" method="POST">
                            <div class="form-group" style="margin-bottom: 15px;">
                                <label style="display: block; margin-bottom: 8px; font-size: 13px; color: #475569; font-weight: 600;">Subject</label>
                                <input type="text" name="subject" placeholder="e.g. New Clinic Timings" required style="width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #dcfce7; background: #fff; color: #1e293b; outline: none;" />
                            </div>
                            <div class="form-group">
                                <label style="display: block; margin-bottom: 8px; font-size: 13px; color: #475569; font-weight: 600;">Message Content</label>
                                <textarea name="message" style="width: 100%; padding: 12px; border-radius: 10px; background: #ffffff; border: 1px solid #dcfce7; color: #1e293b; min-height: 120px; outline: none; font-family: inherit;" placeholder="Write your announcement here..." required></textarea>
                            </div>
                            <button type="submit" style="width: 100%; margin-top: 15px; padding: 14px; background: #10b981; color: #fff; border: none; border-radius: 12px; font-weight: 800; cursor: pointer; transition: 0.3s; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);">Send Update Now</button>
                        </form>
                    </div>
                </div>

                <div class="card" style="background: #ffffff; border: 1px solid #DCFCE7;">
                    <div class="card-header">
                        <h3 style="color: #064e3b;">📧 Active Subscriptions</h3>
                    </div>
                    <div style="max-height: 500px; overflow-y: auto;">
                        <table class="data-table" style="width: 100%; border-collapse: collapse;">
                            <thead style="background: #f8fafc; position: sticky; top: 0; z-index: 1;">
                                <tr>
                                    <th style="padding: 12px; text-align: left; font-size: 11px; color: #64748b; text-transform: uppercase; border-bottom: 2px solid #f1f5f9;">Email Address</th>
                                    <th style="padding: 12px; text-align: left; font-size: 11px; color: #64748b; text-transform: uppercase; border-bottom: 2px solid #f1f5f9;">Joined</th>
                                    <th style="padding: 12px; text-align: right; font-size: 11px; color: #64748b; text-transform: uppercase; border-bottom: 2px solid #f1f5f9;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty newsletterSubscriptions}">
                                        <c:forEach var="sub" items="${newsletterSubscriptions}">
                                            <tr style="border-bottom: 1px solid #f8fafc;">
                                                <td style="padding: 14px 12px; color: #1e293b; font-weight: 600; font-size: 14px;">${sub.email}</td>
                                                <td style="padding: 14px 12px; color: #64748b; font-size: 12px;">${sub.subscribedAt}</td>
                                                <td style="padding: 14px 12px; text-align: right;">
                                                    <form action="${pageContext.request.contextPath}/admin/newsletter/remove/${sub.id}" method="POST" style="display: inline;">
                                                        <button type="submit" style="padding: 6px 12px; border-radius: 8px; background: #fef2f2; color: #ef4444; border: 1px solid #fee2e2; font-size: 11px; cursor: pointer; font-weight: 700; transition: 0.2s;" onclick="return confirm('Are you sure you want to remove this subscriber?')">Remove</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="3" style="text-align:center; padding: 60px; color: #94a3b8;">
                                                <div style="font-size: 40px; margin-bottom: 10px; opacity: 0.3;">&#x1F4EC;</div>
                                                <p style="font-size: 14px; font-weight: 500;">No active subscriptions yet</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Analytics Section -->
        <div id="analytics-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F4C8;</span> Performance & Reports
            </div>
            
            <div class="cards-row">
                <div class="card">
                    <div class="card-header">
                        <h3>&#x1F4C8; Analytics Overview</h3>
                    </div>
                    <div class="mini-stats" style="margin-bottom:16px;">
                        <div class="mini-stat">
                            <h4>${totalVisits}</h4>
                            <p>Total Visits</p>
                        </div>
                        <div class="mini-stat">
                            <h4>${totalAppointments}</h4>
                            <p>All Appointments</p>
                        </div>
                        <div class="mini-stat">
                            <h4>${pendingLabRequests}</h4>
                            <p>Lab Requests</p>
                        </div>
                    </div>
                    <!-- Revenue Summary Placeholder -->
                    <div style="padding:16px; border-radius:12px; background:rgba(108,99,255,0.06); border:1px solid rgba(108,99,255,0.1); margin-bottom:12px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <div>
                                <div style="font-size:12px; color:#64748b; margin-bottom:4px;">Patient Growth</div>
                                <div style="font-size:22px; font-weight:800; color:#a78bfa;">${totalPatients} patients</div>
                            </div>
                            <div style="font-size:28px;">&#x1F4C8;</div>
                        </div>
                    </div>
                    <div style="padding:16px; border-radius:12px; background:rgba(16,185,129,0.06); border:1px solid rgba(16,185,129,0.1);">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <div>
                                <div style="font-size:12px; color:#64748b; margin-bottom:4px;">Revenue Trend</div>
                                <div style="font-size:22px; font-weight:800; color:#34d399;">${completedAppointments} completed</div>
                            </div>
                            <div style="font-size:28px;">&#x1F4B0;</div>
                        </div>
                    </div>
                </div>

                <!-- Disease Patterns Card -->
                <div class="card">
                    <div class="card-header">
                        <h3>&#x1F9A0; Disease Patterns</h3>
                    </div>
                    <div class="data-list">
                        <div style="margin-bottom:12px;">
                            <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:5px;">
                                <span>Viral Fever</span>
                                <span style="color:#a78bfa;">42%</span>
                            </div>
                            <div style="height:6px; background:rgba(255,255,255,0.05); border-radius:10px; overflow:hidden;">
                                <div style="width:42%; height:100%; background:#6C63FF;"></div>
                            </div>
                        </div>
                        <div style="margin-bottom:12px;">
                            <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:5px;">
                                <span>Hypertension</span>
                                <span style="color:#a78bfa;">28%</span>
                            </div>
                            <div style="height:6px; background:rgba(255,255,255,0.05); border-radius:10px; overflow:hidden;">
                                <div style="width:28%; height:100%; background:#8E2DE2;"></div>
                            </div>
                        </div>
                        <div style="margin-bottom:12px;">
                            <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:5px;">
                                <span>Diabetes Type II</span>
                                <span style="color:#a78bfa;">15%</span>
                            </div>
                            <div style="height:6px; background:rgba(255,255,255,0.05); border-radius:10px; overflow:hidden;">
                                <div style="width:15%; height:100%; background:#a78bfa;"></div>
                            </div>
                        </div>
                        <div style="margin-bottom:12px;">
                            <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:5px;">
                                <span>Common Cold</span>
                                <span style="color:#a78bfa;">10%</span>
                            </div>
                            <div style="height:6px; background:rgba(255,255,255,0.05); border-radius:10px; overflow:hidden;">
                                <div style="width:10%; height:100%; background:#c4b5fd;"></div>
                            </div>
                        </div>
                        <div style="font-size:11px; color:#64748b; margin-top:15px; font-style:italic;">
                            * Patterns based on top 4 most diagnosed cases this month.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Staff Management Section -->
        <div id="staff-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F465;</span> Staff Management & Directory
            </div>

            <!-- Role-wise Staff Count -->
            <div class="stats-row" style="grid-template-columns:repeat(6,1fr); margin-bottom:20px;">
                <div class="stat-box" style="padding:16px; text-align:center;">
                    <div style="font-size:24px;">&#x1FA7A;</div>
                    <h3 style="font-size:24px;">${totalDoctors}</h3>
                    <p>Doctors</p>
                </div>
                <div class="stat-box green" style="padding:16px; text-align:center;">
                    <div style="font-size:24px;">&#x1F3E5;</div>
                    <h3 style="font-size:24px;">${totalReceptionists}</h3>
                    <p>Receptionists</p>
                </div>
                <div class="stat-box orange" style="padding:16px; text-align:center;">
                    <div style="font-size:24px;">&#x1F9EA;</div>
                    <h3 style="font-size:24px;">${totalLabUsers}</h3>
                    <p>Lab Staff</p>
                </div>
                <div class="stat-box" style="padding:16px; text-align:center;">
                    <div style="font-size:24px;">&#x1F48A;</div>
                    <h3 style="font-size:24px;">${totalPharmacy}</h3>
                    <p>Pharmacy</p>
                </div>
                <div class="stat-box red" style="padding:16px; text-align:center;">
                    <div style="font-size:24px;">&#x1F69A;</div>
                    <h3 style="font-size:24px;">${totalDelivery}</h3>
                    <p>Delivery</p>
                </div>
                <div class="stat-box green" style="padding:16px; text-align:center;">
                    <div style="font-size:24px;">&#x1F477;</div>
                    <h3 style="font-size:24px;">${totalStaff}</h3>
                    <p>Other Staff</p>
                </div>
            </div>

            <!-- Staff Directory Table -->
            <div class="card">
                <div class="card-header">
                    <h3>&#x1F4CB; All Registered Users</h3>
                    <span class="badge badge-role">Total: ${totalUsers}</span>
                </div>
                <c:choose>
                    <c:when test="${not empty allUsers}">
                        <table class="data-table">
                            <thead>
                                <tr><th>Name</th><th>Role</th><th>Attendance</th><th>Check-In</th><th>Check-Out</th><th>Shift</th><th>Action</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${allUsers}">
                                    <c:if test="${u.role != 'Admin' && u.role != 'Doctor' && u.role != 'Delivery'}">
                                    <tr>
                                        <td>
                                            <div style="display:flex; align-items:center; gap:10px;">
                                                <div class="staff-avatar" style="width:32px; height:32px; font-size:13px; border-radius:8px;">
                                                    ${u.fullName.substring(0,1)}
                                                </div>
                                                <div>
                                                    <div style="font-weight:600;">${u.fullName}</div>
                                                    <div style="font-size:11px; color:#64748b;">${u.email}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="badge badge-role">${u.role}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.attendanceStatus == 'Present'}"><span class="badge badge-completed">Present</span></c:when>
                                                <c:when test="${u.attendanceStatus == 'Absent'}"><span class="badge badge-cancelled">Absent</span></c:when>
                                                <c:when test="${u.attendanceStatus == 'Half Day'}"><span class="badge badge-pending">Half Day</span></c:when>
                                                <c:otherwise><span class="badge badge-pending">Pending</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${u.checkInTime != null && u.checkInTime != 'null' ? u.checkInTime : '--:--'}</td>
                                        <td>${u.checkOutTime != null && u.checkOutTime != 'null' ? u.checkOutTime : '--:--'}</td>
                                        <td><span class="badge badge-role" style="background:rgba(255,255,255,0.05);">${u.shiftTiming != null ? u.shiftTiming : 'Not Assigned'}</span></td>
                                        <td>
                                            <div style="display:flex; gap:5px;">
                                                <button onclick="openAttendanceModal('${u.id}', '${u.fullName}', '${u.attendanceStatus}')" title="Attendance" style="background:rgba(16,185,129,0.1); border:none; padding:6px; border-radius:6px; color:#34d399; cursor:pointer;">&#x2705;</button>
                                                <button onclick="openShiftModal('${u.id}', '${u.fullName}')" title="Assign Shift" style="background:rgba(108,99,255,0.1); border:none; padding:6px; border-radius:6px; color:#a78bfa; cursor:pointer;">&#x231B;</button>
                                                <button onclick="openReportModal('${u.id}', '${u.fullName}')" title="Attendance Report" style="background:rgba(99,102,241,0.1); border:none; padding:6px; border-radius:6px; color:#6366f1; cursor:pointer;">📊</button>
                                            </div>
                                        </td>
                                    </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">&#x1F465;</div>
                            <p>No users registered</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                </div>


                <div class="card">
                    <div class="card-header">
                        <h3>&#x1F4C5; Active Shift Schedule</h3>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Name</th><th>Role</th><th>Shift Timing</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${allUsers}">
                                <c:if test="${u.role != 'Admin' && u.role != 'Doctor' && u.role != 'Delivery' && u.shiftTiming != null}">
                                <tr>
                                    <td>${u.fullName}</td>
                                    <td>${u.role}</td>
                                    <td><span class="badge badge-role">${u.shiftTiming}</span></td>
                                </tr>
                                </c:if>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>


        </div>

        <!-- Visitors Messages Section -->
        <div id="visitors-messages-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F4E8;</span> Visitors Messages
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>&#x1F4E8; Recent Messages from Visitors</h3>
                </div>
                <c:choose>
                    <c:when test="${not empty visitorMessages}">
                        <table class="data-table">
                            <thead>
                                <tr><th>Name</th><th>Email</th><th>Message</th><th>Date</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="msg" items="${visitorMessages}">
                                    <tr>
                                        <td style="font-weight:600; color:#10b981;">${msg.name}</td>
                                        <td>${msg.email}</td>
                                        <td style="max-width:300px; white-space:normal; line-height:1.4; color: #334155;">${msg.message}</td>
                                        <td style="font-size:11px; color:#64748b;">${msg.submittedAt}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">&#x1F4E8;</div>
                            <p>No messages from visitors yet</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Staff Requests Section -->
        <div id="staff-requests-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F4DD;</span> Staff Leave Requests
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>&#x1F4DD; Pending & Recent Requests</h3>
                </div>
                <c:choose>
                    <c:when test="${not empty leaveRequests}">
                        <table class="data-table">
                            <thead>
                                <tr><th>Staff Name</th><th>Role</th><th>Reason</th><th>Period</th><th>Status</th><th>Action</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="req" items="${leaveRequests}">
                                    <tr>
                                        <td style="font-weight:600; color: #10b981;">${req.user.fullName}</td>
                                        <td><span class="badge badge-role">${req.user.role}</span></td>
                                        <td style="max-width:200px; white-space:normal; color: #334155;">${req.reason}</td>
                                        <td style="color: #475569;">${req.startDate} to ${req.endDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${req.status == 'Approved'}"><span class="badge badge-completed">Approved</span></c:when>
                                                <c:when test="${req.status == 'Rejected'}"><span class="badge badge-cancelled">Rejected</span></c:when>
                                                <c:otherwise><span class="badge badge-pending">Pending</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${req.status == 'Pending'}">
                                                <div style="display:flex; gap:5px;">
                                                    <form action="/admin/approve-leave" method="post" style="display:inline;">
                                                        <input type="hidden" name="id" value="${req.id}">
                                                        <button type="submit" style="background:#10b981; color:#fff; border:none; padding:6px 12px; border-radius:6px; font-size:11px; font-weight:600; cursor:pointer; transition: 0.2s;">Approve</button>
                                                    </form>
                                                    <form action="/admin/reject-leave" method="post" style="display:inline;">
                                                        <input type="hidden" name="id" value="${req.id}">
                                                        <button type="submit" style="background:#ef4444; color:#fff; border:none; padding:6px 12px; border-radius:6px; font-size:11px; font-weight:600; cursor:pointer; transition: 0.2s;">Reject</button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">&#x1F4DD;</div>
                            <p>No staff requests at the moment</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Analytics Section -->
        <div id="analytics-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F4C8;</span> Performance & Reports
            </div>
            
            <div class="cards-row">
                <div class="card">
                    <div class="card-header">
                        <h3>&#x1F4C8; Analytics Overview</h3>
                    </div>
                    <div class="mini-stats" style="margin-bottom:16px;">
                        <div class="mini-stat">
                            <h4>${totalVisits}</h4>
                            <p>Total Visits</p>
                        </div>
                        <div class="mini-stat">
                            <h4>${totalAppointments}</h4>
                            <p>All Appointments</p>
                        </div>
                        <div class="mini-stat">
                            <h4>${pendingLabRequests}</h4>
                            <p>Lab Requests</p>
                        </div>
                    </div>
                    <div style="padding:16px; border-radius:12px; background:rgba(108,99,255,0.06); border:1px solid rgba(108,99,255,0.1); margin-bottom:12px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <div>
                                <div style="font-size:12px; color:#64748b; margin-bottom:4px;">Patient Growth</div>
                                <div style="font-size:22px; font-weight:800; color:#a78bfa;">${totalPatients} patients</div>
                            </div>
                            <div style="font-size:28px;">&#x1F4C8;</div>
                        </div>
                    </div>
                    <div style="padding:16px; border-radius:12px; background:rgba(16,185,129,0.06); border:1px solid rgba(16,185,129,0.1);">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <div>
                                <div style="font-size:12px; color:#64748b; margin-bottom:4px;">Revenue Trend</div>
                                <div style="font-size:22px; font-weight:800; color:#34d399;">${completedAppointments} completed</div>
                            </div>
                            <div style="font-size:28px;">&#x1F4B0;</div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>&#x1F9A0; Disease Patterns</h3>
                    </div>
                    <div class="data-list">
                        <div style="margin-bottom:12px;">
                            <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:5px;">
                                <span>Viral Fever</span>
                                <span style="color:#a78bfa;">42%</span>
                            </div>
                            <div style="height:6px; background:rgba(255,255,255,0.05); border-radius:10px; overflow:hidden;">
                                <div style="width:42%; height:100%; background:#6C63FF;"></div>
                            </div>
                        </div>
                        <div style="margin-bottom:12px;">
                            <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:5px;">
                                <span>Hypertension</span>
                                <span style="color:#a78bfa;">28%</span>
                            </div>
                            <div style="height:6px; background:rgba(255,255,255,0.05); border-radius:10px; overflow:hidden;">
                                <div style="width:28%; height:100%; background:#8E2DE2;"></div>
                            </div>
                        </div>
                        <div style="margin-bottom:12px;">
                            <div style="display:flex; justify-content:space-between; font-size:13px; margin-bottom:5px;">
                                <span>Diabetes Type II</span>
                                <span style="color:#a78bfa;">15%</span>
                            </div>
                            <div style="height:6px; background:rgba(255,255,255,0.05); border-radius:10px; overflow:hidden;">
                                <div style="width:15%; height:100%; background:#a78bfa;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- System Health Section -->
        <div id="health-section" class="content-section">
            <div class="section-title">
                <span class="title-icon">&#x1F6E1;</span> System Health & Inventory
            </div>
            
            <div class="cards-row">
                <div class="card">
                    <div class="card-header"><h3>&#x1F4E6; Detailed Inventory Status</h3></div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Item Name</th><th>Category</th><th>Current Stock</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="stock" items="${lowStocks}">
                                <tr>
                                    <td>${stock.item}</td>
                                    <td>Pharmacy</td>
                                    <td style="color:#ef4444; font-weight:600;">${stock.count}</td>
                                    <td><span class="badge ${stock.status == 'Critical' ? 'badge-cancelled' : 'badge-pending'}">${stock.status}</span></td>
                                </tr>
                            </c:forEach>
                            <tr><td>Antibiotics Pack</td><td>Pharmacy</td><td>120 units</td><td><span class="badge badge-completed">Stable</span></td></tr>
                            <tr><td>Bandages (L)</td><td>Medical</td><td>340 units</td><td><span class="badge badge-completed">Stable</span></td></tr>
                        </tbody>
                    </table>
                </div>

                <div class="card">
                    <div class="card-header"><h3>&#x1F4B5; Recent Pending Bills</h3></div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Patient</th><th>Invoice Date</th><th>Amount</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="bill" items="${pendingBills}">
                                <tr>
                                    <td>${bill.patient}</td>
                                    <td>Today</td>
                                    <td style="color:#34d399; font-weight:700;">${bill.amount}</td>
                                    <td><span class="badge badge-pending">Unpaid</span></td>
                                </tr>
                            </c:forEach>
                            <tr><td>John Smith</td><td>Yesterday</td><td style="color:#34d399; font-weight:700;">$45.00</td><td><span class="badge badge-pending">Unpaid</span></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Attendance Modal -->
<div id="attendanceModal" class="modal">
    <div class="modal-content">
        <div class="modal-header"><h3>Update Attendance: <span id="attName"></span></h3></div>
        <form action="/admin/update-attendance" method="POST">
            <input type="hidden" name="userId" id="attUserId">
            <div class="form-group">
                <label>Status</label>
                <select name="status" id="attStatus">
                    <option value="Present">Present</option>
                    <option value="Absent">Absent</option>
                    <option value="Half Day">Half Day</option>
                </select>
            </div>
            <button type="submit" class="modal-btn">Update Attendance</button>
            <button type="button" onclick="closeModal('attendanceModal')" style="background:transparent; color:#64748b; border:none; width:100%; margin-top:10px; cursor:pointer;">Cancel</button>
        </form>
    </div>
</div>

<!-- Attendance Report Modal (White Theme) -->
<div id="attendanceReportModal" class="modal">
    <div class="modal-content" style="max-width: 1000px; background: #ffffff; color: #0f172a; border-radius: 28px; padding: 40px; width: 95%; margin: 2% auto; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); border: 1px solid rgba(0,0,0,0.05); max-height: 90vh; overflow-y: auto;">
        <div class="modal-header" style="border-bottom: 2px solid #f1f5f9; padding-bottom: 25px; margin-bottom: 35px; display: flex; justify-content: space-between; align-items: center;">
            <h3 style="color: #0f172a; font-size: 28px; font-weight: 900; margin: 0; letter-spacing: -0.5px;">📊 Attendance Report</h3>
            <span id="reportStaffName" style="background: #f1f5f9; color: #4338ca; padding: 10px 24px; border-radius: 14px; font-size: 16px; font-weight: 800; border: 1px solid #e2e8f0;"></span>
        </div>

        <!-- Summary Cards Centered -->
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-bottom: 45px;">
            <div style="background: #f0fdf4; border: 2px solid #dcfce7; padding: 30px 20px; border-radius: 24px; text-align: center; box-shadow: 0 10px 15px -3px rgba(22, 163, 74, 0.05);">
                <div style="font-size: 42px; font-weight: 900; color: #15803d;" id="totalPresent">0</div>
                <p style="color: #166534; font-size: 13px; font-weight: 800; margin-top: 10px; text-transform: uppercase; letter-spacing: 1px;">Present Days</p>
            </div>
            <div style="background: #fef2f2; border: 2px solid #fee2e2; padding: 30px 20px; border-radius: 24px; text-align: center; box-shadow: 0 10px 15px -3px rgba(220, 38, 38, 0.05);">
                <div style="font-size: 42px; font-weight: 900; color: #b91c1c;" id="totalAbsent">0</div>
                <p style="color: #991b1b; font-size: 13px; font-weight: 800; margin-top: 10px; text-transform: uppercase; letter-spacing: 1px;">Absent Days</p>
            </div>
            <div style="background: #fffbeb; border: 2px solid #fef3c7; padding: 30px 20px; border-radius: 24px; text-align: center; box-shadow: 0 10px 15px -3px rgba(217, 119, 6, 0.05);">
                <div style="font-size: 42px; font-weight: 900; color: #b45309;" id="totalHalfDay">0</div>
                <p style="color: #92400e; font-size: 13px; font-weight: 800; margin-top: 10px; text-transform: uppercase; letter-spacing: 1px;">Half Days</p>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1.3fr; gap: 40px;">
            <!-- Monthly Summary Table -->
            <div>
                <h4 style="font-size: 18px; font-weight: 800; color: #1e293b; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    📅 Monthly Summary
                </h4>
                <div style="background: #ffffff; border: 1px solid #e2e8f0; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02);">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead style="background: #f8fafc;">
                            <tr>
                                <th style="padding: 16px 20px; text-align: left; font-size: 12px; color: #475569; text-transform: uppercase; font-weight: 700; border-bottom: 2px solid #f1f5f9;">Month</th>
                                <th style="padding: 16px; text-align: center; font-size: 12px; color: #16a34a; font-weight: 800; border-bottom: 2px solid #f1f5f9;">P</th>
                                <th style="padding: 16px; text-align: center; font-size: 12px; color: #dc2626; font-weight: 800; border-bottom: 2px solid #f1f5f9;">A</th>
                                <th style="padding: 16px; text-align: center; font-size: 12px; color: #d97706; font-weight: 800; border-bottom: 2px solid #f1f5f9;">H</th>
                            </tr>
                        </thead>
                        <tbody id="reportMonthlyBody" style="font-size: 14px; color: #334155;"></tbody>
                    </table>
                </div>
            </div>

            <!-- Detailed History Log -->
            <div>
                <h4 style="font-size: 18px; font-weight: 800; color: #1e293b; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    📝 Detailed History
                </h4>
                <div style="background: #ffffff; border: 1px solid #e2e8f0; border-radius: 20px; overflow-y: auto; max-height: 320px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02);">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead style="background: #f8fafc; position: sticky; top: 0; z-index: 10;">
                            <tr>
                                <th style="padding: 16px 25px; text-align: left; font-size: 12px; color: #475569; text-transform: uppercase; font-weight: 700; border-bottom: 2px solid #f1f5f9;">Date</th>
                                <th style="padding: 16px 25px; text-align: right; font-size: 12px; color: #475569; text-transform: uppercase; font-weight: 700; border-bottom: 2px solid #f1f5f9;">Status</th>
                            </tr>
                        </thead>
                        <tbody id="reportDetailedBody" style="font-size: 14px; color: #334155;"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <div style="margin-top: 45px; display: flex; justify-content: flex-end;">
            <button type="button" onclick="closeModal('attendanceReportModal')" style="padding: 16px 50px; background: #0f172a; color: white; border: none; border-radius: 16px; font-size: 15px; font-weight: 800; cursor: pointer; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.3);">
                Close Report
            </button>
        </div>
    </div>
</div>

<!-- Shift Modal -->
<div id="shiftModal" class="modal">
    <div class="modal-content">
        <div class="modal-header"><h3>Assign Shift: <span id="shiftName"></span></h3></div>
        <form action="/admin/assign-shift" method="POST">
            <input type="hidden" name="userId" id="shiftUserId">
            <div class="form-group">
                <label>Shift Type</label>
                <select name="shiftType">
                    <option value="Day Shift">Day Shift</option>
                    <option value="Night Shift">Night Shift</option>
                </select>
            </div>
            <div class="form-group">
                <label>Shift Date</label>
                <input type="date" name="shiftDate" required>
            </div>
            <div class="form-group" style="display:flex; gap:10px;">
                <div style="flex:1;">
                    <label>Start Time</label>
                    <input type="time" name="startTime" required value="09:00">
                </div>
                <div style="flex:1;">
                    <label>End Time</label>
                    <input type="time" name="endTime" required value="17:00">
                </div>
            </div>
            <button type="submit" class="modal-btn">Assign Shift</button>
            <button type="button" onclick="closeModal('shiftModal')" style="background:transparent; color:#64748b; border:none; width:100%; margin-top:10px; cursor:pointer;">Cancel</button>
        </form>
    </div>
</div>



<script>
function showSection(sectionId, element) {
    // Hide all sections
    const sections = document.querySelectorAll('.content-section');
    sections.forEach(s => s.classList.remove('active'));
    
    // Show target section
    document.getElementById(sectionId).classList.add('active');
    
    // Update nav active state
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => item.classList.remove('active'));
    if(element) element.classList.add('active');
}

function openAttendanceModal(id, name, status) {
    document.getElementById('attUserId').value = id;
    document.getElementById('attName').innerText = name;
    document.getElementById('attStatus').value = status || 'Present';
    document.getElementById('attendanceModal').style.display = 'block';
}

const allAttendances = [
    <c:forEach var="a" items="${allAttendances}" varStatus="status">
        {
            userId: "${a.user.id}",
            date: "${a.date}",
            status: "${a.status}"
        }${not status.last ? ',' : ''}
    </c:forEach>
];

function openReportModal(userId, name) {
    document.getElementById('reportStaffName').innerText = name;
    
    const userAtts = allAttendances.filter(a => a.userId == userId).sort((a,b) => new Date(b.date) - new Date(a.date));
    
    let present = 0;
    let absent = 0;
    let halfDay = 0;
    
    const monthlyData = {};
    const detailedBody = document.getElementById('reportDetailedBody');
    detailedBody.innerHTML = '';
    
    userAtts.forEach(a => {
        if (a.status === 'Present') present++;
        else if (a.status === 'Absent') absent++;
        else if (a.status === 'Half Day') halfDay++;
        
        const dateObj = new Date(a.date);
        const monthYear = dateObj.toLocaleString('default', { month: 'long', year: 'numeric' });
        
        if (!monthlyData[monthYear]) {
            monthlyData[monthYear] = { present: 0, absent: 0, halfDay: 0 };
        }
        
        if (a.status === 'Present') monthlyData[monthYear].present++;
        else if (a.status === 'Absent') monthlyData[monthYear].absent++;
        else if (a.status === 'Half Day') monthlyData[monthYear].halfDay++;
        
        // Add to detailed log
        let statusColor = '#16a34a';
        if (a.status === 'Absent') statusColor = '#dc2626';
        if (a.status === 'Half Day') statusColor = '#d97706';
        
        const row = `<tr style="border-bottom: 1px solid #f1f5f9;">
            <td style="padding: 12px 20px; color: #475569; font-weight: 500;">${a.date}</td>
            <td style="padding: 12px 20px; text-align: right;"><span style="color: ${statusColor}; font-weight: 700; font-size: 11px; text-transform: uppercase;">${a.status}</span></td>
        </tr>`;
        detailedBody.innerHTML += row;
    });
    
    document.getElementById('totalPresent').innerText = present;
    document.getElementById('totalAbsent').innerText = absent;
    document.getElementById('totalHalfDay').innerText = halfDay;
    
    const tbody = document.getElementById('reportMonthlyBody');
    tbody.innerHTML = '';
    
    const sortedMonths = Object.keys(monthlyData).sort((a,b) => new Date(b) - new Date(a));
    
    if (sortedMonths.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:60px; color:#64748b; font-style:italic; font-size:16px; font-weight:600;">No attendance records found for this staff member</td></tr>';
        detailedBody.innerHTML = '<tr><td colspan="2" style="text-align:center; padding:60px; color:#64748b; font-style:italic; font-size:16px; font-weight:600;">No detailed history available</td></tr>';
    } else {
        sortedMonths.forEach(month => {
            const row = `<tr style="border-bottom: 1px solid #f1f5f9;">
                <td style="padding: 16px 20px; font-weight:700; color: #1e293b;">${month}</td>
                <td style="padding: 16px; text-align: center; color:#16a34a; font-weight:900; font-size:15px;">${monthlyData[month].present}</td>
                <td style="padding: 16px; text-align: center; color:#dc2626; font-weight:900; font-size:15px;">${monthlyData[month].absent}</td>
                <td style="padding: 16px; text-align: center; color:#d97706; font-weight:900; font-size:15px;">${monthlyData[month].halfDay}</td>
            </tr>`;
            tbody.innerHTML += row;
        });
    }
    
    document.getElementById('attendanceReportModal').style.display = 'block';
}

function openShiftModal(id, name) {
    document.getElementById('shiftUserId').value = id;
    document.getElementById('shiftName').innerText = name;
    document.getElementById('shiftModal').style.display = 'block';
}

function closeModal(id) {
    document.getElementById(id).style.display = 'none';
}



// Close modals when clicking outside
window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = "none";
    }
}

// Handle hash-based section toggling on load
window.addEventListener('load', function() {
    const hash = window.location.hash;
    if (hash) {
        const sectionId = hash.substring(1);
        const section = document.getElementById(sectionId);
        if (section && section.classList.contains('content-section')) {
            // Find the corresponding nav item
            const navItem = document.querySelector(`.nav-item[onclick*="${sectionId}"]`);
            showSection(sectionId, navItem);
        }
    }
});
</script>
</body>
</html>
