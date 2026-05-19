<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients - Clinic Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/doctor.css">
</head>
<body>
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
        <a href="/doctor/dashboard" class="nav-link-item"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="/doctor/appointments" class="nav-link-item"><i class="fas fa-calendar-check"></i> Today's Appointments</a>
        <div class="nav-label">Clinical</div>
        <a href="/doctor/patients" class="nav-link-item active"><i class="fas fa-user-injured"></i> Patients</a>
        <a href="/doctor/emr" class="nav-link-item"><i class="fas fa-file-medical-alt"></i> EMR</a>
        <a href="/doctor/prescriptions" class="nav-link-item"><i class="fas fa-prescription-bottle-alt"></i> Prescriptions</a>
        <div class="nav-label">Lab</div>
        <a href="/doctor/lab-requests" class="nav-link-item"><i class="fas fa-flask"></i> Lab Tests</a>
        <a href="/doctor/lab-reports" class="nav-link-item"><i class="fas fa-file-alt"></i> Lab Reports</a>
        <div class="nav-label">Schedule</div>
        <a href="/doctor/availability" class="nav-link-item"><i class="fas fa-clock"></i> Availability</a>
    </nav>
    <div class="sidebar-footer"><a href="/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a></div>
</div>

<div class="main-content">
    <div class="topbar">
        <h5><i class="fas fa-user-injured me-2" style="color:#2563eb"></i> Patients</h5>
        <a href="/doctor/patients/add" class="btn-primary-custom" style="text-decoration:none">
            <i class="fas fa-user-plus me-1"></i> Add Patient
        </a>
    </div>
    <div class="content-area">
        <c:if test="${not empty success}"><div class="alert-custom alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>

        <!-- Search Bar -->
        <div class="panel" style="padding:16px 24px">
            <form method="get" action="/doctor/patients" class="d-flex gap-3 align-items-center">
                <div style="flex:1; position:relative">
                    <i class="fas fa-search" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:#94a3b8"></i>
                    <input type="text" name="search" value="${search}" placeholder="Search patients by name..."
                           class="form-control-custom" style="padding-left:36px;width:100%">
                </div>
                <button type="submit" class="btn-primary-custom">Search</button>
                <c:if test="${not empty search}">
                    <a href="/doctor/patients" style="color:#64748b;text-decoration:none;font-size:0.85rem">Clear Filter</a>
                </c:if>
            </form>
        </div>

        <!-- Patients Table -->
        <div class="panel">
            <div class="panel-title"><i class="fas fa-users"></i> Patient List
                <span style="margin-left:auto;font-size:0.8rem;font-weight:400;color:#64748b">${patients.size()} records</span>
            </div>
            <c:choose>
                <c:when test="${empty patients}">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-user-slash fa-3x mb-3 d-block" style="color:#cbd5e1"></i>
                        No patients found.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr><th>#</th><th>Name</th><th>Age</th><th>Gender</th><th>Contact</th><th>Actions</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${patients}" var="p" varStatus="loop">
                                    <tr>
                                        <td>${loop.count}</td>
                                        <td>
                                            <div style="display:flex;align-items:center;gap:10px">
                                                <div style="width:34px;height:34px;border-radius:50%;background:#dbeafe;color:#2563eb;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:0.9rem">
                                                    ${p.name.substring(0,1)}
                                                </div>
                                                <span style="font-weight:600">${p.name}</span>
                                            </div>
                                        </td>
                                        <td>${p.age} yrs</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.gender == 'Male'}"><span style="color:#2563eb"><i class="fas fa-mars me-1"></i>Male</span></c:when>
                                                <c:when test="${p.gender == 'Female'}"><span style="color:#db2777"><i class="fas fa-venus me-1"></i>Female</span></c:when>
                                                <c:otherwise>${p.gender}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><i class="fas fa-phone me-1" style="color:#94a3b8"></i>${p.contact}</td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <a href="/doctor/patients/${p.id}" class="btn-sm-action btn-view"><i class="fas fa-eye"></i> View</a>
                                                <a href="/doctor/emr?patientId=${p.id}" class="btn-sm-action btn-print"><i class="fas fa-file-medical"></i> EMR</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<div class="sidebar-overlay" id="sidebarOverlay"></div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const topbar = document.querySelector('.topbar');
        if(topbar && !document.getElementById('sidebarToggleBtn')) {
            const h5 = topbar.querySelector('h5');
            if (h5) {
                const wrapper = document.createElement('div');
                wrapper.className = 'd-flex align-items-center gap-2';
                const toggleBtn = document.createElement('button');
                toggleBtn.id = 'sidebarToggleBtn';
                toggleBtn.className = 'btn btn-light d-md-none';
                toggleBtn.style.padding = '4px 8px';
                toggleBtn.innerHTML = '<i class="fas fa-bars"></i>';
                toggleBtn.onclick = function() {
                    document.querySelector('.sidebar').classList.toggle('active');
                    document.getElementById('sidebarOverlay').classList.toggle('active');
                };
                wrapper.appendChild(toggleBtn);
                h5.parentNode.insertBefore(wrapper, h5);
                wrapper.appendChild(h5);
                h5.style.margin = '0';
            }
        }
        const overlay = document.getElementById('sidebarOverlay');
        if(overlay) {
            overlay.onclick = function() {
                document.querySelector('.sidebar').classList.remove('active');
                overlay.classList.remove('active');
            };
        }
    });
</script>
</body>
</html>
