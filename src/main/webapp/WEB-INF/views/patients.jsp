<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management | Clinic Management System</title>
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
        .content-area { padding: 28px; flex: 1; }

        /* ---- Panels ---- */
        .panel {
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: 1px solid var(--card-border);
            margin-bottom: 24px;
        }
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

        @media(max-width: 992px) {
            .sidebar { width: 80px; }
            .sidebar-brand h4, .sidebar-brand small, .sidebar-user .name, .sidebar-user .role, .nav-link-item span, .nav-label { display: none; }
            .main-content { margin-left: 80px; }
            .nav-link-item { justify-content: center; padding: 15px; }
        }

        @media(max-width: 768px) {
            .sidebar { display: none; }
            .main-content { margin-left: 0; padding: 15px; }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <h4><i class="fas fa-hospital-alt me-2" style="color:#3b82f6"></i> ClinicMS</h4>
            <small>Reception Portal</small>
        </div>
        <div class="sidebar-user">
            <div class="avatar">${user.fullName.substring(0,1)}</div>
            <div>
                <div class="name">${user.fullName}</div>
                <div class="role">Receptionist</div>
            </div>
        </div>
        <div class="nav flex-column mt-4">
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="nav-link-item"><i class="fas fa-th-large"></i> <span>Dashboard</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/patients" class="nav-link-item active"><i class="fas fa-users"></i> <span>Patients</span></a>
            
            <div class="nav-label">Management</div>
            <a href="${pageContext.request.contextPath}/receptionist/queue" class="nav-link-item"><i class="fas fa-users"></i> <span>Queue Status</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/calendar" class="nav-link-item"><i class="fas fa-calendar-alt"></i> <span>Calendar</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/reports" class="nav-link-item"><i class="fas fa-file-medical"></i> <span>Reports</span></a>
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
            <h5>Patient Management</h5>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm" style="border-radius: 20px; padding: 5px 15px; font-weight: 600;">
                    <i class="fas fa-sign-out-alt me-1"></i> Logout
                </a>
            </div>
        </div>

        <div class="content-area">
            <div class="panel">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="panel-title m-0"><i class="fas fa-user-injured"></i> Registered Patients</div>
                    <div class="d-flex gap-2">
                        <input type="text" class="form-control form-control-sm" placeholder="Search patients..." id="tableSearch">
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="custom-table" id="patientsTable">
                        <thead>
                            <tr>
                                <th>Patient ID</th>
                                <th>Name</th>
                                <th>Age/Gender</th>
                                <th>Contact</th>
                                <th>Blood Group</th>
                                <th>Registration Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${patients}">
                                <tr>
                                    <td><strong>${p.patientId}</strong></td>
                                    <td class="fw-bold">${p.name}</td>
                                    <td>${p.age} / ${p.gender}</td>
                                    <td>${p.contactNumber}</td>
                                    <td><span class="badge bg-light text-primary border">${p.bloodGroup}</span></td>
                                    <td>${p.registrationDate}</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" onclick="alert('Viewing profile for ${p.name}')">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script>
        // Simple Table Filter
        document.getElementById('tableSearch').addEventListener('keyup', function() {
            const query = this.value.toLowerCase();
            const rows = document.querySelectorAll('#patientsTable tbody tr');
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        });
    </script>
</body>
</html>
