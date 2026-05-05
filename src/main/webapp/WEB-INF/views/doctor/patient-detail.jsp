<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Detail - Clinic Management</title>
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
        <h5><i class="fas fa-user-circle me-2" style="color:#2563eb"></i> Patient Profile</h5>
        <a href="/doctor/patients" style="color:#64748b;text-decoration:none;font-size:0.85rem"><i class="fas fa-arrow-left me-1"></i> Back</a>
    </div>
    <div class="content-area">
        <div class="panel">
            <div class="d-flex align-items-center gap-4 flex-wrap">
                <div style="width:70px;height:70px;border-radius:50%;background:linear-gradient(135deg,#2563eb,#7c3aed);display:flex;align-items:center;justify-content:center;color:#fff;font-size:2rem;font-weight:800">
                    ${patient.name.substring(0,1)}
                </div>
                <div>
                    <h4 style="margin:0;font-weight:800;color:#1e293b">${patient.name}</h4>
                    <div style="color:#64748b;font-size:0.875rem;margin-top:6px;display:flex;gap:20px;flex-wrap:wrap">
                        <span><i class="fas fa-birthday-cake me-1"></i>${patient.age} yrs</span>
                        <span><i class="fas fa-venus-mars me-1"></i>${patient.gender}</span>
                        <span><i class="fas fa-phone me-1"></i>${patient.contact}</span>
                    </div>
                </div>
                <div class="ms-auto d-flex gap-2 flex-wrap">
                    <a href="/doctor/emr?patientId=${patient.id}" class="btn-primary-custom" style="text-decoration:none"><i class="fas fa-file-medical me-1"></i> New EMR</a>
                    <a href="/doctor/lab-requests" class="btn-primary-custom" style="background:#d97706;text-decoration:none"><i class="fas fa-flask me-1"></i> Lab Test</a>
                </div>
            </div>
        </div>
        <div class="panel">
            <div class="panel-title"><i class="fas fa-history"></i> Visit History</div>
            <c:choose>
                <c:when test="${empty visits}">
                    <div class="text-center py-4 text-muted">
                        <i class="fas fa-notes-medical fa-2x mb-2 d-block" style="color:#cbd5e1"></i>No visit records found.
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${visits}" var="v">
                        <div style="border:1px solid #e2e8f0;border-radius:12px;padding:16px;margin-bottom:12px;background:#fafbfc">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span style="font-weight:700;color:#1e293b"><i class="fas fa-calendar me-2" style="color:#2563eb"></i>${v.visitDate}</span>
                                <a href="/doctor/prescriptions?visitId=${v.id}" class="btn-sm-action btn-print"><i class="fas fa-prescription-bottle"></i> Prescriptions</a>
                            </div>
                            <div class="row g-2">
                                <div class="col-md-4"><div style="font-size:0.72rem;color:#94a3b8;font-weight:600;text-transform:uppercase">Symptoms</div><div style="font-size:0.875rem;color:#334155">${v.symptoms}</div></div>
                                <div class="col-md-4"><div style="font-size:0.72rem;color:#94a3b8;font-weight:600;text-transform:uppercase">Diagnosis</div><div style="font-size:0.875rem;color:#334155">${v.diagnosis}</div></div>
                                <div class="col-md-4"><div style="font-size:0.72rem;color:#94a3b8;font-weight:600;text-transform:uppercase">Notes</div><div style="font-size:0.875rem;color:#334155">${v.notes}</div></div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
