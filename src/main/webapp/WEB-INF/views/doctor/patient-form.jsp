<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Patient - Clinic Management</title>
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
        <h5><i class="fas fa-user-plus me-2" style="color:#16a34a"></i> Add New Patient</h5>
        <a href="/doctor/patients" style="color:#64748b;text-decoration:none;font-size:0.85rem"><i class="fas fa-arrow-left me-1"></i> Back</a>
    </div>
    <div class="content-area">
        <div class="panel" style="max-width:600px">
            <div class="panel-title"><i class="fas fa-user-plus"></i> Patient Information</div>
            <form action="/doctor/patients/save" method="post" id="addPatientForm" novalidate>
                <div class="form-group">
                    <label class="form-label-custom">Full Name *</label>
                    <input type="text" name="name" required minlength="2" class="form-control-custom" placeholder="Enter patient full name">
                    <div class="invalid-feedback">Name is required (min 2 characters).</div>
                </div>
                <div class="row g-3">
                    <div class="col-md-6 form-group">
                        <label class="form-label-custom">Age *</label>
                        <input type="number" name="age" required min="0" max="150" class="form-control-custom" placeholder="Age in years">
                    </div>
                    <div class="col-md-6 form-group">
                        <label class="form-label-custom">Gender *</label>
                        <select name="gender" required class="form-control-custom">
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label-custom">Contact Number *</label>
                    <input type="tel" name="contact" required class="form-control-custom" placeholder="Phone number">
                </div>
                <div class="d-flex gap-3 mt-4">
                    <button type="submit" class="btn-primary-custom" style="padding:10px 28px"><i class="fas fa-save me-1"></i> Save Patient</button>
                    <a href="/doctor/patients" class="btn-primary-custom" style="background:#94a3b8;text-decoration:none;padding:10px 28px">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
document.getElementById('addPatientForm').addEventListener('submit', function(e) {
    if (!this.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
    this.classList.add('was-validated');
});
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
