<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Reports | Clinic Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e3a5f;
            --accent: #2563eb;
            --accent-light: #3b82f6;
            --text-muted-custom: #94a3b8;
            --card-border: rgba(37,99,235,0.15);
        }
        * { box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; margin: 0; }
        
        /* ---- Sidebar ---- */
        .sidebar {
            position: fixed; top: 0; left: 0;
            width: 260px; height: 100vh;
            background: var(--sidebar-bg);
            display: flex; flex-direction: column;
            z-index: 1000; overflow-y: auto;
            box-shadow: 4px 0 20px rgba(0,0,0,0.3);
        }
        .sidebar-brand {
            padding: 24px 20px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .sidebar-brand h4 { color: #fff; font-weight: 700; margin: 0; font-size: 1.1rem; }
        .sidebar-brand small { color: var(--text-muted-custom); font-size: 0.75rem; }
        
        .sidebar-user {
            padding: 16px 20px;
            display: flex; align-items: center; gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .sidebar-user .avatar {
            width: 42px; height: 42px; border-radius: 50%;
            background: var(--accent); display: flex;
            align-items: center; justify-content: center;
            color: white; font-weight: 700; font-size: 1.1rem;
            flex-shrink: 0;
        }
        .sidebar-user .name { color: #fff; font-size: 0.85rem; font-weight: 600; }
        .sidebar-user .role { color: var(--text-muted-custom); font-size: 0.72rem; }

        .nav-link-item {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 20px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 0.875rem;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .nav-link-item:hover, .nav-link-item.active {
            background: var(--sidebar-hover);
            color: #fff;
            border-left-color: var(--accent-light);
        }
        .nav-link-item i { width: 18px; text-align: center; opacity: 0.8; }
        
        .nav-label {
            padding: 8px 20px 4px;
            color: var(--text-muted-custom);
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            font-weight: 600;
        }

        .main-content { margin-left: 260px; min-height: 100vh; padding: 20px; }
        .report-card { background: #fff; border-radius: 16px; padding: 24px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .stat-box { padding: 20px; border-radius: 12px; background: #f8fafc; border: 1px solid #e2e8f0; }

        .sidebar-footer { padding: 16px 20px; border-top: 1px solid rgba(255,255,255,0.07); }
        .btn-logout-sidebar {
            display: flex; align-items: center; gap: 10px;
            color: #f87171; text-decoration: none; font-size: 0.875rem;
            padding: 8px 12px; border-radius: 6px; transition: background 0.2s;
        }
        .btn-logout-sidebar:hover { background: rgba(248,113,113,0.1); }

        
    /* ---- Mobile Responsive Updates ---- */
.sidebar-overlay {
    position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0,0,0,0.5);
    z-index: 998;
    display: none;
    opacity: 0;
    transition: opacity 0.3s ease;
}
.sidebar-overlay.active {
    display: block;
    opacity: 1;
}

@media(max-width: 768px) {
    .sidebar { 
        transform: translateX(-100%); 
        transition: transform 0.3s ease-in-out;
        width: 280px !important;
        z-index: 999;
        display: flex !important; flex-direction: column !important;
    }
    .sidebar.active {
        transform: translateX(0);
    }
    .main-content { 
        margin-left: 0 !important; padding: 15px !important; }
    .topbar {
        padding: 12px 16px;
    }
    .content-area {
        padding: 16px;
    }
    .sidebar-brand h4, .sidebar-brand small, .sidebar-user .name, .sidebar-user .role, .nav-link-item span, .nav-label { display: block !important; }
    .nav-link-item { justify-content: flex-start !important; padding: 10px 20px !important; }
}
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-brand">
            <h4><i class="fas fa-hospital-alt me-2" style="color:#3b82f6"></i> ClinicMS</h4>
            <small>Reception Portal</small>
        </div>
        <a href="${pageContext.request.contextPath}/receptionist/profile" class="sidebar-user text-decoration-none">
            <div class="avatar">${user.fullName.substring(0,1)}</div>
            <div>
                <div class="name text-white">${user.fullName}</div>
                <div class="role text-muted-custom small" style="font-size: 0.72rem; color: #94a3b8;">Receptionist</div>
            </div>
        </a>
        <div class="nav flex-column mt-3">
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="nav-link-item ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}"><i class="fas fa-th-large"></i> <span>Dashboard</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/patients" class="nav-link-item ${pageContext.request.requestURI.contains('patients') ? 'active' : ''}"><i class="fas fa-users"></i> <span>Patients</span></a>
            <a href="#" class="nav-link-item" data-bs-toggle="modal" data-bs-target="#registrationModal"><i class="fas fa-user-plus"></i> <span>Register Patient</span></a>
            <a href="#" class="nav-link-item" data-bs-toggle="modal" data-bs-target="#bookingModal"><i class="fas fa-calendar-check"></i> <span>Book Appointment</span></a>
            <a href="#" class="nav-link-item" data-bs-toggle="modal" data-bs-target="#leaveModal"><i class="fas fa-calendar-minus"></i> <span>Leave Request</span></a>
            
            <div class="nav-label">Management</div>
            <a href="${pageContext.request.contextPath}/receptionist/queue" class="nav-link-item ${pageContext.request.requestURI.contains('queue') ? 'active' : ''}"><i class="fas fa-users"></i> <span>Queue Status</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/calendar" class="nav-link-item ${pageContext.request.requestURI.contains('calendar') ? 'active' : ''}"><i class="fas fa-calendar-alt"></i> <span>Calendar</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/profile" class="nav-link-item ${pageContext.request.requestURI.contains('profile') ? 'active' : ''}"><i class="fas fa-user-circle"></i> <span>My Profile</span></a>
            <a href="${pageContext.request.contextPath}/receptionist/reports" class="nav-link-item ${pageContext.request.requestURI.contains('reports') ? 'active' : ''}"><i class="fas fa-file-medical"></i> <span>Reports</span></a>
        </div>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout-sidebar">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
    <div class="main-content">
        <div class="report-card">
            <h5 class="fw-bold mb-4">Clinic Daily Summary</h5>
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-box">
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.65rem;">Total Today</small>
                        <div class="h3 fw-bold mb-0">${stats.totalAppointmentsToday}</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.65rem;">Completed</small>
                        <div class="h3 fw-bold mb-0 text-success">${stats.completedConsultations}</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.65rem;">New Patients</small>
                        <div class="h3 fw-bold mb-0 text-primary">${stats.walkinsToday}</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.65rem;">Missed</small>
                        <div class="h3 fw-bold mb-0 text-danger">${stats.noShowCount}</div>
                    </div>
                </div>
            </div>
            <button class="btn btn-dark" onclick="window.print()"><i class="fas fa-print me-2"></i> Print Daily Report</button>
        </div>
    </div>
    <!-- Modals -->
    <!-- Registration Modal -->
    <div class="modal fade" id="registrationModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold"><i class="fas fa-user-plus me-2"></i>New Patient Registration</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="registrationForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="name" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Age</label>
                                <input type="number" class="form-control" name="age" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Gender</label>
                                <select class="form-select" name="gender">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contact Number</label>
                                <input type="tel" class="form-control" name="contactNumber" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Blood Group</label>
                                <select class="form-select" name="bloodGroup">
                                    <option value="A+">A+</option>
                                    <option value="B+">B+</option>
                                    <option value="O+">O+</option>
                                    <option value="AB+">AB+</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Address</label>
                                <textarea class="form-control" name="address" rows="2"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary px-4" onclick="submitRegistration()">Register Patient</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Booking Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fas fa-calendar-plus me-2"></i>Book New Appointment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="bookingForm">
                        <div class="mb-3">
                            <label class="form-label">Search Patient</label>
                            <input type="text" class="form-control" id="patientSearch" placeholder="Enter ID or Phone...">
                            <div id="patientResults" class="list-group mt-2 shadow-sm" style="display:none"></div>
                            <input type="hidden" name="patientId" id="selectedPatientId">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Department</label>
                            <select class="form-select" name="department" id="deptSelect">
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.name}">${dept.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Select Doctor</label>
                            <select class="form-select" name="doctorId">
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.id}">Dr. ${doc.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Date</label>
                                <input type="date" class="form-control" name="date" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Time Slot</label>
                                <input type="time" class="form-control" name="time" required>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success px-4" onclick="submitBooking()">Confirm Booking</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Leave Request Modal -->
    <div class="modal fade" id="leaveModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title fw-bold"><i class="fas fa-calendar-minus me-2"></i>Request Leave / Half Day</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/receptionist/leave/apply" method="POST">
                        <div class="mb-3">
                            <label class="form-label">Reason</label>
                            <textarea class="form-control" name="reason" rows="3" placeholder="Explain your reason for leave..." required></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Start Date</label>
                                <input type="date" class="form-control" name="startDate" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">End Date</label>
                                <input type="date" class="form-control" name="endDate" required>
                            </div>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-warning px-4 fw-bold">Submit Request</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script>
        // Patient Search & Selection for Booking
        document.getElementById('patientSearch').addEventListener('input', function(e) {
            const query = e.target.value;
            if (query.length < 3) return;
            
            fetch(`${pageContext.request.contextPath}/receptionist/patient/search?query=` + query)
                .then(res => res.json())
                .then(data => {
                    const results = document.getElementById('patientResults');
                    results.innerHTML = '';
                    if (data.length > 0) {
                        data.forEach(p => {
                            const item = document.createElement('a');
                            item.className = 'list-group-item list-group-item-action';
                            item.innerHTML = `<strong>${p.name}</strong> <small class="text-muted">(${p.patientId})</small>`;
                            item.href = 'javascript:void(0)';
                            item.onclick = () => {
                                document.getElementById('patientSearch').value = p.name + " (" + p.patientId + ")";
                                document.getElementById('selectedPatientId').value = p.id;
                                results.style.display = 'none';
                            };
                            results.appendChild(item);
                        });
                        results.style.display = 'block';
                    }
                });
        });

        function submitRegistration() {
            const formData = new FormData(document.getElementById('registrationForm'));
            const data = Object.fromEntries(formData.entries());
            if(!data.name || !data.contactNumber) {
                alert('Please fill at least name and contact number');
                return;
            }
            fetch(`${pageContext.request.contextPath}/receptionist/patient/register`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(res => {
                if(!res.ok) throw new Error('Registration failed');
                return res.json();
            })
            .then(p => {
                alert('Success! Patient Registered. ID: ' + p.patientId);
                location.reload();
            })
            .catch(err => {
                console.error(err);
                alert('Error: Could not register patient. Please try again.');
            });
        }

        function submitBooking() {
            const formData = new FormData(document.getElementById('bookingForm'));
            const data = Object.fromEntries(formData.entries());
            
            if(!data.patientId || !data.doctorId || !data.date || !data.time) {
                alert('Please search/select a patient and fill all fields.');
                return;
            }

            fetch(`${pageContext.request.contextPath}/receptionist/appointment/book`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            }).then(res => res.json()).then(app => {
                alert('Booking Confirmed! Token: #' + app.tokenNumber);
                location.reload();
            });
        }
    </script>
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
                    const sb = document.querySelector('.sidebar');
                    if(sb) sb.classList.toggle('active');
                    const overlay = document.getElementById('sidebarOverlay');
                    if(overlay) overlay.classList.toggle('active');
                };
                wrapper.appendChild(toggleBtn);
                h5.parentNode.insertBefore(wrapper, h5);
                wrapper.appendChild(h5);
                h5.style.margin = '0';
            }
        } else if (!topbar && !document.getElementById('sidebarToggleBtn')) {
            const main = document.querySelector('.main-content');
            if(main) {
                const wrapper = document.createElement('div');
                wrapper.className = 'd-md-none mb-3 d-flex align-items-center';
                wrapper.innerHTML = '<button id="sidebarToggleBtn" class="btn btn-light me-2" style="padding:4px 8px;"><i class="fas fa-bars"></i></button><h5 class="m-0">Menu</h5>';
                wrapper.querySelector('button').onclick = function() {
                    const sb = document.querySelector('.sidebar');
                    if(sb) sb.classList.toggle('active');
                    const overlay = document.getElementById('sidebarOverlay');
                    if(overlay) overlay.classList.toggle('active');
                };
                main.insertBefore(wrapper, main.firstChild);
            }
        }
        const overlay = document.getElementById('sidebarOverlay');
        if(overlay) {
            overlay.onclick = function() {
                const sb = document.querySelector('.sidebar');
                if(sb) sb.classList.remove('active');
                overlay.classList.remove('active');
            };
        }
    });
</script>
</body>
</html>
