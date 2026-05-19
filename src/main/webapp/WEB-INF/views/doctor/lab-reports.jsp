<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lab Reports - Clinic Management</title>
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
        <a href="/doctor/appointments" class="nav-link-item"><i class="fas fa-calendar-check"></i> Appointments</a>
        <div class="nav-label">Clinical</div>
        <a href="/doctor/patients" class="nav-link-item"><i class="fas fa-user-injured"></i> Patients</a>
        <a href="/doctor/emr" class="nav-link-item"><i class="fas fa-file-medical-alt"></i> EMR</a>
        <a href="/doctor/prescriptions" class="nav-link-item"><i class="fas fa-prescription-bottle-alt"></i> Prescriptions</a>
        <div class="nav-label">Lab</div>
        <a href="/doctor/lab-requests" class="nav-link-item"><i class="fas fa-flask"></i> Lab Tests</a>
        <a href="/doctor/lab-reports" class="nav-link-item active"><i class="fas fa-file-alt"></i> Lab Reports</a>
        <div class="nav-label">Schedule</div>
        <a href="/doctor/availability" class="nav-link-item"><i class="fas fa-clock"></i> Availability</a>
    </nav>
    <div class="sidebar-footer"><a href="/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a></div>
</div>
<div class="main-content">
    <div class="topbar">
        <h5><i class="fas fa-file-alt me-2" style="color:#2563eb"></i> Lab Reports</h5>
        <a href="/logout" class="btn btn-outline-danger btn-sm" style="border-radius: 20px; padding: 5px 15px; font-weight: 600;">
            <i class="fas fa-sign-out-alt me-1"></i> Logout
        </a>
    </div>
    <div class="content-area">
        <div class="panel">
            <div class="panel-title"><i class="fas fa-microscope"></i> Patient Lab Results</div>
            <c:choose>
                <c:when test="${empty reports}">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-file-invoice fa-3x mb-3 d-block" style="color:#cbd5e1"></i>
                        No lab reports available yet.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead><tr><th>Date</th><th>Patient</th><th>Test Name</th><th>Result</th><th>Action</th></tr></thead>
                            <tbody>
                                <c:forEach items="${reports}" var="r">
                                    <tr>
                                        <td>${r.reportDate}</td>
                                        <td style="font-weight:600">${r.request.patient.name}</td>
                                        <td>${r.request.test.name}</td>
                                        <td>${r.result}</td>
                                        <td>
                                            <a href="/doctor/reports/view/${r.id}" target="_blank" class="btn-sm-action btn-print">
                                                <i class="fas fa-file-pdf"></i> View / PDF
                                            </a>
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
