<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - Clinic Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
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
        .sidebar-doctor {
            padding: 16px 20px;
            display: flex; align-items: center; gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
            transition: background 0.2s ease;
        }
        .sidebar-doctor:hover {
            background: rgba(255,255,255,0.05);
        }
        .sidebar-doctor .avatar {
            width: 42px; height: 42px; border-radius: 50%;
            background: var(--accent); display: flex;
            align-items: center; justify-content: center;
            color: white; font-weight: 700; font-size: 1.1rem;
            flex-shrink: 0;
        }
        .sidebar-doctor .name { color: #fff; font-size: 0.85rem; font-weight: 600; }
        .sidebar-doctor .role { color: var(--text-muted-custom); font-size: 0.72rem; }
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
            border-radius: 0;
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
        .btn-logout {
            display: flex; align-items: center; gap: 10px;
            color: #f87171; text-decoration: none; font-size: 0.875rem;
            padding: 8px 12px; border-radius: 6px; transition: background 0.2s;
        }
        .btn-logout:hover { background: rgba(248,113,113,0.1); color: #f87171; }

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
        .custom-table tr:last-child td { border-bottom: none; }
        .custom-table tr:hover td { background: #f8fafc; }

        /* ---- Badges ---- */
        .badge-pending { background: #fef3c7; color: #92400e; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-completed { background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-cancelled { background: #fee2e2; color: #991b1b; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }

        /* ---- Buttons ---- */
        .btn-primary-custom {
            background: var(--accent); color: #fff; border: none;
            padding: 8px 18px; border-radius: 8px; font-size: 0.85rem;
            font-weight: 600; cursor: pointer; transition: background 0.2s;
        }
        .btn-primary-custom:hover { background: var(--accent-light); }
        .btn-sm-action {
            padding: 4px 10px; border-radius: 6px; font-size: 0.75rem;
            font-weight: 600; text-decoration: none; display: inline-flex;
            align-items: center; gap: 4px; border: none; cursor: pointer;
        }
        .btn-view { background: #dbeafe; color: var(--accent); }
        .btn-complete { background: #dcfce7; color: #16a34a; }
        .btn-delete { background: #fee2e2; color: #dc2626; }
        .btn-print { background: #f3e8ff; color: #7c3aed; }

        /* ---- Forms ---- */
        .form-label-custom { font-size: 0.82rem; font-weight: 600; color: #475569; margin-bottom: 4px; }
        .form-control-custom {
            width: 100%; padding: 9px 12px; border-radius: 8px;
            border: 1px solid #cbd5e1; font-size: 0.875rem;
            color: #1e293b; transition: border 0.2s;
        }
        .form-control-custom:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
        .form-group { margin-bottom: 16px; }

        /* ---- Alerts ---- */
        .alert-custom {
            padding: 12px 18px; border-radius: 10px;
            font-size: 0.875rem; margin-bottom: 18px;
            display: flex; align-items: center; gap: 10px;
        }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        @media(max-width: 768px) {
            .sidebar { width: 100%; height: auto; position: relative; }
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>

<!-- ======================== SIDEBAR ======================== -->
<div class="sidebar">
    <div class="sidebar-brand">
        <h4><i class="fas fa-hospital-alt me-2" style="color:#3b82f6"></i> ClinicMS</h4>
        <small>Doctor Portal</small>
    </div>
    <a href="/doctor/profile" style="text-decoration: none;">
        <div class="sidebar-doctor">
            <div class="avatar">${doctor.fullName.substring(0,1)}</div>
            <div>
                <div class="name">Dr. ${doctor.fullName}</div>
                <div class="role">${doctor.specialization != null ? doctor.specialization : 'General Practitioner'}</div>
            </div>
        </div>
    </a>
    <nav>
        <div class="nav-label">Main</div>
        <a href="/doctor/dashboard" class="nav-link-item ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
            <i class="fas fa-th-large"></i> Dashboard
        </a>
        <a href="/doctor/appointments" class="nav-link-item ${pageContext.request.requestURI.contains('appointments') ? 'active' : ''}">
            <i class="fas fa-calendar-check"></i> Today's Appointments
        </a>

        <div class="nav-label">Clinical</div>
        <a href="/doctor/patients" class="nav-link-item ${pageContext.request.requestURI.contains('patients') ? 'active' : ''}">
            <i class="fas fa-user-injured"></i> Patients
        </a>
        <a href="/doctor/emr" class="nav-link-item ${pageContext.request.requestURI.contains('emr') ? 'active' : ''}">
            <i class="fas fa-file-medical-alt"></i> EMR
        </a>
        <a href="/doctor/prescriptions" class="nav-link-item ${pageContext.request.requestURI.contains('prescriptions') ? 'active' : ''}">
            <i class="fas fa-prescription-bottle-alt"></i> Prescriptions
        </a>

        <div class="nav-label">Lab</div>
        <a href="/doctor/lab-requests" class="nav-link-item ${pageContext.request.requestURI.contains('lab-requests') ? 'active' : ''}">
            <i class="fas fa-flask"></i> Lab Tests
        </a>
        <a href="/doctor/lab-reports" class="nav-link-item ${pageContext.request.requestURI.contains('lab-reports') ? 'active' : ''}">
            <i class="fas fa-file-alt"></i> Lab Reports
        </a>

        <div class="nav-label">Schedule</div>
        <a href="/doctor/availability" class="nav-link-item ${pageContext.request.requestURI.contains('availability') ? 'active' : ''}">
            <i class="fas fa-clock"></i> Availability
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="/logout" class="btn-logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</div>

<!-- ======================== MAIN CONTENT ======================== -->
<div class="main-content">
    <div class="topbar">
        <h5 id="page-title">Doctor Dashboard</h5>
        <span class="date-badge"><i class="fas fa-calendar me-1"></i>
            <jsp:useBean id="now" class="java.util.Date"/>
            <%@ page import="java.time.LocalDate" %>
            <%= LocalDate.now().toString() %>
        </span>
    </div>
    <div class="content-area">

        <!-- Flash Messages -->
        <c:if test="${not empty success}">
            <div class="alert-custom alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert-custom alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        </c:if>

        <!-- ======== DASHBOARD OVERVIEW ======== -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fas fa-user-injured"></i></div>
                    <div>
                        <div class="stat-value">${totalPatients}</div>
                        <div class="stat-label">Total Patients</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fas fa-calendar-check"></i></div>
                    <div>
                        <div class="stat-value">${todayAppointments}</div>
                        <div class="stat-label">Today's Appointments</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="fas fa-flask"></i></div>
                    <div>
                        <div class="stat-value">${pendingLabReports}</div>
                        <div class="stat-label">Pending Lab Reports</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="panel">
            <div class="panel-title"><i class="fas fa-bolt"></i> Quick Actions</div>
            <div class="d-flex flex-wrap gap-3">
                <a href="/doctor/appointments" class="btn-primary-custom" style="text-decoration:none; padding:10px 20px; border-radius:10px;">
                    <i class="fas fa-calendar-check me-2"></i>View Appointments
                </a>
                <a href="/doctor/emr" class="btn-primary-custom" style="text-decoration:none; padding:10px 20px; border-radius:10px; background:#7c3aed;">
                    <i class="fas fa-file-medical-alt me-2"></i>New EMR Record
                </a>
                <a href="/doctor/patients/add" class="btn-primary-custom" style="text-decoration:none; padding:10px 20px; border-radius:10px; background:#16a34a;">
                    <i class="fas fa-user-plus me-2"></i>Add Patient
                </a>
                <a href="/doctor/lab-requests" class="btn-primary-custom" style="text-decoration:none; padding:10px 20px; border-radius:10px; background:#d97706;">
                    <i class="fas fa-flask me-2"></i>Request Lab Test
                </a>
            </div>
        </div>

    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
