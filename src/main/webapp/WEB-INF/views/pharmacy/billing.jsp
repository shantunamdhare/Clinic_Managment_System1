<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medicine Issue | MediCare+ Pharmacy</title>
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
                <a href="/pharmacy/billing" class="nav-link active"><i class="fas fa-file-invoice-dollar"></i> Medicine Issue</a>
                <a href="/pharmacy/sales" class="nav-link"><i class="fas fa-chart-line"></i> Sales Summary</a>
                <a href="/pharmacy/staff" class="nav-link"><i class="fas fa-users"></i> Staff & Shifts</a>
            </nav>
            <div class="sidebar-footer"><a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></div>
        </aside>
        <main class="main-content">
            <header class="main-header">
                <div class="header-search"><i class="fas fa-search"></i><input type="text" placeholder="Search..."></div>
                <div class="header-user">
                    <div class="user-profile">
                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=4f46e5&color=fff" alt="User">
                        <div class="user-info"><span class="name">${user.fullName}</span><span class="role">Pharmacist</span></div>
                    </div>
                </div>
            </header>
            <div class="grid-card" style="max-width: 700px; margin: 0 auto;">
                <div class="card-header"><h2><i class="fas fa-receipt"></i> Generate New Invoice / Medicine Issue</h2></div>
                <div class="card-body">
                    <form action="/generate-invoice" method="POST" style="display: flex; flex-direction: column; gap: 20px;">
                        <div>
                            <label style="display: block; margin-bottom: 8px; font-weight: 600;">Select Patient</label>
                            <select name="patientId" required style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
                                <option value="">-- Choose Patient --</option>
                                <c:forEach var="p" items="${patients}"><option value="${p.id}">${p.name} (${p.patientId})</option></c:forEach>
                            </select>
                        </div>
                        <div>
                            <label style="display: block; margin-bottom: 8px; font-weight: 600;">Select Medicine</label>
                            <select name="medicineId" required style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
                                <option value="">-- Choose Medicine --</option>
                                <c:forEach var="m" items="${medicines}"><option value="${m.id}">${m.name} - ₹${m.price} (Stock: ${m.stockLevel})</option></c:forEach>
                            </select>
                        </div>
                        <div>
                            <label style="display: block; margin-bottom: 8px; font-weight: 600;">Quantity</label>
                            <input type="number" name="quantity" min="1" required placeholder="Enter quantity" style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
                        </div>
                        <div>
                            <label style="display: block; margin-bottom: 8px; font-weight: 600;">Payment Method</label>
                            <select id="paymentMethod" name="paymentMethod" required style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
                                <option value="Cash">Cash</option>
                                <option value="Card">Credit/Debit Card</option>
                                <option value="UPI">UPI / QR Scan</option>
                            </select>
                        </div>

                        <!-- Dynamic Payment Simulation Sections -->
                        <div id="card-section" style="display: none; padding: 15px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;">
                            <label style="display: block; margin-bottom: 8px; font-size: 13px; font-weight: 600;">Card Number</label>
                            <input type="text" placeholder="XXXX XXXX XXXX 1234" style="width: 100%; padding: 10px; margin-bottom: 10px; border-radius: 5px; border: 1px solid #cbd5e1;">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                                <div>
                                    <label style="display: block; margin-bottom: 5px; font-size: 12px;">Expiry</label>
                                    <input type="text" placeholder="MM/YY" style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #cbd5e1;">
                                </div>
                                <div>
                                    <label style="display: block; margin-bottom: 5px; font-size: 12px;">Enter PIN</label>
                                    <input type="password" placeholder="****" maxlength="4" style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #cbd5e1;">
                                </div>
                            </div>
                        </div>

                        <div id="upi-section" style="display: none; padding: 15px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; text-align: center;">
                            <div style="margin-bottom: 10px;"><i class="fas fa-qrcode" style="font-size: 60px; color: #475569;"></i></div>
                            <p style="font-size: 13px; color: #64748b; margin-bottom: 10px;">Scan QR to Pay via UPI</p>
                            <input type="text" placeholder="Enter UPI Transaction ID" style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #cbd5e1;">
                        </div>
                        <div id="total-amount-display" style="margin-top: 10px; padding: 15px; background: #f0f7ff; border-radius: 8px; border: 1px dashed #4f46e5; text-align: center;">
                            <span style="color: #64748b; font-size: 14px;">Total Payable Amount:</span>
                            <div style="font-size: 24px; font-weight: 800; color: #4f46e5;">₹<span id="calculated-total">0.00</span></div>
                        </div>
                        <button type="submit" style="padding: 15px; background: #4f46e5; color: white; border: none; border-radius: 8px; font-weight: 700; cursor: pointer; font-size: 16px;">
                            <i class="fas fa-check-circle"></i> Generate & Issue Medicine
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        const medicineSelect = document.querySelector('select[name="medicineId"]');
        const quantityInput = document.querySelector('input[name="quantity"]');
        const totalDisplay = document.getElementById('calculated-total');

        // Create a map of medicine prices from the options
        const medicinePrices = {};
        <c:forEach var="m" items="${medicines}">
            medicinePrices["${m.id}"] = ${m.price};
        </c:forEach>

        function calculateTotal() {
            const medId = medicineSelect.value;
            const qty = parseInt(quantityInput.value) || 0;
            const price = medicinePrices[medId] || 0;
            const subtotal = price * qty;
            const tax = subtotal * 0.05;
            const total = subtotal + tax;
            totalDisplay.innerText = total.toFixed(2) + " (Inc. 5% GST)";
        }

        const methodSelect = document.getElementById('paymentMethod');
        const cardSection = document.getElementById('card-section');
        const upiSection = document.getElementById('upi-section');

        function togglePaymentSections() {
            const method = methodSelect.value;
            cardSection.style.display = (method === 'Card') ? 'block' : 'none';
            upiSection.style.display = (method === 'UPI') ? 'block' : 'none';
        }

        methodSelect.addEventListener('change', togglePaymentSections);
        medicineSelect.addEventListener('change', calculateTotal);
        quantityInput.addEventListener('input', calculateTotal);
    </script>
</body>
</html>
