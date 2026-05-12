<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Request | MediCare+ Pharmacy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <style>
        .leave-status-badge {
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .status-pending { background: var(--warning-light); color: var(--warning); }
        .status-approved { background: var(--success-light); color: var(--success); }
        .status-rejected { background: var(--danger-light); color: var(--danger); }
        
        .request-card {
            background: white;
            border-radius: 20px;
            border: 1px solid var(--border);
            padding: 24px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        .request-card:hover {
            box-shadow: var(--shadow);
            transform: translateY(-2px);
        }
        .date-range {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--text-main);
            font-weight: 600;
            margin-bottom: 10px;
        }
        .reason-text {
            color: var(--secondary);
            font-size: 14px;
            line-height: 1.6;
            background: #f8fafc;
            padding: 15px;
            border-radius: 12px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="pharmacy-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-logo">
                <i class="fas fa-prescription-bottle-alt"></i>
                <span>MediCare+ <span>Pharmacy</span></span>
            </div>
            <nav class="sidebar-nav">
                <a href="/pharmacy-dashboard" class="nav-link"><i class="fas fa-grid-2"></i> Dashboard</a>
                <a href="/pharmacy/inventory" class="nav-link"><i class="fas fa-pills"></i> Inventory</a>
                <a href="/pharmacy/billing" class="nav-link"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link"><i class="fas fa-users-gear"></i> Staff Management</a>
                <a href="/pharmacy/leave" class="nav-link active"><i class="fas fa-calendar-minus"></i> Leave Request</a>
            </nav>
            <div class="sidebar-footer">
                <a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="main-header">
                <div class="header-search">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search requests...">
                </div>
                <div class="header-user">
                    <a href="/pharmacy/profile" class="text-decoration-none">
                        <div class="user-profile">
                            <c:choose>
                                <c:when test="${not empty user.profileImage}">
                                    <img src="${user.profileImage}" alt="User">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff&bold=true" alt="User">
                                </c:otherwise>
                            </c:choose>
                            <div class="user-info">
                                <span class="name">${user.fullName}</span>
                                <span class="role">Chief Pharmacist</span>
                            </div>
                        </div>
                    </a>
                </div>
            </header>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success border-0 shadow-sm d-flex align-items-center gap-3 mb-4" style="border-radius: 16px;">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>

            <div class="row g-4">
                <!-- Submit Form -->
                <div class="col-lg-4">
                    <div class="grid-card">
                        <div class="card-header">
                            <h2><i class="fas fa-paper-plane text-primary"></i> New Request</h2>
                        </div>
                        <div class="card-body">
                            <form action="/pharmacy/leave/submit" method="post">
                                <div class="mb-3">
                                    <label class="form-label fw-bold small text-muted">START DATE</label>
                                    <input type="date" name="startDate" class="form-control rounded-12 p-3" required min="<%= java.time.LocalDate.now() %>">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small text-muted">END DATE</label>
                                    <input type="date" name="endDate" class="form-control rounded-12 p-3" required min="<%= java.time.LocalDate.now() %>">
                                </div>
                                <div class="mb-4">
                                    <label class="form-label fw-bold small text-muted">REASON FOR LEAVE</label>
                                    <textarea name="reason" class="form-control rounded-12 p-3" rows="4" placeholder="Briefly describe your reason..." required></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 rounded-12 py-3 fw-bold">
                                    Send Request to Admin
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- History -->
                <div class="col-lg-8">
                    <div class="grid-card h-100">
                        <div class="card-header">
                            <h2><i class="fas fa-history text-primary"></i> Request History</h2>
                        </div>
                        <div class="card-body">
                            <c:forEach var="req" items="${leaveRequests}">
                                <div class="request-card">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <div class="date-range">
                                                <i class="far fa-calendar-alt text-primary"></i>
                                                ${req.startDate} <i class="fas fa-long-arrow-alt-right mx-1 text-muted"></i> ${req.endDate}
                                            </div>
                                            <div class="text-muted" style="font-size: 11px;">
                                                Submitted on: ${req.submittedAt}
                                            </div>
                                        </div>
                                        <span class="leave-status-badge status-${req.status.toLowerCase()}">
                                            ${req.status}
                                        </span>
                                    </div>
                                    <div class="reason-text">
                                        <div class="fw-bold mb-1 text-dark" style="font-size: 12px;">REASON:</div>
                                        ${req.reason}
                                    </div>
                                    <c:if test="${not empty req.adminRemarks}">
                                        <div class="mt-3 p-3 bg-light border-start border-primary border-4 rounded-3">
                                            <div class="fw-bold mb-1" style="font-size: 11px;">ADMIN REMARKS:</div>
                                            <span class="small">${req.adminRemarks}</span>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                            <c:if test="${empty leaveRequests}">
                                <div class="empty-state">
                                    <i class="fas fa-calendar-check"></i>
                                    <p>No leave requests found</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
