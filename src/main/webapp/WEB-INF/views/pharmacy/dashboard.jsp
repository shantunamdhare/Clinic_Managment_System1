<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacy Dashboard | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="pharmacy-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-logo">
                <i class="fas fa-plus-square"></i>
                <span>MediCare+ <span>Pharmacy</span></span>
            </div>
            <nav class="sidebar-nav">
                <a href="/pharmacy/dashboard" class="active"><i class="fas fa-th-large"></i> Dashboard</a>
                <a href="/pharmacy/inventory"><i class="fas fa-pills"></i> Stock Levels</a>
                <a href="/pharmacy/billing"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff"><i class="fas fa-users"></i> Staff & Performance</a>
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
                    <input type="text" placeholder="Search medicines, invoices, or staff...">
                </div>
                <div class="header-user">
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="badge">${lowStockCount + expiringSoonCount}</span>
                    </div>
                    <div class="user-profile">
                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff" alt="User">
                        <div class="user-info">
                            <span class="name">${user.fullName}</span>
                            <span class="role">Pharmacist</span>
                        </div>
                    </div>
                </div>
            </header>

            <section class="dashboard-stats">
                <div class="stat-card revenue">
                    <div class="stat-icon"><i class="fas fa-indian-rupee-sign"></i></div>
                    <div class="stat-data">
                        <h3>Daily Revenue</h3>
                        <p class="value">₹${dailyRevenue}</p>
                        <span class="trend up"><i class="fas fa-arrow-up"></i> +12% from yesterday</span>
                    </div>
                </div>
                <div class="stat-card stock">
                    <div class="stat-icon"><i class="fas fa-box"></i></div>
                    <div class="stat-data">
                        <h3>Low Stock</h3>
                        <p class="value">${lowStockCount}</p>
                        <span class="status-warning">Requires immediate refill</span>
                    </div>
                </div>
                <div class="stat-card expiry">
                    <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
                    <div class="stat-data">
                        <h3>Expiry Alerts</h3>
                        <p class="value">${expiringSoonCount}</p>
                        <span class="status-danger">Expiring within 90 days</span>
                    </div>
                </div>
                <div class="stat-card payments">
                    <div class="stat-icon"><i class="fas fa-wallet"></i></div>
                    <div class="stat-data">
                        <h3>Pending Payments</h3>
                        <p class="value">${pendingPaymentsCount}</p>
                        <span class="status-info">Follow-up required</span>
                    </div>
                </div>
            </section>

            <div class="dashboard-grid">
                <!-- Recent Sales Summary -->
                <div class="grid-card recent-sales">
                    <div class="card-header">
                        <h2><i class="fas fa-shopping-cart"></i> Recent Medicine Issues</h2>
                        <a href="/pharmacy/sales" class="view-all">View All</a>
                    </div>
                    <div class="card-body">
                        <table>
                            <thead>
                                <tr>
                                    <th>Invoice #</th>
                                    <th>Patient</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="invoice" items="${recentInvoices}">
                                    <tr>
                                        <td><strong>#${invoice.invoiceNumber}</strong></td>
                                        <td>${invoice.patient.name}</td>
                                        <td><fmt:formatDate value="${invoice.invoiceDate}" pattern="MMM dd, HH:mm"/></td>
                                        <td>₹${invoice.totalAmount}</td>
                                        <td><span class="badge ${invoice.paymentStatus.toLowerCase()}">${invoice.paymentStatus}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentInvoices}">
                                    <tr>
                                        <td colspan="5" class="empty-state">No recent sales recorded today.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Stock Alerts -->
                <div class="grid-card stock-alerts">
                    <div class="card-header">
                        <h2><i class="fas fa-exclamation-triangle"></i> Inventory Alerts</h2>
                    </div>
                    <div class="card-body">
                        <ul class="alert-list">
                            <c:forEach var="med" items="${lowStockMedicines}">
                                <li class="alert-item warning">
                                    <div class="alert-info">
                                        <strong>${med.name}</strong>
                                        <span>Only ${med.stockLevel} left in stock</span>
                                    </div>
                                    <button class="btn-refill">Refill</button>
                                </li>
                            </c:forEach>
                            <c:forEach var="med" items="${expiringMedicines}">
                                <li class="alert-item danger">
                                    <div class="alert-info">
                                        <strong>${med.name}</strong>
                                        <span>Expires on: <fmt:formatDate value="${med.expiryDate}" pattern="MMM dd, yyyy"/></span>
                                    </div>
                                    <button class="btn-remove">Dispose</button>
                                </li>
                            </c:forEach>
                            <c:if test="${empty lowStockMedicines && empty expiringMedicines}">
                                <div class="all-clear">
                                    <i class="fas fa-check-circle"></i>
                                    <p>All stock levels are optimal!</p>
                                </div>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
