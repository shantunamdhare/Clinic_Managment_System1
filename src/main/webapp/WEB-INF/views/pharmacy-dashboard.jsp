<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacy Management System | MediCare+</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <style>
        /* Specific overrides for the new dashboard UI */
        .section { display: none; }
        .section.active { display: block; animation: fadeIn 0.4s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        
        .nav-link { cursor: pointer; }
        .payment-card-ui { 
            background: #f8fafc; 
            border: 1px solid #e2e8f0; 
            border-radius: 16px; 
            padding: 20px; 
            margin-top: 10px; 
            border-left: 5px solid var(--primary); 
            box-shadow: var(--shadow-sm);
        }
        .payment-label { font-size: 11px; font-weight: 800; color: #64748b; margin-bottom: 8px; display: block; text-transform: uppercase; letter-spacing: 0.5px; }
        .payment-row { display: flex; gap: 15px; }
        .payment-qr { text-align: center; margin-bottom: 20px; padding: 15px; background: white; border-radius: 12px; border: 1px dashed #cbd5e1; }
        .payment-qr i { font-size: 48px; color: #334155; display: block; margin-bottom: 8px; }
        .payment-qr span { font-size: 12px; color: #64748b; font-weight: 600; }
        
        .empty-state {
            text-align: center;
            padding: 60px 40px;
        }
        .empty-state i {
            font-size: 56px;
            color: #cbd5e1;
            margin-bottom: 20px;
        }
        .empty-state p {
            color: #94a3b8;
            font-size: 15px;
            font-weight: 500;
        }

        .btn-action-main {
            background: var(--primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 14px;
            transition: all 0.2s;
            box-shadow: 0 4px 10px rgba(79, 70, 229, 0.2);
        }
        .btn-action-main:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(79, 70, 229, 0.3);
            color: white;
        }

        .dropdown-menu {
            padding: 16px;
            border-radius: 20px;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1);
            border: 1px solid #f1f5f9;
            min-width: 320px; /* Increased width */
        }
        .dropdown-item {
            border-radius: 12px;
            padding: 12px 16px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .dropdown-item:hover {
            background: var(--primary-light);
            color: var(--primary);
        }

        .payment-card-ui { 
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); 
            border: 1px solid #e2e8f0; 
            border-radius: 18px; 
            padding: 24px; 
            margin-top: 15px; 
            border-top: 4px solid var(--primary); 
            box-shadow: var(--shadow);
        }
        .payment-label { font-size: 11px; font-weight: 800; color: var(--secondary); margin-bottom: 10px; display: block; text-transform: uppercase; letter-spacing: 1px; }
        .payment-row { display: flex; gap: 12px; }
        .payment-qr { 
            text-align: center; 
            margin-bottom: 20px; 
            padding: 25px; 
            background: white; 
            border-radius: 20px; 
            border: 2px solid #f1f5f9;
            box-shadow: inset 0 2px 4px 0 rgba(0,0,0,0.05);
        }
        .payment-qr i { font-size: 80px; color: #1e293b; display: block; margin-bottom: 15px; }
        .payment-qr span { font-size: 13px; color: var(--secondary); font-weight: 600; }
        
        .payment-details-group input {
            height: 44px;
            border-radius: 12px !important;
            border: 1.5px solid #e2e8f0 !important;
            font-size: 14px !important;
            padding-left: 15px !important;
        }
        .payment-details-group input:focus {
            border-color: var(--primary) !important;
            box-shadow: 0 0 0 4px var(--primary-light) !important;
        }
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

.sidebar-toggle-btn {
    display: none;
    background: none;
    border: none;
    color: var(--gray-700);
    cursor: pointer;
    padding: 4px;
}

@media(max-width: 768px) {
    .sidebar-toggle-btn {
        display: flex;
        align-items: center;
        justify-content: center;
    }
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
        margin-left: 0 !important; 
    }
    .main-header {
        padding: 12px 16px !important;
        gap: 12px;
    }
    .header-search {
        display: none !important;
    }
    .user-info {
        display: none !important;
    }
    .user-profile {
        padding-left: 0 !important;
        border-left: none !important;
    }
    .dashboard-stats {
        grid-template-columns: repeat(2, 1fr) !important;
        gap: 16px !important;
    }
    .table-responsive {
        overflow-x: auto;
    }
    table {
        min-width: 800px;
    }
    .quick-status-grid {
        grid-template-columns: 1fr !important;
    }
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
                <a href="/pharmacy-dashboard" class="nav-link active"><i class="fas fa-grid-2"></i> Dashboard</a>
                <a href="/pharmacy/inventory" class="nav-link"><i class="fas fa-pills"></i> Inventory</a>
                <a href="/pharmacy/billing" class="nav-link"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link"><i class="fas fa-users-gear"></i> Staff Management</a>
                <a href="/pharmacy/leave" class="nav-link"><i class="fas fa-calendar-minus"></i> Leave Request</a>
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
                    <input type="text" placeholder="Search medicines, patients, or invoices...">
                </div>
                <div class="header-user">
                    <!-- Notifications -->
                    <div class="dropdown me-2">
                        <button class="btn btn-light position-relative p-0 rounded-circle d-flex align-items-center justify-content-center" type="button" data-bs-toggle="dropdown" style="width: 44px; height: 44px; background: white; border: 1px solid var(--border);">
                            <i class="fas fa-bell text-secondary" style="font-size: 18px;"></i>
                            <c:if test="${not empty notifications}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border-2 border-white" style="font-size: 10px; padding: 4px 6px;">
                                    ${notifications.size()}
                                </span>
                            </c:if>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end mt-3" style="width: 350px;">
                            <li class="px-3 py-2 border-bottom d-flex justify-content-between align-items-center">
                                <span class="fw-bold">Notifications</span>
                                <c:if test="${not empty notifications}">
                                    <form action="/pharmacy/notifications/read-all" method="post" class="m-0">
                                        <button type="submit" class="btn btn-link btn-sm p-0 text-decoration-none text-primary fw-bold" style="font-size: 12px;">Clear All</button>
                                    </form>
                                </c:if>
                            </li>
                            <div style="max-height: 400px; overflow-y: auto;">
                                <c:forEach var="n" items="${notifications}">
                                    <li class="px-3 py-3 border-bottom">
                                        <div class="d-flex gap-3">
                                            <div class="rounded-12 p-2 h-100 bg-${n.type == 'Urgent' ? 'danger' : 'primary'} bg-opacity-10">
                                                <i class="fas ${n.type == 'Urgent' ? 'fa-bolt text-danger' : 'fa-info text-primary'}" style="font-size: 12px;"></i>
                                            </div>
                                            <div>
                                                <div class="text-dark small lh-base mb-1">${n.message}</div>
                                                <div class="text-muted" style="font-size: 10px;"><i class="far fa-clock me-1"></i>${n.createdAt}</div>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty notifications}">
                                    <div class="empty-state py-4">
                                        <i class="fas fa-bell-slash" style="font-size: 32px;"></i>
                                        <p class="mb-0">All caught up!</p>
                                    </div>
                                </c:if>
                            </div>
                        </ul>
                    </div>

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
                <div class="alert alert-success border-0 shadow-sm d-flex align-items-center gap-3 mb-4" style="border-radius: 16px; background: #ecfdf5; color: #059669;">
                    <i class="fas fa-check-circle fs-5"></i>
                    <span class="fw-bold">${successMessage}</span>
                </div>
            </c:if>

            <!-- Dashboard Section -->
            <div id="section-dashboard" class="section active">
                <section class="dashboard-stats">
                    <div class="stat-card revenue">
                        <div class="stat-icon"><i class="fas fa-indian-rupee-sign"></i></div>
                        <div class="stat-data">
                            <h3>Total Sales Today</h3>
                            <div class="pharm-stat-value">₹${dailyRevenue}</div>
                        </div>
                    </div>
                    <div class="stat-card stock">
                        <div class="stat-icon"><i class="fas fa-layer-group"></i></div>
                        <div class="stat-data">
                            <h3>Low Stock Alerts</h3>
                            <div class="pharm-stat-value">${lowStockCount}</div>
                        </div>
                    </div>
                    <div class="stat-card expiry">
                        <div class="stat-icon"><i class="fas fa-clock-rotate-left"></i></div>
                        <div class="stat-data">
                            <h3>Expiring Soon</h3>
                            <div class="pharm-stat-value">${expiringSoonCount}</div>
                        </div>
                    </div>
                    <div class="stat-card payments">
                        <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
                        <div class="stat-data">
                            <h3>Pending Orders</h3>
                            <div class="pharm-stat-value">${pendingPaymentsCount}</div>
                        </div>
                    </div>
                </section>

                <div class="dashboard-grid">
                    <!-- Recent Invoices -->
                    <div class="grid-card">
                        <div class="card-header">
                            <h2><i class="fas fa-history text-primary"></i> Recent Transactions</h2>
                            <a href="/pharmacy/sales" class="view-all">View History</a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="mb-0">
                                    <thead>
                                        <tr>
                                            <th>Invoice #</th>
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
                                                    <td><span class="fw-bold text-dark">#${inv.invoiceNumber}</span></td>
                                                    <td>${inv.patient.name}</td>
                                                    <td><span class="fw-bold text-primary">₹${inv.totalAmount}</span></td>
                                                    <td><span class="badge-pill badge-success">Success</span></td>
                                                    <td class="text-end">
                                                        <a href="/pharmacy/invoice/download?id=${inv.id}" class="btn btn-light btn-sm rounded-8 border p-2" style="width: 32px; height: 32px;">
                                                            <i class="fas fa-download text-secondary" style="font-size: 12px;"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${empty recentInvoices}">
                                            <tr>
                                                <td colspan="5">
                                                    <div class="empty-state">
                                                        <i class="fas fa-folder-open"></i>
                                                        <p>No transactions recorded today</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Prescription Queue -->
                    <div class="grid-card">
                        <div class="card-header">
                            <h2><i class="fas fa-clipboard-list text-primary"></i> Prescription Queue</h2>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="mb-0">
                                    <thead>
                                        <tr>
                                            <th>Patient</th>
                                            <th>Progress</th>
                                            <th class="text-end">Handle</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="rx" items="${prescriptions}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${rx.patient.name}</div>
                                                    <div class="text-muted" style="font-size: 11px;">ID: ${rx.prescriptionId}</div>
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
                                                        <button class="btn btn-action-main btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                            Process
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0">
                                                            <li>
                                                                <form action="/pharmacy/update-prescription-status" method="post">
                                                                    <input type="hidden" name="id" value="${rx.id}">
                                                                    <input type="hidden" name="status" value="Preparing">
                                                                    <button type="submit" class="dropdown-item py-2">
                                                                        <i class="fas fa-mortar-pestle text-primary me-2"></i> Start Preparing
                                                                    </button>
                                                                </form>
                                                            </li>
                                                            <li>
                                                                <form action="/pharmacy/update-prescription-status" method="post">
                                                                    <input type="hidden" name="id" value="${rx.id}">
                                                                    <input type="hidden" name="status" value="Ready">
                                                                    <button type="submit" class="dropdown-item py-2">
                                                                        <i class="fas fa-box-open text-success me-2"></i> Ready for Pickup
                                                                    </button>
                                                                </form>
                                                            </li>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li class="px-3 pt-2 pb-1">
                                                                <form action="/pharmacy/dispense" method="post">
                                                                    <input type="hidden" name="prescriptionId" value="${rx.id}">
                                                                    <label class="payment-label">Checkout Method</label>
                                                                    <select name="paymentMethod" class="form-select form-select-sm mb-3 rounded-8" onchange="togglePaymentDetails(this, '${rx.id}')" required>
                                                                        <option value="Cash">Cash Payment</option>
                                                                        <option value="UPI">Digital (UPI)</option>
                                                                        <option value="Card">Card Swipe</option>
                                                                    </select>
                                                                    
                                                                    <div id="upi-details-${rx.id}" class="payment-details-group mb-3" style="display:none;">
                                                                        <div class="payment-card-ui">
                                                                            <div class="payment-qr">
                                                                                <i class="fas fa-qrcode"></i>
                                                                                <span>Scan for Digital Receipt</span>
                                                                            </div>
                                                                            <input type="text" name="transactionId" class="form-control form-control-sm rounded-8" placeholder="Transaction Ref #">
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <div id="card-details-${rx.id}" class="payment-details-group mb-3" style="display:none;">
                                                                        <div class="payment-card-ui">
                                                                            <label class="payment-label">Card Verification</label>
                                                                            <input type="text" name="cardNumber" class="form-control form-control-sm mb-2 rounded-8" placeholder="XXXX XXXX XXXX 1234">
                                                                            <div class="payment-row">
                                                                                <div style="flex:1">
                                                                                    <input type="text" name="expiry" class="form-control form-control-sm rounded-8" placeholder="MM/YY">
                                                                                </div>
                                                                                <div style="flex:1">
                                                                                    <input type="password" name="pin" class="form-control form-control-sm rounded-8" placeholder="PIN">
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <button type="submit" class="btn btn-primary w-100 rounded-12 py-2 fw-bold" style="font-size: 13px;">Complete & Generate Bill</button>
                                                                </form>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty prescriptions}">
                                            <tr>
                                                <td colspan="3">
                                                    <div class="empty-state py-5">
                                                        <i class="fas fa-check-double text-success opacity-25"></i>
                                                        <p>Queue is currently empty</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="grid-card mt-4">
                    <div class="card-header">
                        <h2><i class="fas fa-wave-square text-primary"></i> Inventory Intelligence</h2>
                    </div>
                    <div class="card-body">
                        <div class="quick-status-grid">
                            <!-- Low Stock Side -->
                            <div class="status-list">
                                <h6 class="fw-bold mb-3 d-flex align-items-center gap-2" style="font-size: 13px; color: var(--secondary);">
                                    <i class="fas fa-circle text-warning" style="font-size: 8px;"></i> STOCK ALERTS
                                </h6>
                                <c:forEach var="med" items="${lowStockMedicines}" end="2">
                                    <div class="status-item">
                                        <div class="status-icon" style="background: var(--warning-light); color: var(--warning);"><i class="fas fa-arrow-trend-down"></i></div>
                                        <div class="status-info">
                                            <span class="status-tag" style="color: var(--warning);">CRITICAL STOCK</span>
                                            <span class="status-name">${med.name}</span>
                                            <span class="status-desc">${med.stockLevel} left in batch</span>
                                        </div>
                                        <a href="/pharmacy/inventory" class="btn-mini-action btn-mini-low">Procure</a>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty lowStockMedicines}">
                                    <div class="text-center py-5 border border-dashed rounded-4 bg-light opacity-75">
                                        <i class="fas fa-check-circle text-success mb-2 fs-3"></i>
                                        <p class="small text-muted mb-0">All items optimally stocked</p>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Expiry Side -->
                            <div class="status-list">
                                <h6 class="fw-bold mb-3 d-flex align-items-center gap-2" style="font-size: 13px; color: var(--secondary);">
                                    <i class="fas fa-circle text-danger" style="font-size: 8px;"></i> EXPIRY TRACKER
                                </h6>
                                <c:forEach var="med" items="${expiringMedicines}" end="2">
                                    <div class="status-item">
                                        <div class="status-icon" style="background: var(--danger-light); color: var(--danger);"><i class="fas fa-hourglass-end"></i></div>
                                        <div class="status-info">
                                            <span class="status-tag" style="color: var(--danger);">NEAR EXPIRY</span>
                                            <span class="status-name">${med.name}</span>
                                            <span class="status-desc">Expires: ${med.expiryDate}</span>
                                        </div>
                                        <a href="/pharmacy/inventory" class="btn-mini-action btn-mini-expiry">Action</a>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty expiringMedicines}">
                                    <div class="text-center py-5 border border-dashed rounded-4 bg-light opacity-75">
                                        <i class="fas fa-calendar-check text-success mb-2 fs-3"></i>
                                        <p class="small text-muted mb-0">No upcoming expirations</p>
                                    </div>
                                </c:if>
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
        function togglePaymentDetails(select, rxId) {
            const upiDetails = document.getElementById('upi-details-' + rxId);
            const cardDetails = document.getElementById('card-details-' + rxId);
            
            upiDetails.style.display = 'none';
            cardDetails.style.display = 'none';
            
            if (select.value === 'UPI') {
                upiDetails.style.display = 'block';
            } else if (select.value === 'Card') {
                cardDetails.style.display = 'block';
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            // Auto-refresh notifications every 30 seconds
            function checkNewPrescriptions() {
                // In a real app, this would be an AJAX call
                console.log('Checking for new orders...');
            }
            setInterval(checkNewPrescriptions, 30000);
        });
    </script>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
<script>
    function toggleSidebar() {
        const sb = document.querySelector('.sidebar');
        if(sb) sb.classList.toggle('active');
        const overlay = document.getElementById('sidebarOverlay');
        if(overlay) overlay.classList.toggle('active');
    }

    document.addEventListener("DOMContentLoaded", function() {
        const header = document.querySelector('.main-header');
        if(header && !document.getElementById('sidebarToggleBtn')) {
            const toggleBtn = document.createElement('button');
            toggleBtn.id = 'sidebarToggleBtn';
            toggleBtn.className = 'sidebar-toggle-btn';
            toggleBtn.innerHTML = '<i class="fas fa-bars" style="font-size: 24px;"></i>';
            toggleBtn.onclick = toggleSidebar;
            header.insertBefore(toggleBtn, header.firstChild);
        }

        document.querySelectorAll('.sidebar-nav .nav-link').forEach(link => {
            link.addEventListener('click', () => {
                if(window.innerWidth <= 768) {
                    toggleSidebar();
                }
            });
        });
        
        const overlay = document.getElementById('sidebarOverlay');
        if(overlay) {
            overlay.onclick = toggleSidebar;
        }
    });
</script>
</body>
</html>
