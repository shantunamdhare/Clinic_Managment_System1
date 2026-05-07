<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Reports | Clinic Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --sidebar-bg: #0f172a; --accent: #2563eb; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; margin: 0; }
        .sidebar { position: fixed; top: 0; left: 0; width: 260px; height: 100vh; background: var(--sidebar-bg); z-index: 1000; }
        .main-content { margin-left: 260px; min-height: 100vh; padding: 20px; }
        .report-card { background: #fff; border-radius: 16px; padding: 24px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .nav-link-item { display: flex; align-items: center; gap: 12px; padding: 10px 20px; color: #cbd5e1; text-decoration: none; border-left: 3px solid transparent; }
        .nav-link-item:hover, .nav-link-item.active { background: #1e3a5f; color: #fff; border-left-color: #3b82f6; }
        .avatar { width: 42px; height: 42px; border-radius: 50%; background: var(--accent); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; }
        .stat-box { padding: 20px; border-radius: 12px; background: #f8fafc; border: 1px solid #e2e8f0; }
        @media(max-width: 992px) { .sidebar { width: 80px; } .sidebar-brand h4, .sidebar-user div, .nav-link-item span { display: none; } .main-content { margin-left: 80px; } }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="p-4 border-bottom border-secondary border-opacity-10">
            <h4 class="text-white fw-bold mb-0">ClinicMS</h4>
        </div>
        <div class="p-3 d-flex align-items-center gap-3 border-bottom border-secondary border-opacity-10">
            <div class="avatar">${user.fullName.substring(0,1)}</div>
            <div class="text-white"><div class="fw-bold small">${user.fullName}</div><div style="font-size: 0.7rem; opacity: 0.7;">Receptionist</div></div>
        </div>
        <div class="nav flex-column mt-3">
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="nav-link-item"><i class="fas fa-th-large"></i> <span>Dashboard</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/patients" class="nav-link-item"><i class="fas fa-users"></i> <span>Patients</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/queue" class="nav-link-item"><i class="fas fa-users"></i> <span>Queue Status</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/calendar" class="nav-link-item"><i class="fas fa-calendar-alt"></i> <span>Calendar</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/reports" class="nav-link-item active"><i class="fas fa-file-medical"></i> <span>Reports</span></a>
        </div>
    </div>
    <div class="main-content">
        <div class="report-card">
            <h5 class="fw-bold mb-4">Clinic Daily Summary</h5>
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-box">
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.65rem;">Total Today</small>
                        <div class="h3 fw-bold mb-0">${stats.totalAppointmentsToday}</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.65rem;">Completed</small>
                        <div class="h3 fw-bold mb-0 text-success">${stats.completedConsultations}</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.65rem;">New Patients</small>
                        <div class="h3 fw-bold mb-0 text-primary">${stats.walkinsToday}</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.65rem;">Missed</small>
                        <div class="h3 fw-bold mb-0 text-danger">${stats.noShowCount}</div>
                    </div>
                </div>
            </div>
            <button class="btn btn-dark" onclick="window.print()"><i class="fas fa-print me-2"></i> Print Daily Report</button>
        </div>
    </div>
</body>
</html>
