<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prescriptions - Clinic Management</title>
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
        <a href="/doctor/prescriptions" class="nav-link-item active"><i class="fas fa-prescription-bottle-alt"></i> Prescriptions</a>
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
        <h5><i class="fas fa-prescription-bottle-alt me-2" style="color:#2563eb"></i> Prescriptions</h5>
    </div>
    <div class="content-area">
        <c:if test="${not empty success}"><div class="alert-custom alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
        <c:if test="${not empty error}"><div class="alert-custom alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

        <div class="row g-4">
            <!-- Left: Select Visit -->
            <div class="col-lg-4">
                <div class="panel">
                    <div class="panel-title"><i class="fas fa-history"></i> Select Visit</div>
                    <c:choose>
                        <c:when test="${empty visits}">
                            <p style="color:#94a3b8;font-size:0.875rem">No visits yet. Create an EMR record first.</p>
                            <a href="/doctor/emr" class="btn-primary-custom" style="text-decoration:none;display:inline-block;margin-top:8px">
                                <i class="fas fa-file-medical me-1"></i> New EMR
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div style="display:flex;flex-direction:column;gap:8px">
                                <c:forEach items="${visits}" var="v">
                                    <a href="/doctor/prescriptions?visitId=${v.id}"
                                       style="display:block;padding:12px;border-radius:10px;text-decoration:none;border:2px solid ${selectedVisit != null && selectedVisit.id == v.id ? '#2563eb' : '#e2e8f0'};background:${selectedVisit != null && selectedVisit.id == v.id ? '#eff6ff' : '#fff'};transition:all 0.2s">
                                        <div style="font-weight:600;color:#1e293b;font-size:0.875rem">${v.patient.name}</div>
                                        <div style="color:#64748b;font-size:0.75rem;margin-top:3px"><i class="fas fa-calendar me-1"></i>${v.visitDate}</div>
                                        <div style="color:#94a3b8;font-size:0.75rem;margin-top:2px">${v.diagnosis}</div>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right: Add & List Prescriptions -->
            <div class="col-lg-8">
                <c:if test="${selectedVisit != null}">
                    <!-- Visit Summary -->
                    <div class="panel" style="background:linear-gradient(135deg,#eff6ff,#f0fdf4);border-color:#bfdbfe">
                        <div style="font-weight:700;color:#1e293b;font-size:0.95rem">
                            <i class="fas fa-user me-2" style="color:#2563eb"></i>${selectedVisit.patient.name}
                            <a href="/doctor/prescriptions/print/${selectedVisit.id}" target="_blank" class="btn-sm-action btn-print ms-3">
                                <i class="fas fa-print"></i> Print Prescription
                            </a>
                        </div>
                        <div style="color:#64748b;font-size:0.8rem;margin-top:6px;display:flex;gap:16px;flex-wrap:wrap">
                            <span><i class="fas fa-calendar me-1"></i>${selectedVisit.visitDate}</span>
                            <span><i class="fas fa-diagnoses me-1"></i>${selectedVisit.diagnosis}</span>
                        </div>
                    </div>

                    <!-- Add Prescription Form -->
                    <div class="panel">
                        <div class="panel-title"><i class="fas fa-plus-circle"></i> Add Medicine</div>
                        <form action="/doctor/prescriptions/save" method="post" id="rxForm" novalidate>
                            <input type="hidden" name="visitId" value="${selectedVisit.id}">
                            <div class="row g-3">
                                <div class="col-md-6 form-group">
                                    <label class="form-label-custom">Medicine Name *</label>
                                    <input type="text" name="medicine" required class="form-control-custom" placeholder="e.g. Paracetamol 500mg">
                                </div>
                                <div class="col-md-3 form-group">
                                    <label class="form-label-custom">Dosage *</label>
                                    <input type="text" name="dosage" required class="form-control-custom" placeholder="e.g. 1-0-1">
                                </div>
                                <div class="col-md-3 form-group">
                                    <label class="form-label-custom">Duration *</label>
                                    <input type="text" name="duration" required class="form-control-custom" placeholder="e.g. 5 days">
                                </div>
                                <div class="col-12 form-group">
                                    <label class="form-label-custom">Instructions</label>
                                    <input type="text" name="instructions" class="form-control-custom" placeholder="e.g. After meals, with warm water">
                                </div>
                            </div>
                            <button type="submit" class="btn-primary-custom mt-3" style="padding:9px 24px">
                                <i class="fas fa-plus me-1"></i> Add Medicine
                            </button>
                        </form>
                    </div>

                    <!-- Existing Prescriptions -->
                    <div class="panel">
                        <div class="panel-title"><i class="fas fa-list"></i> Prescribed Medicines</div>
                        <c:choose>
                            <c:when test="${empty prescriptions}">
                                <p style="color:#94a3b8;font-size:0.875rem">No medicines added yet.</p>
                            </c:when>
                            <c:otherwise>
                                <table class="custom-table">
                                    <thead><tr><th>Medicine</th><th>Dosage</th><th>Duration</th><th>Instructions</th></tr></thead>
                                    <tbody>
                                        <c:forEach items="${prescriptions}" var="rx">
                                            <tr>
                                                <td style="font-weight:600">${rx.medicine}</td>
                                                <td><span class="badge-pending">${rx.dosage}</span></td>
                                                <td>${rx.duration}</td>
                                                <td style="color:#64748b">${rx.instructions}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
                <c:if test="${selectedVisit == null}">
                    <div class="panel text-center py-5">
                        <i class="fas fa-hand-point-left fa-3x mb-3 d-block" style="color:#cbd5e1"></i>
                        <p style="color:#64748b">Select a visit from the left panel to manage prescriptions.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
<script>
document.getElementById('rxForm') && document.getElementById('rxForm').addEventListener('submit', function(e) {
    if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
    this.classList.add('was-validated');
});
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
