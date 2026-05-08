<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory | MediCare+ Pharmacy</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/pharmacy.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid #e2e8f0; color: #64748b; font-size: 13px; text-transform: uppercase; }
        td { padding: 14px 12px; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
        .badge-pill { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-success { background: #ecfdf5; color: #10b981; }
        .badge-warning { background: #fffbeb; color: #f59e0b; }
        .badge-danger { background: #fef2f2; color: #ef4444; }
        
        .btn-primary { background: #4f46e5; color: white; border: none; padding: 10px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-primary:hover { background: #4338ca; }
        .btn-outline { background: transparent; border: 1px solid #e2e8f0; color: #64748b; padding: 10px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; }
        .btn-outline:hover { background: #f8fafc; }
        
        .add-form-container { display: none; background: white; border-radius: 12px; border: 1px solid #e2e8f0; padding: 24px; margin-bottom: 24px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
        .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group label { font-size: 13px; font-weight: 600; color: #64748b; }
        .form-group input, .form-group select { padding: 10px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 14px; }
        .form-actions { margin-top: 24px; display: flex; gap: 12px; justify-content: flex-end; }
        
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; }
        .alert-success { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
        .alert-danger { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
    </style>
</head>
<body>
    <div class="pharmacy-container">
        <aside class="sidebar">
            <div class="sidebar-logo"><i class="fas fa-plus-square"></i> <span>MediCare+ <span>Pharmacy</span></span></div>
            <nav class="sidebar-nav">
                <a href="/pharmacy-dashboard" class="nav-link"><i class="fas fa-th-large"></i> Dashboard</a>
                <a href="/pharmacy/inventory" class="nav-link active"><i class="fas fa-pills"></i> Stock & Expiry</a>
                <a href="/pharmacy/billing" class="nav-link"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link"><i class="fas fa-users"></i> Staff & Shifts</a>
            </nav>
            <div class="sidebar-footer"><a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></div>
        </aside>
        <main class="main-content">
            <header class="main-header">
                <div class="header-search"><i class="fas fa-search"></i><input type="text" placeholder="Search medicines..."></div>
                <div class="header-user">
                    <div class="user-profile">
                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff" alt="User">
                        <div class="user-info"><span class="name">${user.fullName}</span><span class="role">Pharmacist</span></div>
                    </div>
                </div>
            </header>
            <div class="grid-card">
                <div class="card-header">
                    <h2><i class="fas fa-pills"></i> Inventory & Stock Tracking</h2>
                    <button class="btn-primary" onclick="toggleAddForm()">
                        <i class="fas fa-plus me-2"></i> Add New Medicine
                    </button>
                </div>
                <div class="card-body">
                    <!-- Flash Messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i> ${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i> ${errorMessage}</div>
                    </c:if>

                    <!-- Add Medicine Form -->
                    <div id="addMedicineForm" class="add-form-container">
                        <h3 style="margin-bottom: 20px; font-size: 18px; color: #1e293b;">Register New Medicine Stock</h3>
                        <form action="/pharmacy/inventory/add" method="POST">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Medicine Name</label>
                                    <input type="text" name="name" placeholder="e.g. Paracetamol" required>
                                </div>
                                <div class="form-group">
                                    <label>Category</label>
                                    <select name="category" required>
                                        <option value="Tablet">Tablet</option>
                                        <option value="Syrup">Syrup</option>
                                        <option value="Capsule">Capsule</option>
                                        <option value="Injection">Injection</option>
                                        <option value="Ointment">Ointment</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Manufacturer</label>
                                    <input type="text" name="manufacturer" placeholder="e.g. GSK" required>
                                </div>
                                <div class="form-group">
                                    <label>Stock Quantity</label>
                                    <input type="number" name="stockLevel" min="0" placeholder="0" required>
                                </div>
                                <div class="form-group">
                                    <label>Unit Price (₹)</label>
                                    <input type="number" name="price" step="0.01" min="0" placeholder="0.00" required>
                                </div>
                                <div class="form-group">
                                    <label>Expiry Date</label>
                                    <input type="date" name="expiryDate" required>
                                </div>
                                <div class="form-group">
                                    <label>Batch Number</label>
                                    <input type="text" name="batchNumber" placeholder="e.g. BT-999" required>
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="button" class="btn-outline" onclick="toggleAddForm()">Cancel</button>
                                <button type="submit" class="btn-primary">Save Medicine</button>
                            </div>
                        </form>
                    </div>
                    <table>
                        <thead><tr><th>Medicine Name</th><th>Batch #</th><th>Stock</th><th>Price</th><th>Expiry Date</th><th>Status</th></tr></thead>
                        <tbody>
                            <c:forEach var="med" items="${medicines}">
                                <tr>
                                    <td><strong>${med.name}</strong></td>
                                    <td>${med.batchNumber}</td>
                                    <td>${med.stockLevel} units</td>
                                    <td>₹${med.price}</td>
                                    <td>${med.expiryDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${med.stockLevel <= 10}"><span class="badge-pill badge-danger">Low Stock</span></c:when>
                                            <c:otherwise><span class="badge-pill badge-success">Available</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
                form.scrollIntoView({ behavior: 'smooth' });
            }
        }
    </script>
</body>
</html>
