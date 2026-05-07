<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | MediCare+</title>
    <link rel="stylesheet" href="/css/style.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#f8fafc; color:#1e293b; min-height:100vh; }

        .dashboard-layout { display:flex; min-height:100vh; }

        /* Sidebar */
        .sidebar {
            width:280px; background:#ffffff; padding:24px 0; display:flex; 
            flex-direction:column; position:fixed; top:0; left:0; height:100vh; 
            z-index:100; border-right:1px solid #e2e8f0;
        }
        .sidebar-brand { padding:0 24px 28px; border-bottom:1px solid #f1f5f9; }
        .sidebar-brand h2 { font-size:22px; font-weight:800; color:#4f46e5; }
        .sidebar-brand span { font-size:11px; color:#64748b; text-transform:uppercase; letter-spacing:1px; }
        
        .sidebar-nav { flex:1; padding:20px 12px; display:flex; flex-direction:column; gap:4px; }
        .nav-item {
            display:flex; align-items:center; gap:12px; padding:12px 16px; border-radius:12px;
            color:#64748b; font-size:14px; font-weight:600; cursor:pointer; transition:all .2s;
            text-decoration:none;
        }
        .nav-item:hover, .nav-item.active { background:#f1f5f9; color:#4f46e5; }
        .nav-item.active { background:#eff6ff; color:#2563eb; }
        .nav-icon { font-size:18px; width:24px; text-align:center; }

        .sidebar-footer { padding:16px 24px; border-top:1px solid #f1f5f9; }
        .sidebar-footer a {
            display:flex; align-items:center; gap:10px; color:#ef4444; font-size:14px;
            font-weight:700; text-decoration:none; padding:12px 16px; border-radius:12px; transition:all .2s;
        }
        .sidebar-footer a:hover { background:#fef2f2; }

        /* Main Content */
        .main-content { flex:1; margin-left:280px; padding:32px 40px; background:#f8fafc; }

        .top-bar {
            display:flex; justify-content:space-between; align-items:center;
            margin-bottom:32px;
        }
        .user-profile-summary { display:flex; align-items:center; gap:12px; }
        .user-avatar {
            width:48px; height:48px; border-radius:14px; background:#4f46e5;
            display:flex; align-items:center; justify-content:center; color:#fff;
            font-weight:700; font-size:20px;
        }
        .user-info h1 { font-size:22px; font-weight:800; color:#1e293b; }
        .user-info p { font-size:13px; color:#64748b; }

        /* Sections */
        .content-section { display:none; animation: fadeIn 0.4s ease; }
        .content-section.active { display:block; }
        @keyframes fadeIn { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }

        /* Cards */
        .card { background:#fff; border:1px solid #e2e8f0; border-radius:20px; padding:24px; box-shadow:0 1px 3px rgba(0,0,0,0.02); margin-bottom:24px; }
        .card-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
        .card-header h3 { font-size:17px; font-weight:700; color:#1e293b; display:flex; align-items:center; gap:10px; }

        /* Stats Row */
        .stats-row { display:grid; grid-template-columns:repeat(3, 1fr); gap:20px; margin-bottom:24px; }
        .stat-card { background:#fff; border:1px solid #e2e8f0; border-radius:20px; padding:20px; display:flex; align-items:center; gap:16px; }
        .stat-icon { width:48px; height:48px; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:20px; }
        .stat-data h4 { font-size:20px; font-weight:800; color:#1e293b; }
        .stat-data p { font-size:12px; color:#64748b; font-weight:600; }

        /* Table */
        .data-table { width:100%; border-collapse:collapse; }
        .data-table th { text-align:left; padding:12px 16px; font-size:12px; font-weight:700; color:#64748b; text-transform:uppercase; border-bottom:1px solid #f1f5f9; }
        .data-table td { padding:16px; font-size:14px; color:#334155; border-bottom:1px solid #f8fafc; }
        .data-table tr:last-child td { border-bottom:none; }
        
        /* Badges */
        .badge { padding:4px 12px; border-radius:20px; font-size:11px; font-weight:700; text-transform:uppercase; }
        .badge-success { background:#ecfdf5; color:#10b981; }
        .badge-warning { background:#fffbeb; color:#f59e0b; }
        .badge-info { background:#eff6ff; color:#3b82f6; }

        /* Timeline */
        .timeline { position:relative; padding-left:30px; }
        .timeline::before { content:''; position:absolute; left:0; top:0; width:2px; height:100%; background:#e2e8f0; }
        .timeline-item { position:relative; margin-bottom:24px; }
        .timeline-item::before { content:''; position:absolute; left:-34px; top:4px; width:10px; height:100%; background:#fff; z-index:1; }
        .timeline-dot { position:absolute; left:-35px; top:4px; width:12px; height:12px; border-radius:50%; background:#4f46e5; border:3px solid #fff; z-index:2; box-shadow:0 0 0 3px rgba(79,70,229,0.1); }
        .timeline-date { font-size:12px; font-weight:700; color:#64748b; margin-bottom:4px; }
        .timeline-content { background:#f8fafc; padding:12px 16px; border-radius:12px; }
        .timeline-content h4 { font-size:14px; font-weight:700; color:#1e293b; }
        .timeline-content p { font-size:12px; color:#64748b; }

        /* Forms */
        .btn-primary { background:#4f46e5; color:#fff; border:none; padding:12px 24px; border-radius:12px; font-weight:700; cursor:pointer; transition:all .2s; }
        .btn-primary:hover { background:#4338ca; transform:translateY(-1px); box-shadow:0 4px 12px rgba(79,70,229,0.2); }

        /* Modals */
        .modal {
            display:none; position:fixed; top:0; left:0; width:100%; height:100%;
            background:rgba(15,23,42,0.6); backdrop-filter:blur(4px); z-index:1000;
            align-items:center; justify-content:center;
        }
        .modal-content {
            background:#fff; border-radius:24px; padding:32px; width:100%; max-width:450px;
            animation: modalSlide 0.3s ease;
        }
        @keyframes modalSlide { from { transform:translateY(20px); opacity:0; } to { transform:translateY(0); opacity:1; } }
        .modal-header { margin-bottom:24px; }
        .modal-header h3 { font-size:20px; font-weight:800; color:#1e293b; }
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:13px; font-weight:700; color:#64748b; margin-bottom:8px; }

        @media (max-width: 1024px) {
            .sidebar { width:80px; }
            .sidebar-brand span, .nav-item span { display:none; }
            .main-content { margin-left:80px; }
            .stats-row { grid-template-columns:1fr; }
        }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-brand">
                <h2>&#x2695; MediCare+</h2>
                <span>Patient Portal</span>
            </div>
            <nav class="sidebar-nav">
                <a class="nav-item active" href="javascript:void(0)" onclick="showSection('overview', this)">
                    <span class="nav-icon">&#x1F4CA;</span> <span>Overview</span>
                </a>
                <a class="nav-item" href="javascript:void(0)" onclick="showSection('medical-records', this)">
                    <span class="nav-icon">&#x1F4CB;</span> <span>Medical Records</span>
                </a>
                <a class="nav-item" href="javascript:void(0)" onclick="showSection('prescriptions', this)">
                    <span class="nav-icon">&#x1F48A;</span> <span>Prescriptions</span>
                </a>
                <a class="nav-item" href="javascript:void(0)" onclick="showSection('lab-reports', this)">
                    <span class="nav-icon">&#x1F9EA;</span> <span>Lab Reports</span>
                </a>
                <a class="nav-item" href="javascript:void(0)" onclick="showSection('appointments', this)">
                    <span class="nav-icon">&#x1F4C5;</span> <span>Appointments</span>
                </a>
                <a class="nav-item" href="javascript:void(0)" onclick="showSection('billing', this)">
                    <span class="nav-icon">&#x1F4B3;</span> <span>Billing & Payments</span>
                </a>
            </nav>
            <div class="sidebar-footer">
                <a href="/logout"><span class="nav-icon">&#x1F6AA;</span> <span>Logout</span></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <c:if test="${not empty successMessage}">
                <div style="background:#f0fdf4; color:#166534; padding:16px; border-radius:12px; margin-bottom:20px; border:1px solid #bbf7d0; font-size:14px; font-weight:600;">
                    &#x2705; ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div style="background:#fef2f2; color:#991b1b; padding:16px; border-radius:12px; margin-bottom:20px; border:1px solid #fecaca; font-size:14px; font-weight:600;">
                    &#x26A0; ${errorMessage}
                </div>
            </c:if>

            <header class="top-bar">
                <div class="user-profile-summary">
                    <div class="user-avatar">${user.fullName.substring(0,1)}</div>
                    <div class="user-info">
                        <h1>Hello, ${user.fullName}</h1>
                        <p>ID: PAT-2024-${user.id} &bull; Blood Group: O+</p>
                    </div>
                </div>
                <div class="top-actions">
                    <button class="btn-primary" onclick="showSection('appointments', document.querySelectorAll('.nav-item')[4])">&#x1F4C5; Book Appointment</button>
                </div>
            </header>

            <!-- Overview Section -->
            <section id="overview" class="content-section active">
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#eff6ff; color:#2563eb;">&#x1F4C5;</div>
                        <div class="stat-data">
                            <p>Upcoming Appointment</p>
                            <h4>May 10, 10:30 AM</h4>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#f0fdf4; color:#10b981;">&#x1F48A;</div>
                        <div class="stat-data">
                            <p>Active Prescriptions</p>
                            <h4>2 Medicines</h4>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background:#fffbeb; color:#f59e0b;">&#x1F4B3;</div>
                        <div class="stat-data">
                            <p>Pending Bills</p>
                            <h4>$0.00</h4>
                        </div>
                    </div>
                </div>

                <div style="display:grid; grid-template-columns: 2fr 1fr; gap:24px;">
                    <div class="card">
                        <div class="card-header">
                            <h3>&#x1F4CB; Patient Profile</h3>
                        </div>
                        <div style="padding:10px; display:grid; grid-template-columns:1fr 1fr; gap:20px;">
                            <div><p style="font-size:12px; color:#64748b; font-weight:700;">PATIENT ID</p><p style="font-weight:600;">${patientDetails.patientId}</p></div>
                            <div><p style="font-size:12px; color:#64748b; font-weight:700;">GENDER</p><p style="font-weight:600;">${patientDetails.gender}</p></div>
                            <div><p style="font-size:12px; color:#64748b; font-weight:700;">AGE</p><p style="font-weight:600;">${patientDetails.age} Years</p></div>
                            <div><p style="font-size:12px; color:#64748b; font-weight:700;">CONTACT</p><p style="font-weight:600;">${patientDetails.contactNumber}</p></div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header">
                            <h3>&#x1F5D3; Visit Timeline</h3>
                        </div>
                        <div class="timeline">
                            <c:forEach var="v" items="${visitTimeline}">
                                <div class="timeline-item" style="cursor:pointer;" onclick="viewVisitDetails('${v.id}', '${v.visitDate}', '${v.doctor.fullName}', '${v.symptoms}', '${v.diagnosis}', '${v.notes}')">
                                    <div class="timeline-dot"></div>
                                    <div class="timeline-date">${v.visitDate}</div>
                                    <div class="timeline-content">
                                        <h4>${v.diagnosis != null ? v.diagnosis : 'Consultation'}</h4>
                                        <p>Dr. ${v.doctor.fullName}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Medical Records Section -->
            <section id="medical-records" class="content-section">
                <div class="card">
                    <div class="card-header"><h3>&#x1F4CB; Recent Consultations</h3></div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Date</th><th>Diagnosis</th><th>Doctor</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="v" items="${visitTimeline}">
                                <tr>
                                    <td>${v.visitDate}</td>
                                    <td style="font-weight:600;">${v.diagnosis != null ? v.diagnosis : 'Consultation'}</td>
                                    <td>Dr. ${v.doctor.fullName}</td>
                                    <td><button class="btn-primary" style="padding:4px 12px; font-size:12px;" onclick="viewVisitDetails('${v.id}', '${v.visitDate}', '${v.doctor.fullName}', '${v.symptoms}', '${v.diagnosis}', '${v.notes}')">View</button></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- Prescriptions Section -->
            <section id="prescriptions" class="content-section">
                <div class="card">
                    <div class="card-header"><h3>&#x1F48A; Active Prescriptions</h3></div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Medication</th><th>Dosage</th><th>Duration</th><th>Prescribed By</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${prescriptions}">
                                <tr>
                                    <td style="font-weight:600; color:#4f46e5;">${p.medicine}</td>
                                    <td>${p.dosage}</td>
                                    <td>${p.duration}</td>
                                    <td>Dr. ${p.visit.doctor.fullName}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- Lab Reports Section -->
            <section id="lab-reports" class="content-section">
                <div class="card">
                    <div class="card-header"><h3>&#x1F9EA; Lab Results</h3></div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Test Name</th><th>Date</th><th>Result</th><th>Status</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${labReports}">
                                <tr>
                                    <td style="font-weight:600;">${r.request.test.name}</td>
                                    <td>${r.reportDate}</td>
                                    <td style="color:#2563eb; font-weight:700;">${r.result}</td>
                                    <td><span class="badge badge-success">Available</span></td>
                                    <td><button onclick="viewReportDetails('${r.id}', '${r.request.test.name}', '${r.reportDate}', '${r.result}', '${r.filePath}')" style="background:none; border:none; color:#4f46e5; cursor:pointer; font-weight:700;">View Report &#x2193;</button></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- Appointments Section -->
            <section id="appointments" class="content-section">
                <div class="card">
                    <div class="card-header"><h3>&#x1F4C5; Appointment History</h3></div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Doctor</th><th>Date</th><th>Time</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ah" items="${appointmentHistory}">
                                <tr>
                                    <td>Dr. ${ah.doctor.fullName}</td>
                                    <td>${ah.appointmentDate}</td>
                                    <td>${ah.appointmentTime}</td>
                                    <td><span class="badge ${ah.status == 'Scheduled' ? 'badge-success' : 'badge-info'}">${ah.status}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="card">
                    <div class="card-header"><h3>&#x1F4D6; Book New Appointment</h3></div>
                    <p style="color:#64748b; margin-bottom:20px;">Schedule your next consultation with our specialists.</p>
                    <button class="btn-primary" onclick="openModal('bookingModal')">Open Booking Form</button>
                </div>
            </section>

            <!-- Billing Section -->
            <section id="billing" class="content-section">
                <div class="card">
                    <div class="card-header"><h3>&#x1F4B3; Payment History</h3></div>
                    <table class="data-table">
                        <thead>
                            <tr><th>Invoice ID</th><th>Date</th><th>Amount</th><th>Status</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ph" items="${paymentHistory}">
                                <tr>
                                    <td>#${ph.invoiceNumber}</td>
                                    <td>${ph.invoiceDate}</td>
                                    <td style="font-weight:700;">$${ph.amount}</td>
                                    <td><span class="badge ${ph.status == 'Paid' ? 'badge-success' : 'badge-warning'}">${ph.status}</span></td>
                                    <td><button style="background:none; border:none; color:#4f46e5; cursor:pointer; font-weight:700;">View Invoice</button></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <!-- Booking Modal -->
    <div id="bookingModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h3>Book New Appointment</h3></div>
            <form action="/patient/book-appointment" method="POST">
                <div class="form-group">
                    <label>Select Doctor</label>
                    <select name="doctorId" class="form-select" required style="width:100%; padding:10px; border-radius:8px; border:1px solid #e2e8f0; appearance:auto;">
                        <option value="" disabled selected>Choose a Doctor</option>
                        <c:forEach var="doc" items="${doctors}">
                            <option value="${doc.id}">Dr. ${doc.fullName} (${doc.specialization})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-row" style="display:flex; gap:10px; margin-bottom:15px;">
                    <div style="flex:1;">
                        <label>Date</label>
                        <input type="date" name="date" class="form-input" required style="width:100%; padding:10px; border-radius:8px; border:1px solid #e2e8f0;">
                    </div>
                    <div style="flex:1;">
                        <label>Time</label>
                        <input type="time" name="time" class="form-input" required style="width:100%; padding:10px; border-radius:8px; border:1px solid #e2e8f0;">
                    </div>
                </div>
                <div class="form-group">
                    <label>Purpose of Visit</label>
                    <textarea name="purpose" placeholder="e.g. Regular checkup, headache, etc." style="width:100%; padding:10px; border-radius:8px; border:1px solid #e2e8f0; height:80px;"></textarea>
                </div>
                <button type="submit" class="btn-primary" style="width:100%; margin-top:10px;">Confirm Booking</button>
                <button type="button" onclick="closeModal('bookingModal')" style="background:transparent; color:#64748b; border:none; width:100%; margin-top:10px; cursor:pointer; font-weight:600;">Cancel</button>
            </form>
        </div>
    </div>

    <!-- Detail Modals -->
    <div id="detailModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h3 id="detailTitle">Details</h3></div>
            <div id="detailBody" style="font-size:14px; color:#475569; line-height:1.6;">
                <!-- Dynamic content -->
            </div>
            <button type="button" onclick="closeModal('detailModal')" class="btn-primary" style="width:100%; margin-top:20px;">Close</button>
        </div>
    </div>

    <script>
        function showSection(sectionId, element) {
            // Hide all sections
            const sections = document.querySelectorAll('.content-section');
            sections.forEach(s => s.classList.remove('active'));

            // Show target
            document.getElementById(sectionId).classList.add('active');

            // Update nav active state
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => item.classList.remove('active'));
            element.classList.add('active');

            // Scroll to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function openModal(id) {
            document.getElementById(id).style.display = 'flex';
        }

        function closeModal(id) {
            document.getElementById(id).style.display = 'none';
        }

        function viewVisitDetails(id, date, doctor, symptoms, diagnosis, notes) {
            document.getElementById('detailTitle').innerText = 'Visit Details - ' + date;
            document.getElementById('detailBody').innerHTML = `
                <p><strong>Doctor:</strong> Dr. ${doctor}</p>
                <p><strong>Symptoms:</strong> ${symptoms || 'None recorded'}</p>
                <p><strong>Diagnosis:</strong> ${diagnosis || 'N/A'}</p>
                <hr style="margin:15px 0; border:0; border-top:1px solid #e2e8f0;">
                <p><strong>Notes:</strong><br>${notes || 'No additional notes'}</p>
            `;
            openModal('detailModal');
        }

        function viewReportDetails(id, test, date, result, file) {
            document.getElementById('detailTitle').innerText = 'Lab Report - ' + test;
            document.getElementById('detailBody').innerHTML = `
                <p><strong>Test Date:</strong> ${date}</p>
                <p><strong>Result Summary:</strong> ${result || 'Pending'}</p>
                <div style="margin-top:20px; padding:15px; background:#f8fafc; border-radius:12px; text-align:center;">
                    <p style="margin-bottom:10px; font-weight:600;">Full Report File</p>
                    <a href="${file}" class="btn-primary" style="text-decoration:none; display:inline-block;" download>Download PDF</a>
                </div>
            `;
            openModal('detailModal');
        }

        // Close modal on click outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }
    </script>
</body>
</html>
