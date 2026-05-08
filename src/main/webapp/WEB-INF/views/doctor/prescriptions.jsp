<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prescriptions - Clinic Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/doctor.css">
    <style>
        .medicine-row { border-bottom: 1px solid #f1f5f9; padding: 15px 0; position: relative; }
        .medicine-row:last-child { border-bottom: none; }
        .remove-row { color: #ef4444; cursor: pointer; position: absolute; right: 0; top: 15px; }
        .status-badge { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; padding: 4px 10px; border-radius: 12px; }
        .status-pending { background: #fef3c7; color: #d97706; }
        .status-preparing { background: #dbeafe; color: #2563eb; }
        .status-ready { background: #dcfce7; color: #16a34a; }
        .status-dispensed { background: #f1f5f9; color: #64748b; }
        .search-results { position: absolute; background: white; border: 1px solid #e2e8f0; width: 100%; z-index: 1000; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); display: none; max-height: 200px; overflow-y: auto; }
        .search-item { padding: 8px 12px; cursor: pointer; }
        .search-item:hover { background: #f8fafc; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-brand">
        <h4><i class="fas fa-hospital-alt me-2" style="color:#3b82f6"></i> ClinicMS</h4>
        <small>Doctor Portal</small>
    </div>
    <a href="/doctor/profile" style="text-decoration: none;">
        <div class="sidebar-doctor">
            <div class="avatar">${doctor.fullName.substring(0,1)}</div>
            <div>
                <div class="name">Dr. ${doctor.fullName}</div>
                <div class="role">${doctor.specialization != null ? doctor.specialization : 'General Practitioner'}</div>
            </div>
        </div>
    </a>
    <nav>
        <div class="nav-label">Main</div>
        <a href="/doctor/dashboard" class="nav-link-item"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="/doctor/appointments" class="nav-link-item"><i class="fas fa-calendar-check"></i> Appointments</a>
        <div class="nav-label">Clinical</div>
        <a href="/doctor/patients" class="nav-link-item"><i class="fas fa-user-injured"></i> Patients</a>
        <a href="/doctor/emr" class="nav-link-item"><i class="fas fa-file-medical-alt"></i> EMR</a>
        <a href="/doctor/prescriptions" class="nav-link-item active"><i class="fas fa-prescription-bottle-alt"></i> Prescriptions</a>
        <div class="nav-label">Lab</div>
        <a href="/doctor/lab-requests" class="nav-link-item"><i class="fas fa-flask"></i> Lab Tests</a>
        <a href="/doctor/lab-reports" class="nav-link-item"><i class="fas fa-file-alt"></i> Lab Reports</a>
        <div class="nav-label">Schedule</div>
        <a href="/doctor/availability" class="nav-link-item"><i class="fas fa-clock"></i> Availability</a>
    </nav>
    <div class="sidebar-footer"><a href="/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a></div>
</div>

<div class="main-content">
    <div class="topbar">
        <h5><i class="fas fa-prescription-bottle-alt me-2" style="color:#2563eb"></i> Pharmacy Integration</h5>
        <div class="d-flex align-items-center gap-3">
            <div class="dropdown">
                <a href="#" class="position-relative text-dark me-3" id="notifDropdown" data-bs-toggle="dropdown">
                    <i class="fas fa-bell fa-lg"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="notif-count" style="display:none">0</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0" id="notif-list" style="width: 300px; max-height: 400px; overflow-y: auto;">
                    <li><h6 class="dropdown-header">Notifications</h6></li>
                    <li><hr class="dropdown-divider"></li>
                    <li class="text-center py-3 text-muted"><small>No new notifications</small></li>
                </ul>
            </div>
        </div>
    </div>

    <div class="content-area">
        <c:if test="${not empty success}"><div class="alert-custom alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
        <c:if test="${not empty error}"><div class="alert-custom alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

        <div class="row g-4">
            <!-- New Prescription Form -->
            <div class="col-lg-12">
                <div class="panel">
                    <div class="panel-title d-flex justify-content-between">
                        <span><i class="fas fa-plus-circle"></i> Create New Prescription</span>
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#patientModal">
                                <i class="fas fa-user-plus me-1"></i> Select Patient
                            </button>
                        </div>
                    </div>

                    <form action="/doctor/prescriptions/save-full" method="post" id="complexRxForm">
                        <input type="hidden" name="patientId" id="selectedPatientId" value="${selectedPatient != null ? selectedPatient.id : ''}" required>
                        
                        <div id="patientInfoSection" class="mb-4 p-3 rounded" style="background: #f8fafc; border: 1px solid #e2e8f0; ${selectedPatient == null ? 'display: none;' : ''}">
                            <div class="row">
                                <div class="col-md-3"><strong>Patient:</strong> <span id="displayPatientName">${selectedPatient != null ? selectedPatient.name : ''}</span></div>
                                <div class="col-md-2"><strong>ID:</strong> <span id="displayPatientId">${selectedPatient != null ? selectedPatient.patientId : ''}</span></div>
                                <div class="col-md-2"><strong>Age/Sex:</strong> <span id="displayPatientAgeSex">${selectedPatient != null ? selectedPatient.age : ''}y / ${selectedPatient != null ? selectedPatient.gender : ''}</span></div>
                                <div class="col-md-5"><strong>Allergies:</strong> <span class="text-danger">None Reported</span></div>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-borderless align-middle" id="medicineTable">
                                <thead class="text-muted" style="font-size: 0.75rem; text-transform: uppercase;">
                                    <tr>
                                        <th style="width: 25%">Medicine Name</th>
                                        <th style="width: 15%">Dosage</th>
                                        <th style="width: 15%">Frequency</th>
                                        <th style="width: 15%">Duration</th>
                                        <th style="width: 10%">Qty</th>
                                        <th style="width: 15%">Food</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="medicineBody">
                                    <tr class="medicine-row">
                                        <td>
                                            <div class="position-relative">
                                                <input type="text" name="medName[]" class="form-control-custom med-search" placeholder="Search medicine..." required autocomplete="off">
                                                <div class="search-results"></div>
                                            </div>
                                        </td>
                                        <td><input type="text" name="dosage[]" class="form-control-custom" placeholder="500mg" required></td>
                                        <td><input type="text" name="frequency[]" class="form-control-custom" placeholder="1-0-1" required></td>
                                        <td><input type="text" name="duration[]" class="form-control-custom" placeholder="5 days" required></td>
                                        <td><input type="number" name="quantity[]" class="form-control-custom" placeholder="10" required></td>
                                        <td>
                                            <select name="food[]" class="form-control-custom">
                                                <option>After Food</option>
                                                <option>Before Food</option>
                                                <option>With Food</option>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <button type="button" class="btn btn-sm btn-outline-secondary mb-3" id="addRowBtn">
                            <i class="fas fa-plus me-1"></i> Add Another Medicine
                        </button>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group mb-4">
                                    <label class="form-label-custom"><i class="fas fa-hand-holding-usd text-success me-1"></i> Consultation Fee (₹)</label>
                                    <input type="number" name="consultationFee" class="form-control-custom" placeholder="e.g. 500" min="0" step="10" value="500">
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="form-group mb-4">
                                    <label class="form-label-custom">Special Notes for Pharmacist</label>
                                    <textarea name="notes" class="form-control-custom" rows="1" placeholder="Any specific instructions..."></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" name="status" value="Pending" class="btn-primary-custom" style="background: #2563eb;">
                                <i class="fas fa-paper-plane me-2"></i> Send to Pharmacy
                            </button>
                            <button type="submit" name="status" value="Draft" class="btn-primary-custom" style="background: #64748b;">
                                <i class="fas fa-save me-2"></i> Save Draft
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Prescription Queue & Updates -->
            <div class="col-lg-12">
                <div class="panel">
                    <div class="panel-title"><i class="fas fa-clock"></i> Sent Prescriptions & Status</div>
                    <div class="table-responsive">
                        <table class="custom-table" id="statusTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient</th>
                                    <th>Date</th>
                                    <th>Medicines</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="statusBody">
                                <!-- Populated by AJAX -->
                                <tr id="statusPlaceholder"><td colspan="6" class="text-center py-4">Loading updates...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Patient Selection Modal -->
<div class="modal fade" id="patientModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Select Patient</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="text" id="patientSearch" class="form-control-custom mb-3" placeholder="Search by name or ID...">
                <div id="patientList" style="max-height: 300px; overflow-y: auto;">
                    <c:forEach items="${patients}" var="p">
                        <div class="search-item patient-item border-bottom" 
                             data-id="${p.id}" 
                             data-name="${p.name}" 
                             data-pid="${p.patientId}" 
                             data-age="${p.age}" 
                             data-gender="${p.gender}">
                            <strong>${p.name}</strong> <small class="text-muted">(${p.patientId})</small>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script>
$(document).ready(function() {
    // Row Addition
    $('#addRowBtn').click(function() {
        const row = $('.medicine-row').first().clone();
        row.find('input').val('');
        row.append('<i class="fas fa-times remove-row"></i>');
        $('#medicineBody').append(row);
    });

    $(document).on('click', '.remove-row', function() {
        $(this).closest('tr').remove();
    });

    // Patient Selection
    $('.patient-item').click(function() {
        const id = $(this).data('id');
        const name = $(this).data('name');
        const pid = $(this).data('pid');
        const age = $(this).data('age');
        const gender = $(this).data('gender');

        $('#selectedPatientId').val(id);
        $('#displayPatientName').text(name);
        $('#displayPatientId').text(pid);
        $('#displayPatientAgeSex').text(age + 'y / ' + gender);
        $('#patientInfoSection').fadeIn();
        $('#patientModal').modal('hide');
    });

    // Form Validation
    $('#complexRxForm').submit(function(e) {
        if (!$('#selectedPatientId').val()) {
            e.preventDefault();
            alert('Please select a patient before saving the prescription.');
            $('#patientModal').modal('show');
            return false;
        }
        return true;
    });

    // Medicine Search (AJAX)
    $(document).on('keyup', '.med-search', function() {
        const input = $(this);
        const results = input.siblings('.search-results');
        const query = input.val();

        if (query.length < 2) { results.hide(); return; }

        $.get('/doctor/prescriptions/api/search-medicines', { query: query }, function(data) {
            results.empty();
            if (data.length > 0) {
                data.forEach(med => {
                    results.append('<div class="search-item med-item" data-name="' + med.name + '">' + med.name + ' <small class="text-muted">(Stock: ' + med.stockLevel + ')</small></div>');
                });
                results.show();
            } else {
                results.hide();
            }
        });
    });

    $(document).on('click', '.med-item', function() {
        const name = $(this).data('name');
        $(this).closest('.position-relative').find('.med-search').val(name);
        $('.search-results').hide();
    });

    // Status Updates (AJAX Polling)
    function fetchStatusUpdates() {
        $.get('/doctor/prescriptions/status-updates', function(data) {
            if (data.length === 0) {
                $('#statusBody').html('<tr><td colspan="6" class="text-center">No prescriptions found.</td></tr>');
                return;
            }
            let html = '';
            data.forEach(rx => {
                let statusClass = 'status-' + rx.status.toLowerCase();
                let meds = rx.items.map(i => i.medicine.name).join(', ');
                if (meds.length > 30) meds = meds.substring(0, 27) + '...';

                html += '<tr>' +
                    '<td><span class="text-primary fw-bold">' + rx.prescriptionId + '</span></td>' +
                    '<td>' + rx.patient.name + '</td>' +
                    '<td>' + new Date(rx.createdAt).toLocaleDateString() + '</td>' +
                    '<td>' + meds + '</td>' +
                    '<td><span class="status-badge ' + statusClass + '">' + rx.status + '</span></td>' +
                    '<td>' +
                        '<button class="btn btn-sm btn-outline-info me-1"><i class="fas fa-eye"></i></button>' +
                        '<a href="/doctor/prescriptions/download/' + rx.id + '" class="btn btn-sm btn-outline-dark"><i class="fas fa-download"></i></a>' +
                    '</td>' +
                '</tr>';
            });
            $('#statusBody').html(html);
        });
    }

    // Notifications Polling
    function fetchNotifications() {
        $.get('/doctor/notifications/latest', function(data) {
            if (data.length > 0) {
                $('#notif-count').text(data.length).show();
                let html = '<li><h6 class="dropdown-header">New Notifications</h6></li>';
                data.forEach(n => {
                    html += '<li><a class="dropdown-item py-2" href="#">' +
                        '<div class="d-flex align-items-center">' +
                        '<div class="flex-shrink-0"><i class="fas fa-info-circle text-primary"></i></div>' +
                        '<div class="ms-3"><div>' + n.message + '</div><small class="text-muted">Just now</small></div>' +
                        '</div></a></li>';
                });
                html += '<li><hr class="dropdown-divider"></li><li><a class="dropdown-item text-center small text-primary" href="#" id="markAllRead">Mark all as read</a></li>';
                $('#notif-list').html(html);
            }
        });
    }

    $(document).on('click', '#markAllRead', function() {
        $.post('/doctor/notifications/mark-read', function() {
            $('#notif-count').hide();
            $('#notif-list').html('<li><h6 class="dropdown-header">Notifications</h6></li><li><hr class="dropdown-divider"></li><li class="text-center py-3 text-muted"><small>No new notifications</small></li>');
        });
    });

    setInterval(fetchStatusUpdates, 5000);
    setInterval(fetchNotifications, 10000);
    fetchStatusUpdates();
    fetchNotifications();

    // Close search results on click outside
    $(document).click(function(e) {
        if (!$(e.target).closest('.position-relative').length) {
            $('.search-results').hide();
        }
    });
});
</script>
</body>
</html>

