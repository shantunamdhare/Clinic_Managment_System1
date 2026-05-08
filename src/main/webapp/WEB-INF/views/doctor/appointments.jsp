<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Today's Appointments - Clinic Management</title>
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
        <a href="/doctor/appointments" class="nav-link-item active">
            <i class="fas fa-calendar-check"></i> 
            <span style="flex-grow: 1;">Today's Appointments</span>
            <c:if test="${pendingAppointmentCount > 0}">
                <span class="badge rounded-pill bg-danger" style="font-size: 0.65rem; padding: 4px 6px;">${pendingAppointmentCount}</span>
            </c:if>
        </a>
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
        <h5><i class="fas fa-calendar-check me-2" style="color:#2563eb"></i> Today's Appointments</h5>
        <div class="d-flex align-items-center gap-3">
            <span class="date-badge"><i class="fas fa-calendar me-1"></i> <%=java.time.LocalDate.now()%></span>
            <a href="/logout" class="btn btn-outline-danger btn-sm" style="border-radius: 20px; padding: 5px 15px; font-weight: 600;">
                <i class="fas fa-sign-out-alt me-1"></i> Logout
            </a>
        </div>
    </div>
    <div class="content-area">

        <c:if test="${not empty success}">
            <div class="alert-custom alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
        </c:if>

        <div class="panel">
            <div class="panel-title"><i class="fas fa-list"></i> Scheduled Appointments for Today</div>

            <c:choose>
                <c:when test="${empty appointments}">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-calendar-times fa-3x mb-3 d-block" style="color:#cbd5e1"></i>
                        No appointments scheduled for today.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Patient Name</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${appointments}" var="appt" varStatus="loop">
                                    <tr>
                                        <td>${loop.count}</td>
                                        <td>
                                            <i class="fas fa-user-circle me-2" style="color:#94a3b8"></i>
                                            ${appt.patient.name}
                                        </td>
                                        <td>
                                            <i class="fas fa-clock me-1" style="color:#64748b"></i>
                                            ${appt.appointmentTime}
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.status == 'Completed'}">
                                                    <span class="badge-completed"><i class="fas fa-check me-1"></i>Completed</span>
                                                </c:when>
                                                <c:when test="${appt.status == 'Cancelled'}">
                                                    <span class="badge-cancelled"><i class="fas fa-times me-1"></i>Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-pending"><i class="fas fa-clock me-1"></i>Pending</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <a href="/doctor/patients/${appt.patient.id}" class="btn-sm-action btn-view">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                                <a href="/doctor/emr?patientId=${appt.patient.id}" class="btn-sm-action btn-print" style="background:#f3e8ff;color:#7c3aed;">
                                                    <i class="fas fa-stethoscope"></i> Consult
                                                </a>
                                                <c:if test="${appt.status != 'Completed'}">
                                                    <form action="/doctor/appointments/complete/${appt.id}" method="post" style="margin:0">
                                                        <button type="submit" class="btn-sm-action btn-complete">
                                                            <i class="fas fa-check"></i> Done
                                                        </button>
                                                    </form>
                                                </c:if>
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
</body>
</html>
