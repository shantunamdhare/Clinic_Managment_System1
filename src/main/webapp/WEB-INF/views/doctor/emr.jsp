<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EMR - Clinic Management</title>
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
        <a href="/doctor/emr" class="nav-link-item active"><i class="fas fa-file-medical-alt"></i> EMR</a>
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
        <h5><i class="fas fa-file-medical-alt me-2" style="color:#7c3aed"></i> Electronic Medical Records</h5>
        <span class="date-badge"><i class="fas fa-calendar me-1"></i><%=java.time.LocalDate.now()%></span>
    </div>
    <div class="content-area">
        <c:if test="${not empty success}"><div class="alert-custom alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
        <c:if test="${not empty error}"><div class="alert-custom alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

        <div class="panel" style="max-width:720px">
            <div class="panel-title"><i class="fas fa-notes-medical"></i> Create Visit / EMR Record</div>
            <form action="/doctor/emr/save" method="post" id="emrForm" novalidate>
                <div class="form-group">
                    <label class="form-label-custom">Select Patient *</label>
                    <select name="patientId" required class="form-control-custom" id="patientSelect">
                        <option value="">-- Choose Patient --</option>
                        <c:forEach items="${patients}" var="p">
                            <option value="${p.id}" ${param.patientId == p.id ? 'selected' : ''}>${p.name} (Age: ${p.age}, ${p.gender})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label-custom">Symptoms *</label>
                    <textarea name="symptoms" required rows="3" class="form-control-custom" placeholder="Describe patient's symptoms in detail..."></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label-custom">Diagnosis *</label>
                    <textarea name="diagnosis" required rows="3" class="form-control-custom" placeholder="Enter diagnosis..."></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label-custom">Clinical Notes</label>
                    <textarea name="notes" rows="3" class="form-control-custom" placeholder="Additional notes, observations, follow-up instructions..."></textarea>
                </div>
                <div class="d-flex gap-3 mt-4">
                    <button type="submit" class="btn-primary-custom" style="padding:10px 28px;background:#7c3aed">
                        <i class="fas fa-save me-1"></i> Save & Add Prescription
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
document.getElementById('emrForm').addEventListener('submit', function(e) {
    if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
    this.classList.add('was-validated');
});
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
