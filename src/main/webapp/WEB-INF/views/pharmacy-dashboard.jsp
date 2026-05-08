<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacy Management System | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .section { display: none; }
        .section.active { display: block; }
        .nav-link { cursor: pointer; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; color: #64748b; font-size: 13px; text-transform: uppercase; }
        td { padding: 14px 12px; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
        
        .badge-pill { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-success { background: #ecfdf5; color: #10b981; }
        .badge-warning { background: #fffbeb; color: #f59e0b; }
        .badge-danger { background: #fef2f2; color: #ef4444; }
        
        .pharm-stat-value {
            font-size: 24px !important;
            font-weight: 700 !important;
            color: #1e293b !important;
            display: block !important;
            margin-top: 5px;
        }
        
        .payment-card-ui { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 15px; margin-top: 5px; border-left: 4px solid #4f46e5; }
        .payment-label { font-size: 11px; font-weight: 700; color: #475569; margin-bottom: 5px; display: block; }
        .payment-row { display: flex; gap: 10px; }
        .payment-qr { text-align: center; margin-bottom: 12px; }
        .payment-qr i { font-size: 36px; color: #334155; display: block; margin-bottom: 6px; }
        .payment-qr span { font-size: 12px; color: #64748b; font-weight: 500; }
        .payment-details-group input { font-size: 12px !important; }
        
        .quick-status-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .status-list { display: flex; flex-direction: column; gap: 12px; }
        .status-item { 
            display: flex; align-items: center; gap: 15px; padding: 12px 16px; 
            border-radius: 12px; background: white; border: 1px solid #e2e8f0; 
            transition: transform 0.2s;
        }
        .status-item:hover { transform: translateX(5px); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
        .status-icon { 
            width: 40px; height: 40px; border-radius: 10px; display: flex; 
            align-items: center; justify-content: center; font-size: 18px; 
        }
        .status-info { flex: 1; }
        .status-tag { font-size: 10px; font-weight: 700; text-transform: uppercase; margin-bottom: 2px; display: block; }
        .status-name { font-size: 14px; font-weight: 600; color: #1e293b; display: block; }
        .status-desc { font-size: 12px; color: #64748b; }
        
        .status-item.low { border-left: 4px solid #f59e0b; }
        .status-item.low .status-icon { background: #fffbeb; color: #f59e0b; }
        .status-item.low .status-tag { color: #f59e0b; }
        
        .status-item.expiry { border-left: 4px solid #ef4444; }
        .status-item.expiry .status-icon { background: #fef2f2; color: #ef4444; }
        .status-item.expiry .status-tag { color: #ef4444; }
        
        .btn-mini-action { 
            padding: 6px 12px; border-radius: 6px; font-size: 11px; font-weight: 600; 
            text-decoration: none; transition: all 0.2s;
        }
        .btn-mini-low { background: #fffbeb; color: #f59e0b; border: 1px solid #fef3c7; }
        .btn-mini-low:hover { background: #fef3c7; }
        .btn-mini-expiry { background: #fef2f2; color: #ef4444; border: 1px solid #fee2e2; }
        .btn-mini-expiry:hover { background: #fee2e2; }
    </style>
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
                <a href="/pharmacy-dashboard" class="nav-link active"><i class="fas fa-th-large"></i> Dashboard</a>
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
                <div class="header-search">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search...">
                </div>
                <div class="header-user">
                    <!-- Notifications -->
                    <div class="dropdown me-3">
                        <button class="btn btn-light position-relative p-2 rounded-circle" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 40px; height: 40px;">
                            <i class="fas fa-bell text-secondary"></i>
                            <c:if test="${not empty notifications}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-light" style="font-size: 9px; padding: 3px 5px;">
                                    ${notifications.size()}
                                </span>
                            </c:if>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2" style="width: 320px; border-radius: 12px; overflow: hidden;">
                            <li class="px-3 py-3 bg-light border-bottom d-flex justify-content-between align-items-center">
                                <h6 class="mb-0 fw-bold">Notifications</h6>
                                <c:if test="${not empty notifications}">
                                    <form action="/pharmacy/notifications/read-all" method="post" class="m-0">
                                        <button type="submit" class="btn btn-link btn-sm p-0 text-decoration-none" style="font-size: 12px;">Mark all read</button>
                                    </form>
                                </c:if>
                            </li>
                            <div style="max-height: 350px; overflow-y: auto;">
                                <c:forEach var="n" items="${notifications}">
                                    <li class="px-3 py-3 border-bottom dropdown-item-text">
                                        <div class="d-flex align-items-start gap-3">
                                            <div class="rounded-circle p-2 bg-${n.type == 'Urgent' ? 'danger' : 'primary'} bg-opacity-10">
                                                <i class="fas ${n.type == 'Urgent' ? 'fa-exclamation-circle text-danger' : 'fa-info-circle text-primary'}" style="font-size: 14px;"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="small fw-bold text-dark mb-1">${n.type} Alert</div>
                                                <div class="text-muted small" style="line-height: 1.4;">${n.message}</div>
                                                <div class="text-muted mt-2" style="font-size: 10px;">
                                                    <i class="far fa-clock me-1"></i>
                                                    ${n.createdAt}
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty notifications}">
                                    <li class="px-3 py-5 text-center">
                                        <div class="mb-2 text-muted opacity-50"><i class="fas fa-bell-slash fa-2x"></i></div>
                                        <div class="text-muted small">No new notifications</div>
                                    </li>
                                </c:if>
                            </div>
                            <li class="p-2 bg-light text-center border-top">
                                <a href="#" class="text-decoration-none small text-muted">View all history</a>
                            </li>
                        </ul>
                    </div>
                    <div class="user-profile">
                        <c:choose>
                            <c:when test="${not empty user.profileImage}">
                                <img src="${user.profileImage}" alt="User">
                            </c:when>
                            <c:when test="${user.gender == 'Female'}">
                                <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=ec4899&color=fff" alt="User">
                            </c:when>
                            <c:otherwise>
                                <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff" alt="User">
                            </c:otherwise>
                        </c:choose>
                        <div class="user-info">
                            <span class="name">${user.fullName}</span>
                            <span class="role">Chief Pharmacist</span>
                        </div>
                    </div>
                </div>
            </header>

            <c:if test="${not empty successMessage}">
                <div style="background: #ecfdf5; color: #10b981; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #10b981;">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>

            <!-- Dashboard Section -->
            <div id="section-dashboard" class="section active">
                <section class="dashboard-stats">
                    <div class="stat-card revenue">
                        <div class="stat-icon"><i class="fas fa-indian-rupee-sign"></i></div>
                        <div class="stat-data">
                            <h3>Daily Revenue</h3>
                            <div class="pharm-stat-value">₹${dailyRevenue}</div>
                        </div>
                    </div>
                    <div class="stat-card stock">
                        <div class="stat-icon"><i class="fas fa-box"></i></div>
                        <div class="stat-data">
                            <h3>Low Stock</h3>
                            <div class="pharm-stat-value">${lowStockCount}</div>
                        </div>
                    </div>
                    <div class="stat-card expiry">
                        <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
                        <div class="stat-data">
                            <h3>Expiry Alerts</h3>
                            <div class="pharm-stat-value">${expiringSoonCount}</div>
                        </div>
                    </div>
                    <div class="stat-card payments">
                        <div class="stat-icon"><i class="fas fa-wallet"></i></div>
                        <div class="stat-data">
                            <h3>Pending</h3>
                            <div class="pharm-stat-value">${pendingPaymentsCount}</div>
                        </div>
                    </div>
                </section>

                <div class="dashboard-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 24px; align-items: start;">
                    <!-- Recent Invoices -->
                    <div class="grid-card">
                        <div class="card-header">
                            <h2><i class="fas fa-file-invoice-dollar"></i> Recent Invoices</h2>
                            <a href="/pharmacy/sales" class="view-all">View All</a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="custom-table mb-0">
                                    <thead>
                                        <tr>
                                            <th>Inv #</th>
                                            <th>Patient</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th class="text-end">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="inv" items="${recentInvoices}" varStatus="status">
                                            <c:if test="${status.index < 5}">
                                                <tr>
                                                    <td><strong>${inv.invoiceNumber}</strong></td>
                                                    <td>${inv.patient.name}</td>
                                                    <td>₹${inv.totalAmount}</td>
                                                    <td><span class="badge-pill badge-success">${inv.paymentStatus}</span></td>
                                                    <td class="text-end">
                                                        <a href="/pharmacy/invoice/download?id=${inv.id}" class="btn btn-sm btn-light text-primary border" title="Download">
                                                            <i class="fas fa-download"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${empty recentInvoices}">
                                            <tr><td colspan="5" class="text-center py-4 text-muted small">No invoices found</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Prescription Queue -->
                    <div class="grid-card">
                        <div class="card-header">
                            <h2><i class="fas fa-prescription-bottle-alt"></i> Prescription Queue</h2>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="custom-table mb-0">
                                    <thead>
                                        <tr>
                                            <th>Patient</th>
                                            <th>Status</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="rx" items="${prescriptions}">
                                            <tr>
                                                <td>
                                                    <strong>${rx.patient.name}</strong><br>
                                                    <span class="text-muted small">${rx.prescriptionId}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${rx.status == 'Pending'}"><span class="badge-pill badge-warning">${rx.status}</span></c:when>
                                                        <c:when test="${rx.status == 'Preparing'}"><span class="badge-pill badge-info">${rx.status}</span></c:when>
                                                        <c:when test="${rx.status == 'Ready'}"><span class="badge-pill badge-success">${rx.status}</span></c:when>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" data-bs-display="static" aria-expanded="false">
                                                            Actions
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                                            <li>
                                                                <form action="/pharmacy/update-prescription-status" method="post">
                                                                    <input type="hidden" name="id" value="${rx.id}">
                                                                    <input type="hidden" name="status" value="Preparing">
                                                                    <button type="submit" class="dropdown-item py-2">
                                                                        <i class="fas fa-clock text-primary me-2"></i> Mark Preparing
                                                                    </button>
                                                                </form>
                                                            </li>
                                                            <li>
                                                                <form action="/pharmacy/update-prescription-status" method="post">
                                                                    <input type="hidden" name="id" value="${rx.id}">
                                                                    <input type="hidden" name="status" value="Ready">
                                                                    <button type="submit" class="dropdown-item py-2">
                                                                        <i class="fas fa-check-circle text-success me-2"></i> Mark Ready
                                                                    </button>
                                                                </form>
                                                            </li>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li class="px-3 py-2">
                                                                <form action="/pharmacy/dispense" method="post">
                                                                    <input type="hidden" name="prescriptionId" value="${rx.id}">
                                                                    <label class="form-label small mb-1 text-muted">Payment</label>
                                                                    <select name="paymentMethod" class="form-select form-select-sm mb-2" onchange="togglePaymentDetails(this, '${rx.id}')" required>
                                                                        <option value="Cash">Cash</option>
                                                                        <option value="UPI">UPI</option>
                                                                        <option value="Card">Card</option>
                                                                    </select>
                                                                    
                                                                    <div id="upi-details-${rx.id}" class="payment-details-group" style="display:none;">
                                                                        <div class="payment-card-ui">
                                                                            <div class="payment-qr">
                                                                                <i class="fas fa-qrcode"></i>
                                                                                <span>Scan QR to Pay via UPI</span>
                                                                            </div>
                                                                            <input type="text" name="transactionId" class="form-control form-control-sm" placeholder="Enter UPI Transaction ID">
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <div id="card-details-${rx.id}" class="payment-details-group" style="display:none;">
                                                                        <div class="payment-card-ui">
                                                                            <label class="payment-label">Card Number</label>
                                                                            <input type="text" name="cardNumber" class="form-control form-control-sm mb-2" placeholder="XXXX XXXX XXXX 1234">
                                                                            <div class="payment-row">
                                                                                <div style="flex:1">
                                                                                    <label class="payment-label">Expiry</label>
                                                                                    <input type="text" name="expiry" class="form-control form-control-sm" placeholder="MM/YY">
                                                                                </div>
                                                                                <div style="flex:1">
                                                                                    <label class="payment-label">Enter PIN</label>
                                                                                    <input type="password" name="pin" class="form-control form-control-sm" placeholder="••••">
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <button type="submit" class="btn btn-sm btn-primary w-100 mt-2">Dispense & Bill</button>
                                                                </form>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty prescriptions}">
                                            <tr><td colspan="3" class="text-center py-4 text-muted small">No active prescriptions</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="grid-card mt-4">
                    <div class="card-header">
                        <h2><i class="fas fa-bullseye text-primary"></i> Quick Inventory Insights</h2>
                    </div>
                    <div class="card-body">
                        <div class="quick-status-grid">
                            <!-- Low Stock Side -->
                            <div class="status-list">
                                <h6 class="fw-bold mb-3 d-flex align-items-center gap-2" style="font-size: 14px; color: #64748b;">
                                    <i class="fas fa-cubes"></i> Low Stock Alerts
                                </h6>
                                <c:forEach var="med" items="${lowStockMedicines}" end="2">
                                    <div class="status-item low">
                                        <div class="status-icon"><i class="fas fa-exclamation-triangle"></i></div>
                                        <div class="status-info">
                                            <span class="status-tag">Reorder Needed</span>
                                            <span class="status-name">${med.name}</span>
                                            <span class="status-desc">${med.stockLevel} units remaining</span>
                                        </div>
                                        <a href="/pharmacy/inventory" class="btn-mini-action btn-mini-low">Restock</a>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty lowStockMedicines}">
                                    <div class="text-center py-4 border rounded-3 bg-light opacity-50 small">No low stock items</div>
                                </c:if>
                            </div>

                            <!-- Expiry Side -->
                            <div class="status-list">
                                <h6 class="fw-bold mb-3 d-flex align-items-center gap-2" style="font-size: 14px; color: #64748b;">
                                    <i class="fas fa-hourglass-end"></i> Expiring Soon
                                </h6>
                                <c:forEach var="med" items="${expiringMedicines}" end="2">
                                    <div class="status-item expiry">
                                        <div class="status-icon"><i class="fas fa-clock"></i></div>
                                        <div class="status-info">
                                            <span class="status-tag">Near Expiry</span>
                                            <span class="status-name">${med.name}</span>
                                            <span class="status-desc">Expires: ${med.expiryDate}</span>
                                        </div>
                                        <a href="/pharmacy/inventory" class="btn-mini-action btn-mini-expiry">Action</a>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty expiringMedicines}">
                                    <div class="text-center py-4 border rounded-3 bg-light opacity-50 small">No items expiring soon</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
            </div>

            <!-- Inventory Section -->
            <div id="section-inventory" class="section">
                <div class="grid-card">
                    <div class="card-header"><h2><i class="fas fa-pills"></i> Complete Inventory & Expiry Tracking</h2></div>
                    <div class="card-body">
                        <table>
                            <thead><tr><th>Medicine Name</th><th>Batch</th><th>Stock</th><th>Price</th><th>Expiry Date</th><th>Status</th></tr></thead>
                            <tbody>
                                <c:forEach var="med" items="${medicines}">
                                    <tr>
                                        <td><strong>${med.name}</strong></td>
                                        <td>${med.batchNumber}</td>
                                        <td>${med.stockLevel}</td>
                                        <td>₹${med.price}</td>
                                        <td style="color: #b91c1c;"><strong>${med.expiryDate}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${med.stockLevel <= 5}"><span class="badge-pill badge-danger">Critical</span></c:when>
                                                <c:when test="${med.stockLevel <= 15}"><span class="badge-pill badge-warning">Low</span></c:when>
                                                <c:otherwise><span class="badge-pill badge-success">Optimal</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Medicine Issue / Billing Section -->
            <div id="section-billing" class="section">
                <div class="grid-card" style="max-width: 600px; margin: 0 auto;">
                    <div class="card-header"><h2><i class="fas fa-receipt"></i> Medicine Issue & Billing Generation</h2></div>
                    <div class="card-body">
                        <form action="/generate-invoice" method="POST" style="display: flex; flex-direction: column; gap: 20px;">
                            <div class="form-group">
                                <label>Patient Name</label>
                                <select name="patientId" required style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
                                    <option value="">Select Patient</option>
                                    <c:forEach var="p" items="${patients}"><option value="${p.id}">${p.name} (${p.patientId})</option></c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Medicine</label>
                                <select name="medicineId" required style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
                                    <option value="">Select Medicine</option>
                                    <c:forEach var="m" items="${medicines}"><option value="${m.id}">${m.name} - ₹${m.price} (Stock: ${m.stockLevel})</option></c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Quantity</label>
                                <input type="number" name="quantity" placeholder="Enter quantity" min="1" required style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
                            </div>
                            <div class="form-group">
                                <label>Payment Method</label>
                                <select id="dash-payment-method" name="paymentMethod" required style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
                                    <option value="Cash">Cash</option>
                                    <option value="Card">Credit/Debit Card</option>
                                    <option value="UPI">UPI / Net Banking</option>
                                </select>
                            </div>

                            <!-- Dynamic Payment Simulation for Dashboard -->
                            <div id="dash-card-section" style="display: none; padding: 12px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 10px;">
                                <input type="password" placeholder="Enter Card PIN" maxlength="4" style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #cbd5e1; text-align: center; font-size: 18px; letter-spacing: 5px;">
                            </div>

                            <div id="dash-upi-section" style="display: none; padding: 12px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 10px; text-align: center;">
                                <i class="fas fa-qrcode" style="font-size: 30px; color: #475569; margin-bottom: 5px;"></i>
                                <p style="font-size: 11px; color: #64748b;">Scan to Pay</p>
                            </div>
                            <div id="dash-total-display" style="padding: 10px; background: #e0f2fe; border-radius: 8px; text-align: center; border: 1px solid #bae6fd; margin-bottom: 10px;">
                                <span style="font-size: 12px; color: #0369a1;">Total Amount</span>
                                <div style="font-size: 20px; font-weight: 800; color: #0369a1;">₹<span id="dash-total-val">0.00</span></div>
                            </div>
                            <button type="submit" style="padding: 15px; background: #4f46e5; color: white; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; font-size: 16px;">
                                <i class="fas fa-print"></i> Generate Invoice & Update Stock
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Sales Summary Section -->
            <div id="section-sales" class="section">
                <div class="grid-card">
                    <div class="card-header"><h2><i class="fas fa-chart-line"></i> Sales Summary & Invoice Records</h2></div>
                    <div class="card-body">
                        <table>
                            <thead><tr><th>Invoice #</th><th>Patient</th><th>Date & Time</th><th>Total Amount</th><th>Method</th><th>Status</th></tr></thead>
                            <tbody>
                                <c:forEach var="invoice" items="${recentInvoices}">
                                    <tr>
                                        <td><strong>#${invoice.invoiceNumber}</strong></td>
                                        <td>${invoice.patient.name}</td>
                                        <td>${invoice.invoiceDate}</td>
                                        <td>₹${invoice.totalAmount}</td>
                                        <td>${invoice.paymentMethod}</td>
                                        <td><span class="badge-pill badge-success">Paid</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                      <!-- Staff & Shifts Section -->
            <div id="section-staff" class="section">
                <div class="grid-card">
                    <div class="card-header"><h2><i class="fas fa-users-cog"></i> Pharmacy Staff, Shifts & Attendance</h2></div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: 1fr 1.5fr; gap: 24px;">
                            <div>
                                <h3 style="margin-bottom: 15px;">Today's Shifts</h3>
                                <c:forEach var="shift" items="${allShifts}">
                                    <div style="padding: 15px; background: #f8fafc; border-radius: 10px; margin-bottom: 10px; border: 1px solid #e2e8f0;">
                                        <strong>${shift.staff.fullName}</strong><br>
                                        <small style="color: #64748b;">${shift.dayOfWeek} | ${shift.startTime} - ${shift.endTime}</small>
                                    </div>
                                </c:forEach>
                            </div>
                            <div>
                                <h3 style="margin-bottom: 15px;">Recent Attendance</h3>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Staff</th>
                                            <th>Date</th>
                                            <th>Check-In</th>
                                            <th>Check-Out</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="att" items="${allAttendance}">
                                            <tr>
                                                <td>${att.staff.fullName}</td>
                                                <td>${att.date}</td>
                                                <td>${att.checkIn}</td>
                                                <td>${att.checkOut != null ? att.checkOut : '--'}</td>
                                                <td><span class="badge-pill badge-success">${att.status}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Personal Stats (From Admin) -->
                <div class="grid-card" style="margin-top: 24px;">
                    <div class="card-header"><h2><i class="fas fa-user-chart"></i> Your Personal Performance (Admin Assigned)</h2></div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
                            <div style="background: #f8fafc; padding: 15px; border-radius: 12px; text-align: center; border: 1px solid #e2e8f0;">
                                <h4 style="color: #4f46e5; font-size: 11px; text-transform: uppercase; margin-bottom: 5px;">Today's Status</h4>
                                <div style="font-size: 18px; font-weight: 700;">
                                    <c:choose>
                                        <c:when test="${user.attendanceStatus == 'Present'}"><span class="badge-pill badge-success">Present</span></c:when>
                                        <c:otherwise><span class="badge-pill" style="background:#f1f5f9; color:#64748b;">${user.attendanceStatus != null ? user.attendanceStatus : 'Not Marked'}</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div style="background: #f8fafc; padding: 15px; border-radius: 12px; text-align: center; border: 1px solid #e2e8f0;">
                                <h4 style="color: #4f46e5; font-size: 11px; text-transform: uppercase; margin-bottom: 5px;">Your Shift</h4>
                                <div style="font-size: 14px; font-weight: 700; color: #4f46e5;">${user.shiftTiming != null ? user.shiftTiming : 'Not Assigned'}</div>
                            </div>
                            <div style="background: #f8fafc; padding: 15px; border-radius: 12px; text-align: center; border: 1px solid #e2e8f0;">
                                <h4 style="color: #4f46e5; font-size: 11px; text-transform: uppercase; margin-bottom: 5px;">Performance</h4>
                                <div style="color: #fbbf24; font-size: 20px;">
                                    <c:choose>
                                        <c:when test="${user.performanceRating != null}">
                                            <c:forEach begin="1" end="${user.performanceRating}">⭐</c:forEach>
                                        </c:when>
                                        <c:otherwise><span style="font-size: 12px; color: #64748b;">No Rating</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize all dropdowns manually to be safe
        document.addEventListener('DOMContentLoaded', function () {
            var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'))
            var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
                return new bootstrap.Dropdown(dropdownToggleEl)
            })
        });
        // Real-time calculation for dashboard form
        const dashMedSelect = document.querySelector('#section-billing select[name="medicineId"]');
        const dashQtyInput = document.querySelector('#section-billing input[name="quantity"]');
        const dashTotalVal = document.getElementById('dash-total-val');

        const prices = {};
        <c:forEach var="m" items="${medicines}">
            prices["${m.id}"] = ${m.price};
        </c:forEach>

        function updateDashTotal() {
            const medId = dashMedSelect.value;
            const qty = parseInt(dashQtyInput.value) || 0;
            const price = prices[medId] || 0;
            const total = price * qty;
            dashTotalVal.innerText = total.toFixed(2);
        }

        const dashMethod = document.getElementById('dash-payment-method');
        const dashCardSec = document.getElementById('dash-card-section');
        const dashUpiSec = document.getElementById('dash-upi-section');

        function toggleDashPayments() {
            const m = dashMethod.value;
            dashCardSec.style.display = (m === 'Card') ? 'block' : 'none';
            dashUpiSec.style.display = (m === 'UPI') ? 'block' : 'none';
        }

        if(dashMedSelect && dashQtyInput) {
            dashMedSelect.addEventListener('change', updateDashTotal);
            dashQtyInput.addEventListener('input', updateDashTotal);
            dashMethod.addEventListener('change', toggleDashPayments);
        }

        // Notification System for Pharmacy
        function fetchNotifications() {
            $.get('/doctor/notifications/latest', function(data) {
                if (data.length > 0) {
                    $('.notifications .badge').text(data.length).show();
                    // Optional: show a toast or update a list
                }
            });
        }
        setInterval(fetchNotifications, 10000);
        fetchNotifications();
    </script>
    <script>
        function togglePaymentDetails(select, rxId) {
            const upiDetails = document.getElementById('upi-details-' + rxId);
            const cardDetails = document.getElementById('card-details-' + rxId);
            
            // Hide all first
            upiDetails.style.display = 'none';
            cardDetails.style.display = 'none';
            
            // Remove required attribute from all
            upiDetails.querySelectorAll('input').forEach(i => i.required = false);
            cardDetails.querySelectorAll('input').forEach(i => i.required = false);
            
            if (select.value === 'UPI') {
                upiDetails.style.display = 'block';
                upiDetails.querySelector('input').required = true;
            } else if (select.value === 'Card') {
                cardDetails.style.display = 'block';
                cardDetails.querySelectorAll('input').forEach(i => i.required = true);
            }
        }
    </script>
</body>
</html>
