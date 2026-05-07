<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="MediCare+ Clinic Management System - Manage appointments, patients, labs, pharmacy, billing, staff and more from a single platform.">
    <title>MediCare+ | Clinic Management System</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <!-- Hidden toggle for Login Card -->
    <input type="checkbox" id="login-toggle" class="login-toggle-input" style="display:none">

    <!-- ==================== HEADER ==================== -->
    <header class="header" id="header">
        <div class="header-logo">
            <div class="logo-icon">M+</div>
            <div class="logo-text">
                <h1>MediCare+</h1>
                <span>Clinic Management System</span>
            </div>
        </div>
        <nav>
            <ul class="header-nav">
                <li><a href="#hero" class="active">Home</a></li>
                <li><a href="#features">Features</a></li>
                <li><a href="#modules">Modules</a></li>
                <li><a href="#how-it-works">How It Works</a></li>
                <li><a href="#about">About Us</a></li>
                <li><a href="#contact">Contact</a></li>
            </ul>
        </nav>
        <div class="header-actions">
            <label for="login-toggle" class="btn-get-started">Get Started</label>
        </div>
    </header>

    <!-- ==================== HERO SECTION ==================== -->
    <section class="hero" id="hero">
        <div class="hero-container">

            <!-- Left Side -->
            <div class="hero-left">
                <h2>
                    Smarter <span class="highlight-blue">Clinic.</span><br>
                    Better <span class="highlight-purple">Care.</span><br>
                    All in One Place.
                </h2>
                <p>Manage appointments, patients, labs, pharmacy, billing, staff and more &mdash; from a single, secure and intelligent platform.</p>

                <div class="hero-features">
                    <div class="hero-feature-card">
                        <div class="feature-icon secure">&#x1F6E1;</div>
                        <span>Secure &amp; Reliable</span>
                    </div>
                    <div class="hero-feature-card">
                        <div class="feature-icon cloud">&#x2601;</div>
                        <span>Cloud Based</span>
                    </div>
                    <div class="hero-feature-card">
                        <div class="feature-icon analytics">&#x1F4CA;</div>
                        <span>Real-time Analytics</span>
                    </div>
                    <div class="hero-feature-card">
                        <div class="feature-icon mobile">&#x1F4F1;</div>
                        <span>Mobile Friendly</span>
                    </div>
                </div>
            </div>

            <!-- Right Side - Login/Register Modal -->
            <div class="hero-right" id="login-section">
                <div class="login-card">
                    <label for="login-toggle" class="modal-close">&times;</label>
                    
                    <!-- Tab System -->
                    <div class="modal-tabs">
                        <input type="radio" name="modal-tab" id="tab-login" checked style="display:none">
                        <input type="radio" name="modal-tab" id="tab-register" style="display:none">
                        
                        <div class="tab-header">
                            <label for="tab-login" class="tab-btn login-tab-btn">Login</label>
                            <label for="tab-register" class="tab-btn register-tab-btn">Register</label>
                        </div>


                        <!-- Login Form Content -->
                        <div class="tab-content login-content">
                            <h3>Welcome Back!</h3>
                            <p class="subtitle">Login to access your dashboard</p>

                            <form action="/login" method="post">
                                <div class="form-group">
                                    <span class="input-icon">&#x2709;</span>
                                    <input type="email" name="email" class="form-input" placeholder="Enter your email" required>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x1F512;</span>
                                    <input type="password" name="password" class="form-input" placeholder="Enter your password" required>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x1F464;</span>
                                    <select name="role" class="form-select" required>
                                        <option value="" disabled selected>Select Your Role</option>
                                        <option value="Admin">Admin</option>
                                        <option value="Doctor">Doctor</option>
                                        <option value="Receptionist">Receptionist</option>
                                        <option value="Patient">Patient</option>
                                        <option value="Lab">Lab</option>
                                        <option value="Pharmacy">Pharmacy</option>
                                        <option value="Staff">Staff</option>
                                        <option value="Delivery">Delivery Boy</option>
                                    </select>
                                </div>
                                <div class="form-row">
                                    <label><input type="checkbox" name="remember"> Remember Me</label>
                                    <a href="#">Forgot Password?</a>
                                </div>
                                <button type="submit" class="btn-login">Login &#x27A1;</button>
                            </form>
                        </div>

                        <!-- Register Form Content -->
                        <div class="tab-content register-content">
                            <h3>Create Account</h3>
                            <p class="subtitle">Join our medical community</p>

                            <form action="/register" method="post" onsubmit="this.querySelector('.btn-register').classList.add('loading')">
                                <div class="form-group">
                                    <span class="input-icon">&#x1F464;</span>
                                    <input type="text" name="fullName" class="form-input" placeholder="Full Name" required>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x2709;</span>
                                    <input type="email" name="email" id="regEmail" class="form-input" placeholder="Email Address" required>
                                </div>
                                <div class="form-group" id="regPhoneGroup">
                                    <span class="input-icon">&#x1F4DE;</span>
                                    <input type="tel" name="phone" id="regPhone" class="form-input" placeholder="Phone Number">
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x1F512;</span>
                                    <input type="password" name="password" id="regPassword" class="form-input" placeholder="Create Password" required>
                                    <span class="password-toggle" onclick="togglePassword('regPassword')">&#x1F441;</span>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x1F512;</span>
                                    <input type="password" name="confirmPassword" id="regConfirmPassword" class="form-input" placeholder="Confirm Password" required>
                                    <span class="password-toggle" onclick="togglePassword('regConfirmPassword')">&#x1F441;</span>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x1F464;</span>
                                    <select name="role" id="registerRoleSelect" class="form-select" required onchange="toggleRoleFields()">
                                        <option value="Admin" selected>Admin</option>
                                        <option value="Doctor">Doctor</option>
                                        <option value="Receptionist">Receptionist</option>
                                        <option value="Patient">Patient</option>
                                        <option value="Lab">Lab</option>
                                        <option value="Pharmacy">Pharmacy</option>
                                        <option value="Staff">Staff</option>
                                        <option value="Delivery">Delivery Boy</option>
                                    </select>
                                </div>
                                
                                <!-- Admin specific fields -->
                                <div id="adminFields" style="display:none; background: rgba(108,99,255,0.03); padding: 15px; border-radius: 12px; margin-bottom: 15px; border: 1px dashed rgba(108,99,255,0.3);">
                                    <p style="font-size: 0.8rem; color: #6C63FF; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Admin Professional Details</p>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x1F1EE;&#x1F1E9;</span>
                                        <input type="text" name="adminId" id="adminId" class="form-input" placeholder="Admin ID (e.g. ADM-101)">
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <span class="input-icon">&#x1F3E5;</span>
                                        <input type="text" name="clinicName" id="clinicName" class="form-input" placeholder="Clinic/Hospital Name">
                                    </div>
                                </div>

                                <!-- Patient specific fields -->
                                <div id="patientFields" style="display:none; background: rgba(124,77,255,0.03); padding: 15px; border-radius: 12px; margin-bottom: 15px; border: 1px dashed rgba(124,77,255,0.3); backdrop-filter: blur(5px);">
                                    <p style="font-size: 0.8rem; color: #7c4dff; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Patient Medical Details</p>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x1F382;</span>
                                        <input type="number" name="age" id="patientAge" class="form-input" placeholder="Age">
                                    </div>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x26A7;</span>
                                        <select name="gender" id="patientGender" class="form-select">
                                            <option value="" disabled selected>Select Gender</option>
                                            <option value="Male">Male</option>
                                            <option value="Female">Female</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <span class="input-icon">&#x1F4CD;</span>
                                        <input type="text" name="address" id="patientAddress" class="form-input" placeholder="Full Home Address">
                                    </div>
                                </div>
                                
                                <!-- Doctor specific fields (hidden by default) -->
                                <div id="doctorFields" style="display: none; background: rgba(37,99,235,0.03); padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px dashed rgba(37,99,235,0.3);">
                                    <p style="font-size: 0.8rem; color: #2563eb; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Doctor Details</p>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x260E;</span>
                                        <input type="text" name="phone" id="doctorPhone" class="form-input" placeholder="Phone Number">
                                    </div>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x1F3E5;</span>
                                        <input type="text" name="specialization" id="doctorSpecialization" class="form-input" placeholder="Specialization (e.g. Cardiologist)">
                                    </div>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x23F1;</span>
                                        <input type="number" name="experience" id="doctorExperience" class="form-input" placeholder="Years of Experience">
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <span class="input-icon">&#x1FAAA;</span>
                                        <input type="text" name="licenseId" id="doctorLicenseId" class="form-input" placeholder="Medical License ID">
                                    </div>
                                </div>

                                <!-- LAB SPECIFIC FIELDS -->
                                <div id="labFields" style="display: none; background: rgba(37,99,235,0.03); padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px dashed rgba(37,99,235,0.3);">
                                    <p style="font-size: 0.8rem; color: #2563eb; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Lab Details</p>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x1F3EC;</span>
                                        <select name="labType" id="labType" class="form-select">
                                            <option value="In-House">In-House Lab</option>
                                            <option value="External">External Lab</option>
                                        </select>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x1F3E5;</span>
                                        <input type="text" name="labName" id="labName" class="form-input" placeholder="Laboratory Name">
                                    </div>
                                    <div class="form-group" style="margin-bottom: 10px;">
                                        <span class="input-icon">&#x1F4CD;</span>
                                        <input type="text" name="labAddress" id="labAddress" class="form-input" placeholder="Laboratory Address">
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <span class="input-icon">&#x1F3AB;</span>
                                        <input type="text" name="labId" id="labId" class="form-input" placeholder="Laboratory ID (e.g. LAB1001)">
                                    </div>
                                </div>
                                 <!-- RECEPTIONIST SPECIFIC FIELDS -->
                                 <div id="receptionistFields" style="display: none; background: rgba(37,99,235,0.03); padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px dashed rgba(37,99,235,0.3);">
                                     <p style="font-size: 0.8rem; color: #2563eb; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Receptionist Details</p>
                                     <div class="form-group" style="margin-bottom: 10px;">
                                         <span class="input-icon">&#x260E;</span>
                                         <input type="text" name="phone" id="receptionistPhone" class="form-input" placeholder="Phone Number">
                                     </div>
                                     <div class="form-group" style="margin-bottom: 10px;">
                                         <span class="input-icon">&#x1F194;</span>
                                         <input type="text" name="govIdNumber" id="receptionistGovId" class="form-input" placeholder="Government ID Number">
                                     </div>
                                     <div class="form-group" style="margin-bottom: 10px;">
                                         <span class="input-icon">&#x26A5;</span>
                                         <select name="gender" id="receptionistGender" class="form-select">
                                             <option value="" disabled selected>Select Gender</option>
                                             <option value="Male">Male</option>
                                             <option value="Female">Female</option>
                                             <option value="Other">Other</option>
                                         </select>
                                     </div>
                                     <div class="form-group" style="margin-bottom: 0;">
                                         <span class="input-icon">&#x1F4CD;</span>
                                         <input type="text" name="address" id="receptionistAddress" class="form-input" placeholder="Complete Address">
                                     </div>
                                 </div>

                                 <!-- Delivery specific fields -->
                                 <div id="deliveryFields" style="display: none; background: rgba(37,99,235,0.03); padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px dashed rgba(37,99,235,0.3);">
                                     <p style="font-size: 0.8rem; color: #2563eb; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Delivery Boy Details</p>
                                     <div class="form-group" style="margin-bottom: 10px;">
                                         <span class="input-icon">&#x260E;</span>
                                         <input type="text" name="deliveryPhone" id="deliveryPhone" class="form-input" placeholder="Contact Number (WhatsApp)">
                                     </div>
                                     <div class="form-group" style="margin-bottom: 0;">
                                         <span class="input-icon">&#x1F6B2;</span>
                                         <input type="text" name="vehicleType" id="vehicleType" class="form-input" placeholder="Vehicle Type (e.g. Bike, Van)">
                                     </div>
                                 </div>
                                 <!-- Pharmacy specific fields (hidden by default) -->
                                 <div id="pharmacyFields" style="display: none; background: rgba(37,99,235,0.03); padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px dashed rgba(37,99,235,0.3);">
                                     <p style="font-size: 0.8rem; color: #2563eb; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Pharmacy Details</p>
                                     <div class="form-group" style="margin-bottom: 10px;">
                                         <span class="input-icon">&#x1F3E5;</span>
                                         <input type="text" name="pharmacyName" class="form-input" placeholder="Pharmacy Name">
                                     </div>
                                     <div class="form-group" style="margin-bottom: 10px;">
                                         <span class="input-icon">&#x1F4CD;</span>
                                         <input type="text" name="pharmacyAddress" class="form-input" placeholder="Pharmacy Address">
                                     </div>
                                     <div class="form-group" style="margin-bottom: 0;">
                                         <span class="input-icon">&#x1F4DC;</span>
                                         <input type="text" name="pharmacyLicense" class="form-input" placeholder="Pharmacy License ID">
                                     </div>
                                 </div>

                                 <!-- Gender Selection -->
                                 <div class="form-group" style="margin-bottom: 15px;">
                                     <p style="font-size: 0.8rem; color: #64748b; margin-bottom: 8px; font-weight: 600;">Select Gender</p>
                                     <div style="display: flex; gap: 20px;">
                                         <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px; color: #475569;">
                                             <input type="radio" name="gender" value="Male" required style="accent-color: #4f46e5;"> Male
                                         </label>
                                         <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px; color: #475569;">
                                             <input type="radio" name="gender" value="Female" required style="accent-color: #4f46e5;"> Female
                                         </label>
                                     </div>
                                 </div>

                                 <!-- Staff specific fields -->
                                 <div id="staffFields" style="display: none; background: rgba(37,99,235,0.03); padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px dashed rgba(37,99,235,0.3);">
                                     <p style="font-size: 0.8rem; color: #2563eb; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Staff Details</p>
                                     <div class="form-group" style="margin-bottom: 10px;">
                                         <span class="input-icon">&#x260E;</span>
                                         <input type="text" name="staffPhone" id="staffPhone" class="form-input" placeholder="Contact Number">
                                     </div>
                                     <div class="form-group" style="margin-bottom: 10px;">
                                         <span class="input-icon">&#x1F3AB;</span>
                                         <input type="text" name="staffId" id="staffId" class="form-input" placeholder="Staff Employee ID">
                                     </div>
                                     <div class="form-group" style="margin-bottom: 0;">
                                         <span class="input-icon">&#x1F3E5;</span>
                                         <input type="text" name="hospitalName" id="hospitalName" class="form-input" placeholder="Hospital/Clinic Name">
                                     </div>
                                 </div>

                                 <div class="terms-row">
                                    <input type="checkbox" name="terms" required>
                                    <span>I agree to the <a href="#">Terms &amp; Conditions</a></span>
                                </div>
                                <button type="submit" class="btn-register">Register &#x27A1;</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- ==================== FEATURES SECTION ==================== -->
    <section id="features" class="features-section">
      <div class="features-container">
    
        <span class="section-line"></span>
        <h2>Features</h2>
        <p class="section-subtitle">
          Powerful features to manage your clinic efficiently
        </p>
    
        <div class="features-grid">
    
          <div class="feature-card">
            <img src="https://images.pexels.com/photos/7578808/pexels-photo-7578808.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Appointment Management" class="feature-img" />
            <h3>Appointment Management</h3>
            <p>Schedule, track and manage patient appointments efficiently.</p>
          </div>
    
          <div class="feature-card">
            <img src="https://images.pexels.com/photos/8413090/pexels-photo-8413090.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Patient Records" class="feature-img" />
            <h3>Patient Records</h3>
            <p>Maintain complete patient history, reports and profiles.</p>
          </div>
    
          <div class="feature-card">
            <img src="https://images.pexels.com/photos/8442110/pexels-photo-8442110.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Lab Integration" class="feature-img" />
            <h3>Lab Integration</h3>
            <p>Manage test requests, results and lab workflows efficiently.</p>
          </div>
    
          <div class="feature-card">
            <img src="https://images.pexels.com/photos/19471016/pexels-photo-19471016.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Pharmacy Management" class="feature-img" />
            <h3>Pharmacy Management</h3>
            <p>Handle medicines, prescriptions and stock tracking.</p>
          </div>
    
          <div class="feature-card">
            <img src="https://images.pexels.com/photos/6129118/pexels-photo-6129118.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Billing & Payments" class="feature-img" />
            <h3>Billing & Payments</h3>
            <p>Generate invoices and manage payments securely.</p>
          </div>
    
          <div class="feature-card">
            <img src="https://images.pexels.com/photos/6129502/pexels-photo-6129502.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Staff Management" class="feature-img" />
            <h3>Staff Management</h3>
            <p>Manage staff roles, schedules and daily operations.</p>
          </div>
    
        </div>
      </div>
    </section>

    <!-- ==================== MODULES SECTION ==================== -->
    <section id="modules" class="modules-section">
      <div class="modules-container">
    
        <span class="section-line"></span>
        <h2>Our Modules</h2>
        <p class="section-subtitle">
          Powerful tools designed for every role in your clinic
        </p>
    
        <div class="modules-grid">
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/4021775/pexels-photo-4021775.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Doctor" />
            </div>
            <h3> Doctor Module</h3>
            <p>Manage patient consultations, prescriptions, medical history and appointments efficiently.</p>
            <ul>
              <li> View patient records</li>
              <li> Manage prescriptions</li>
              <li> Track appointments</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3844581/pexels-photo-3844581.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Receptionist" />
            </div>
            <h3> Receptionist Module</h3>
            <p>Handle patient registrations, appointment scheduling and front-desk operations.</p>
            <ul>
              <li> Register patients</li>
              <li> Book appointments</li>
              <li> Manage check-ins</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3769151/pexels-photo-3769151.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Patient" />
            </div>
            <h3> Patient Module</h3>
            <p>Allow patients to access their medical records, reports and appointments.</p>
            <ul>
              <li> View reports</li>
              <li> Book appointments</li>
              <li> Track history</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3735770/pexels-photo-3735770.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Lab" />
            </div>
            <h3> Lab Module</h3>
            <p>Manage lab tests, sample collection and report generation efficiently.</p>
            <ul>
              <li> Test requests</li>
              <li> Upload reports</li>
              <li> Track samples</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3652103/pexels-photo-3652103.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Pharmacy" />
            </div>
            <h3> Pharmacy Module</h3>
            <p>Manage medicines, prescriptions, stock and sales records.</p>
            <ul>
              <li> Inventory tracking</li>
              <li> Prescription handling</li>
              <li> Billing support</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3825539/pexels-photo-3825539.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Staff" />
            </div>
            <h3> Staff Module</h3>
            <p>Manage staff roles, schedules and daily operational tasks.</p>
            <ul>
              <li> Staff scheduling</li>
              <li> Task management</li>
              <li> Role control</li>
            </ul>
          </div>
    
        </div>
      </div>
    </section>
    
    <!-- ==================== ABOUT US SECTION ==================== -->
    <section id="about" class="about-section">
      <div class="about-container">
        <div class="about-content">
          <span class="section-line"></span>
          <h2>About MediCare+</h2>
          <p>
            MediCare+ is a modern Clinic Management System designed to simplify
            hospital and clinic operations. It helps manage appointments, patients,
            doctors, lab tests, pharmacy, billing and staff from one secure platform.
          </p>
          <p>
            Our goal is to reduce manual work, improve workflow efficiency and provide
            better patient care through a smart digital healthcare system.
          </p>
        </div>

        <div class="about-cards">
          <div class="about-card"> Doctor Management</div>
          <div class="about-card"> Patient Records</div>
          <div class="about-card"> Lab Reports</div>
          <div class="about-card"> Pharmacy & Billing</div>
        </div>
      </div>
    </section>



    <!-- ==================== HOW IT WORKS SECTION ==================== -->
    <section id="how-it-works" class="how-section">
      <div class="how-container">
    
        <span class="section-line"></span>
        <h2>How It Works</h2>
        <p class="section-subtitle">
          Simple workflow to manage your clinic efficiently
        </p>
    
        <div class="steps-grid">
    
          <div class="step-card">
            <div class="step-number">1</div>
            <h3>Patient Registration</h3>
            <p>Receptionist registers patient details and creates a profile in the system.</p>
          </div>
    
          <div class="step-card">
            <div class="step-number">2</div>
            <h3>Appointment Booking</h3>
            <p>Appointments are scheduled with available doctors based on patient needs.</p>
          </div>
    
          <div class="step-card">
            <div class="step-number">3</div>
            <h3>Doctor Consultation</h3>
            <p>Doctor reviews patient history, examines and provides prescriptions or tests.</p>
          </div>
    
          <div class="step-card">
            <div class="step-number">4</div>
            <h3>Lab Tests</h3>
            <p>If required, lab tests are assigned and reports are generated in the system.</p>
          </div>
    
          <div class="step-card">
            <div class="step-number">5</div>
            <h3>Pharmacy & Medicines</h3>
            <p>Prescriptions are sent to pharmacy for medicine dispensing and stock updates.</p>
          </div>
    
          <div class="step-card">
            <div class="step-number">6</div>
            <h3>Billing & Payment</h3>
            <p>System generates invoice and manages payments securely.</p>
          </div>
    
        </div>
    
      </div>
    </section>

    <!-- ==================== CONTACT SECTION ==================== -->
    <section id="contact" class="contact-section">
      <div class="contact-container">
    
        <span class="section-line"></span>
        <h2>Contact Us</h2>
        <p class="section-subtitle">
          Get in touch with us for support, queries or demo access
        </p>
    
        <div class="contact-grid">
    
          <!-- Left Info -->
          <div class="contact-info">
            <h3>MediCare+ Clinic Management System</h3>
            <p>We are here to help you manage your clinic efficiently and digitally.</p>
    
            <div class="contact-item"> Bangalore, India</div>
            <div class="contact-item"> +91 9876543210</div>
            <div class="contact-item"> support@medicare.com</div>
            <div class="contact-item"> Mon - Sat : 9 AM - 6 PM</div>
          </div>
    
          <!-- Right Form -->
          <form class="contact-form">
            <input type="text" placeholder="Your Name" required />
            <input type="email" placeholder="Your Email" required />
            <textarea placeholder="Your Message" required></textarea>
            <button type="submit">Send Message</button>
          </form>
        </div>
    
      </div>
    </section>
    <footer class="footer" id="footer">
        <div class="footer-left">
            &copy; 2024 MediCare+ Clinic Management System. All rights reserved.
        </div>
        <ul class="footer-links">
            <li><a href="#">Privacy Policy</a></li>
            <li><a href="#">Terms &amp; Conditions</a></li>
            <li><a href="#">Support</a></li>
        </ul>
        <div class="footer-social">
            <span>Follow Us:</span>
            <span class="social-icon fb">f</span>
            <span class="social-icon tw">t</span>
            <span class="social-icon ln">in</span>
            <span class="social-icon ig">ig</span>
        </div>
    </footer>

    <script>
        function togglePassword(id) {
            const el = document.getElementById(id);
            if (el.type === 'password') {
                el.type = 'text';
            } else {
                el.type = 'password';
            }
        }

        function toggleRoleFields() {
            var roleSelect = document.getElementById("registerRoleSelect");
            var adminFields = document.getElementById("adminFields");
            var patientFields = document.getElementById("patientFields");
            var doctorFields = document.getElementById("doctorFields");
            var labFields = document.getElementById("labFields");
            var deliveryFields = document.getElementById("deliveryFields");
            
            var adminId = document.getElementById("adminId");
            var clinicName = document.getElementById("clinicName");
            var regPhone = document.getElementById("regPhone");
            var patientAge = document.getElementById("patientAge");
            var patientGender = document.getElementById("patientGender");
            var patientAddress = document.getElementById("patientAddress");
            var doctorPhone = document.getElementById("doctorPhone");
            var doctorSpec = document.getElementById("doctorSpecialization");
            var doctorExp = document.getElementById("doctorExperience");
            var doctorLic = document.getElementById("doctorLicenseId");

            var labNameInput = document.getElementById("labName");
            var labAddrInput = document.getElementById("labAddress");
            var labIdInput = document.getElementById("labId");

            var pharmacyFields = document.getElementById("pharmacyFields");
            var staffFields = document.getElementById("staffFields");
            var deliveryPhone = document.getElementById("deliveryPhone");
            var vehicleType = document.getElementById("vehicleType");
            var staffPhone = document.getElementById("staffPhone");
            var staffId = document.getElementById("staffId");
            var hospName = document.getElementById("hospitalName");

            var receptionistFields = document.getElementById("receptionistFields");
            var recPhone = document.getElementById("receptionistPhone");
            var recGovId = document.getElementById("receptionistGovId");
            var recGender = document.getElementById("receptionistGender");
            var recAddr = document.getElementById("receptionistAddress");

            // Reset visibility
            if(adminFields) adminFields.style.display = "none";
            if(patientFields) patientFields.style.display = "none";
            if(doctorFields) doctorFields.style.display = "none";
            if(labFields) labFields.style.display = "none";
            if(receptionistFields) receptionistFields.style.display = "none";
            if(deliveryFields) deliveryFields.style.display = "none";
            if(pharmacyFields) pharmacyFields.style.display = "none";
            if(staffFields) staffFields.style.display = "none";
            
            // Reset required status
            if(adminId) adminId.required = false;
            if(clinicName) clinicName.required = false;
            if(regPhone) regPhone.required = false;
            if(patientAge) patientAge.required = false;
            if(patientGender) patientGender.required = false;
            if(patientAddress) patientAddress.required = false;
            if(doctorPhone) doctorPhone.required = false;
            if(doctorSpec) doctorSpec.required = false;
            if(doctorExp) doctorExp.required = false;
            if(doctorLic) doctorLic.required = false;

            if(labNameInput) labNameInput.required = false;
            if(labAddrInput) labAddrInput.required = false;
            if(labIdInput) labIdInput.required = false;

            if(recPhone) recPhone.required = false;
            if(recGovId) recGovId.required = false;
            if(recGender) recGender.required = false;
            if(recAddr) recAddr.required = false;

            if(deliveryPhone) deliveryPhone.required = false;
            if(vehicleType) vehicleType.required = false;

            if(staffPhone) staffPhone.required = false;
            if(staffId) staffId.required = false;
            if(hospName) hospName.required = false;

            // Show and set required based on role
            if (roleSelect.value === "Admin") {
                if(adminFields) adminFields.style.display = "block";
                if(adminId) adminId.required = true;
                if(clinicName) clinicName.required = true;
            } else if (roleSelect.value === "Patient") {
                if(patientFields) patientFields.style.display = "block";
                if(regPhone) regPhone.required = true;
                if(patientAge) patientAge.required = true;
                if(patientGender) patientGender.required = true;
                if(patientAddress) patientAddress.required = true;
            } else if (roleSelect.value === "Doctor") {
                if(doctorFields) doctorFields.style.display = "block";
                if(doctorPhone) doctorPhone.required = true;
                if(doctorSpec) doctorSpec.required = true;
                if(doctorExp) doctorExp.required = true;
                if(doctorLic) doctorLic.required = true;
            } else if (roleSelect.value === "Lab") {
                if(labFields) labFields.style.display = "block";
                if(labNameInput) labNameInput.required = true;
                if(labAddrInput) labAddrInput.required = true;
                if(labIdInput) labIdInput.required = true;
            } else if (roleSelect.value === "Receptionist") {
                if(receptionistFields) receptionistFields.style.display = "block";
                if(recPhone) recPhone.required = true;
                if(recGovId) recGovId.required = true;
                if(recGender) recGender.required = true;
                if(recAddr) recAddr.required = true;
            } else if (roleSelect.value === "Pharmacy") {
                if(pharmacyFields) pharmacyFields.style.display = "block";
            } else if (roleSelect.value === "Delivery") {
                if(deliveryFields) {
                    deliveryFields.style.display = "block";
                    if(deliveryPhone) deliveryPhone.required = true;
                    if(vehicleType) vehicleType.required = true;
                }
            } else if (roleSelect.value === "Staff") {
                if(staffFields) {
                    staffFields.style.display = "block";
                    if(staffPhone) staffPhone.required = true;
                    if(staffId) staffId.required = true;
                    if(hospName) hospName.required = true;
                }
            }
        }
        // Hero Background Slider Logic
        const heroImages = [
            "/hero-slider/hero1.jpg",
            "/hero-slider/hero2.jpg",
            "/hero-slider/hero3.jpg",
            "/hero-slider/hero4.jpg",
            "/hero-slider/hero5.jpg"
        ];
        let currentHero = 0;
        const heroSection = document.getElementById('hero');

        function changeHeroBackground() {
            currentHero = (currentHero + 1) % heroImages.length;
            heroSection.style.backgroundImage = `linear-gradient(rgba(0, 0, 0, 0.45), rgba(0, 0, 0, 0.45)), url(${heroImages[currentHero]})`;
        }

        // Initialize first background
        heroSection.style.backgroundImage = `linear-gradient(rgba(0, 0, 0, 0.45), rgba(0, 0, 0, 0.45)), url(${heroImages[0]})`;
        
        // Start slider
        setInterval(changeHeroBackground, 10000); // 10 seconds per slide for better UX

        // Initialize role fields
        window.addEventListener('load', toggleRoleFields);
    </script>
</body>
</html>
