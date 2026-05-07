<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Clinic Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #0f172a;
            --accent: #2563eb;
            --card-border: rgba(37,99,235,0.1);
        }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; margin: 0; }
        
        .sidebar { position: fixed; top: 0; left: 0; width: 260px; height: 100vh; background: var(--sidebar-bg); z-index: 1000; box-shadow: 4px 0 20px rgba(0,0,0,0.3); }
        .main-content { margin-left: 260px; min-height: 100vh; padding: 40px; }
        
        .nav-link-item { display: flex; align-items: center; gap: 12px; padding: 12px 20px; color: #cbd5e1; text-decoration: none; border-left: 3px solid transparent; }
        .nav-link-item:hover, .nav-link-item.active { background: #1e3a5f; color: #fff; border-left-color: #3b82f6; }

        .profile-card {
            background: #fff; border-radius: 20px;
            overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            max-width: 800px; margin: 0 auto;
        }
        .profile-header {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            padding: 40px; color: #fff; text-align: center;
        }
        .profile-avatar {
            width: 100px; height: 100px; border-radius: 50%;
            background: rgba(255,255,255,0.2); margin: 0 auto 15px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem; font-weight: 700; border: 4px solid rgba(255,255,255,0.3);
        }
        .profile-body { padding: 40px; }
        
        .form-label { font-weight: 600; color: #475569; font-size: 0.9rem; }
        .form-control { border-radius: 10px; padding: 12px; border: 1px solid #e2e8f0; }
        .form-control:focus { box-shadow: 0 0 0 4px rgba(37,99,235,0.1); border-color: var(--accent); }
        
        .btn-update {
            background: var(--accent); color: #fff; border: none;
            padding: 12px 30px; border-radius: 10px; font-weight: 600;
            transition: all 0.2s;
        }
        .btn-update:hover { background: #1d4ed8; transform: translateY(-2px); }

        @media(max-width: 992px) {
            .sidebar { width: 80px; }
            .sidebar span, .sidebar h4, .sidebar small { display: none; }
            .main-content { margin-left: 80px; padding: 20px; }
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="p-4 border-bottom border-secondary border-opacity-10 text-center">
            <h4 class="text-white fw-bold mb-0">ClinicMS</h4>
        </div>
        <div class="nav flex-column mt-4">
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="nav-link-item"><i class="fas fa-th-large"></i> <span>Dashboard</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/patients" class="nav-link-item"><i class="fas fa-users"></i> <span>Patients</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/queue" class="nav-link-item"><i class="fas fa-users"></i> <span>Queue Status</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/calendar" class="nav-link-item"><i class="fas fa-calendar-alt"></i> <span>Calendar</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/profile" class="nav-link-item active"><i class="fas fa-user-circle"></i> <span>My Profile</span></a>
        </div>
    </div>

    <div class="main-content">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-avatar">${user.fullName.substring(0,1)}</div>
                <h3 class="mb-1">${user.fullName}</h3>
                <p class="mb-0 opacity-75">Receptionist | ${user.email}</p>
            </div>
            
            <div class="profile-body">
                <c:if test="${param.success == 'true'}">
                    <div class="alert alert-success border-0 shadow-sm mb-4" style="border-radius: 12px;">
                        <i class="fas fa-check-circle me-2"></i> Profile updated successfully!
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/receptionist/profile/update" method="POST">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address</label>
                            <input type="email" class="form-control" name="email" value="${user.email}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone Number</label>
                            <input type="text" class="form-control" name="phone" value="${user.phone}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Role</label>
                            <input type="text" class="form-control" value="Receptionist" disabled>
                        </div>
                        <div class="col-12 mt-5 text-center">
                            <button type="submit" class="btn-update">
                                <i class="fas fa-save me-2"></i> Save Changes
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>
