<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live Queue Management | Clinic Management System</title>
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

        /* ---- Queue Grid ---- */
        .queue-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }
        .doctor-card {
            background: #fff;
            border-radius: 16px;
            padding: 0;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: 1px solid var(--card-border);
            transition: transform 0.2s;
        }
        .doctor-card:hover { transform: translateY(-5px); }
        .doctor-header {
            padding: 20px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .doctor-avatar {
            width: 50px; height: 50px; border-radius: 50%;
            background: var(--accent); color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 1.2rem;
        }
        .doctor-info h6 { margin: 0; font-weight: 700; color: #1e293b; }
        .doctor-info small { color: #64748b; font-size: 0.75rem; }

        .queue-body { padding: 20px; }
        .token-display {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px;
            background: #eff6ff;
            border-radius: 12px;
        }
        .token-item { text-align: center; }
        .token-number { font-size: 1.8rem; font-weight: 800; color: var(--accent); display: block; }
        .token-label { font-size: 0.7rem; color: #64748b; text-transform: uppercase; font-weight: 600; }

        .queue-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            text-align: center;
        }
        .stat-item { padding: 10px; border-radius: 10px; }
        .stat-waiting { background: #fffbeb; color: #92400e; }
        .stat-in-progress { background: #f0fdf4; color: #166534; }
        .stat-completed { background: #f1f5f9; color: #475569; }
        .stat-val { font-size: 1.2rem; font-weight: 700; display: block; }
        .stat-lbl { font-size: 0.65rem; opacity: 0.8; }

        @media(max-width: 992px) {
            .sidebar { width: 80px; }
            .sidebar-brand h4, .sidebar-brand small, .sidebar-user .name, .sidebar-user .role, .nav-link-item span, .nav-label { display: none; }
            .main-content { margin-left: 80px; }
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
            <a href="${pageContext.request.contextPath}/receptionist/patients" class="nav-link-item"><i class="fas fa-users"></i> <span>Patients</span></a>
            
            <div class="nav-label">Management</div>
            <a href="${pageContext.request.contextPath}/receptionist/queue" class="nav-link-item active"><i class="fas fa-users"></i> <span>Queue Status</span></a>
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
            <h5>Live Queue Management</h5>
            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-primary btn-sm" onclick="location.reload()">
                    <i class="fas fa-sync-alt me-1"></i> Refresh
                </button>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm" style="border-radius: 20px; padding: 5px 15px; font-weight: 600;">
                    <i class="fas fa-sign-out-alt me-1"></i> Logout
                </a>
            </div>
        </div>

            <div class="queue-grid">
                <c:forEach var="doc" items="${doctors}">
                    <c:set var="q" value="${doctorQueues[doc.id.toString()]}" />
                    <div class="doctor-card">
                        <div class="doctor-header">
                            <div class="doctor-avatar">${not empty doc.fullName ? doc.fullName.substring(0,1) : 'D'}</div>
                            <div class="doctor-info">
                                <h6>Dr. ${doc.fullName}</h6>
                                <small>${doc.specialization}</small>
                            </div>
                        </div>
                        <div class="queue-body">
                            <c:choose>
                                <c:when test="${not empty q}">
                                    <div class="token-display">
                                        <div class="token-item">
                                            <span class="token-number">${q.currentToken == 0 ? '--' : q.currentToken}</span>
                                            <span class="token-label">Serving</span>
                                        </div>
                                        <div class="token-item text-end">
                                            <span class="token-number" style="color: #64748b;">${q.waiting + q.inProgress + q.completed}</span>
                                            <span class="token-label">Total</span>
                                        </div>
                                    </div>
                                    <div class="queue-stats">
                                        <div class="stat-item stat-waiting">
                                            <span class="stat-val">${q.waiting}</span>
                                            <span class="stat-lbl">Waiting</span>
                                        </div>
                                        <div class="stat-item stat-in-progress">
                                            <span class="stat-val">${q.inProgress}</span>
                                            <span class="stat-lbl">In Office</span>
                                        </div>
                                        <div class="stat-item stat-completed">
                                            <span class="stat-val">${q.completed}</span>
                                            <span class="stat-lbl">Done</span>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-light text-center small py-2">No queue data</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="mt-4">
                                <button class="btn btn-outline-primary btn-sm w-100" onclick="alert('Viewing detailed queue for Dr. ${doc.fullName}')">
                                    View Patient List
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh every 30 seconds to keep queue live
        setTimeout(function() {
            location.reload();
        }, 30000);
    </script>
</body>
</html>
