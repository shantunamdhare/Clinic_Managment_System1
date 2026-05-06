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
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="badge">${lowStockCount + expiringSoonCount}</span>
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
                        <div class="stat-data"><h3>Daily Revenue</h3><p class="value">₹${dailyRevenue}</p></div>
                    </div>
                    <div class="stat-card stock">
                        <div class="stat-icon"><i class="fas fa-box"></i></div>
                        <div class="stat-data"><h3>Low Stock</h3><p class="value">${lowStockCount}</p></div>
                    </div>
                    <div class="stat-card expiry">
                        <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
                        <div class="stat-data"><h3>Expiry Alerts</h3><p class="value">${expiringSoonCount}</p></div>
                    </div>
                    <div class="stat-card payments">
                        <div class="stat-icon"><i class="fas fa-wallet"></i></div>
                        <div class="stat-data"><h3>Pending</h3><p class="value">${pendingPaymentsCount}</p></div>
                    </div>
                </section>

                <div class="dashboard-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 24px;">
                    <div class="grid-card">
                        <div class="card-header"><h2><i class="fas fa-history"></i> Recent Invoices</h2></div>
                        <div class="card-body">
                            <table>
                                <thead><tr><th>Invoice #</th><th>Patient</th><th>Amount</th></tr></thead>
                                <tbody>
                                    <c:forEach var="invoice" items="${recentInvoices}" end="4">
                                        <tr><td>#${invoice.invoiceNumber}</td><td>${invoice.patient.name}</td><td>₹${invoice.totalAmount}</td></tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="grid-card">
                        <div class="card-header"><h2><i class="fas fa-exclamation-circle"></i> Quick Stock Status</h2></div>
                        <div class="card-body">
                            <c:forEach var="med" items="${lowStockMedicines}" end="4">
                                <div style="padding: 10px; background: #fffbeb; border-radius: 8px; margin-bottom: 8px; border-left: 4px solid #f59e0b;">
                                    <strong>${med.name}</strong>: ${med.stockLevel} left
                                </div>
                            </c:forEach>
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

    <script>
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
    </script>
</body>
</html>
