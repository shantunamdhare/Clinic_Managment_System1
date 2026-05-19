<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Prescription Print - ${visit.patient.name}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #fff; color: #1e293b; padding: 32px; }
        .header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 3px solid #2563eb; padding-bottom: 16px; margin-bottom: 24px; }
        .clinic-name { font-size: 1.6rem; font-weight: 800; color: #2563eb; }
        .clinic-sub { color: #64748b; font-size: 0.85rem; margin-top: 4px; }
        .doctor-info { text-align: right; }
        .doctor-info .name { font-size: 1rem; font-weight: 700; }
        .doctor-info .sub { color: #64748b; font-size: 0.8rem; }
        .patient-section { display: flex; gap: 40px; background: #f8fafc; padding: 14px 18px; border-radius: 10px; margin-bottom: 24px; }
        .patient-section .label { font-size: 0.72rem; color: #94a3b8; text-transform: uppercase; font-weight: 600; }
        .patient-section .value { font-size: 0.95rem; font-weight: 600; color: #1e293b; margin-top: 2px; }
        .rx-symbol { font-size: 2rem; font-weight: 800; color: #2563eb; margin-bottom: 12px; }
        table { width: 100%; border-collapse: collapse; margin-top: 8px; }
        th { background: #2563eb; color: #fff; padding: 10px 14px; font-size: 0.8rem; text-align: left; }
        td { padding: 10px 14px; border-bottom: 1px solid #e2e8f0; font-size: 0.875rem; }
        tr:last-child td { border-bottom: none; }
        .footer { margin-top: 40px; display: flex; justify-content: space-between; align-items: flex-end; }
        .sign-box { border-top: 2px solid #1e293b; width: 200px; text-align: center; padding-top: 8px; font-size: 0.8rem; color: #64748b; }
        .no-print { margin-bottom: 24px; }
        @media print {
            .no-print { display: none; }
            body { padding: 16px; }
        }
    </style>
</head>
<body>
    <div class="no-print">
        <button onclick="window.print()" style="background:#2563eb;color:#fff;border:none;padding:10px 24px;border-radius:8px;font-size:0.9rem;cursor:pointer;font-weight:600">
            <i class="fas fa-print"></i> Print Prescription
        </button>
        <a href="/doctor/prescriptions?visitId=${visit.id}" style="margin-left:12px;color:#64748b;text-decoration:none;font-size:0.875rem"> Back</a>
    </div>

    <div class="header">
        <div>
            <div class="clinic-name"> ClinicMS</div>
            <div class="clinic-sub">Clinic Management System | Medical Prescription</div>
        </div>
        <div class="doctor-info">
            <div class="name">Dr. ${doctor.fullName}</div>
            <div class="sub">MBBS, General Practitioner</div>
            <div class="sub">Reg. No: CMS-DOC-${doctor.id}</div>
        </div>
    </div>

    <div class="patient-section">
        <div>
            <div class="label">Patient Name</div>
            <div class="value">${visit.patient.name}</div>
        </div>
        <div>
            <div class="label">Age / Gender</div>
            <div class="value">${visit.patient.age} yrs / ${visit.patient.gender}</div>
        </div>
        <div>
            <div class="label">Contact</div>
            <div class="value">${visit.patient.contact}</div>
        </div>
        <div>
            <div class="label">Date</div>
            <div class="value">${visit.visitDate}</div>
        </div>
    </div>

    <div style="margin-bottom:12px">
        <div style="font-size:0.8rem;color:#64748b;margin-bottom:4px">Diagnosis</div>
        <div style="font-weight:600;color:#1e293b">${visit.diagnosis}</div>
    </div>

    <div class="rx-symbol"></div>

    <table>
        <thead>
            <tr><th>#</th><th>Medicine</th><th>Dosage</th><th>Duration</th><th>Instructions</th></tr>
        </thead>
        <tbody>
            <c:forEach items="${prescriptions}" var="rx" varStatus="loop">
                <tr>
                    <td>${loop.count}</td>
                    <td style="font-weight:600">${rx.medicine}</td>
                    <td>${rx.dosage}</td>
                    <td>${rx.duration}</td>
                    <td style="color:#64748b">${rx.instructions}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <c:if test="${not empty visit.notes}">
        <div style="margin-top:20px;padding:14px;background:#fef9c3;border-radius:8px;border-left:4px solid #f59e0b">
            <div style="font-size:0.75rem;font-weight:600;color:#92400e;text-transform:uppercase;margin-bottom:4px">Clinical Notes</div>
            <div style="font-size:0.875rem;color:#78350f">${visit.notes}</div>
        </div>
    </c:if>

    <div class="footer">
        <div style="font-size:0.8rem;color:#94a3b8">
            This prescription is valid for 30 days from the date of issue.
        </div>
        <div class="sign-box">
            Dr. ${doctor.fullName}<br>Doctor's Signature
        </div>
    </div>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<div class="sidebar-overlay" id="sidebarOverlay"></div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const topbar = document.querySelector('.topbar');
        if(topbar && !document.getElementById('sidebarToggleBtn')) {
            const h5 = topbar.querySelector('h5');
            if (h5) {
                const wrapper = document.createElement('div');
                wrapper.className = 'd-flex align-items-center gap-2';
                const toggleBtn = document.createElement('button');
                toggleBtn.id = 'sidebarToggleBtn';
                toggleBtn.className = 'btn btn-light d-md-none';
                toggleBtn.style.padding = '4px 8px';
                toggleBtn.innerHTML = '<i class="fas fa-bars"></i>';
                toggleBtn.onclick = function() {
                    document.querySelector('.sidebar').classList.toggle('active');
                    document.getElementById('sidebarOverlay').classList.toggle('active');
                };
                wrapper.appendChild(toggleBtn);
                h5.parentNode.insertBefore(wrapper, h5);
                wrapper.appendChild(h5);
                h5.style.margin = '0';
            }
        }
        const overlay = document.getElementById('sidebarOverlay');
        if(overlay) {
            overlay.onclick = function() {
                document.querySelector('.sidebar').classList.remove('active');
                overlay.classList.remove('active');
            };
        }
    });
</script>
</body>
</html>
