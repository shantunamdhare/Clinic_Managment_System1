<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lab Dashboard | MediCare+</title>
    <!-- Core Style -->
    <link rel="stylesheet" href="/css/style.css">
    <!-- Dashboard Specific Style -->
    <link rel="stylesheet" href="/css/dashboard.css">
    <!-- Leaflet Map -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
    <style>
        /* Modern Premium Modal */
        #patientFullModal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(15, 23, 42, 0.7);
            backdrop-filter: blur(8px);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 20px;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-container {
            background: #ffffff;
            width: 100%;
            max-width: 850px;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: slideUp 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex;
            flex-direction: column;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .modal-top {
            background: var(--gradient-1);
            padding: 24px 32px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-info-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 40px;
            padding: 32px;
        }

        .info-card {
            background: var(--gray-50);
            padding: 24px;
            border-radius: 16px;
            border: 1px solid var(--gray-200);
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        .info-row:last-child { border-bottom: none; }

        .label { color: var(--gray-500); font-size: 13px; font-weight: 500; }
        .value { color: var(--gray-900); font-weight: 700; font-size: 14px; }

        .status-pill {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .modal-action-bar {
            background: var(--gray-50);
            padding: 20px 32px;
            display: flex;
            justify-content: flex-end;
            gap: 16px;
            border-top: 1px solid var(--gray-200);
        }

        .btn-modern {
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
            border: none;
        }

        .btn-close-record { background: var(--gray-200); color: var(--gray-700); }
        .btn-close-record:hover { background: var(--gray-300); }

        .btn-print-record { background: var(--primary); color: white; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3); }
        .btn-print-record:hover { transform: translateY(-1px); box-shadow: 0 6px 15px rgba(79, 70, 229, 0.4); }

        /* Map Styles */
        #logistics-map {
            height: 500px;
            width: 100%;
            border-radius: 16px;
            margin-top: 20px;
            border: 1px solid var(--gray-200);
            z-index: 1;
        }
        .map-marker-label {
            font-weight: 700;
            font-size: 12px;
            color: var(--primary);
        }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        
        <!-- ==================== SIDEBAR ==================== -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="logo-icon">M+</div>
                <h2>MediCare+</h2>
            </div>
            
            <nav class="sidebar-nav">
                <a href="#" class="nav-item active" onclick="event.preventDefault(); showSection('overview-section', event)">
                    <span class="material-symbols-outlined">dashboard</span>
                    Dashboard Overview
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('requests-section', event)">
                    <span class="material-symbols-outlined">experiment</span>
                    Test Requests
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); clearDoctorBadge(); showSection('doctor-requests-section', event)" style="position: relative;">
                    <span class="material-symbols-outlined">assignment_ind</span>
                    Doctor Requests
                    <c:if test="${not empty doctorRequests && doctorRequests.size() > 0}">
                        <span id="dr-badge" style="background: var(--error); color: white; border-radius: 50%; padding: 2px 6px; font-size: 10px; position: absolute; right: 15px; top: 12px; font-weight: 800;">${doctorRequests.size()}</span>
                    </c:if>
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('samples-section', event)">
                    <span class="material-symbols-outlined">bloodtype</span>
                    Sample Collection
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('pending-section', event)">
                    <span class="material-symbols-outlined">pending_actions</span>
                    Pending Reports
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('inprogress-section', event)">
                    <span class="material-symbols-outlined">science</span>
                    In-Progress Tests
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('completed-section', event)">
                    <span class="material-symbols-outlined">task_alt</span>
                    Completed Reports
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('reports-section', event)">
                    <span class="material-symbols-outlined">upload_file</span>
                    Upload Reports
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('patients-section', event)">
                    <span class="material-symbols-outlined">folder_shared</span>
                    Patient Records
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('logistics-section', event)">
                    <span class="material-symbols-outlined">local_shipping</span>
                    Logistics & Samples
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('attendance-section', event)">
                    <span class="material-symbols-outlined">calendar_today</span>
                    Attendance
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('shifts-section', event)">
                    <span class="material-symbols-outlined">schedule</span>
                    Shift Schedule
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('performance-section', event)">
                    <span class="material-symbols-outlined">analytics</span>
                    Performance
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('profile-section', event)">
                    <span class="material-symbols-outlined">person</span>
                    My Profile
                </a>
                <a href="#" class="nav-item" onclick="event.preventDefault(); showSection('notifications-section', event)">
                    <span class="material-symbols-outlined">notifications</span>
                    Notifications
                </a>
            </nav>
        </aside>

        <!-- ==================== MAIN CONTENT ==================== -->
        <main class="main-content">
            
            <!-- TOPBAR -->
            <header class="topbar">
                <div class="topbar-search">
                    <span class="material-symbols-outlined">search</span>
                    <input type="text" placeholder="Search tests, patients, or reports...">
                </div>
                
                <div class="topbar-actions">
                    <div class="notification-wrapper" style="position: relative;">
                        <button class="action-btn" onclick="toggleNotifications(event)">
                            <span class="material-symbols-outlined">notifications</span>
                            <span class="badge" style="display: none;">0</span>
                        </button>
                        
                        <!-- NOTIFICATION DROPDOWN -->
                        <div id="notificationDropdown" class="section-card" style="display: none; position: absolute; top: 100%; right: 0; width: 320px; z-index: 1000; margin-top: 10px; padding: 0; box-shadow: var(--shadow-lg); overflow: hidden;">
                            <div class="section-header" style="padding: 12px 16px;">
                                <h3 style="font-size: 14px; font-weight: 700;">Notifications</h3>
                            </div>
                            <div class="notification-list" style="max-height: 400px; overflow-y: auto;">
                                <div style="padding: 16px; text-align: center; color: var(--gray-500); font-size: 13px;">
                                    No new notifications
                                </div>
                            </div>
                            <div style="padding: 12px; text-align: center; border-top: 1px solid var(--gray-100);">
                                <a href="#" style="font-size: 12px; color: var(--primary); font-weight: 600; text-decoration: none;">View All Notifications</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="user-profile" onclick="showSection('profile-section', event)" style="cursor: pointer;">
                        <img src="/img/lab_tech_avatar.png" alt="Lab Technician Profile">
                        <div class="user-info">
                            <span class="user-name">${not empty user.fullName ? user.fullName : 'Dr. Sarah Jenkins'}</span>
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <span class="user-role">${not empty user.labName ? user.labName : 'Senior Lab Technician'}</span>
                                <c:if test="${not empty user.labId}">
                                    <span style="background: var(--primary-light); color: var(--primary); padding: 2px 8px; border-radius: 10px; font-size: 10px; font-weight: 700;">${user.labId}</span>
                                </c:if>
                            </div>
                            <c:if test="${not empty user.labAddress}">
                                <div style="font-size: 11px; color: var(--gray-500); margin-top: 2px;">
                                    <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: middle;">location_on</span>
                                    ${user.labAddress}
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <a href="/" class="action-btn" title="Logout" style="margin-left: 12px; border-left: 1px solid var(--gray-200); padding-left: 20px;">
                        <span class="material-symbols-outlined">logout</span>
                    </a>
                </div>
            </header>

            <!-- DASHBOARD CONTENT -->
            <div class="dashboard-container">
                
                <c:if test="${not empty successMessage}">
                    <div class="alert-success" style="background: var(--success-50); color: var(--success-700); padding: 16px; border-radius: var(--radius-md); margin-bottom: 24px; border: 1px solid var(--success-200); display: flex; align-items: center; gap: 12px;">
                        <span class="material-symbols-outlined">check_circle</span>
                        ${successMessage}
                    </div>
                </c:if>

                <div class="page-header">
                    <h1 class="page-title">Lab Dashboard</h1>
                    <button class="btn-primary" onclick="openNewRequestModal()">
                        <span class="material-symbols-outlined">add</span>
                        New Test Request
                    </button>
                </div>

                <!-- DASHBOARD OVERVIEW SECTION -->
                <div id="overview-section" class="dashboard-section">
                    
                    <!-- HERO BANNER -->
                    <div style="background: linear-gradient(rgba(15, 23, 42, 0.4), rgba(15, 23, 42, 0.7)), url('/img/lab_banner.png') center/cover no-repeat; padding: 48px; border-radius: 24px; margin-bottom: 32px; display: flex; align-items: center; color: white; box-shadow: 0 10px 30px -10px rgba(79, 70, 229, 0.3);">
                        <div style="max-width: 500px;">
                            <h2 style="font-size: 28px; font-weight: 800; margin-bottom: 12px; letter-spacing: -0.5px;">Welcome back, ${not empty user.fullName ? user.fullName : 'Technician'}!</h2>
                            <p style="font-size: 15px; opacity: 0.9; line-height: 1.6; margin-bottom: 12px;">Your modern workspace is ready. You currently have ${patients.size()} pending requests to process and manage today.</p>
                            
                            <!-- Staff Stats Bar (Managed by Admin) -->
                            <div style="display:flex; gap:15px; margin-bottom:24px; background:rgba(255,255,255,0.1); padding:12px; border-radius:12px; backdrop-filter:blur(10px); border:1px solid rgba(255,255,255,0.15);">
                                <div style="flex:1;">
                                    <div style="font-size:9px; font-weight:800; text-transform:uppercase; color:rgba(255,255,255,0.6); margin-bottom:2px;">Attendance</div>
                                    <div style="font-size:12px; font-weight:700;">${user.attendanceStatus != null ? user.attendanceStatus : 'Not Marked'}</div>
                                </div>
                                <div style="flex:1; border-left:1px solid rgba(255,255,255,0.1); padding-left:15px;">
                                    <div style="font-size:9px; font-weight:800; text-transform:uppercase; color:rgba(255,255,255,0.6); margin-bottom:2px;">Shift</div>
                                    <div style="font-size:12px; font-weight:700;">${user.shiftTiming != null ? user.shiftTiming : 'N/A'}</div>
                                </div>
                                <div style="flex:1; border-left:1px solid rgba(255,255,255,0.1); padding-left:15px;">
                                    <div style="font-size:9px; font-weight:800; text-transform:uppercase; color:rgba(255,255,255,0.6); margin-bottom:2px;">Performance</div>
                                    <div style="font-size:12px; font-weight:700; color:#fbbf24;">
                                        <c:choose>
                                            <c:when test="${user.performanceRating != null}">
                                                <c:forEach begin="1" end="${user.performanceRating}">&#x2B50;</c:forEach>
                                            </c:when>
                                            <c:otherwise>Pending</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <button class="btn-primary" style="background: white; color: var(--primary); padding: 12px 24px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);" onclick="openNewRequestModal()">
                                <span class="material-symbols-outlined" style="font-size: 20px;">add_circle</span>
                                Quick Request
                            </button>
                        </div>
                    </div>

                    <c:set var="pendingCount" value="0"/>
                    <c:set var="collectedCount" value="0"/>
                    <c:set var="completedCount" value="0"/>
                    <c:forEach var="p" items="${patients}">
                        <c:if test="${p.deliveryStatus == 'Pending Pickup'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if>
                        <c:if test="${p.deliveryStatus == 'Collected'}"><c:set var="collectedCount" value="${collectedCount + 1}"/></c:if>
                        <c:if test="${p.deliveryStatus == 'Completed'}"><c:set var="completedCount" value="${completedCount + 1}"/></c:if>
                    </c:forEach>

                    <!-- STATS GRID -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-blue">
                                <span class="material-symbols-outlined">experiment</span>
                            </div>
                            <div class="stat-content">
                                <h3>${patients.size()}</h3>
                                <p>Total Test Requests</p>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-yellow">
                                <span class="material-symbols-outlined">bloodtype</span>
                            </div>
                            <div class="stat-content">
                                <h3>${collectedCount}</h3>
                                <p>Samples Collected</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-red">
                                <span class="material-symbols-outlined">hourglass_empty</span>
                            </div>
                            <div class="stat-content">
                                <h3>${pendingCount}</h3>
                                <p>Pending Pickups</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon-wrapper stat-green">
                                <span class="material-symbols-outlined">fact_check</span>
                            </div>
                            <div class="stat-content">
                                <h3>${completedCount}</h3>
                                <p>Completed Reports</p>
                            </div>
                        </div>
                    </div>

                    <!-- ACTIVE TEST REQUESTS TABLE -->
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Recent Test Requests</h2>
                            <button class="section-action" onclick="showSection('requests')">View All Requests &rarr;</button>
                        </div>
                        
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Test Type</th>
                                    <th>Prescribed By</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Delivery Assignment</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}" begin="0" end="2">
                                    <tr>
                                        <td>
                                            <div class="patient-cell">
                                                <div class="patient-avatar" style="background: var(--primary-light); color: var(--primary);">
                                                    ${p.name.substring(0,1)}${p.name.contains(' ') ? p.name.split(' ')[1].substring(0,1) : ''}
                                                </div>
                                                <div class="patient-details">
                                                    <span class="patient-name">${p.name}</span>
                                                    <span class="patient-id">${p.patientId}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td><strong>${not empty p.testType ? p.testType : 'Complete Blood Count (CBC)'}</strong><br><small style="color:var(--gray-500)">${not empty p.collectionType ? p.collectionType : 'Walk-in'}</small></td>
                                        <td>Dr. Emily Chen</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.priority == 'High'}"><span class="status-badge" style="background: var(--error-50); color: var(--error-700);">High</span></c:when>
                                                <c:when test="${p.priority == 'Medium'}"><span class="status-badge" style="background: var(--warning-50); color: var(--warning-700);">Medium</span></c:when>
                                                <c:otherwise><span class="status-badge" style="background: var(--success-50); color: var(--success-700);">${not empty p.priority ? p.priority : 'Normal'}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="status-badge ${p.deliveryStatus == 'Pending Pickup' ? 'status-pending' : 'status-progress'}">${p.deliveryStatus}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.deliveryAssignedTo == 'Not Required'}">
                                                    <span style="color: var(--gray-500); font-size: 12px; font-weight: 700; background: var(--gray-100); padding: 6px 12px; border-radius: 8px; border: 1px solid var(--gray-200); display: inline-flex; align-items: center; gap: 4px;">
                                                        <span class="material-symbols-outlined" style="font-size: 14px;">house</span>
                                                        In-House Lab
                                                    </span>
                                                </c:when>
                                                <c:when test="${not empty p.deliveryAssignedTo && p.deliveryAssignedTo != 'Unassigned'}">
                                                    <span style="color: var(--primary-700); font-size: 12px; font-weight: 700; background: var(--primary-50); padding: 6px 12px; border-radius: 8px; border: 1px solid var(--primary-100); display: inline-flex; align-items: center; gap: 4px;">
                                                        <span class="material-symbols-outlined" style="font-size: 14px;">local_shipping</span>
                                                        ${p.deliveryAssignedTo}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="display: flex; flex-direction: column; gap: 8px;">
                                                        <form action="/assign-delivery" method="POST" style="display: flex; gap: 8px; align-items: center; background: var(--gray-50); padding: 4px; border-radius: 8px; border: 1px solid var(--gray-200);">
                                                            <input type="hidden" name="patientId" value="${p.id}">
                                                            <select name="deliveryUserId" style="border: none; background: transparent; padding: 4px; font-size: 12px; font-weight: 600; color: var(--gray-700); outline: none; flex: 1;" required>
                                                                <option value="" disabled selected>Select Partner...</option>
                                                                <c:forEach var="dp" items="${deliveryPartners}">
                                                                    <option value="${dp.id}">${dp.fullName}</option>
                                                                </c:forEach>
                                                            </select>
                                                            <button type="submit" class="btn-primary" style="padding: 6px 12px; font-size: 11px; border-radius: 6px; white-space: nowrap;">
                                                                Assign
                                                            </button>
                                                        </form>
                                                        
                                                        <form action="/assign-delivery" method="POST">
                                                            <input type="hidden" name="patientId" value="${p.id}">
                                                            <input type="hidden" name="destinationType" value="In-House">
                                                            <button type="submit" style="width: 100%; background: white; color: var(--primary); border: 1px solid var(--primary-200); padding: 6px; border-radius: 8px; font-size: 11px; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 4px; transition: all 0.2s;">
                                                                <span class="material-symbols-outlined" style="font-size: 14px;">house</span>
                                                                Process In-House
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="actions-cell">
                                                <button class="btn-icon view-record-btn" title="View Full Record" 
                                                        data-id="${p.id}" 
                                                        data-name="${p.name}"
                                                        data-pid="${p.patientId}"
                                                        data-gender="${p.gender}"
                                                        data-dob="${p.dateOfBirth}"
                                                        data-contact="${p.contactNumber}"
                                                        data-blood="${p.bloodGroup}"
                                                        data-last="${p.lastVisit}"
                                                        data-status="${p.deliveryStatus}"
                                                        data-executive="${p.deliveryAssignedTo}"
                                                        data-phone="${p.deliveryBoyPhone}"
                                                        data-source="${p.sourceHospital}"
                                                        data-dest="${p.destinationHospital}"
                                                        data-eta="${p.estimatedTime}"
                                                        data-loc="${p.currentLocation}">
                                                    <span class="material-symbols-outlined" style="color: var(--primary); font-size: 22px;">visibility</span>
                                                </button>
                                                <button class="btn-action" onclick="alert('Starting sample collection for ${p.name}...')">Collect Sample</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 60px; color: var(--gray-500);">
                                            <img src="/img/empty_state.png" alt="No Records" style="max-width: 180px; margin-bottom: 20px; border-radius: 16px;">
                                            <h3 style="color: var(--gray-800); font-size: 18px; margin-bottom: 8px;">No recent test requests found</h3>
                                            <p style="font-size: 14px;">Create a new test request to get started.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- DOCTOR REQUESTS SECTION (INCOMING FROM DOCTOR DASHBOARD) -->
                <div id="doctor-requests-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Incoming Doctor Requests</h2>
                            <span class="status-badge" style="background: var(--primary-50); color: var(--primary-700); font-weight: 700;">
                                ${not empty doctorRequests ? doctorRequests.size() : 0} New Requests
                            </span>
                        </div>
                        
                        <div style="padding: 24px; background: #f8fafc; border-bottom: 1px solid var(--gray-100);">
                            <p style="color: var(--gray-600); margin: 0; font-size: 14px;">These are lab tests prescribed by doctors via the Doctor Dashboard. Click "Process" to convert them into active lab tasks.</p>
                        </div>

                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Requested Test</th>
                                    <th>Prescribed By</th>
                                    <th>Status</th>
                                    <th>Priority</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="req" items="${doctorRequests}">
                                    <c:if test="${req.status == 'Pending'}">
                                        <tr>
                                            <td>
                                                <div class="patient-cell">
                                                    <div class="patient-avatar" style="background: var(--primary-light); color: var(--primary);">
                                                        ${req.patient.name.substring(0,1)}
                                                    </div>
                                                    <div class="patient-details">
                                                        <span class="patient-name">${req.patient.name}</span>
                                                        <span class="patient-id">${req.patient.patientId}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><strong>${req.test.name}</strong></td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 8px;">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary);">medical_services</span>
                                                    <span>${req.doctor.fullName}</span>
                                                </div>
                                            </td>
                                            <td><span class="status-badge status-pending">INCOMING</span></td>
                                            <td><span class="status-badge" style="background: #fee2e2; color: #991b1b;">Medium</span></td>
                                            <td>
                                                <form action="/process-lab-request" method="POST">
                                                    <input type="hidden" name="id" value="${req.id}">
                                                    <button type="submit" class="btn-primary" style="padding: 8px 16px; font-size: 12px;">
                                                        Process & Accept
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${empty doctorRequests}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 60px; color: var(--gray-500);">
                                            <span class="material-symbols-outlined" style="font-size: 48px; margin-bottom: 16px; display: block;">inbox</span>
                                            <h3 style="color: var(--gray-800); font-size: 18px; margin-bottom: 8px;">No incoming requests</h3>
                                            <p style="font-size: 14px;">Tests prescribed by doctors will automatically appear here.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div id="requests-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">All Test Requests</h2>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Test Type</th>
                                    <th>Prescribed By</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Current Location</th>
                                    <th>Delivery Assignment</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}">
                                    <tr>
                                        <td>
                                            <div class="patient-cell">
                                                <div class="patient-avatar" style="background: var(--primary-light); color: var(--primary);">
                                                    ${p.name.substring(0,1)}${p.name.contains(' ') ? p.name.split(' ')[1].substring(0,1) : ''}
                                                </div>
                                                <div class="patient-details">
                                                    <span class="patient-name">${p.name}</span>
                                                    <span class="patient-id">${p.patientId}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td><strong>${not empty p.testType ? p.testType : 'Complete Blood Count (CBC)'}</strong><br><small style="color:var(--gray-500)">${not empty p.collectionType ? p.collectionType : 'Walk-in'}</small></td>
                                        <td>Dr. Emily Chen</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.priority == 'High'}"><span class="status-badge" style="background: var(--error-50); color: var(--error-700);">High</span></c:when>
                                                <c:when test="${p.priority == 'Medium'}"><span class="status-badge" style="background: var(--warning-50); color: var(--warning-700);">Medium</span></c:when>
                                                <c:otherwise><span class="status-badge" style="background: var(--success-50); color: var(--success-700);">${not empty p.priority ? p.priority : 'Normal'}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="status-badge ${p.deliveryStatus == 'Pending Pickup' ? 'status-pending' : 'status-progress'}">${p.deliveryStatus}</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 12px; font-weight: 600; color: var(--primary); display: flex; align-items: center; gap: 4px;">
                                                <span class="material-symbols-outlined" style="font-size: 16px;">location_on</span>
                                                ${not empty p.currentLocation ? p.currentLocation : 'At Collection Point'}
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.deliveryAssignedTo == 'Not Required'}">
                                                    <span style="color: var(--gray-500); font-size: 12px; font-weight: 700; background: var(--gray-100); padding: 6px 12px; border-radius: 8px; border: 1px solid var(--gray-200); display: inline-flex; align-items: center; gap: 4px;">
                                                        <span class="material-symbols-outlined" style="font-size: 14px;">house</span>
                                                        In-House Lab
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="/assign-delivery" method="POST" style="display: flex; gap: 8px; align-items: center; background: var(--gray-50); padding: 4px; border-radius: 8px; border: 1px solid var(--gray-200);">
                                                        <input type="hidden" name="patientId" value="${p.id}">
                                                        <select name="deliveryUserId" style="border: none; background: transparent; padding: 4px; font-size: 12px; font-weight: 600; color: var(--gray-700); outline: none; flex: 1;" required>
                                                            <option value="" disabled ${p.deliveryAssignedTo == 'Unassigned' ? 'selected' : ''}>${p.deliveryAssignedTo == 'Unassigned' ? 'Unassigned' : p.deliveryAssignedTo}</option>
                                                            <c:forEach var="dp" items="${deliveryPartners}">
                                                                <option value="${dp.id}">${dp.fullName}</option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="submit" class="btn-primary" style="padding: 6px 12px; font-size: 11px; border-radius: 6px; white-space: nowrap;">
                                                            Assign
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="actions-cell">
                                                <button class="btn-icon view-record-btn" title="View Full Record" 
                                                        data-id="${p.id}" 
                                                        data-name="${p.name}"
                                                        data-pid="${p.patientId}"
                                                        data-gender="${p.gender}"
                                                        data-dob="${p.dateOfBirth}"
                                                        data-contact="${p.contactNumber}"
                                                        data-blood="${p.bloodGroup}"
                                                        data-last="${p.lastVisit}"
                                                        data-status="${p.deliveryStatus}"
                                                        data-executive="${p.deliveryAssignedTo}"
                                                        data-phone="${p.deliveryBoyPhone}"
                                                        data-source="${p.sourceHospital}"
                                                        data-dest="${p.destinationHospital}"
                                                        data-eta="${p.estimatedTime}"
                                                        data-loc="${p.currentLocation}">
                                                    <span class="material-symbols-outlined" style="color: var(--primary); font-size: 22px;">visibility</span>
                                                </button>
                                                <button class="btn-action" onclick="alert('Starting sample collection for ${p.name}...')">Collect Sample</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 60px; color: var(--gray-500);">
                                            <img src="/img/empty_state.png" alt="No Records" style="max-width: 180px; margin-bottom: 20px; border-radius: 16px;">
                                            <h3 style="color: var(--gray-800); font-size: 18px; margin-bottom: 8px;">No test requests available</h3>
                                            <p style="font-size: 14px;">Create a new test request to get started.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- SAMPLE COLLECTION SECTION (HIDDEN BY DEFAULT) -->
                <div id="samples-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Sample Collection Queue</h2>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Test Type</th>
                                    <th>Prescribed By</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Delivery Assignment</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}">
                                    <c:if test="${p.deliveryStatus == 'Pending Pickup' || p.deliveryStatus == 'Collected' || p.deliveryStatus == 'In Transit'}">
                                        <tr>
                                            <td>
                                                <div class="patient-cell">
                                                    <div class="patient-avatar" style="background: var(--primary-light); color: var(--primary);">
                                                        ${p.name.substring(0,1)}${p.name.contains(' ') ? p.name.split(' ')[1].substring(0,1) : ''}
                                                    </div>
                                                    <div class="patient-details">
                                                        <span class="patient-name">${p.name}</span>
                                                        <span class="patient-id">${p.patientId}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><strong>${not empty p.testType ? p.testType : 'Complete Blood Count (CBC)'}</strong><br><small style="color:var(--gray-500)">${not empty p.collectionType ? p.collectionType : 'Walk-in'}</small></td>
                                            <td>Dr. Emily Chen</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.priority == 'High'}"><span class="status-badge" style="background: var(--error-50); color: var(--error-700);">High</span></c:when>
                                                    <c:when test="${p.priority == 'Medium'}"><span class="status-badge" style="background: var(--warning-50); color: var(--warning-700);">Medium</span></c:when>
                                                    <c:otherwise><span class="status-badge" style="background: var(--success-50); color: var(--success-700);">${not empty p.priority ? p.priority : 'Normal'}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="status-badge ${p.deliveryStatus == 'Pending Pickup' ? 'status-pending' : 'status-progress'}">${p.deliveryStatus}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.deliveryAssignedTo == 'Not Required'}">
                                                        <span style="color: var(--gray-500); font-size: 12px; font-weight: 700; background: var(--gray-100); padding: 6px 12px; border-radius: 8px; border: 1px solid var(--gray-200); display: inline-flex; align-items: center; gap: 4px;">
                                                            <span class="material-symbols-outlined" style="font-size: 14px;">house</span>
                                                            In-House Lab
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="/assign-delivery" method="POST" style="display: flex; gap: 8px; align-items: center; background: var(--gray-50); padding: 4px; border-radius: 8px; border: 1px solid var(--gray-200);">
                                                            <input type="hidden" name="patientId" value="${p.id}">
                                                            <select name="deliveryUserId" style="border: none; background: transparent; padding: 4px; font-size: 12px; font-weight: 600; color: var(--gray-700); outline: none; flex: 1;" required>
                                                                <option value="" disabled ${p.deliveryAssignedTo == 'Unassigned' ? 'selected' : ''}>${p.deliveryAssignedTo == 'Unassigned' ? 'Unassigned' : p.deliveryAssignedTo}</option>
                                                                <c:forEach var="dp" items="${deliveryPartners}">
                                                                    <option value="${dp.id}">${dp.fullName}</option>
                                                                </c:forEach>
                                                            </select>
                                                            <button type="submit" class="btn-primary" style="padding: 6px 12px; font-size: 11px; border-radius: 6px; white-space: nowrap;">
                                                                Assign
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="actions-cell">
                                                    <button class="btn-icon view-record-btn" title="View Full Record" 
                                                            data-id="${p.id}" 
                                                            data-name="${p.name}"
                                                            data-pid="${p.patientId}"
                                                            data-gender="${p.gender}"
                                                            data-dob="${p.dateOfBirth}"
                                                            data-contact="${p.contactNumber}"
                                                            data-blood="${p.bloodGroup}"
                                                            data-last="${p.lastVisit}"
                                                            data-status="${p.deliveryStatus}"
                                                            data-executive="${p.deliveryAssignedTo}"
                                                            data-phone="${p.deliveryBoyPhone}"
                                                            data-source="${p.sourceHospital}"
                                                            data-dest="${p.destinationHospital}"
                                                            data-eta="${p.estimatedTime}"
                                                            data-loc="${p.currentLocation}">
                                                        <span class="material-symbols-outlined" style="color: var(--primary); font-size: 22px;">visibility</span>
                                                    </button>
                                                    <button class="btn-action" onclick="alert('Starting sample collection for ${p.name}...')">Collect Sample</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 60px; color: var(--gray-500);">
                                            <img src="/img/empty_state.png" alt="No Records" style="max-width: 180px; margin-bottom: 20px; border-radius: 16px;">
                                            <h3 style="color: var(--gray-800); font-size: 18px; margin-bottom: 8px;">No active sample collections</h3>
                                            <p style="font-size: 14px;">All samples have been processed or none are currently active.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- REPORTS SECTION -->
                <div id="reports-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Upload New Lab Report</h2>
                        </div>
                        <div style="padding: 32px;">
                            <form action="/upload-report" method="POST" enctype="multipart/form-data" style="max-width: 600px; margin: 0 auto;">
                                <div class="form-group" style="margin-bottom: 24px;">
                                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: var(--gray-700);">Select Patient</label>
                                    <select id="uploadPatientSelect" name="patientId" class="form-select" style="padding-left: 14px;" required>
                                        <option value="" disabled selected>Choose a patient...</option>
                                        <c:forEach var="patient" items="${patients}">
                                            <c:if test="${patient.deliveryStatus == 'Delivered'}">
                                                <option value="${patient.id}">${patient.name} (${patient.patientId})</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group" style="margin-bottom: 24px;">
                                    <label style="display: block; margin-bottom: 8px; font-weight: 600; color: var(--gray-700);">Test Category</label>
                                    <select class="form-select" id="uploadTestSelect" style="padding-left: 14px;" required>
                                        <option value="" disabled selected>Select test type...</option>
                                        <c:forEach var="t" items="${allTests}">
                                            <option value="${t.name}">${t.name}</option>
                                        </c:forEach>
                                        <option>General Test</option>
                                    </select>
                                </div>
                                
                                <div class="upload-zone" id="dropZone" style="border: 2px dashed var(--gray-300); border-radius: var(--radius-lg); padding: 40px; text-align: center; cursor: pointer; transition: all 0.2s; background: var(--gray-50); margin-bottom: 24px;" onclick="document.getElementById('fileInput').click()">
                                    <input type="file" id="fileInput" name="reportFile" style="display: none;" accept=".pdf,.jpg,.png" onchange="showFileName(this)">
                                    <span class="material-symbols-outlined" style="font-size: 48px; color: var(--primary); margin-bottom: 12px;">cloud_upload</span>
                                    <h4 style="margin-bottom: 8px; color: var(--gray-900);">Click to upload or drag and drop</h4>
                                    <p style="font-size: 13px; color: var(--gray-500);">PDF, PNG, JPG (max. 10MB)</p>
                                    <div id="fileInfo" style="margin-top: 16px; font-weight: 600; color: var(--success); display: none;"></div>
                                </div>

                                <button type="submit" class="btn-primary" style="width: 100%; justify-content: center; height: 48px;">
                                    <span class="material-symbols-outlined">send</span>
                                    Finish & Upload Report
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- PENDING REPORTS SECTION -->
                <div id="pending-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Pending Reports Verification</h2>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Test Type</th>
                                    <th>Prescribed By</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}">
                                    <c:if test="${p.deliveryStatus == 'Delivered'}">
                                        <tr>
                                            <td>
                                                <div class="patient-cell">
                                                    <div class="patient-avatar" style="background: var(--primary-light); color: var(--primary);">
                                                        ${p.name.substring(0,1)}
                                                    </div>
                                                    <div class="patient-details">
                                                        <span class="patient-name">${p.name}</span>
                                                        <span class="patient-id">${p.patientId}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><strong>${p.testType}</strong></td>
                                            <td>Dr. Emily Chen</td>
                                            <td><span class="status-badge" style="background: var(--success-50); color: var(--success-700);">${p.priority}</span></td>
                                            <td><span class="status-badge status-progress">Pending Report</span></td>
                                            <td>
                                                <button class="btn-action" onclick="openReportUpload('${p.id}')">Upload Now</button>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- IN-PROGRESS SECTION -->
                <div id="inprogress-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Tests In-Progress</h2>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Test Type</th>
                                    <th>Collection Type</th>
                                    <th>Priority</th>
                                    <th>Lab Status</th>
                                    <th>Time Elapsed</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}">
                                    <c:if test="${p.deliveryStatus == 'Delivered'}">
                                        <tr>
                                            <td>
                                                <div class="patient-cell">
                                                    <div class="patient-avatar" style="background: var(--warning-50); color: var(--warning-700);">
                                                        ${p.name.substring(0,1)}
                                                    </div>
                                                    <div class="patient-details">
                                                        <span class="patient-name">${p.name}</span>
                                                        <span class="patient-id">${p.patientId}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><strong>${p.testType}</strong></td>
                                            <td>${p.collectionType}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.priority == 'High'}"><span class="status-badge" style="background: #fee2e2; color: #991b1b;">High</span></c:when>
                                                    <c:when test="${p.priority == 'Medium'}"><span class="status-badge" style="background: #fef3c7; color: #92400e;">Medium</span></c:when>
                                                    <c:otherwise><span class="status-badge" style="background: #dcfce7; color: #166534;">${not empty p.priority ? p.priority : 'Normal'}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span class="status-badge status-progress">${p.deliveryStatus}</span></td>
                                            <td><span style="font-size: 12px; color: var(--gray-500);">Updated Just Now</span></td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- COMPLETED REPORTS SECTION -->
                <div id="completed-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Completed Reports History</h2>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Test Type</th>
                                    <th>Completed Date</th>
                                    <th>Report</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}">
                                    <c:if test="${p.deliveryStatus == 'Completed'}">
                                        <tr>
                                            <td>
                                                <div class="patient-cell">
                                                    <div class="patient-avatar" style="background: var(--success-50); color: var(--success-700);">
                                                        ${p.name.substring(0,1)}
                                                    </div>
                                                    <div class="patient-details">
                                                        <span class="patient-name">${p.name}</span>
                                                        <span class="patient-id">${p.patientId}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><strong>${p.testType}</strong></td>
                                            <td>${p.lastVisit}</td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 8px; color: var(--primary); font-weight: 600; font-size: 13px; cursor: pointer;">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">description</span>
                                                    Report_v1.pdf
                                                </div>
                                            </td>
                                            <td><span class="status-badge" style="background: var(--success-50); color: var(--success-700);">VERIFIED</span></td>
                                            <td>
                                                <button class="btn-icon" title="Print" onclick="window.print()">
                                                    <span class="material-symbols-outlined" style="color: var(--primary);">print</span>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>


                <!-- PATIENT RECORDS SECTION -->
                <div id="patients-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Global Patient Records</h2>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient Details</th>
                                    <th>Lab Type</th>
                                    <th>Gender</th>
                                    <th>Date of Birth</th>
                                    <th>Contact</th>
                                    <th>Blood Group</th>
                                    <th>Last Visit</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="patient" items="${patients}">
                                    <tr>
                                        <td>
                                            <div class="patient-cell">
                                                <div class="patient-avatar" style="background: var(--primary-light); color: var(--primary);">
                                                    ${patient.name.substring(0,1)}${patient.name.contains(' ') ? patient.name.split(' ')[1].substring(0,1) : ''}
                                                </div>
                                                <div class="patient-details">
                                                    <span class="patient-name">${patient.name}</span>
                                                    <span class="patient-id">${patient.patientId}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${patient.destinationHospital.contains('In-House') || patient.destinationHospital.contains('Same Hospital')}">
                                                    <span style="background: #e7f5ff; color: #1971c2; font-size: 10px; padding: 2px 8px; border-radius: 10px; font-weight: 800;">IN-HOUSE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="background: #fff0f6; color: #d6336c; font-size: 10px; padding: 2px 8px; border-radius: 10px; font-weight: 800;">EXTERNAL</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${patient.gender}</td>
                                        <td>${patient.dateOfBirth}</td>
                                        <td>${patient.contactNumber}</td>
                                        <td><span class="status-badge" style="background: var(--red-50); color: var(--red-600); border: 1px solid var(--red-200);">${patient.bloodGroup}</span></td>
                                        <td>${patient.lastVisit}</td>
                                        <td>
                                            <div class="actions-cell">
                                                <div style="display: flex; gap: 8px;">
                                                    <c:if test="${user.labType == 'External' && patient.deliveryStatus == 'Delivered'}">
                                                        <form action="/update-delivery-status" method="POST" style="display: inline;">
                                                            <input type="hidden" name="id" value="${patient.id}">
                                                            <input type="hidden" name="status" value="Received">
                                                            <button type="submit" class="btn-action" style="background: var(--success); color: white; padding: 6px 12px; border-radius: 6px; border: none; font-weight: 600; cursor: pointer;">
                                                                Receive Sample
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <button class="btn-icon view-record-btn" title="View Full Record" 
                                                             data-id="${patient.id}" 
                                                             data-name="${patient.name}"
                                                             data-pid="${patient.patientId}"
                                                             data-gender="${patient.gender}"
                                                             data-dob="${patient.dateOfBirth}"
                                                             data-contact="${patient.contactNumber}"
                                                             data-blood="${patient.bloodGroup}"
                                                             data-last="${patient.lastVisit}"
                                                             data-status="${patient.deliveryStatus}"
                                                             data-executive="${patient.deliveryAssignedTo}"
                                                             data-phone="${patient.deliveryBoyPhone}"
                                                             data-source="${patient.sourceHospital}"
                                                             data-dest="${patient.destinationHospital}"
                                                             data-eta="${patient.estimatedTime}"
                                                             data-loc="${patient.currentLocation}">
                                                         <span class="material-symbols-outlined" style="color: var(--primary); font-size: 22px;">visibility</span>
                                                     </button>
                                                    <button class="btn-icon" title="Edit Record" onclick="editPatient('${patient.id}', '${patient.name}', '${patient.contactNumber}', '${patient.gender}', '${patient.bloodGroup}', '${patient.destinationHospital}')">
                                                        <span class="material-symbols-outlined">edit</span>
                                                    </button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    
                                    <!-- DELIVERY TRACKING TIMELINE (Only for External Labs) -->
                                    <c:if test="${user.labType == 'External'}">
                                        <tr>
                                            <td colspan="8" style="padding: 0 24px 24px 24px; border-top: none;">
                                                <div style="background: var(--gray-50); padding: 16px; border-radius: 12px; border: 1px solid var(--gray-200);">
                                                    <div style="font-size: 11px; font-weight: 700; color: var(--gray-600); margin-bottom: 16px; display: flex; align-items: center; gap: 8px; text-transform: uppercase; letter-spacing: 0.5px;">
                                                        <span class="material-symbols-outlined" style="font-size: 16px; color: var(--primary);">local_shipping</span>
                                                        Sample Logistics: <span style="color: var(--primary);">${patient.deliveryStatus}</span>
                                                    </div>
                                                    <div style="display: flex; justify-content: space-between; position: relative; max-width: 600px; margin: 0 auto;">
                                                        <!-- Timeline Line -->
                                                        <div style="position: absolute; top: 12px; left: 30px; right: 30px; height: 2px; background: var(--gray-200); z-index: 1;"></div>
                                                        
                                                        <!-- Steps -->
                                                        <div style="position: relative; z-index: 2; display: flex; flex-direction: column; align-items: center; gap: 4px; width: 60px;">
                                                            <div style="width: 24px; height: 24px; border-radius: 50%; background: ${patient.deliveryStatus != 'Pending Pickup' ? 'var(--success)' : 'var(--white)'}; border: 2px solid ${patient.deliveryStatus != 'Pending Pickup' ? 'var(--success)' : 'var(--gray-300)'}; display: flex; align-items: center; justify-content: center;">
                                                                <span class="material-symbols-outlined" style="font-size: 14px; color: ${patient.deliveryStatus != 'Pending Pickup' ? 'white' : 'var(--gray-400)'};">hail</span>
                                                            </div>
                                                            <span style="font-size: 8px; font-weight: 800; color: var(--gray-500);">PICKUP</span>
                                                        </div>
                                                        
                                                        <div style="position: relative; z-index: 2; display: flex; flex-direction: column; align-items: center; gap: 4px; width: 60px;">
                                                            <div style="width: 24px; height: 24px; border-radius: 50%; background: ${(patient.deliveryStatus == 'In Transit' || patient.deliveryStatus == 'Delivered' || patient.deliveryStatus == 'Received') ? (patient.deliveryStatus == 'In Transit' ? 'var(--primary)' : 'var(--success)') : 'var(--white)'}; border: 2px solid ${(patient.deliveryStatus == 'In Transit' || patient.deliveryStatus == 'Delivered' || patient.deliveryStatus == 'Received') ? (patient.deliveryStatus == 'In Transit' ? 'var(--primary)' : 'var(--success)') : 'var(--gray-300)'}; display: flex; align-items: center; justify-content: center;">
                                                                <span class="material-symbols-outlined" style="font-size: 14px; color: ${(patient.deliveryStatus == 'In Transit' || patient.deliveryStatus == 'Delivered' || patient.deliveryStatus == 'Received') ? 'white' : 'var(--gray-400)'};">local_shipping</span>
                                                            </div>
                                                            <span style="font-size: 8px; font-weight: 800; color: var(--gray-500);">TRANSIT</span>
                                                        </div>
                                                        
                                                        <div style="position: relative; z-index: 2; display: flex; flex-direction: column; align-items: center; gap: 4px; width: 60px;">
                                                            <div style="width: 24px; height: 24px; border-radius: 50%; background: ${(patient.deliveryStatus == 'Delivered' || patient.deliveryStatus == 'Received') ? (patient.deliveryStatus == 'Delivered' ? 'var(--primary)' : 'var(--success)') : 'var(--white)'}; border: 2px solid ${(patient.deliveryStatus == 'Delivered' || patient.deliveryStatus == 'Received') ? (patient.deliveryStatus == 'Delivered' ? 'var(--primary)' : 'var(--success)') : 'var(--gray-300)'}; display: flex; align-items: center; justify-content: center;">
                                                                <span class="material-symbols-outlined" style="font-size: 14px; color: ${(patient.deliveryStatus == 'Delivered' || patient.deliveryStatus == 'Received') ? 'white' : 'var(--gray-400)'};">apartment</span>
                                                            </div>
                                                            <span style="font-size: 8px; font-weight: 800; color: var(--gray-500);">DELIVERED</span>
                                                        </div>
                                                        
                                                        <div style="position: relative; z-index: 2; display: flex; flex-direction: column; align-items: center; gap: 4px; width: 60px;">
                                                            <div style="width: 24px; height: 24px; border-radius: 50%; background: ${patient.deliveryStatus == 'Received' ? 'var(--success)' : 'var(--white)'}; border: 2px solid ${patient.deliveryStatus == 'Received' ? 'var(--success)' : 'var(--gray-300)'}; display: flex; align-items: center; justify-content: center;">
                                                                <span class="material-symbols-outlined" style="font-size: 14px; color: ${patient.deliveryStatus == 'Received' ? 'white' : 'var(--gray-400)'};">biotech</span>
                                                            </div>
                                                            <span style="font-size: 8px; font-weight: 800; color: var(--gray-500);">READY</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="8" style="text-align: center; padding: 40px; color: var(--gray-500);">
                                            <span class="material-symbols-outlined" style="font-size: 48px; margin-bottom: 16px; display: block;">people</span>
                                            <h3 style="color: var(--gray-800); font-size: 18px; margin-bottom: 8px;">No patient records found</h3>
                                            <p style="font-size: 14px;">Patient history will appear here once records are verified.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- LOGISTICS & SAMPLES SECTION -->
                <div id="logistics-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">
                                <span class="material-symbols-outlined" style="vertical-align: middle; margin-right: 8px;">local_shipping</span>
                                Advanced Sample Logistics Tracking
                            </h2>
                        </div>
                        <div style="padding: 24px; border-bottom: 1px solid var(--gray-100); display: flex; justify-content: space-between; align-items: center;">
                            <p style="color: var(--gray-500); margin: 0; font-size: 14px;">Monitor real-time sample movement, executive details, and hospital-to-hospital routing.</p>
                            <div style="display: flex; gap: 8px;">
                                <button class="btn-secondary" id="toggleTableView" style="padding: 8px 16px; font-size: 12px; display: none;" onclick="showLogisticsView('table')">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">table_chart</span>
                                    Table View
                                </button>
                                <button class="btn-primary" id="toggleMapView" style="padding: 8px 16px; font-size: 12px;" onclick="showLogisticsView('map')">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">map</span>
                                    Live Map View
                                </button>
                            </div>
                        </div>
                        
                        <div id="logistics-table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Patient & ID</th>
                                    <th>Routing (Source → Destination)</th>
                                    <th>Delivery Executive</th>
                                    <th>Current Location</th>
                                    <th>Pickup Status</th>
                                    <th>ETA & Progress</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}">
                                    <c:if test="${not empty p.deliveryStatus}">
                                        <tr style="border-bottom: 1px solid var(--gray-50);">
                                            <td>
                                                <div style="font-weight: 700; color: var(--gray-900);">${p.name}</div>
                                                <div style="font-size: 11px; color: var(--primary); font-weight: 600;">${p.patientId}</div>
                                            </td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 12px;">
                                                    <div style="background: var(--gray-50); padding: 6px 10px; border-radius: 6px; border: 1px solid var(--gray-100);">
                                                        <div style="font-size: 11px; font-weight: 700; color: var(--gray-700);">${p.sourceHospital}</div>
                                                        <div style="font-size: 9px; color: var(--gray-400); text-transform: uppercase;">Origin</div>
                                                    </div>
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary); opacity: 0.5;">arrow_right_alt</span>
                                                    <div style="background: var(--primary-50); padding: 6px 10px; border-radius: 6px; border: 1px solid var(--primary-100);">
                                                        <div style="font-size: 11px; font-weight: 700; color: var(--primary-700);">${p.destinationHospital}</div>
                                                        <div style="font-size: 9px; color: var(--primary-400); text-transform: uppercase;">Destination</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 10px;">
                                                    <div style="width: 36px; height: 36px; border-radius: 10px; background: var(--gray-100); color: var(--gray-700); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px;">
                                                        ${p.deliveryAssignedTo.substring(0,1)}
                                                    </div>
                                                    <div>
                                                        <div style="font-size: 13px; font-weight: 700;">${p.deliveryAssignedTo}</div>
                                                        <a href="tel:${p.deliveryBoyPhone}" style="font-size: 11px; color: var(--success-700); text-decoration: none; display: flex; align-items: center; gap: 4px; font-weight: 600;">
                                                            <span class="material-symbols-outlined" style="font-size: 12px;">call</span>
                                                            ${p.deliveryBoyPhone}
                                                        </a>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 6px; color: var(--gray-700);">
                                                    <span class="material-symbols-outlined" style="font-size: 16px; color: var(--primary);">my_location</span>
                                                    <span style="font-size: 12px; font-weight: 600;">${p.currentLocation}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.deliveryStatus == 'Pending Pickup'}">
                                                        <span style="display: inline-flex; align-items: center; gap: 6px; background: #fff9db; color: #f08c00; padding: 4px 12px; border-radius: 20px; font-size: 10px; font-weight: 800; border: 1px solid #ffe066;">
                                                            <span style="width: 6px; height: 6px; background: #f08c00; border-radius: 50%; display: block;"></span>
                                                            AWAITING PICKUP
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${p.deliveryStatus == 'In Transit'}">
                                                        <span style="display: inline-flex; align-items: center; gap: 6px; background: #e7f5ff; color: #1971c2; padding: 4px 12px; border-radius: 20px; font-size: 10px; font-weight: 800; border: 1px solid #a5d8ff;">
                                                            <span style="width: 6px; height: 6px; background: #1971c2; border-radius: 50%; display: block;"></span>
                                                            IN TRANSIT
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="display: inline-flex; align-items: center; gap: 6px; background: #ebfbee; color: #2f9e44; padding: 4px 12px; border-radius: 20px; font-size: 10px; font-weight: 800; border: 1px solid #b2f2bb;">
                                                            <span style="width: 6px; height: 6px; background: #2f9e44; border-radius: 50%; display: block;"></span>
                                                            DELIVERED
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="display: flex; flex-direction: column; gap: 6px;">
                                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                                        <span style="font-size: 10px; font-weight: 800; color: var(--primary); text-transform: uppercase; letter-spacing: 0.5px;">${p.deliveryStatus}</span>
                                                        <span style="font-size: 10px; font-weight: 600; color: var(--gray-500);">ETA: ${p.estimatedTime}</span>
                                                    </div>
                                                    <div style="width: 140px; height: 6px; background: var(--gray-100); border-radius: 3px; overflow: hidden; border: 1px solid var(--gray-200);">
                                                        <div style="width: ${p.deliveryStatus == 'Completed' ? '100%' : (p.deliveryStatus == 'Delivered' ? '75%' : (p.deliveryStatus == 'In Transit' ? '50%' : '25%'))}; height: 100%; background: linear-gradient(90deg, var(--primary), #748ffc); transition: width 1s cubic-bezier(0.4, 0, 0.2, 1);"></div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 60px; color: var(--gray-400);">
                                            <span class="material-symbols-outlined" style="font-size: 48px; display: block; margin-bottom: 12px;">inventory_2</span>
                                            <h3 style="color: var(--gray-800); font-size: 18px; margin-bottom: 8px;">No active logistics records</h3>
                                            <p style="font-size: 14px;">Track sample movement and routing here.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                        </div>

                        <div id="logistics-map-container" style="display: none; padding: 24px;">
                            <div id="logistics-map"></div>
                        </div>
                    </div>
                </div>

                <!-- ATTENDANCE SECTION -->
                <div id="attendance-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">My Attendance & Punctuality</h2>
                            <div style="display: flex; gap: 12px;">
                                <form id="presentForm" action="/mark-attendance" method="POST">
                                    <input type="hidden" name="date" id="attDate">
                                    <input type="hidden" name="time" id="attTime">
                                    <button type="button" class="btn-primary" style="background: var(--success); border: none;" onclick="submitAttendance('Present')">
                                        <span class="material-symbols-outlined">how_to_reg</span> Mark Present
                                    </button>
                                </form>
                                <form id="leaveForm" action="/mark-attendance" method="POST">
                                    <input type="hidden" name="date" id="leaveDate">
                                    <input type="hidden" name="time" id="leaveTime">
                                    <button type="button" class="btn-secondary" onclick="submitAttendance('Leave')">Mark Leave</button>
                                </form>
                            </div>
                        </div>
                        
                        <div class="stats-grid" style="margin-top: 24px;">
                            <div class="stat-card">
                                <div class="stat-icon-wrapper stat-green"><span class="material-symbols-outlined">task_alt</span></div>
                                <div class="stat-content">
                                    <h3>${attendanceRecords.size()}</h3>
                                    <p>Days Present</p>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon-wrapper stat-blue"><span class="material-symbols-outlined">schedule</span></div>
                                <div class="stat-content">
                                    <h3>98%</h3>
                                    <p>On-Time Arrival</p>
                                </div>
                            </div>
                        </div>

                        <table class="data-table" style="margin-top: 32px;">
                            <thead>
                                <tr>
                                    <th>Date & Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="record" items="${attendanceRecords}">
                                    <tr>
                                        <td>
                                            <div style="font-weight: 700; color: var(--gray-900);">${record.checkIn.toLocalDate()}</div>
                                            <div style="font-size: 11px; color: var(--primary);">${record.checkIn.toLocalTime()}</div>
                                        </td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <span class="status-badge" style="background: ${record.status == 'Present' ? 'var(--success-50)' : 'var(--error-50)'}; color: ${record.status == 'Present' ? 'var(--success-700)' : 'var(--error-700)'};">
                                                    ${record.status}
                                                </span>
                                                <c:if test="${record.verified}">
                                                    <span class="status-badge" style="background: var(--primary-50); color: var(--primary); border: 1px solid var(--primary-200); font-size: 10px; display: flex; align-items: center; gap: 4px;">
                                                        <span class="material-symbols-outlined" style="font-size: 12px;">verified</span>
                                                        VERIFIED
                                                    </span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 12px;">
                                                <c:choose>
                                                    <c:when test="${not empty record.checkOut}">
                                                        <div style="font-size: 13px; font-weight: 700; color: var(--gray-600); display: flex; align-items: center; gap: 8px;">
                                                            <span class="material-symbols-outlined" style="font-size: 18px; color: var(--success);">task_alt</span>
                                                            Checked Out: ${record.checkOut.toLocalTime()}
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form id="checkoutForm_${record.id}" action="/update-attendance" method="POST" style="display: inline;">
                                                            <input type="hidden" name="id" value="${record.id}">
                                                            <input type="hidden" name="date" id="checkoutDate_${record.id}">
                                                            <input type="hidden" name="time" id="checkoutTime_${record.id}">
                                                            <button type="button" class="btn-primary" style="background: var(--error); border: none; padding: 6px 12px; font-size: 12px; display: flex; align-items: center; gap: 4px;" onclick="submitCheckout('${record.id}')">
                                                                <span class="material-symbols-outlined" style="font-size: 16px;">logout</span> Check Out
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <c:if test="${!record.verified}">
                                                    <form action="/delete-attendance" method="POST" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this attendance record?')">
                                                        <input type="hidden" name="id" value="${record.id}">
                                                        <button type="submit" style="background: none; border: none; color: var(--gray-400); cursor: pointer; display: flex; align-items: center; transition: color 0.2s;" onmouseover="this.style.color='var(--error)'" onmouseout="this.style.color='var(--gray-400)'">
                                                            <span class="material-symbols-outlined" style="font-size: 20px;">delete</span>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty attendanceRecords}">
                                    <tr><td colspan="3" style="text-align:center; padding: 40px; color: var(--gray-500);">No attendance records found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- PERFORMANCE SECTION -->
                <div id="performance-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Technician Performance Metrics</h2>
                        </div>
                        <div style="padding: 60px; display: flex; flex-direction: column; align-items: center; justify-content: center; background: radial-gradient(circle at center, var(--primary-50) 0%, transparent 70%);">
                            <div style="width: 240px; height: 240px; border-radius: 50%; border: 15px solid var(--gray-100); border-top-color: var(--primary); border-right-color: var(--primary); margin: 0 auto; display: flex; align-items: center; justify-content: center; position: relative; box-shadow: var(--shadow-lg); background: white;">
                                <div style="text-align: center;">
                                    <div style="font-size: 56px; font-weight: 800; color: var(--gray-900); line-height: 1;">4.9</div>
                                    <div style="font-size: 14px; font-weight: 700; color: var(--primary); text-transform: uppercase; letter-spacing: 1px; margin-top: 8px;">Rating</div>
                                </div>
                            </div>
                            
                            <div class="stats-grid" style="margin-top: 48px; width: 100%; max-width: 800px;">
                                <div class="stat-card" style="background: white; border: 1px solid var(--gray-100);">
                                    <div class="stat-icon-wrapper" style="background: var(--success-50); color: var(--success);"><span class="material-symbols-outlined">verified</span></div>
                                    <div class="stat-content">
                                        <h3>96%</h3>
                                        <p>Accuracy Rate</p>
                                    </div>
                                </div>
                                <div class="stat-card" style="background: white; border: 1px solid var(--gray-100);">
                                    <div class="stat-icon-wrapper" style="background: var(--primary-50); color: var(--primary);"><span class="material-symbols-outlined">timer</span></div>
                                    <div class="stat-content">
                                        <h3>18m</h3>
                                        <p>Avg. Processing</p>
                                    </div>
                                </div>
                                <div class="stat-card" style="background: white; border: 1px solid var(--gray-100);">
                                    <div class="stat-icon-wrapper" style="background: var(--warning-50); color: var(--warning);"><span class="material-symbols-outlined">thumb_up</span></div>
                                    <div class="stat-content">
                                        <h3>124</h3>
                                        <p>Doctor Feedbacks</p>
                                    </div>
                                </div>
                            </div>
                            
                            <p style="margin-top: 32px; color: var(--gray-500); max-width: 500px; text-align: center; line-height: 1.6;">
                                Your performance is calculated based on report turnaround time, data accuracy, and feedback from referring doctors. Keep up the excellent work!
                            </p>
                        </div>
                    </div>
                </div>

                <!-- SHIFT SCHEDULE SECTION -->
                <div id="shifts-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">My Assigned Shifts</h2>
                            <p style="color: var(--gray-500); font-size: 13px;">View your upcoming schedule managed by the Admin.</p>
                        </div>
                        
                        <div class="stats-grid" style="margin-top: 24px; grid-template-columns: 1fr 1fr 1fr;">
                            <c:forEach var="shift" items="${shifts}">
                                <div class="stat-card" style="flex-direction: column; align-items: flex-start; gap: 12px; padding: 24px; border: 1px solid var(--primary-100); background: var(--primary-50);">
                                    <div style="display: flex; justify-content: space-between; width: 100%; align-items: center;">
                                        <span class="status-badge" style="background: var(--primary); color: white;">${shift.department}</span>
                                        <span class="material-symbols-outlined" style="color: var(--primary);">event</span>
                                    </div>
                                    <h3 style="margin: 0; font-size: 20px;">${shift.startTime.toLocalTime()} - ${shift.endTime.toLocalTime()}</h3>
                                    <p style="margin: 0; font-weight: 700; color: var(--gray-700);">${shift.startTime.toLocalDate()}</p>
                                    <p style="margin: 0; font-size: 12px; color: var(--gray-500);">${shift.note}</p>
                                </div>
                            </c:forEach>
                            <c:if test="${empty shifts}">
                                <div style="grid-column: span 3; text-align: center; padding: 60px; background: var(--gray-50); border-radius: 20px;">
                                    <span class="material-symbols-outlined" style="font-size: 48px; color: var(--gray-300); margin-bottom: 16px;">event_busy</span>
                                    <h3 style="color: var(--gray-700);">No Shifts Assigned</h3>
                                    <p style="color: var(--gray-500);">Please contact the Admin to update your shift schedule.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- PROFILE SECTION -->
                <div id="profile-section" class="dashboard-section" style="display: none;">
                    <div class="section-card" style="max-width: 900px; margin: 0 auto; overflow: hidden;">
                        <div style="background: linear-gradient(135deg, var(--primary), var(--primary-light)); height: 160px; position: relative;">
                            <div style="position: absolute; bottom: -50px; left: 40px; display: flex; align-items: flex-end; gap: 24px;">
                                <div style="position: relative;">
                                    <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${user.fullName}" id="profileImagePreview" alt="Profile" style="width: 140px; height: 140px; border-radius: 24px; border: 6px solid white; box-shadow: var(--shadow-lg); background: white; object-fit: cover;">
                                    <label for="profilePhotoInput" style="position: absolute; bottom: 5px; right: 5px; background: var(--primary); color: white; width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; border: 3px solid white; box-shadow: var(--shadow-md); transition: all 0.2s;" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
                                        <span class="material-symbols-outlined" style="font-size: 20px;">photo_camera</span>
                                    </label>
                                    <input type="file" id="profilePhotoInput" style="display: none;" onchange="previewProfilePhoto(event)">
                                </div>
                                <div style="margin-bottom: 15px; color: var(--gray-900);">
                                    <h2 style="font-size: 32px; font-weight: 800; margin: 0; letter-spacing: -1px;">${user.fullName}</h2>
                                    <div style="display: flex; align-items: center; gap: 8px; margin-top: 4px;">
                                        <span class="material-symbols-outlined" style="font-size: 18px; color: var(--primary);">biotech</span>
                                        <span style="color: var(--gray-600); font-weight: 600;">Lab Personnel | ${user.labName}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div style="padding: 80px 40px 40px 40px;">
                            <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 40px;">
                                <div>
                                    <h3 style="font-size: 18px; font-weight: 800; margin-bottom: 24px; display: flex; align-items: center; gap: 10px;">
                                        <span class="material-symbols-outlined" style="color: var(--primary);">person</span>
                                        Personal Information
                                    </h3>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                                        <div class="profile-field">
                                            <label style="display: block; font-size: 11px; font-weight: 800; color: var(--gray-400); text-transform: uppercase; margin-bottom: 6px;">Full Legal Name</label>
                                            <p style="font-weight: 700; color: var(--gray-900); margin: 0;">${user.fullName}</p>
                                        </div>
                                        <div class="profile-field">
                                            <label style="display: block; font-size: 11px; font-weight: 800; color: var(--gray-400); text-transform: uppercase; margin-bottom: 6px;">Email Address</label>
                                            <p style="font-weight: 700; color: var(--gray-900); margin: 0;">${user.email}</p>
                                        </div>
                                        <div class="profile-field">
                                            <label style="display: block; font-size: 11px; font-weight: 800; color: var(--gray-400); text-transform: uppercase; margin-bottom: 6px;">Phone Number</label>
                                            <p style="font-weight: 700; color: var(--gray-900); margin: 0;">${not empty user.phone ? user.phone : 'Not Linked'}</p>
                                        </div>
                                        <div class="profile-field">
                                            <label style="display: block; font-size: 11px; font-weight: 800; color: var(--gray-400); text-transform: uppercase; margin-bottom: 6px;">Account Status</label>
                                            <span class="status-badge" style="background: var(--success-50); color: var(--success-700); font-weight: 800;">ACTIVE</span>
                                        </div>
                                    </div>

                                    <div style="margin-top: 40px; padding: 24px; background: var(--primary-50); border-radius: 16px; border: 1px solid var(--primary-100);">
                                        <h4 style="margin: 0 0 12px 0; color: var(--primary-800); display: flex; align-items: center; gap: 8px;">
                                            <span class="material-symbols-outlined" style="font-size: 20px;">security</span>
                                            Security & Access
                                        </h4>
                                        <p style="font-size: 13px; color: var(--primary-700); line-height: 1.6; margin: 0 0 20px 0;">
                                            Your account has high-level access to sensitive patient lab data. Ensure you maintain confidentiality and follow clinic security protocols.
                                        </p>
                                        <button class="btn-primary" style="font-size: 12px; padding: 10px 20px;" onclick="alert('Password reset link has been sent to your email.')">Change Password</button>
                                    </div>
                                </div>

                                <div>
                                    <h3 style="font-size: 18px; font-weight: 800; margin-bottom: 24px; display: flex; align-items: center; gap: 10px;">
                                        <span class="material-symbols-outlined" style="color: var(--primary);">domain</span>
                                        Workplace Details
                                    </h3>
                                    <div style="background: white; border: 1px solid var(--gray-200); border-radius: 20px; padding: 24px; box-shadow: var(--shadow-sm);">
                                        <div style="margin-bottom: 20px;">
                                            <label style="display: block; font-size: 11px; font-weight: 800; color: var(--gray-400); text-transform: uppercase; margin-bottom: 8px;">Primary Laboratory</label>
                                            <div style="display: flex; align-items: center; gap: 12px;">
                                                <div style="background: var(--primary-light); color: var(--primary); width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center;">
                                                    <span class="material-symbols-outlined">home_health</span>
                                                </div>
                                                <div>
                                                    <p style="font-weight: 800; color: var(--gray-900); margin: 0;">${user.labName}</p>
                                                    <p style="font-size: 12px; color: var(--gray-500); margin: 0;">ID: ${user.labId}</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div style="margin-bottom: 20px;">
                                            <label style="display: block; font-size: 11px; font-weight: 800; color: var(--gray-400); text-transform: uppercase; margin-bottom: 8px;">Location</label>
                                            <p style="font-size: 13px; font-weight: 600; color: var(--gray-700); margin: 0;">
                                                <span class="material-symbols-outlined" style="font-size: 16px; vertical-align: middle; color: var(--primary);">location_on</span>
                                                ${user.labAddress}
                                            </p>
                                        </div>
                                        <div style="padding-top: 20px; border-top: 1px solid var(--gray-100);">
                                            <label style="display: block; font-size: 11px; font-weight: 800; color: var(--gray-400); text-transform: uppercase; margin-bottom: 8px;">Account Type</label>
                                            <div style="display: flex; align-items: center; gap: 8px; background: var(--gray-50); padding: 8px 12px; border-radius: 10px;">
                                                <span class="material-symbols-outlined" style="font-size: 18px; color: var(--gray-600);">badge</span>
                                                <span style="font-weight: 700; font-size: 13px; color: var(--gray-700);">${user.role} Dashboard Access</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- NOTIFICATIONS SECTION -->
                <div id="notifications-section" class="dashboard-section" style="display: none;">
                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">Lab System Notifications</h2>
                        </div>
                        <div style="padding: 40px; text-align: center; color: var(--gray-500);">
                            <span class="material-symbols-outlined" style="font-size: 48px; margin-bottom: 16px;">notifications_active</span>
                            <h3 style="color: var(--gray-800); font-size: 20px; margin-bottom: 8px;">All caught up!</h3>
                            <p>No new urgent notifications at this time.</p>
                        </div>
                    </div>
                </div>

            </div>
        </main>

    </div>

    <!-- ==================== JAVASCRIPT ==================== -->
    <!-- EDIT PATIENT MODAL -->
    <div id="editModal" class="modal" style="display:none; position:fixed; z-index:2000; left:0; top:0; width:100%; height:100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center;">
        <div class="section-card" style="width: 100%; max-width: 500px; margin: auto; position: relative;">
            <div class="section-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h2 class="section-title">Edit Patient Record</h2>
                <button onclick="closeModal()" style="background:none; border:none; cursor:pointer;"><span class="material-symbols-outlined">close</span></button>
            </div>
            <div style="padding: 24px;">
                <form action="/update-patient" method="POST">
                    <input type="hidden" id="editId" name="id">
                    <div class="form-group" style="margin-bottom: 16px;">
                        <label style="display:block; margin-bottom: 8px; font-weight:600;">Full Name</label>
                        <input type="text" id="editName" name="name" class="form-select" style="padding-left:12px;" required>
                    </div>
                    <div class="form-group" style="margin-bottom: 16px;">
                        <label style="display:block; margin-bottom: 8px; font-weight:600;">Contact Number</label>
                        <input type="text" id="editContact" name="contactNumber" class="form-select" style="padding-left:12px;" required>
                    </div>
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px; margin-bottom: 24px;">
                        <div class="form-group">
                            <label style="display:block; margin-bottom: 8px; font-weight:600;">Gender</label>
                            <select id="editGender" name="gender" class="form-select" style="padding-left:12px;">
                                <option>Male</option>
                                <option>Female</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label style="display:block; margin-bottom: 8px; font-weight:600;">Blood Group</label>
                            <select id="editBlood" name="bloodGroup" class="form-select" style="padding-left:12px;">
                                <option>A+</option><option>A-</option><option>B+</option><option>B-</option>
                                <option>O+</option><option>O-</option><option>AB+</option><option>AB-</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 24px;">
                        <label style="display:block; margin-bottom: 8px; font-weight:600;">Lab Destination</label>
                        <select id="editLabDestination" name="labDestination" class="form-select" style="padding-left:12px;">
                            <option value="In-House">Same Hospital (In-House Lab)</option>
                            <option value="External">Different Lab (Requires Delivery Partner)</option>
                        </select>
                    </div>
                    <div style="display: flex; gap: 12px; justify-content: flex-end;">
                        <button type="button" class="btn-secondary" onclick="closeModal()">Cancel</button>
                        <button type="submit" class="btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- NEW TEST REQUEST MODAL -->
    <div id="newRequestModal" class="modal" style="display:none; position:fixed; z-index:2000; left:0; top:0; width:100%; height:100%; background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(8px); align-items: center; justify-content: center;">
        <div class="section-card" style="width: 100%; max-width: 600px; margin: auto; position: relative; border-radius: 20px; overflow: hidden; animation: slideUp 0.3s ease;">
            <div class="section-header" style="background: var(--primary); color: white; padding: 24px; display: flex; justify-content: space-between; align-items: center;">
                <h2 style="font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 8px; margin: 0;">
                    <span class="material-symbols-outlined">experiment</span>
                    New Test Request
                </h2>
                <button onclick="closeNewRequestModal()" style="background:rgba(255,255,255,0.2); border:none; cursor:pointer; color:white; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: background 0.2s;"><span class="material-symbols-outlined" style="font-size: 20px;">close</span></button>
            </div>
            <div style="padding: 32px;">
                <form action="/add-patient" method="POST">
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Patient Full Name</label>
                        <input type="text" name="name" class="form-select" style="padding-left:16px; border-radius: 10px;" placeholder="e.g. John Doe" required>
                    </div>
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-bottom: 20px;">
                        <div class="form-group">
                            <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Contact Number</label>
                            <input type="text" name="contactNumber" class="form-select" style="padding-left:16px; border-radius: 10px;" placeholder="+91 9876543210" required>
                        </div>
                        <div class="form-group">
                            <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Date of Birth</label>
                            <input type="date" name="dob" class="form-select" style="padding-left:16px; border-radius: 10px;" required>
                        </div>
                    </div>
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-bottom: 24px;">
                        <div class="form-group">
                            <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Gender</label>
                            <select name="gender" class="form-select" style="padding-left:16px; border-radius: 10px;">
                                <option>Male</option>
                                <option>Female</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Blood Group</label>
                            <select name="bloodGroup" class="form-select" style="padding-left:16px; border-radius: 10px;">
                                <option>A+</option><option>A-</option><option>B+</option><option>B-</option>
                                <option>O+</option><option>O-</option><option>AB+</option><option>AB-</option>
                            </select>
                        </div>
                    </div>
                    
                    <div style="padding: 16px; background: var(--gray-50); border-radius: 12px; margin-bottom: 24px; border: 1px solid var(--gray-200);">
                        <div style="margin-bottom: 16px;">
                            <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Prescribed Test</label>
                            <select name="testType" class="form-select" style="padding-left:16px; border-radius: 10px; background: white;">
                                <option>Complete Blood Count (CBC)</option>
                                <option>Lipid Profile</option>
                                <option>Thyroid Function Test</option>
                                <option>Blood Sugar (Fasting)</option>
                            </select>
                        </div>
                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-bottom: 16px;">
                            <div>
                                <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Collection Type</label>
                                <select name="collectionType" class="form-select" style="padding-left:16px; border-radius: 10px; background: white;">
                                    <option>Walk-in</option>
                                    <option>Home Collection</option>
                                </select>
                            </div>
                            <div>
                                <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Priority</label>
                                <select name="priority" class="form-select" style="padding-left:16px; border-radius: 10px; background: white;">
                                    <option>Normal</option>
                                    <option>Medium</option>
                                    <option>High</option>
                                </select>
                            </div>
                        </div>
                        <div>
                            <label style="display:block; margin-bottom: 8px; font-weight:600; color: var(--gray-700);">Lab Destination</label>
                            <select name="labDestination" class="form-select" style="padding-left:16px; border-radius: 10px; background: white;">
                                <option value="In-House">Same Hospital (In-House Lab)</option>
                                <option value="External">Different Lab (Requires Delivery Partner)</option>
                            </select>
                        </div>
                    </div>

                    <div style="display: flex; gap: 12px; justify-content: flex-end;">
                        <button type="button" class="btn-secondary" onclick="closeNewRequestModal()" style="border-radius: 10px;">Cancel</button>
                        <button type="submit" class="btn-primary" style="border-radius: 10px; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);">
                            <span class="material-symbols-outlined" style="font-size: 20px;">add_circle</span>
                            Create Request
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- PATIENT FULL RECORD MODAL -->
    <div id="patientFullModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(8px); z-index: 9999; align-items: center; justify-content: center; padding: 20px;">
        <div class="modal-container" style="background: #ffffff; width: 100%; max-width: 850px; border-radius: 24px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); overflow: hidden; display: flex; flex-direction: column; border: 1px solid rgba(255, 255, 255, 0.1);">
            <div id="modalContentInjected">
                <!-- Content will be injected here -->
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('click', function(event) {
            const btn = event.target.closest('.view-record-btn');
            if (btn) {
                const data = btn.dataset;
                viewPatientFull(data.id, data.name, data.pid, data.gender, data.dob, data.contact, data.blood, data.last, data.status, data.executive, data.phone, data.source, data.dest, data.eta, data.loc);
            }
        });

        function viewPatientFull(id, name, pid, gender, dob, contact, blood, last, status, executive, phone, source, dest, eta, loc) {
            const container = document.getElementById('modalContentInjected');
            container.innerHTML = `
                <div class="modal-top">
                    <div>
                        <h3 style="font-size: 20px; font-weight: 800; margin-bottom: 4px;">Patient Medical Report</h3>
                        <p style="opacity: 0.8; font-size: 13px;">Full comprehensive record for \${name}</p>
                    </div>
                    <button class="close-btn" onclick="closeFullModal()" style="color: white; font-size: 32px; opacity: 0.8;">&times;</button>
                </div>
                
                <div class="modal-info-grid">
                    <div>
                        <div class="info-card">
                            <h4 style="color: var(--primary); font-size: 15px; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                                <span class="material-symbols-outlined" style="font-size: 20px;">person</span>
                                Personal Information
                            </h4>
                            <div class="info-row"><span class="label">Full Name</span><span class="value">\${name}</span></div>
                            <div class="info-row"><span class="label">Patient ID</span><span class="value" style="color: var(--primary);">\${pid}</span></div>
                            <div class="info-row"><span class="label">Gender / DOB</span><span class="value">\${gender} / \${dob}</span></div>
                            <div class="info-row"><span class="label">Contact</span><span class="value">\${contact}</span></div>
                            <div class="info-row"><span class="label">Blood Group</span><span class="value" style="color: var(--error);">\${blood}</span></div>
                            <div class="info-row"><span class="label">Last Interaction</span><span class="value">\${last}</span></div>
                        </div>
                        
                        <div style="margin-top: 24px; padding: 20px; background: #EEF2FF; border-radius: 16px; border: 1px solid #C7D2FE;">
                            <h4 style="font-size: 14px; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; color: var(--primary-dark);">
                                <span class="material-symbols-outlined" style="font-size: 18px;">verified_user</span>
                                Lab Verification
                            </h4>
                            <p style="font-size: 12px; color: var(--primary-dark); line-height: 1.5; opacity: 0.9;">
                                This record was verified by <strong>Shyam (Senior Technician)</strong> at <strong>MediCare Central Lab</strong> on \${new Date().toLocaleDateString()}.
                            </p>
                        </div>
                    </div>
                    
                    <div>
                        <div class="info-card" style="border-color: #D1FAE5; background: #F0FDF4;">
                            <h4 style="color: #059669; font-size: 15px; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                                <span class="material-symbols-outlined" style="font-size: 20px;">local_shipping</span>
                                Logistics Tracking
                            </h4>
                            <div class="info-row"><span class="label">Current Status</span><span class="status-pill" style="background: #D1FAE5; color: #059669;">\${status}</span></div>
                            <div class="info-row"><span class="label">Executive</span><span class="value">\${executive || 'N/A'}</span></div>
                            <div class="info-row"><span class="label">Contact No.</span><span class="value">\${phone || 'N/A'}</span></div>
                            <div class="info-row"><span class="label">Current Location</span><span class="value" style="color: #059669;">\${loc || 'Processing'}</span></div>
                            <div class="info-row"><span class="label">Route</span><span class="value" style="font-size: 11px;">\${source} → \${dest}</span></div>
                            <div class="info-row"><span class="label">Estimated Time</span><span class="value">\${eta || 'N/A'}</span></div>
                        </div>
                        
                        <div style="margin-top: 24px;">
                            <button class="btn-modern btn-print-record" style="width: 100%; justify-content: center; height: 50px;" onclick="window.print()">
                                <span class="material-symbols-outlined">print</span>
                                Generate PDF Report
                            </button>
                        </div>
                    </div>
                </div>
                
                <div class="modal-action-bar">
                    <button class="btn-modern btn-close-record" onclick="closeFullModal()">Dismiss Record</button>
                    <button class="btn-modern btn-print-record" onclick="window.print()">
                        <span class="material-symbols-outlined">description</span>
                        Print Summary
                    </button>
                </div>
            `;
            document.getElementById('patientFullModal').style.display = 'flex';
        }

        function closeFullModal() {
            document.getElementById('patientFullModal').style.display = 'none';
        }

        function clearDoctorBadge() {
            const badge = document.getElementById('dr-badge');
            if (badge) {
                badge.style.display = 'none';
            }
        }

        function showSection(sectionId, event) {
            // Update UI Active State
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => item.classList.remove('active'));
            
            if (event && event.currentTarget.classList.contains('nav-item')) {
                event.currentTarget.classList.add('active');
            }

            // Hide all sections first
            const sections = document.querySelectorAll('.dashboard-section');
            sections.forEach(section => {
                section.style.display = 'none';
                section.classList.remove('active-section'); // For extra safety
            });
            
            // Resolve the target section
            let target = document.getElementById(sectionId);
            if (!target && !sectionId.endsWith('-section')) {
                target = document.getElementById(sectionId + '-section');
            }
            
            if (target) {
                target.style.display = 'block';
                target.classList.add('active-section');
                
                // Update Page Title based on ID
                const titleMap = {
                    'overview-section': 'Lab Dashboard',
                    'patients-section': 'Global Patient Records',
                    'profile-section': 'Technician Profile',
                    'notifications-section': 'System Notifications',
                    'logistics-section': 'Logistics & Sample Tracking',
                    'doctor-requests-section': 'Incoming Doctor Prescriptions',
                    'attendance-section': 'Attendance Tracking',
                    'shifts-section': 'My Shift Schedule',
                    'performance-section': 'Performance Analytics'
                };
                
                const titleElement = document.querySelector('.page-title');
                if (titleElement && titleMap[target.id]) {
                    titleElement.innerText = titleMap[target.id];
                }
            }
        }

        // New Test Request Modal functionality
        function openNewRequestModal() {
            document.getElementById('newRequestModal').style.display = 'flex';
        }

        function closeNewRequestModal() {
            document.getElementById('newRequestModal').style.display = 'none';
        }

        function editPatient(id, name, contact, gender, blood, dest) {
            document.getElementById('editId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editContact').value = contact;
            document.getElementById('editGender').value = gender;
            document.getElementById('editBlood').value = blood;
            document.getElementById('editLabDestination').value = dest;
            document.getElementById('editModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        // Logistics Map Integration
        let map;
        let markers = [];

        function showLogisticsView(view) {
            const tableContainer = document.getElementById('logistics-table-container');
            const mapContainer = document.getElementById('logistics-map-container');
            const toggleTableView = document.getElementById('toggleTableView');
            const toggleMapView = document.getElementById('toggleMapView');

            if (view === 'map') {
                tableContainer.style.display = 'none';
                mapContainer.style.display = 'block';
                toggleTableView.style.display = 'flex';
                toggleMapView.style.display = 'none';
                initLogisticsMap();
            } else {
                tableContainer.style.display = 'block';
                mapContainer.style.display = 'none';
                toggleTableView.style.display = 'none';
                toggleMapView.style.display = 'flex';
            }
        }

        function initLogisticsMap() {
            if (map) return; // Already initialized

            // Coordinates for demo (Bangalore area)
            const locations = {
                "City Medical Center": [12.9716, 77.5946],
                "Regional Health Center": [12.9352, 77.6245],
                "City Central Hospital": [12.9250, 77.5898],
                "In-House Lab": [12.9516, 77.6046],
                "MediCare Central Lab": [12.9516, 77.6046],
                "External Partner Lab": [12.9141, 77.6412],
                "MediCare Partner Lab": [12.9141, 77.6412]
            };

            map = L.map('logistics-map').setView([12.95, 77.61], 12);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap contributors'
            }).addTo(map);

            // Collect data from the UI or model
            const shipments = [];
            <c:forEach var="p" items="${patients}">
                <c:if test="${not empty p.deliveryStatus}">
                    shipments.push({
                        id: '${p.patientId}',
                        name: '${p.name}',
                        source: '${p.sourceHospital}',
                        dest: '${p.destinationHospital}',
                        loc: '${p.currentLocation}',
                        status: '${p.deliveryStatus}',
                        executive: '${p.deliveryAssignedTo}'
                    });
                </c:if>
            </c:forEach>

            shipments.forEach(s => {
                const sourceCoords = locations[s.source] || [12.9716, 77.5946];
                const destCoords = locations[s.dest] || [12.9141, 77.6412];
                
                // Destination Marker
                L.marker(destCoords, {
                    icon: L.divIcon({
                        className: 'map-marker-label',
                        html: `<div style="background: white; padding: 4px 8px; border-radius: 4px; border: 2px solid var(--primary); white-space: nowrap;">🏁 ${s.dest}</div>`
                    })
                }).addTo(map).bindPopup(`<b>Destination:</b> ${s.dest}`);

                // Source Marker
                L.marker(sourceCoords, {
                    icon: L.divIcon({
                        className: 'map-marker-label',
                        html: `<div style="background: white; padding: 4px 8px; border-radius: 4px; border: 2px solid var(--gray-400); white-space: nowrap;">📍 ${s.source}</div>`
                    })
                }).addTo(map).bindPopup(`<b>Origin:</b> ${s.source}`);

                // Current Location Marker (if in transit)
                if (s.status === 'In Transit') {
                    // Random offset for demo "en route"
                    const currentCoords = [
                        (sourceCoords[0] + destCoords[0]) / 2 + (Math.random() - 0.5) * 0.01,
                        (sourceCoords[1] + destCoords[1]) / 2 + (Math.random() - 0.5) * 0.01
                    ];
                    
                    const vanIcon = L.divIcon({
                        className: 'map-marker-label',
                        html: `<div style="background: var(--primary); color: white; padding: 6px 10px; border-radius: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); white-space: nowrap;">🚚 ${s.name} (${s.executive})</div>`
                    });

                    L.marker(currentCoords, { icon: vanIcon }).addTo(map)
                        .bindPopup(`<b>Patient:</b> ${s.name}<br><b>Status:</b> ${s.status}<br><b>Executive:</b> ${s.executive}`);
                }
            });

            // Adjust view to fit all shipments if any
            if (shipments.length > 0) {
                // simple bounds
                map.fitBounds([
                    [12.90, 77.55],
                    [13.00, 77.68]
                ]);
            }
        }

        function toggleNotifications(event) {
            event.stopPropagation();
            const dropdown = document.getElementById('notificationDropdown');
            dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
        }

        // Close dropdowns when clicking outside
        window.onclick = function(event) {
            const dropdown = document.getElementById('notificationDropdown');
            if (dropdown && !dropdown.contains(event.target) && !event.target.closest('.action-btn')) {
                dropdown.style.display = 'none';
            }
            
            const modal = document.getElementById('editModal');
            if (event.target == modal) {
                closeModal();
            }
        }

        function showFileName(input) {
            const info = document.getElementById('fileInfo');
            if (input.files && input.files[0]) {
                info.innerText = "Selected: " + input.files[0].name;
                info.style.display = 'block';
            }
        }

        function handleUpload(event) {
            event.preventDefault();
            const patient = event.target.querySelectorAll('select')[0].value;
            const test = event.target.querySelectorAll('select')[1].value;
            const file = document.getElementById('fileInput').files[0];
            
            if (!file) {
                alert('Please select a file first!');
                return;
            }

            alert('Uploading report for ' + patient + ' (' + test + ')... Success!');
            event.target.reset();
            document.getElementById('fileInfo').style.display = 'none';
            showSection('overview');
        }

        function openReportUpload(patientId) {
            showSection('reports-section');
            const select = document.getElementById('uploadPatientSelect');
            if (select) {
                select.value = patientId;
                // Trigger auto-select
                const option = select.querySelector(`option[value="${patientId}"]`);
                if (option && option.dataset.test) {
                    document.getElementById('uploadTestSelect').value = option.dataset.test;
                }
            }
        }

        // Auto-select test type when patient is chosen manually
        document.addEventListener('DOMContentLoaded', function() {
            const patientSelect = document.getElementById('uploadPatientSelect');
            if (patientSelect) {
                patientSelect.addEventListener('change', function() {
                    const selectedOption = this.options[this.selectedIndex];
                    const testType = selectedOption.dataset.test;
                    if (testType) {
                        document.getElementById('uploadTestSelect').value = testType;
                    }
                });
            }
        });

        function previewProfilePhoto(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profileImagePreview').src = e.target.result;
                }
                reader.readAsDataURL(file);
                
                // Show success toast
                const toast = document.createElement('div');
                toast.innerText = 'Profile photo updated successfully!';
                toast.style.cssText = 'position: fixed; bottom: 20px; right: 20px; background: var(--success); color: white; padding: 12px 24px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 9999; font-weight: 600; font-family: sans-serif;';
                document.body.appendChild(toast);
                setTimeout(() => { toast.style.opacity = '0'; toast.style.transition = 'opacity 0.3s'; setTimeout(() => toast.remove(), 300); }, 3000);
            }
        }

        function submitAttendance(status) {
            const now = new Date();
            const dateStr = now.toISOString().split('T')[0];
            const timeStr = now.toTimeString().split(' ')[0].substring(0, 5);
            
            if (status === 'Present') {
                document.getElementById('attDate').value = dateStr;
                document.getElementById('attTime').value = timeStr;
                document.getElementById('presentForm').submit();
            } else {
                document.getElementById('leaveDate').value = dateStr;
                document.getElementById('leaveTime').value = timeStr;
                document.getElementById('leaveForm').submit();
            }
        }

        function submitCheckout(recordId) {
            const now = new Date();
            const dateStr = now.toISOString().split('T')[0];
            const timeStr = now.toTimeString().split(' ')[0].substring(0, 5);
            
            document.getElementById('checkoutDate_' + recordId).value = dateStr;
            document.getElementById('checkoutTime_' + recordId).value = timeStr;
            document.getElementById('checkoutForm_' + recordId).submit();
        }
    </script>
</body>
</html>
