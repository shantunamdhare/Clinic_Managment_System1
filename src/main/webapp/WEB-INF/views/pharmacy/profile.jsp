<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacist Profile | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --pharmacy-primary: #4f46e5;
            --pharmacy-secondary: #818cf8;
            --bg-light: #f8fafc;
            --text-dark: #1e293b;
        }

        body {
            background-color: var(--bg-light);
            font-family: 'Inter', sans-serif;
        }

        .profile-header-banner {
            height: 150px;
            background: linear-gradient(135deg, var(--pharmacy-primary), var(--pharmacy-secondary));
            border-radius: 16px 16px 0 0;
            position: relative;
        }

        .profile-avatar-container {
            position: absolute;
            bottom: -50px;
            left: 40px;
            padding: 5px;
            background: white;
            border-radius: 50%;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .profile-avatar-container img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
        }

        .profile-content {
            padding-top: 60px;
            padding-left: 40px;
            padding-right: 40px;
            padding-bottom: 40px;
        }

        .card-profile {
            background: white;
            border-radius: 16px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: none;
            overflow: hidden;
        }

        .form-label {
            font-weight: 600;
            color: #475569;
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            padding: 0.75rem 1rem;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            font-size: 0.95rem;
            transition: all 0.2s;
        }

        .form-control:focus {
            border-color: var(--pharmacy-primary);
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }

        .btn-save {
            background-color: var(--pharmacy-primary);
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 10px;
            font-weight: 600;
            border: none;
            transition: all 0.2s;
        }

        .btn-save:hover {
            background-color: #4338ca;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .profile-stat-badge {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            background: #f1f5f9;
            border-radius: 12px;
            color: #475569;
        }

        .profile-stat-badge i {
            color: var(--pharmacy-primary);
            font-size: 1.25rem;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e2e8f0;
        }
        
        .image-upload-label {
            position: absolute;
            bottom: 0;
            right: 0;
            background: var(--pharmacy-primary);
            color: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 2px solid white;
        }
    </style>
</head>
<body>
    <div class="pharmacy-container">
        <!-- Sidebar (Reusing from Dashboard) -->
        <aside class="sidebar">
            <div class="sidebar-logo">
                <i class="fas fa-plus-square"></i>
                <span>MediCare+ <span>Pharmacy</span></span>
            </div>
            <nav class="sidebar-nav">
                <a href="/pharmacy-dashboard" class="nav-link"><i class="fas fa-th-large"></i> Dashboard</a>
                <a href="/pharmacy/inventory" class="nav-link"><i class="fas fa-pills"></i> Stock & Expiry</a>
                <a href="/pharmacy/billing" class="nav-link"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link"><i class="fas fa-users"></i> Staff & Shifts</a>
            </nav>
            <div class="sidebar-footer">
                <a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="main-header">
                <div class="d-flex align-items-center gap-3">
                    <a href="/pharmacy-dashboard" class="btn btn-light rounded-circle p-2" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                    <h4 class="mb-0 fw-bold">My Professional Profile</h4>
                </div>
            </header>

            <div class="container-fluid py-4">
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success border-0 shadow-sm mb-4 d-flex align-items-center gap-3" style="border-radius: 12px;">
                        <i class="fas fa-check-circle fs-4 text-success"></i>
                        <div>${successMessage}</div>
                    </div>
                </c:if>

                <div class="card-profile">
                    <div class="profile-header-banner">
                        <div class="profile-avatar-container">
                            <c:choose>
                                <c:when test="${not empty user.profileImage}">
                                    <img src="${user.profileImage}" alt="Profile" id="profile-preview">
                                </c:when>
                                <c:when test="${user.gender == 'Female'}">
                                    <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=ec4899&color=fff&size=120" alt="Profile" id="profile-preview">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff&size=120" alt="Profile" id="profile-preview">
                                </c:otherwise>
                            </c:choose>
                            <label for="profileImageInput" class="image-upload-label">
                                <i class="fas fa-camera"></i>
                            </label>
                        </div>
                    </div>

                    <div class="profile-content">
                        <div class="row mb-5 align-items-end">
                            <div class="col">
                                <h2 class="fw-bold mb-1">${user.fullName}</h2>
                                <p class="text-muted mb-0"><i class="fas fa-user-shield me-2"></i>Chief Pharmacist | Professional ID: ${user.pharmacyLicense != null ? user.pharmacyLicense : 'PENDING'}</p>
                            </div>
                            <div class="col-auto d-flex gap-3">
                                <div class="profile-stat-badge">
                                    <i class="fas fa-calendar-check"></i>
                                    <div>
                                        <div class="small text-muted">Status</div>
                                        <div class="fw-bold text-success">Active</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <form action="/pharmacy/profile/update" method="POST" id="profileForm">
                            <!-- Hidden input for base64 image -->
                            <input type="hidden" name="profileImage" id="profileImageBase64">
                            <input type="file" id="profileImageInput" style="display: none;" accept="image/*" onchange="previewImage(this)">

                            <div class="section-title"><i class="fas fa-info-circle"></i> Personal Information</div>
                            <div class="row g-4 mb-5">
                                <div class="col-md-6">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" class="form-control" name="email" value="${user.email}" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Phone Number</label>
                                    <input type="text" class="form-control" name="phone" value="${user.phone}" 
                                           placeholder="Enter 10-digit number" 
                                           maxlength="10" 
                                           pattern="[0-9]{10}" 
                                           title="Please enter exactly 10 digits"
                                           oninput="this.value = this.value.replace(/[^0-9]/g, '');"
                                           required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Gender</label>
                                    <select class="form-select" name="gender">
                                        <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                        <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                            </div>

                            <div class="section-title"><i class="fas fa-hospital"></i> Pharmacy Details</div>
                            <div class="row g-4 mb-5">
                                <div class="col-md-6">
                                    <label class="form-label">Pharmacy Name</label>
                                    <input type="text" class="form-control" name="pharmacyName" value="${user.pharmacyName}" placeholder="Enter pharmacy name">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">License Number</label>
                                    <input type="text" class="form-control" name="pharmacyLicense" value="${user.pharmacyLicense}" placeholder="PH-XXXX-XXXX">
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Pharmacy Address</label>
                                    <textarea class="form-control" name="pharmacyAddress" rows="3" placeholder="Full address of the pharmacy branch">${user.pharmacyAddress}</textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-3 mt-4">
                                <button type="button" class="btn btn-outline-primary px-4 py-2" data-bs-toggle="modal" data-bs-target="#changePasswordModal" style="border-radius: 10px; font-weight: 600; border-width: 2px;">
                                    <i class="fas fa-key me-2"></i>Change Password
                                </button>
                                <button type="submit" class="btn-save">Save Professional Profile</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Change Password Modal -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 24px;">
                <div class="modal-header border-0 pb-0 pt-4 px-4">
                    <h5 class="modal-title fw-bold" style="font-size: 1.25rem;"><i class="fas fa-lock text-primary me-2"></i>Update Security</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <p class="text-muted small mb-4">Protect your account by creating a strong, unique password.</p>
                    <form action="/change-password" method="POST">
                        <div class="mb-3">
                            <label class="form-label">Current Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px;"><i class="fas fa-shield-alt text-muted"></i></span>
                                <input type="password" name="currentPassword" class="form-control border-start-0" style="border-radius: 0 10px 10px 0;" placeholder="••••••••" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">New Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px;"><i class="fas fa-key text-muted"></i></span>
                                <input type="password" name="newPassword" class="form-control border-start-0" style="border-radius: 0 10px 10px 0;" placeholder="Minimum 8 characters" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Confirm New Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px;"><i class="fas fa-check-double text-muted"></i></span>
                                <input type="password" name="confirmPassword" class="form-control border-start-0" style="border-radius: 0 10px 10px 0;" placeholder="Repeat your new password" required>
                            </div>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary py-3 fw-bold" style="border-radius: 12px; background: var(--pharmacy-primary); border: none; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);">Update Password Now</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#profile-preview').attr('src', e.target.result);
                    $('#profileImageBase64').val(e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>
