<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lab Report - ${report.request.patient.name}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <style>
        body { background: #f8fafc; font-family: 'Inter', sans-serif; }
        .report-paper {
            background: white;
            max-width: 800px;
            margin: 40px auto;
            padding: 60px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            border-radius: 8px;
            position: relative;
        }
        .report-header {
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 30px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .clinic-logo { color: #2563eb; font-weight: 800; font-size: 24px; }
        .report-title { text-transform: uppercase; letter-spacing: 2px; font-weight: 700; color: #64748b; font-size: 14px; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 40px; }
        .info-item { margin-bottom: 10px; }
        .info-label { color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase; }
        .info-value { font-weight: 600; color: #1e293b; }
        .results-section { background: #f1f5f9; padding: 30px; border-radius: 12px; margin-bottom: 40px; min-height: 200px; }
        .results-title { font-weight: 700; color: #334155; margin-bottom: 20px; border-bottom: 1px solid #cbd5e1; padding-bottom: 10px; }
        .footer-note { font-size: 12px; color: #94a3b8; border-top: 1px solid #e2e8f0; padding-top: 20px; text-align: center; }
        
        @media print {
            body { background: white; }
            .report-paper { box-shadow: none; margin: 0; padding: 20px; width: 100%; max-width: 100%; }
            .no-print { display: none; }
        }
    </style>
</head>
<body>
    <div class="container no-print mt-4 text-end" style="max-width: 800px;">
        <button onclick="window.print()" class="btn btn-primary btn-sm">
            <i class="fas fa-print"></i> Print as PDF
        </button>
        <button onclick="window.close()" class="btn btn-outline-secondary btn-sm ms-2">Close Window</button>
    </div>

    <div class="report-paper">
        <div class="report-header">
            <div class="clinic-logo">MediCare+ <span style="font-weight: 400; color: #64748b;">Laboratory</span></div>
            <div class="text-end">
                <div class="report-title">Laboratory Test Report</div>
                <div style="font-size: 13px; color: #64748b;">Report ID: #RPT-${report.id}</div>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <div class="info-item">
                    <div class="info-label">Patient Name</div>
                    <div class="info-value">${report.request.patient.name}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Patient ID</div>
                    <div class="info-value">${report.request.patient.patientId}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Gender / Age</div>
                    <div class="info-value">${report.request.patient.gender} / ${not empty report.request.patient.age ? report.request.patient.age : 'N/A'}</div>
                </div>
            </div>
            <div class="info-card">
                <div class="info-item">
                    <div class="info-label">Referring Doctor</div>
                    <div class="info-value">Dr. ${report.request.doctor.fullName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Test Category</div>
                    <div class="info-value">${report.request.test.name}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Collection Date</div>
                    <div class="info-value">${report.reportDate}</div>
                </div>
            </div>
        </div>

        <div class="results-section">
            <div class="results-title">Clinical Findings & Observations</div>
            <div style="line-height: 1.6; white-space: pre-wrap;">${report.result}</div>
        </div>

        <div class="row mt-5 mb-5">
            <div class="col-6">
                <div style="margin-top: 50px; border-top: 1px solid #1e293b; width: 200px; padding-top: 5px; font-size: 13px; font-weight: 700;">
                    Technician Signature
                </div>
            </div>
            <div class="col-6 text-end">
                <div style="margin-top: 50px; border-top: 1px solid #1e293b; width: 200px; margin-left: auto; padding-top: 5px; font-size: 13px; font-weight: 700;">
                    Pathologist Signature
                </div>
            </div>
        </div>

        <div class="footer-note">
            This is a computer-generated report and does not require a physical signature. <br>
            Please correlate clinically with patient's history and other investigations.
        </div>
    </div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>
