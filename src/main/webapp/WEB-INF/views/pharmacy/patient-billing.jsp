<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Billing History | MediCare+ Pharmacy</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="pharmacy-container">
        <aside class="sidebar">
            <div class="sidebar-logo"><i class="fas fa-plus-square"></i> <span>MediCare+ <span>Pharmacy</span></span></div>
            <nav class="sidebar-nav">
                <a href="/pharmacy-dashboard" class="nav-link"><i class="fas fa-th-large"></i> Dashboard</a>
                <a href="/pharmacy/inventory" class="nav-link"><i class="fas fa-pills"></i> Stock & Expiry</a>
                <a href="/pharmacy/billing" class="nav-link"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link"><i class="fas fa-users"></i> Staff & Shifts</a>
            </nav>
            <div class="sidebar-footer"><a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></div>
        </aside>
        <main class="main-content">
            <header class="main-header">
                <div class="header-search"><i class="fas fa-arrow-left"></i> <a href="/pharmacy-dashboard" style="text-decoration:none; color:inherit; margin-left:10px;">Back to Dashboard</a></div>
                <div class="header-user">
                    <div class="user-profile">
                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff" alt="User">
                        <div class="user-info"><span class="name">${user.fullName}</span><span class="role">Pharmacist</span></div>
                    </div>
                </div>
            </header>

            <div class="dashboard-stats" style="grid-template-columns: repeat(3, 1fr);">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#e0f2fe; color:#0ea5e9;"><i class="fas fa-user"></i></div>
                    <div class="stat-data"><h3>Patient Name</h3><p class="value">${patient.name}</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fef2f2; color:#ef4444;"><i class="fas fa-id-card"></i></div>
                    <div class="stat-data"><h3>Patient ID</h3><p class="value">${patient.patientId}</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#ecfdf5; color:#10b981;"><i class="fas fa-wallet"></i></div>
                    <div class="stat-data"><h3>Total Billed</h3><p class="value">₹<fmt:formatNumber value="${invoices.stream().mapToDouble(i -> i.totalAmount).sum()}" pattern="#,##0.00"/></p></div>
                </div>
            </div>

            <div class="grid-card" style="margin-top:24px;">
                <div class="card-header"><h2><i class="fas fa-history"></i> Billing & Invoice History</h2></div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Inv #</th>
                                    <th>Date</th>
                                    <th>Items Summary</th>
                                    <th>Method</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="inv" items="${invoices}">
                                    <tr>
                                        <td><strong>${inv.invoiceNumber}</strong></td>
                                        <td><fmt:formatDate value="${java.util.Date.from(inv.invoiceDate.atZone(java.time.ZoneId.systemDefault()).toInstant())}" pattern="dd MMM yyyy HH:mm"/></td>
                                        <td>${inv.billingItems}</td>
                                        <td>${inv.paymentMethod}</td>
                                        <td>₹${inv.totalAmount}</td>
                                        <td><span class="badge-pill badge-success">${inv.paymentStatus}</span></td>
                                        <td>
                                            <a href="/pharmacy/invoice/download?id=${inv.id}" class="btn btn-sm btn-outline-primary" title="Download PDF">
                                                <i class="fas fa-download"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty invoices}">
                                    <tr><td colspan="7" class="text-center py-4 text-muted">No billing history found for this patient.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
