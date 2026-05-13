<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Clinic Management</title>
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
        <div class="nav-label">Clinical</div>
        <a href="/doctor/patients" class="nav-link-item"><i class="fas fa-user-injured"></i> Patients</a>
        <a href="/doctor/emr" class="nav-link-item"><i class="fas fa-file-medical-alt"></i> EMR</a>
        <a href="/doctor/prescriptions" class="nav-link-item"><i class="fas fa-prescription-bottle-alt"></i> Prescriptions</a>
        <div class="nav-label">Lab</div>
        <a href="/doctor/lab-requests" class="nav-link-item"><i class="fas fa-flask"></i> Lab Tests</a>
        <a href="/doctor/lab-reports" class="nav-link-item"><i class="fas fa-file-alt"></i> Lab Reports</a>
        <div class="nav-label">Schedule</div>
        <a href="/doctor/availability" class="nav-link-item"><i class="fas fa-clock"></i> Availability</a>
    </nav>
    <div class="sidebar-footer">
        <a href="/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <h5><i class="fas fa-user-md me-2" style="color:#3b82f6"></i> My Profile</h5>
        <div class="user-profile">
            <div class="avatar" style="width:36px;height:36px;font-size:1rem">${doctor.fullName.substring(0,1)}</div>
        </div>
    </div>

    <div class="content-area">
        <c:if test="${not empty success}">
            <div class="alert-custom alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert-custom alert-success">
                <i class="fas fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert-custom alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert-custom alert-error">
                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>

        <div class="row g-4 justify-content-center">
            <div class="col-lg-8">
                <div class="panel">
                    <div class="panel-title d-flex justify-content-between align-items-center">
                        <span><i class="fas fa-id-card"></i> Profile Details</span>
                    </div>

                    <form action="/doctor/profile/save" method="post" class="mt-3">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group mb-4">
                                    <label class="form-label-custom">Full Name</label>
                                    <input type="text" name="fullName" value="${doctor.fullName}" class="form-control-custom" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-4">
                                    <label class="form-label-custom">Email Address <small class="text-muted">(Cannot be changed)</small></label>
                                    <input type="email" value="${doctor.email}" class="form-control-custom" disabled style="background-color: #f8fafc; cursor: not-allowed;">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-4">
                                    <label class="form-label-custom">Phone Number</label>
                                    <input type="text" name="phone" value="${doctor.phone}" class="form-control-custom" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-4">
                                    <label class="form-label-custom">Specialization</label>
                                    <input type="text" name="specialization" value="${doctor.specialization}" class="form-control-custom" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-4">
                                    <label class="form-label-custom">Years of Experience</label>
                                    <input type="number" name="experience" value="${doctor.experience}" class="form-control-custom" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group mb-4">
                                    <label class="form-label-custom">License ID</label>
                                    <input type="text" name="licenseId" value="${doctor.licenseId}" class="form-control-custom" required>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4" style="border-color: #e2e8f0;">

                        <div class="d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-outline-primary" style="border-radius: 8px; font-weight: 600;" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                <i class="fas fa-key me-1"></i> Change Password
                            </button>
                            <button type="submit" class="btn-primary-custom">
                                <i class="fas fa-save me-1"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Change Password Modal -->
<div class="modal fade" id="changePasswordModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold"><i class="fas fa-lock me-2"></i>Change Password</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form action="/change-password" method="POST">
                    <div class="mb-3">
                        <label class="form-label-custom">Current Password</label>
                        <input type="password" name="currentPassword" class="form-control-custom" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label-custom">New Password</label>
                        <input type="password" name="newPassword" class="form-control-custom" required minlength="8">
                    </div>
                    <div class="mb-3">
                        <label class="form-label-custom">Confirm New Password</label>
                        <input type="password" name="confirmPassword" class="form-control-custom" required minlength="8">
                    </div>
                    <div class="text-end mt-4">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-primary-custom px-4">Update Password</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
