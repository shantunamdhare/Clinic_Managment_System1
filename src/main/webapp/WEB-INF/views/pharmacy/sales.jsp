<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Summary | MediCare+ Pharmacy</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; color: #64748b; font-size: 13px; text-transform: uppercase; }
        td { padding: 14px 12px; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
        .badge-pill { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; background: #ecfdf5; color: #10b981; }
    </style>
</head>
<body>
    <div class="pharmacy-container">
        <aside class="sidebar">
            <div class="sidebar-logo">
                <i class="fas fa-prescription-bottle-alt"></i>
                <span>MediCare+ <span>Pharmacy</span></span>
            </div>
            <nav class="sidebar-nav">
                <a href="/pharmacy-dashboard" class="nav-link"><i class="fas fa-grid-2"></i> Dashboard</a>
                <a href="/pharmacy/inventory" class="nav-link"><i class="fas fa-pills"></i> Inventory</a>
                <a href="/pharmacy/billing" class="nav-link"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link active"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link"><i class="fas fa-users-gear"></i> Staff Management</a>
                <a href="/pharmacy/leave" class="nav-link"><i class="fas fa-calendar-minus"></i> Leave Request</a>
            </nav>
            <div class="sidebar-footer">
                <a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </aside>
        <main class="main-content">
            <header class="main-header">
                <div class="header-search"><i class="fas fa-search"></i><input type="text" placeholder="Search invoices..."></div>
                <div class="header-user">
                    <div class="user-profile">
                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff" alt="User">
                        <div class="user-info"><span class="name">${user.fullName}</span><span class="role">Pharmacist</span></div>
                    </div>
                </div>
            </header>
            <div class="grid-card">
                <div class="card-header"><h2><i class="fas fa-chart-line"></i> Sales History & Invoice Records</h2></div>
                <div class="card-body">
                    <table>
                        <thead><tr><th>Invoice #</th><th>Patient</th><th>Date & Time</th><th>Amount</th><th>Method</th><th>Status</th></tr></thead>
                        <tbody>
                            <c:forEach var="invoice" items="${recentInvoices}">
                                <tr>
                                    <td><strong>#${invoice.invoiceNumber}</strong></td>
                                    <td>${invoice.patient.name}</td>
                                    <td>${invoice.invoiceDate}</td>
                                    <td>₹${invoice.totalAmount}</td>
                                    <td>${invoice.paymentMethod}</td>
                                    <td><span class="badge-pill">Paid</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentInvoices}">
                                <tr><td colspan="6" style="text-align: center; padding: 40px; color: #64748b;">No sales records found.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
