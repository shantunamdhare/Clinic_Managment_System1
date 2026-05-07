<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receptionist Dashboard | Clinic Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e3a5f;
            --accent: #2563eb;
            --accent-light: #3b82f6;
            --text-muted-custom: #94a3b8;
            --card-border: rgba(37,99,235,0.15);
        }
        * { box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; margin: 0; }

        /* ---- Sidebar ---- */
        .sidebar {
            position: fixed; top: 0; left: 0;
            width: 260px; height: 100vh;
            background: var(--sidebar-bg);
            display: flex; flex-direction: column;
            z-index: 1000; overflow-y: auto;
            box-shadow: 4px 0 20px rgba(0,0,0,0.3);
        }
        .sidebar-brand {
            padding: 24px 20px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .sidebar-brand h4 { color: #fff; font-weight: 700; margin: 0; font-size: 1.1rem; }
        .sidebar-brand small { color: var(--text-muted-custom); font-size: 0.75rem; }
        
        .sidebar-user {
            padding: 16px 20px;
            display: flex; align-items: center; gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .sidebar-user .avatar {
            width: 42px; height: 42px; border-radius: 50%;
            background: var(--accent); display: flex;
            align-items: center; justify-content: center;
            color: white; font-weight: 700; font-size: 1.1rem;
            flex-shrink: 0;
        }
        .sidebar-user .name { color: #fff; font-size: 0.85rem; font-weight: 600; }
        .sidebar-user .role { color: var(--text-muted-custom); font-size: 0.72rem; }

        .sidebar nav { padding: 12px 0; flex: 1; }
        .nav-label {
            padding: 8px 20px 4px;
            color: var(--text-muted-custom);
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            font-weight: 600;
        }
        .nav-link-item {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 20px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 0.875rem;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .nav-link-item:hover, .nav-link-item.active {
            background: var(--sidebar-hover);
            color: #fff;
            border-left-color: var(--accent-light);
        }
        .nav-link-item i { width: 18px; text-align: center; opacity: 0.8; }
        
        .sidebar-footer { padding: 16px 20px; border-top: 1px solid rgba(255,255,255,0.07); }
        .btn-logout-sidebar {
            display: flex; align-items: center; gap: 10px;
            color: #f87171; text-decoration: none; font-size: 0.875rem;
            padding: 8px 12px; border-radius: 6px; transition: background 0.2s;
        }
        .btn-logout-sidebar:hover { background: rgba(248,113,113,0.1); }

        /* ---- Main Content ---- */
        .main-content {
            margin-left: 260px;
            min-height: 100vh;
            display: flex; flex-direction: column;
        }
        .topbar {
            background: #fff;
            padding: 16px 28px;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            position: sticky; top: 0; z-index: 100;
        }
        .topbar h5 { margin: 0; font-weight: 700; color: #1e293b; font-size: 1.1rem; }
        .topbar .date-badge {
            background: #f0f4f8; color: #64748b;
            padding: 5px 14px; border-radius: 20px; font-size: 0.8rem;
        }
        .content-area { padding: 28px; flex: 1; }

        /* ---- Stat Cards ---- */
        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: 1px solid var(--card-border);
            display: flex; align-items: center; gap: 18px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(37,99,235,0.1); }
        .stat-icon {
            width: 58px; height: 58px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; flex-shrink: 0;
        }
        .stat-icon.blue { background: #dbeafe; color: var(--accent); }
        .stat-icon.green { background: #dcfce7; color: #16a34a; }
        .stat-icon.amber { background: #fef3c7; color: #d97706; }
        .stat-icon.red { background: #fee2e2; color: #dc2626; }
        .stat-value { font-size: 2rem; font-weight: 800; color: #1e293b; line-height: 1; }
        .stat-label { color: #64748b; font-size: 0.82rem; margin-top: 4px; }

        /* ---- Panels ---- */
        .panel {
            background: #fff; border-radius: 16px; padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: 1px solid var(--card-border); margin-bottom: 24px;
            position: relative;
        }
        /* Fix for dropdowns in responsive tables */
        .table-responsive { overflow: visible !important; }
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .panel-title {
            font-size: 1rem; font-weight: 700;
            color: #1e293b; margin-bottom: 18px;
            display: flex; align-items: center; gap: 8px;
        }
        .panel-title i { color: var(--accent); }

        /* ---- Tables ---- */
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table th {
            background: #f8fafc; color: #475569;
            font-size: 0.75rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.05em;
            padding: 10px 14px; border-bottom: 1px solid #e2e8f0;
        }
        .custom-table td {
            padding: 12px 14px; border-bottom: 1px solid #f1f5f9;
            font-size: 0.875rem; color: #334155; vertical-align: middle;
        }
        .custom-table tr:hover td { background: #f8fafc; }

        .status-badge {
            padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600;
        }
        .status-waiting { background: #fef3c7; color: #92400e; }
        .status-completed { background: #dcfce7; color: #166534; }
        .status-noshow { background: #fee2e2; color: #991b1b; }

        .btn-primary-custom {
            background: var(--accent); color: #fff; border: none;
            padding: 8px 18px; border-radius: 8px; font-size: 0.85rem;
            font-weight: 600; cursor: pointer; transition: background 0.2s;
            text-decoration: none; display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-primary-custom:hover { background: var(--accent-light); color: #fff; }

        @media(max-width: 992px) {
            .sidebar { width: 80px; }
            .sidebar-brand h4, .sidebar-brand small, .sidebar-user .name, .sidebar-user .role, .nav-link-item span, .nav-label { display: none; }
            .main-content { margin-left: 80px; }
            .nav-link-item { justify-content: center; padding: 15px; }
        }

        @media(max-width: 768px) {
            .sidebar { display: none; }
            .main-content { margin-left: 0; padding: 15px; }
            .topbar { padding: 10px 15px; }
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <h4><i class="fas fa-hospital-alt me-2" style="color:#3b82f6"></i> ClinicMS</h4>
            <small>Reception Portal</small>
        </div>
        <a href="${pageContext.request.contextPath}/receptionist/profile" class="sidebar-user text-decoration-none">
            <div class="avatar">${user.fullName.substring(0,1)}</div>
            <div>
                <div class="name text-white">${user.fullName}</div>
                <div class="role text-muted-custom small">Receptionist</div>
            </div>
        </a>
            <div class="nav flex-column mt-4">
                <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="nav-link-item ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}"><i class="fas fa-th-large"></i> <span>Dashboard</span></a>
                <a href="${pageContext.request.contextPath}/receptionist/patients" class="nav-link-item"><i class="fas fa-users"></i> <span>Patients</span></a>
                <a href="#" class="nav-link-item" data-bs-toggle="modal" data-bs-target="#registrationModal"><i class="fas fa-user-plus"></i> <span>Register Patient</span></a>
                <a href="#" class="nav-link-item" data-bs-toggle="modal" data-bs-target="#bookingModal"><i class="fas fa-calendar-check"></i> <span>Book Appointment</span></a>
                
                <div class="nav-label">Management</div>
                <a href="${pageContext.request.contextPath}/receptionist/queue" class="nav-link-item ${pageContext.request.requestURI.contains('queue') ? 'active' : ''}"><i class="fas fa-users"></i> <span>Queue Status</span></a>
                <a href="${pageContext.request.contextPath}/receptionist/calendar" class="nav-link-item ${pageContext.request.requestURI.contains('calendar') ? 'active' : ''}"><i class="fas fa-calendar-alt"></i> <span>Calendar</span></a>
                <a href="${pageContext.request.contextPath}/receptionist/profile" class="nav-link-item ${pageContext.request.requestURI.contains('profile') ? 'active' : ''}"><i class="fas fa-user-circle"></i> <span>My Profile</span></a>
                <a href="${pageContext.request.contextPath}/receptionist/reports" class="nav-link-item ${pageContext.request.requestURI.contains('reports') ? 'active' : ''}"><i class="fas fa-file-medical"></i> <span>Reports</span></a>
            </div>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout-sidebar">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="topbar">
            <h5>Receptionist Dashboard</h5>
            <div class="d-flex align-items-center gap-3">
                <span class="date-badge"><i class="fas fa-calendar me-1"></i>
                    <%= LocalDate.now().toString() %>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm" style="border-radius: 20px; padding: 5px 15px; font-weight: 600;">
                    <i class="fas fa-sign-out-alt me-1"></i> Logout
                </a>
            </div>
        </div>

        <div class="content-area">
            <!-- Dashboard Statistics -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon blue"><i class="fas fa-calendar-check"></i></div>
                        <div>
                            <div class="stat-value">${stats.totalAppointmentsToday}</div>
                            <div class="stat-label">Appointments Today</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon green"><i class="fas fa-user-check"></i></div>
                        <div>
                            <div class="stat-value">${stats.completedConsultations}</div>
                            <div class="stat-label">Completed</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon amber"><i class="fas fa-clock"></i></div>
                        <div>
                            <div class="stat-value">${stats.pendingConsultations}</div>
                            <div class="stat-label">Pending</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon red"><i class="fas fa-user-slash"></i></div>
                        <div>
                            <div class="stat-value">${stats.noShowCount}</div>
                            <div class="stat-label">No-shows</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="panel">
                <div class="panel-title"><i class="fas fa-bolt"></i> Quick Actions</div>
                <div class="d-flex flex-wrap gap-3">
                    <button class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#registrationModal">
                        <i class="fas fa-user-plus me-2"></i> New Registration
                    </button>
                    <button class="btn-primary-custom" style="background:#7c3aed;" data-bs-toggle="modal" data-bs-target="#bookingModal">
                        <i class="fas fa-calendar-plus me-2"></i> Book Appointment
                    </button>
                    <a href="${pageContext.request.contextPath}/receptionist/queue" class="btn-primary-custom text-decoration-none d-flex align-items-center" style="background:#16a34a;">
                        <i class="fas fa-users me-2"></i> Live Queue
                    </a>
                </div>
            </div>

            <!-- Staff Operations (Attendance, Shift, Performance) -->
            <div class="row g-4 mb-5">
                <div class="col-lg-12">
                    <div class="panel">
                        <div class="panel-title d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-briefcase"></i> Staff Operations</span>
                            <div class="attendance-actions">
                                <c:choose>
                                    <c:when test="${empty attendance or empty attendance.checkIn}">
                                        <form action="${pageContext.request.contextPath}/receptionist/attendance/checkin" method="POST" class="d-inline">
                                            <button type="submit" class="btn btn-success btn-sm px-3 shadow-sm" style="border-radius: 8px;">
                                                <i class="fas fa-sign-in-alt me-1"></i> Check In
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${empty attendance.checkOut}">
                                        <div class="d-inline-block me-3 text-muted small">
                                            <i class="fas fa-clock me-1"></i> In at: <strong>${attendance.checkIn}</strong>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/receptionist/attendance/checkout" method="POST" class="d-inline">
                                            <button type="submit" class="btn btn-danger btn-sm px-3 shadow-sm" style="border-radius: 8px;">
                                                <i class="fas fa-sign-out-alt me-1"></i> Check Out
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="badge bg-light text-dark border p-2 shadow-sm" style="border-radius: 8px;">
                                            <i class="fas fa-check-circle text-success me-1"></i> Day Completed
                                            <span class="ms-2 opacity-50">${attendance.checkIn} - ${attendance.checkOut}</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="row mt-3">
                            <!-- Shift Schedule -->
                            <div class="col-md-6 border-end">
                                <h6 class="fw-bold small text-muted mb-3"><i class="fas fa-calendar-day me-2"></i> My Shift Schedule</h6>
                                <c:choose>
                                    <c:when test="${not empty shifts}">
                                        <div class="table-responsive">
                                            <table class="table table-sm table-borderless align-middle">
                                                <thead class="text-muted" style="font-size: 0.7rem; text-transform: uppercase;">
                                                    <tr><th>Day</th><th>Time</th><th>Shift</th></tr>
                                                </thead>
                                                <tbody class="small">
                                                    <c:forEach var="s" items="${shifts}">
                                                        <tr>
                                                            <td class="fw-bold">${s.dayOfWeek}</td>
                                                            <td>${s.shiftStart != null ? s.shiftStart.toLocalTime() : s.startTime} - ${s.shiftEnd != null ? s.shiftEnd.toLocalTime() : s.endTime}</td>
                                                            <td><span class="badge bg-soft-primary text-primary border">${s.note}</span></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 bg-light rounded-4">
                                            <i class="fas fa-calendar-times opacity-25 h1 d-block mb-2"></i>
                                            <p class="text-muted small">No shift scheduled by Admin</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Performance -->
                            <div class="col-md-6 ps-md-4">
                                <h6 class="fw-bold small text-muted mb-3"><i class="fas fa-chart-line me-2"></i> My Performance Metrics</h6>
                                <c:choose>
                                    <c:when test="${not empty performance}">
                                        <c:forEach var="p" items="${performance}" end="0">
                                            <div class="performance-card p-3 rounded-4 bg-light border-0 shadow-none mb-3">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <div class="rating text-warning h4 mb-0">
                                                        <c:forEach begin="1" end="${p.rating.intValue()}">
                                                            <i class="fas fa-star"></i>
                                                        </c:forEach>
                                                        <c:if test="${p.rating % 1 != 0}">
                                                            <i class="fas fa-star-half-alt"></i>
                                                        </c:if>
                                                    </div>
                                                    <small class="text-muted">${p.reviewDate}</small>
                                                </div>
                                                <p class="small text-dark mb-0 fst-italic">"${p.comments}"</p>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4 bg-light rounded-4">
                                            <i class="fas fa-award opacity-25 h1 d-block mb-2"></i>
                                            <p class="text-muted small">Awaiting first performance review</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                    <div class="panel h-100">
                        <div class="panel-title"><i class="fas fa-list"></i> Today's Appointments</div>
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Token</th>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Time</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="app" items="${todayAppointments}">
                                        <tr>
                                            <td><strong>#${app.tokenNumber}</strong></td>
                                            <td>
                                                <div class="fw-bold">${app.patient.name}</div>
                                                <small class="text-muted">${app.patient.patientId}</small>
                                            </td>
                                            <td>Dr. ${app.doctor.fullName}</td>
                                            <td>${app.appointmentTime}</td>
                                            <td>
                                                <span class="status-badge status-${app.status == 'Waiting' ? 'waiting' : (app.status == 'Completed' ? 'completed' : 'noshow')}">
                                                    ${app.status}
                                                </span>
                                            </td>
                                             <td>
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-light border shadow-sm" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="border-radius: 8px;">
                                                        <i class="fas fa-ellipsis-v text-muted"></i>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="border-radius: 12px; min-width: 160px;">
                                                        <li><h6 class="dropdown-header">Update Status</h6></li>
                                                        <li><a class="dropdown-item rounded" href="#" onclick="updateStatus(${app.id}, 'Waiting')"><i class="fas fa-clock me-2 text-warning"></i> Check-in</a></li>
                                                        <li><a class="dropdown-item rounded" href="#" onclick="updateStatus(${app.id}, 'Completed')"><i class="fas fa-check-circle me-2 text-success"></i> Check-out</a></li>
                                                        <li><a class="dropdown-item rounded" href="#" onclick="updateStatus(${app.id}, 'No-show')"><i class="fas fa-user-slash me-2 text-danger"></i> Mark No-show</a></li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Trends Chart -->
                <div class="col-lg-4">
                    <div class="panel h-100">
                        <div class="panel-title"><i class="fas fa-chart-line"></i> Appointment Trends</div>
                        <div style="height: 300px;">
                            <canvas id="appointmentChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals (Registration/Booking) -->
    <!-- Registration Modal -->
    <div class="modal fade" id="registrationModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold"><i class="fas fa-user-plus me-2"></i>New Patient Registration</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="registrationForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Age</label>
                                <input type="number" class="form-control" name="age" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Gender</label>
                                <select class="form-select" name="gender">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contact Number</label>
                                <input type="tel" class="form-control" name="contactNumber" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Blood Group</label>
                                <select class="form-select" name="bloodGroup">
                                    <option value="A+">A+</option>
                                    <option value="B+">B+</option>
                                    <option value="O+">O+</option>
                                    <option value="AB+">AB+</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Address</label>
                                <textarea class="form-control" name="address" rows="2"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary px-4" onclick="submitRegistration()">Register Patient</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Booking Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fas fa-calendar-plus me-2"></i>Book New Appointment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="bookingForm">
                        <div class="mb-3">
                            <label class="form-label">Search Patient</label>
                            <input type="text" class="form-control" id="patientSearch" placeholder="Enter ID or Phone...">
                            <div id="patientResults" class="list-group mt-2 shadow-sm" style="display:none"></div>
                            <input type="hidden" name="patientId" id="selectedPatientId">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Department</label>
                            <select class="form-select" name="department" id="deptSelect">
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.name}">${dept.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Select Doctor</label>
                            <select class="form-select" name="doctorId">
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.id}">Dr. ${doc.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Date</label>
                                <input type="date" class="form-control" name="date" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Time Slot</label>
                                <input type="time" class="form-control" name="time" required>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success px-4" onclick="submitBooking()">Confirm Booking</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize Chart
        const ctx = document.getElementById('appointmentChart').getContext('2d');
        if (ctx) {
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: [
                        <c:forEach var="t" items="${trends}" varStatus="status">
                            '${t.date}'${!status.last ? ',' : ''}
                        </c:forEach>
                    ],
                    datasets: [{
                        label: 'Appointments',
                        data: [
                            <c:forEach var="t" items="${trends}" varStatus="status">
                                ${t.count}${!status.last ? ',' : ''}
                            </c:forEach>
                        ],
                        borderColor: '#2563eb',
                        backgroundColor: 'rgba(37, 99, 235, 0.1)',
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#f1f5f9' } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        // Patient Search & Selection
        document.getElementById('patientSearch').addEventListener('input', function(e) {
            const query = e.target.value;
            if (query.length < 3) return;
            
            fetch(`${pageContext.request.contextPath}/receptionist/patient/search?query=` + query)
                .then(res => res.json())
                .then(data => {
                    const results = document.getElementById('patientResults');
                    results.innerHTML = '';
                    if (data.length > 0) {
                        data.forEach(p => {
                            const item = document.createElement('a');
                            item.className = 'list-group-item list-group-item-action';
                            item.innerHTML = `<strong>${p.name}</strong> <small class="text-muted">(${p.patientId})</small>`;
                            item.href = 'javascript:void(0)';
                            item.onclick = () => {
                                document.getElementById('patientSearch').value = p.name + " (" + p.patientId + ")";
                                document.getElementById('selectedPatientId').value = p.id;
                                results.style.display = 'none';
                            };
                            results.appendChild(item);
                        });
                        results.style.display = 'block';
                    }
                });
        });

        function submitRegistration() {
            const formData = new FormData(document.getElementById('registrationForm'));
            const data = Object.fromEntries(formData.entries());
            if(!data.name || !data.contactNumber) {
                alert('Please fill at least name and contact number');
                return;
            }
            fetch(`${pageContext.request.contextPath}/receptionist/patient/register`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(res => {
                if(!res.ok) throw new Error('Registration failed');
                return res.json();
            })
            .then(p => {
                alert('Success! Patient Registered. ID: ' + p.patientId);
                location.reload();
            })
            .catch(err => {
                console.error(err);
                alert('Error: Could not register patient. Please try again.');
            });
        }

        function submitBooking() {
            const formData = new FormData(document.getElementById('bookingForm'));
            const data = Object.fromEntries(formData.entries());
            
            if(!data.patientId || !data.doctorId || !data.date || !data.time) {
                alert('Please search/select a patient and fill all fields.');
                return;
            }

            fetch(`${pageContext.request.contextPath}/receptionist/appointment/book`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            }).then(res => res.json()).then(app => {
                alert('Booking Confirmed! Token: #' + app.tokenNumber);
                location.reload();
            });
        }

        function updateStatus(id, status) {
            const formData = new FormData();
            formData.append('id', id);
            formData.append('status', status);
            fetch(`${pageContext.request.contextPath}/receptionist/appointment/update-status`, {
                method: 'POST',
                body: formData
            }).then(() => location.reload());
        }
    </script>
</body>
</html>
