<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory | MediCare+ Pharmacy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <style>
        .form-control-premium {
            height: 50px;
            border-radius: 12px;
            border: 1.5px solid var(--border);
            padding: 0 20px;
            font-size: 14px;
            transition: all 0.2s;
        }
        .form-control-premium:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px var(--primary-light);
        }
        .add-inventory-card {
            display: none;
            background: white;
            border-radius: 24px;
            border: 1px solid var(--border);
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: var(--shadow-lg);
            animation: slideDown 0.4s ease-out;
        }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
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
                <a href="/pharmacy/inventory" class="nav-link active"><i class="fas fa-pills"></i> Inventory</a>
                <a href="/pharmacy/billing" class="nav-link"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link"><i class="fas fa-users-gear"></i> Staff Management</a>
                <a href="/pharmacy/leave" class="nav-link"><i class="fas fa-calendar-minus"></i> Leave Request</a>
            </nav>
            <div class="sidebar-footer">
                <a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <header class="main-header">
                <div class="header-search">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Search medicines by name, batch, or manufacturer...">
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
                    <i class="fas fa-check-circle fs-5"></i>
                    <span class="fw-bold">${successMessage}</span>
                </div>
            </c:if>

            <!-- Active Alerts (Stock & Expiry) -->
            <c:if test="${not empty lowStockMedicines || not empty expiringSoonMedicines}">
                <div id="inventoryAlertSection" class="grid-card mb-4 border-warning border-opacity-25" style="transition: all 0.5s ease;">
                    <div class="card-header bg-warning bg-opacity-10">
                        <h2 class="text-warning"><i class="fas fa-triangle-exclamation"></i> Inventory Intelligence & Alerts</h2>
                        <div class="d-flex align-items-center gap-3">
                            <span class="badge bg-warning text-dark rounded-pill px-3">${lowStockMedicines.size() + expiringSoonMedicines.size()} Alerts Active</span>
                            <button class="btn btn-sm btn-link text-warning p-0" onclick="document.getElementById('inventoryAlertSection').style.display='none'"><i class="fas fa-times"></i></button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="quick-status-grid">
                            <!-- Low Stock Side -->
                            <div class="status-list">
                                <h6 class="fw-bold mb-3 d-flex align-items-center gap-2" style="font-size: 12px; color: var(--secondary);">
                                    <i class="fas fa-circle text-warning" style="font-size: 8px;"></i> STOCK ALERTS
                                </h6>
                                <c:forEach var="med" items="${lowStockMedicines}" end="2">
                                    <div class="status-item border-warning border-opacity-10">
                                        <div class="status-icon" style="background: var(--warning-light); color: var(--warning);"><i class="fas fa-arrow-trend-down"></i></div>
                                        <div class="status-info">
                                            <span class="status-tag" style="color: var(--warning);">CRITICAL STOCK</span>
                                            <span class="status-name">${med.name}</span>
                                            <span class="status-desc">${med.stockLevel} units remaining (Batch: ${med.batchNumber})</span>
                                        </div>
                                        <button class="btn-mini-action btn-mini-low" onclick="toggleAddForm()">Restock</button>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty lowStockMedicines}">
                                    <div class="text-center py-4 bg-light rounded-4 opacity-50">
                                        <p class="small text-muted mb-0">No low stock alerts</p>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Expiry Side -->
                            <div class="status-list">
                                <h6 class="fw-bold mb-3 d-flex align-items-center gap-2" style="font-size: 12px; color: var(--secondary);">
                                    <i class="fas fa-circle text-danger" style="font-size: 8px;"></i> EXPIRY TRACKER
                                </h6>
                                <c:forEach var="med" items="${expiringSoonMedicines}" end="5">
                                    <div class="status-item border-danger border-opacity-10">
                                        <div class="status-icon" style="background: var(--danger-light); color: var(--danger);"><i class="fas fa-hourglass-half"></i></div>
                                        <div class="status-info">
                                            <span class="status-tag" style="color: var(--danger);">NEAR EXPIRY</span>
                                            <span class="status-name">${med.name}</span>
                                            <span class="status-desc">Expires on: <strong>${med.expiryDate}</strong></span>
                                        </div>
                                        <button class="btn-mini-action btn-mini-expiry" onclick="alert('Action taken: Logged for disposal/return')">Action</button>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty expiringSoonMedicines}">
                                    <div class="text-center py-4 bg-light rounded-4 opacity-50">
                                        <p class="small text-muted mb-0">No upcoming expirations</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Add Inventory Form -->
            <div id="addMedicineForm" class="add-inventory-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold m-0" style="font-size: 20px; color: var(--text-main);">Register New Stock</h3>
                    <button class="btn btn-light rounded-circle" onclick="toggleAddForm()"><i class="fas fa-times"></i></button>
                </div>
                <form action="/pharmacy/inventory/add" method="POST">
                    <div class="row g-4">
                        <div class="col-md-4">
                            <label class="payment-label">Medicine Name</label>
                            <input type="text" name="name" class="form-control form-control-premium" placeholder="e.g. Paracetamol" required>
                        </div>
                        <div class="col-md-4">
                            <label class="payment-label">Category</label>
                            <select name="category" class="form-select form-control-premium" required>
                                <option value="Tablet">Tablet</option>
                                <option value="Syrup">Syrup</option>
                                <option value="Capsule">Capsule</option>
                                <option value="Injection">Injection</option>
                                <option value="Ointment">Ointment</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="payment-label">Manufacturer</label>
                            <input type="text" name="manufacturer" class="form-control form-control-premium" placeholder="e.g. GSK Pharma" required>
                        </div>
                        <div class="col-md-3">
                            <label class="payment-label">Stock Quantity</label>
                            <input type="number" name="stockLevel" min="0" class="form-control form-control-premium" placeholder="0" required>
                        </div>
                        <div class="col-md-3">
                            <label class="payment-label">Unit Price (₹)</label>
                            <input type="number" name="price" step="0.01" min="0" class="form-control form-control-premium" placeholder="0.00" required>
                        </div>
                        <div class="col-md-3">
                            <label class="payment-label">Expiry Date</label>
                            <input type="date" name="expiryDate" class="form-control form-control-premium" required>
                        </div>
                        <div class="col-md-3">
                            <label class="payment-label">Batch Number</label>
                            <input type="text" name="batchNumber" class="form-control form-control-premium" placeholder="e.g. BT-2024" required>
                        </div>
                    </div>
                    <div class="mt-4 d-flex gap-3">
                        <button type="submit" class="btn btn-primary px-5 py-3 rounded-12 fw-bold shadow-sm">
                            <i class="fas fa-plus me-2"></i> Save to Inventory
                        </button>
                    </div>
                </form>
            </div>

            <div class="grid-card">
                <div class="card-header">
                    <h2><i class="fas fa-warehouse text-primary"></i> Current Stock Status</h2>
                    <button class="btn-action-main" onclick="toggleAddForm()">
                        <i class="fas fa-plus me-2"></i> Add New Medicine
                    </button>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="mb-0">
                            <thead>
                                <tr>
                                    <th>Medicine Name</th>
                                    <th>Manufacturer</th>
                                    <th>Batch #</th>
                                    <th>Stock Level</th>
                                    <th>Unit Price</th>
                                    <th>Expiry</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="med" items="${medicines}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-dark">${med.name}</div>
                                            <div class="text-muted" style="font-size: 11px;">${med.category}</div>
                                        </td>
                                        <td>${med.manufacturer}</td>
                                        <td><span class="badge bg-light text-secondary border px-2 py-1">${med.batchNumber}</span></td>
                                        <td><span class="fw-bold">${med.stockLevel}</span> units</td>
                                        <td>₹${med.price}</td>
                                        <td>
                                            <span class="small fw-bold ${expiringIds.contains(med.id) ? 'text-danger' : 'text-muted'}">
                                                ${med.expiryDate}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${med.stockLevel <= 10}"><span class="badge-pill badge-danger">Low Stock</span></c:when>
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
        </main>
    </div>

    <script>
        function toggleAddForm() {
            const form = document.getElementById('addMedicineForm');
            if (form.style.display === 'block') {
                form.style.display = 'none';
            } else {
                form.style.display = 'block';
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        }

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alertSection = document.getElementById('inventoryAlertSection');
            if (alertSection) {
                setTimeout(() => {
                    alertSection.style.opacity = '0';
                    alertSection.style.transform = 'translateY(-20px)';
                    setTimeout(() => {
                        alertSection.style.display = 'none';
                    }, 500); // Wait for transition
                }, 5000);
            }
        });
    </script>
</body>
</html>
