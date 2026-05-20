<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Dashboard | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#f4f6f8; color:#1e293b; min-height:100vh; }

        .admin-layout { display:flex; min-height:100vh; }

        /* Sidebar */
        .admin-sidebar {
            width:260px; background:linear-gradient(180deg,#1e1b4b 0%,#312e81 100%);
            padding:24px 0; display:flex; flex-direction:column; position:fixed;
            top:0; left:0; height:100vh; z-index:100; border-right:1px solid rgba(99,102,241,0.15);
        }
        .sidebar-brand { padding:0 24px 28px; border-bottom:1px solid rgba(255,255,255,0.06); }
        .sidebar-brand h2 { font-size:22px; font-weight:800; background:linear-gradient(135deg,#818cf8,#c7d2fe);
            -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .sidebar-brand span { font-size:11px; color:#a5b4fc; }
        .sidebar-nav { 
            flex:1; padding:20px 12px; display:flex; flex-direction:column; gap:4px; 
            overflow-y:auto; -ms-overflow-style: none; scrollbar-width: none; 
        }
        .sidebar-nav::-webkit-scrollbar { display: none; }
        .nav-item {
            display:flex; align-items:center; gap:12px; padding:11px 16px; border-radius:10px;
            color:#c7d2fe; font-size:14px; font-weight:500; cursor:pointer; transition:all .2s;
            text-decoration:none;
        }
        .nav-item:hover, .nav-item.active { background:rgba(99,102,241,0.2); color:#fff; }
        .nav-item.active { background:rgba(99,102,241,0.4); color:#fff; font-weight:600; border-left: 3px solid #818cf8; }
        .nav-icon { font-size:18px; width:24px; text-align:center; }
        .sidebar-footer { padding:16px 24px; border-top:1px solid rgba(255,255,255,0.06); }
        .sidebar-footer a {
            display:flex; align-items:center; gap:10px; color:#fca5a5; font-size:14px;
            font-weight:600; text-decoration:none; padding:10px 16px; border-radius:10px; transition:all .2s;
        }
        .sidebar-footer a:hover { background:rgba(239,68,68,0.1); }

        /* Main Content */
        .admin-main { flex:1; margin-left:260px; padding:28px 32px; }

        /* Top Bar */
        .top-bar {
            display:flex; justify-content:space-between; align-items:center;
            margin-bottom:28px; padding-bottom:20px; border-bottom:1px solid rgba(0,0,0,0.06);
        }
        .top-bar h1 { font-size:26px; font-weight:800; color:#1e1b4b; }
        .top-bar h1 span { color:#4f46e5; }
        .top-bar-right { display:flex; align-items:center; gap:16px; }
        .admin-badge {
            background:linear-gradient(135deg,#4f46e5,#6366f1); color:#fff; padding:8px 18px;
            border-radius:20px; font-size:13px; font-weight:700; cursor:default;
            box-shadow: 0 4px 10px rgba(79,70,229,0.2);
        }

        /* Stats Grid */
        .stats-row { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:28px; }
        .stat-box {
            background:#ffffff;
            border:1px solid rgba(79,70,229,0.08); border-radius:20px; padding:24px;
            transition:all .3s ease; position:relative; overflow:hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
        }
        .stat-box:hover { transform:translateY(-5px); box-shadow:0 12px 30px rgba(79,70,229,0.12); }
        .stat-box::before {
            content:''; position:absolute; top:0; left:0; right:0; height:4px;
            background:linear-gradient(90deg,#4f46e5,#818cf8); border-radius:20px 20px 0 0;
        }
        .stat-box.green::before { background:linear-gradient(90deg,#10b981,#34d399); }
        .stat-box.orange::before { background:linear-gradient(90deg,#f59e0b,#fbbf24); }
        
        .stat-box h3 { font-size:32px; font-weight:800; color:#1e1b4b; margin-bottom:4px; }
        .stat-box p { font-size:14px; color:#64748b; font-weight:600; }

        /* Section Title */
        .section-title {
            font-size:20px; font-weight:800; color:#1e1b4b; margin-bottom:20px;
            display:flex; align-items:center; gap:12px; justify-content:space-between;
        }

        /* Cards */
        .card {
            background:#ffffff;
            border:1px solid rgba(79,70,229,0.06); border-radius:24px; padding:32px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03); margin-bottom:28px;
        }

        /* Table */
        .data-table { width:100%; border-collapse:separate; border-spacing: 0 8px; }
        .data-table th {
            text-align:left; padding:12px 16px; font-size:11px; font-weight:700;
            color:#94a3b8; text-transform:uppercase; letter-spacing:1px;
            border-bottom: 2px solid #f8fafc;
        }
        .data-table td {
            padding:16px; font-size:14px; color:#1e293b; background: #ffffff;
            border-top: 1px solid #f8fafc; border-bottom: 1px solid #f8fafc;
        }
        .data-table td:first-child { border-left: 1px solid #f8fafc; border-radius: 12px 0 0 12px; }
        .data-table td:last-child { border-right: 1px solid #f8fafc; border-radius: 0 12px 12px 0; }

        /* Badges */
        .badge {
            display:inline-block; padding:4px 12px; border-radius:20px;
            font-size:11px; font-weight:700; text-transform:uppercase;
        }
        .badge-active { background:rgba(16,185,129,0.15); color:#10b981; }
        .badge-blocked { background:rgba(239,68,68,0.15); color:#ef4444; }

        /* Buttons */
        .btn-primary { background:#4f46e5; color:#fff; border:none; padding:10px 20px; border-radius:8px; cursor:pointer; font-weight:600; font-size:14px; }
        .btn-primary:hover { background:#4338ca; }
        .btn-danger { background:#ef4444; color:#fff; border:none; padding:6px 12px; border-radius:6px; cursor:pointer; font-weight:600; font-size:12px; }
        .btn-warning { background:#f59e0b; color:#fff; border:none; padding:6px 12px; border-radius:6px; cursor:pointer; font-weight:600; font-size:12px; }
        .btn-info { background:#3b82f6; color:#fff; border:none; padding:6px 12px; border-radius:6px; cursor:pointer; font-weight:600; font-size:12px; }
        
        .action-btns { display:flex; gap:8px; }

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
            width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(2px);
            overflow-y: auto; padding: 20px 0;
        }
        .modal-content {
            background: #ffffff; margin: 5% auto; padding: 30px; border-radius: 16px;
            width: 400px; box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            position: relative;
        }
        .modal-header h3 { font-size: 18px; color: #1e293b; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 13px; color: #64748b; font-weight: 600; }
        .form-group input, .form-group select {
            width: 100%; padding: 10px; border-radius: 8px; background: #f8fafc;
            border: 1px solid #e2e8f0; color: #1e293b; outline: none; font-family: 'Inter', sans-serif;
        }
        .form-group input:focus, .form-group select:focus { border-color: #4f46e5; }
        .modal-close { position:absolute; top:20px; right:20px; font-size:24px; cursor:pointer; color:#94a3b8; }
        .modal-close:hover { color:#1e293b; }
    </style>
</head>
<body>
<div class="admin-layout">
    <!-- Sidebar -->
    <aside class="admin-sidebar">
        <div class="sidebar-brand">
            <h2>&#x2695; MediCare+</h2>
            <span>Super Admin System</span>
        </div>
        <nav class="sidebar-nav">
            <a class="nav-item active" href="javascript:void(0)" onclick="showSection('dashboard-section', this)">
                <span class="nav-icon">&#x1F4CA;</span> System Overview
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('clinics-section', this)">
                <span class="nav-icon">&#x1F3E5;</span> Clinics Management
            </a>
            <a class="nav-item" href="javascript:void(0)" onclick="showSection('admins-section', this)">
                <span class="nav-icon">&#x1F468;&#x200D;&#x1F4BC;</span> Admin Accounts
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="/superadmin/logout">&#x1F6AA; Logout</a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="admin-main">
        <div class="top-bar">
            <h1>Super Admin <span>Control Center</span></h1>
            <div class="top-bar-right">
                <span class="admin-badge">&#x26A1; Master Access</span>
            </div>
        </div>

        <c:if test="${not empty success}">
            <div style="background:#dcfce7; color:#166534; padding:12px 20px; border-radius:12px; margin-bottom:20px; font-size:14px; font-weight:600;">
                ✅ ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="background:#fee2e2; color:#991b1b; padding:12px 20px; border-radius:12px; margin-bottom:20px; font-size:14px; font-weight:600;">
                ⚠️ ${error}
            </div>
        </c:if>

        <!-- Dashboard Section -->
        <div id="dashboard-section" class="content-section active">
            <div class="stats-row">
                <div class="stat-box">
                    <h3>${totalClinics}</h3>
                    <p>Total Registered Clinics</p>
                </div>
                <div class="stat-box green">
                    <h3>₹${totalRevenue}</h3>
                    <p>Total System Revenue</p>
                </div>
                <div class="stat-box orange">
                    <h3>${totalAdmins}</h3>
                    <p>Total Clinic Admins</p>
                </div>
                <div class="stat-box">
                    <h3>${totalDoctors}</h3>
                    <p>Total Doctors</p>
                </div>
                <div class="stat-box green">
                    <h3>${totalPatients}</h3>
                    <p>Total Patients</p>
                </div>
                <div class="stat-box orange">
                    <h3>${totalAppointments}</h3>
                    <p>Total Appointments</p>
                </div>
            </div>
        </div>

        <!-- Clinics Section -->
        <div id="clinics-section" class="content-section">
            <div class="section-title">
                <div><span class="title-icon">&#x1F3E5;</span> Clinic Management</div>
                <button class="btn-primary" onclick="openModal('addClinicModal')">+ Add New Clinic</button>
            </div>
            <div class="card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Clinic Name</th>
                            <th>Contact</th>
                            <th>Registration Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="clinic" items="${clinics}">
                            <tr>
                                <td><strong>${clinic.name}</strong><br><small style="color:#64748b;">${clinic.address}</small></td>
                                <td>${clinic.contactNumber}<br><small style="color:#64748b;">${clinic.email}</small></td>
                                <td>${clinic.registrationDate}</td>
                                <td>
                                    <span class="badge ${clinic.status == 'Active' ? 'badge-active' : 'badge-blocked'}">${clinic.status}</span>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-info" onclick="openClinicStatsModal('${clinic.name}', ${clinicStats[clinic.id].users}, ${clinicStats[clinic.id].doctors}, ${clinicStats[clinic.id].patients}, ${clinicStats[clinic.id].appointments}, ${clinicStats[clinic.id].revenue})" style="background:linear-gradient(135deg, #10b981 0%, #059669 100%);">Stats</button>
                                        <button class="btn-info" onclick="openEditClinicModal(${clinic.id}, '${clinic.name}', '${clinic.address}', '${clinic.contactNumber}', '${clinic.email}')">Edit</button>
                                        <form action="/superadmin/clinic/status" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${clinic.id}">
                                            <input type="hidden" name="status" value="${clinic.status == 'Active' ? 'Blocked' : 'Active'}">
                                            <button type="submit" class="btn-warning">${clinic.status == 'Active' ? 'Block' : 'Unblock'}</button>
                                        </form>
                                        <form action="/superadmin/clinic/remove" method="post" style="display:inline;" onsubmit="return confirm('Remove clinic?');">
                                            <input type="hidden" name="id" value="${clinic.id}">
                                            <button type="submit" class="btn-danger">Remove</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Admins Section -->
        <div id="admins-section" class="content-section">
            <div class="section-title">
                <div><span class="title-icon">&#x1F468;&#x200D;&#x1F4BC;</span> Admin Account Management</div>
                <button class="btn-primary" onclick="openModal('addAdminModal')">+ Create Admin Account</button>
            </div>
            <div class="card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Admin Name</th>
                            <th>Email</th>
                            <th>Assigned Clinic</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="admin" items="${admins}">
                            <tr>
                                <td><strong>${admin.fullName}</strong></td>
                                <td>${admin.email}</td>
                                <td>${admin.hospitalName}</td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-info" onclick="openEditAdminModal(${admin.id}, '${admin.fullName}', '${admin.email}', '${admin.hospitalName}')">Edit</button>
                                        <button class="btn-warning" onclick="openResetPasswordModal(${admin.id})">Reset Pwd</button>
                                        <form action="/superadmin/admin/remove" method="post" style="display:inline;" onsubmit="return confirm('Remove admin?');">
                                            <input type="hidden" name="id" value="${admin.id}">
                                            <button type="submit" class="btn-danger">Remove</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<!-- Add Clinic Modal -->
<div id="addClinicModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal('addClinicModal')">&times;</span>
        <div class="modal-header"><h3>Add New Clinic</h3></div>
        <form action="/superadmin/clinic/add" method="post">
            <div class="form-group">
                <label>Clinic Name</label>
                <input type="text" name="name" required>
            </div>
            <div class="form-group">
                <label>Address</label>
                <input type="text" name="address" required>
            </div>
            <div class="form-group">
                <label>Contact Number</label>
                <input type="text" name="contactNumber" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>
            <button type="submit" class="btn-primary" style="width:100%;">Add Clinic</button>
        </form>
    </div>
</div>

<!-- Edit Clinic Modal -->
<div id="editClinicModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal('editClinicModal')">&times;</span>
        <div class="modal-header"><h3>Edit Clinic Details</h3></div>
        <form action="/superadmin/clinic/update" method="post">
            <input type="hidden" name="id" id="editClinicId">
            <div class="form-group">
                <label>Clinic Name</label>
                <input type="text" name="name" id="editClinicName" required>
            </div>
            <div class="form-group">
                <label>Address</label>
                <input type="text" name="address" id="editClinicAddress" required>
            </div>
            <div class="form-group">
                <label>Contact Number</label>
                <input type="text" name="contactNumber" id="editClinicContact" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" id="editClinicEmail" required>
            </div>
            <button type="submit" class="btn-primary" style="width:100%;">Update Clinic</button>
        </form>
    </div>
</div>

<!-- Add Admin Modal -->
<div id="addAdminModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal('addAdminModal')">&times;</span>
        <div class="modal-header"><h3>Create Admin Account</h3></div>
        <form action="/superadmin/admin/add" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" required>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <div class="form-group">
                <label>Assign to Clinic</label>
                <select name="clinicName" required>
                    <option value="">Select Clinic</option>
                    <c:forEach var="clinic" items="${clinics}">
                        <option value="${clinic.name}">${clinic.name}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn-primary" style="width:100%;">Create Admin</button>
        </form>
    </div>
</div>

<!-- Edit Admin Modal -->
<div id="editAdminModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal('editAdminModal')">&times;</span>
        <div class="modal-header"><h3>Edit Admin Details</h3></div>
        <form action="/superadmin/admin/update" method="post">
            <input type="hidden" name="id" id="editAdminId">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" id="editAdminName" required>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" id="editAdminEmail" required>
            </div>
            <div class="form-group">
                <label>Assign to Clinic</label>
                <select name="clinicName" id="editAdminClinic" required>
                    <option value="">Select Clinic</option>
                    <c:forEach var="clinic" items="${clinics}">
                        <option value="${clinic.name}">${clinic.name}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn-primary" style="width:100%;">Update Details</button>
        </form>
    </div>
</div>

<!-- Reset Password Modal -->
<div id="resetPasswordModal" class="modal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeModal('resetPasswordModal')">&times;</span>
        <div class="modal-header"><h3>Reset Admin Password</h3></div>
        <form action="/superadmin/admin/reset-password" method="post">
            <input type="hidden" name="id" id="resetAdminId">
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="newPassword" required>
            </div>
            <button type="submit" class="btn-primary" style="width:100%; background:linear-gradient(135deg, #f59e0b 0%, #d97706 100%); border:none;">Reset Password</button>
        </form>
    </div>
</div>

<!-- Clinic Stats Modal -->
<div id="clinicStatsModal" class="modal">
    <div class="modal-content" style="max-width:550px;">
        <span class="modal-close" onclick="closeModal('clinicStatsModal')">&times;</span>
        <div class="modal-header">
            <h3 id="statsClinicName">Clinic Stats</h3>
        </div>
        <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px; margin-top:20px;">
            <div style="background:#f8fafc; padding:20px; border-radius:12px; border:1px solid #e2e8f0; text-align:center;">
                <div style="font-size:28px; font-weight:800; color:#4f46e5;" id="statsRevenue">₹0.0</div>
                <div style="font-size:12px; color:#64748b; font-weight:600; text-transform:uppercase; margin-top:5px;">Total Revenue</div>
            </div>
            <div style="background:#f8fafc; padding:20px; border-radius:12px; border:1px solid #e2e8f0; text-align:center;">
                <div style="font-size:28px; font-weight:800; color:#10b981;" id="statsPatients">0</div>
                <div style="font-size:12px; color:#64748b; font-weight:600; text-transform:uppercase; margin-top:5px;">Total Patients</div>
            </div>
            <div style="background:#f8fafc; padding:20px; border-radius:12px; border:1px solid #e2e8f0; text-align:center;">
                <div style="font-size:28px; font-weight:800; color:#f59e0b;" id="statsAppointments">0</div>
                <div style="font-size:12px; color:#64748b; font-weight:600; text-transform:uppercase; margin-top:5px;">Total Appointments</div>
            </div>
            <div style="background:#f8fafc; padding:20px; border-radius:12px; border:1px solid #e2e8f0; text-align:center;">
                <div style="font-size:28px; font-weight:800; color:#0ea5e9;" id="statsUsers">0</div>
                <div style="font-size:12px; color:#64748b; font-weight:600; text-transform:uppercase; margin-top:5px;">Total Staff (Inc. Doctors)</div>
            </div>
        </div>
    </div>
</div>

<script>
    function showSection(sectionId, element) {
        document.querySelectorAll('.content-section').forEach(sec => sec.classList.remove('active'));
        document.getElementById(sectionId).classList.add('active');
        document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
        element.classList.add('active');
    }

    function openModal(id) {
        document.getElementById(id).style.display = 'block';
    }

    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }

    function openEditClinicModal(id, name, address, contact, email) {
        document.getElementById('editClinicId').value = id;
        document.getElementById('editClinicName').value = name;
        document.getElementById('editClinicAddress').value = address;
        document.getElementById('editClinicContact').value = contact;
        document.getElementById('editClinicEmail').value = email;
        openModal('editClinicModal');
    }

    function openEditAdminModal(id, name, email, clinic) {
        document.getElementById('editAdminId').value = id;
        document.getElementById('editAdminName').value = name;
        document.getElementById('editAdminEmail').value = email;
        document.getElementById('editAdminClinic').value = clinic;
        openModal('editAdminModal');
    }

    function openResetPasswordModal(id) {
        document.getElementById('resetAdminId').value = id;
        openModal('resetPasswordModal');
    }

    function openClinicStatsModal(name, users, doctors, patients, appointments, revenue) {
        document.getElementById('statsClinicName').innerText = name + ' Overview';
        document.getElementById('statsRevenue').innerText = '₹' + revenue;
        document.getElementById('statsPatients').innerText = patients;
        document.getElementById('statsAppointments').innerText = appointments;
        document.getElementById('statsUsers').innerText = users;
        openModal('clinicStatsModal');
    }

    // Close modals if clicked outside
    window.onclick = function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    }
</script>
</body>
</html>
