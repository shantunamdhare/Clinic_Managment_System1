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
                                            <span class="small ${med.expiryDate.isBefore(java.time.LocalDate.now().plusMonths(3)) ? 'text-danger fw-bold' : ''}">
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
    </script>
</body>
</html>
