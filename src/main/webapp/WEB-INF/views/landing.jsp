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
    <style>
        .login-toggle-input:checked ~ .hero .hero-right {
            display: block !important;
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            z-index: 99999 !important;
            background: rgba(15, 23, 42, 0.8) !important;
            backdrop-filter: blur(8px) !important;
            padding: 80px 20px !important; /* Space for top navigation and scrolling */
            margin: 0 !important;
            overflow-y: auto !important;
            scrollbar-width: thin;
            scrollbar-color: #6C63FF rgba(255,255,255,0.1);
        }
        .hero,
        .hero-section {
            min-height: 720px !important;
            width: 100% !important;
            background-size: cover !important;
            background-position: center !important;
            background-repeat: no-repeat !important;
            transition: background-image 2.0s ease-in-out !important;
            background-attachment: scroll !important;
            background-color: transparent !important;
        }
        .hero-right .login-card {
            background: #ffffff !important;
            border-radius: 24px !important;
            padding: 32px !important;
            max-width: 440px !important;
            width: 100% !important;
            max-height: none !important;
            overflow: visible !important;
            position: relative !important;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2), 0 10px 10px -5px rgba(0, 0, 0, 0.1) !important;
            border: 1px solid rgba(0, 0, 0, 0.05) !important;
            margin: 0 auto !important; /* Center horizontally */
        }
        /* Hide scrollbar for cleaner look if desired, or keep it on the body/overlay */
        .login-toggle-input:checked ~ .hero .hero-right::-webkit-scrollbar {
            width: 0;
            background: transparent;
        }
        .login-toggle-input:checked ~ .hero .hero-right {
            scrollbar-width: none;
            -ms-overflow-style: none;
        }
        .login-card h3 {
            color: #111827 !important;
            font-size: 24px !important; /* Slightly smaller */
            font-weight: 800 !important;
            margin-bottom: 8px !important;
        }
        .login-card .subtitle {
            color: #6b7280 !important;
            font-size: 14px !important; /* Slightly smaller */
            margin-bottom: 24px !important;
        }
        .tab-header {
            display: flex !important;
            gap: 20px !important;
            margin-bottom: 24px !important;
            border-bottom: 2px solid #f3f4f6 !important;
            padding-bottom: 0 !important;
        }
        .tab-btn {
            padding: 10px 0 !important;
            font-size: 15px !important;
            font-weight: 700 !important;
            color: #9ca3af !important;
            border-bottom: 2px solid transparent !important;
            border-radius: 0 !important;
            background: transparent !important;
            margin-bottom: -2px !important;
        }
        .form-group {
            margin-bottom: 16px !important; /* More compact */
        }
        .form-input {
            padding: 12px 12px 12px 42px !important; /* More compact */
        }
        .btn-login, .btn-register {
            height: 48px !important; /* More compact */
            margin-top: 20px !important;
        }
        .modal-close {
            position: absolute !important;
            top: 20px !important;
            right: 20px !important;
            font-size: 22px !important;
            color: #9ca3af !important;
            cursor: pointer !important;
        }

        /* Footer Modals Styling */
        #privacy-toggle:checked ~ #privacy-modal,
        #terms-toggle:checked ~ #terms-modal,
        #support-toggle:checked ~ #support-modal {
            display: flex !important;
            opacity: 1 !important;
            visibility: visible !important;
        }
        .footer-modal-overlay {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            background: rgba(15, 23, 42, 0.85) !important;
            backdrop-filter: blur(8px) !important;
            z-index: 100000 !important;
            display: none !important;
            justify-content: center !important;
            align-items: center !important;
            padding: 20px !important;
            transition: all 0.3s ease !important;
        }
        .footer-modal-card {
            background: #ffffff !important;
            border-radius: 24px !important;
            padding: 40px !important;
            max-width: 600px !important;
            width: 100% !important;
            max-height: 90vh !important;
            overflow-y: auto !important;
            position: relative !important;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25) !important;
            border-top: 6px solid #7c3aed !important;
        }
        .footer-modal-card h2 {
            font-size: 28px !important;
            font-weight: 900 !important;
            color: #0f172a !important;
            margin-bottom: 15px !important;
            display: flex !important;
            align-items: center !important;
            gap: 12px !important;
        }
        .footer-modal-card p {
            color: #64748b !important;
            line-height: 1.6 !important;
            font-size: 15px !important;
            margin-bottom: 20px !important;
        }
        .footer-modal-card ul {
            list-style: none !important;
            padding: 0 !important;
            margin-bottom: 20px !important;
        }
        .footer-modal-card ul li {
            padding: 10px 0 !important;
            border-bottom: 1px solid #f1f5f9 !important;
            color: #334155 !important;
            font-size: 14px !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }
        .footer-modal-card ul li::before {
            content: "✓" !important;
            color: #7c3aed !important;
            font-weight: bold !important;
        }
        .footer-modal-close {
            position: absolute !important;
            top: 25px !important;
            right: 25px !important;
            font-size: 24px !important;
            color: #94a3b8 !important;
            cursor: pointer !important;
            transition: color 0.2s !important;
        }
        .footer-modal-close:hover {
            color: #0f172a !important;
        }
        .support-info {
            background: #f8fafc !important;
            padding: 20px !important;
            border-radius: 16px !important;
            margin-top: 20px !important;
            border: 1px solid #e2e8f0 !important;
        }
        .support-info div {
            margin-bottom: 10px !important;
            color: #1e293b !important;
            font-weight: 600 !important;
            font-size: 14px !important;
        }

        /* WhatsApp Floating Button - Round Icon Version */
        .whatsapp-float {
            position: fixed !important;
            bottom: 40px !important;
            right: 40px !important;
            background: #25d366 !important;
            color: white !important;
            width: 60px !important;
            height: 60px !important;
            border-radius: 50% !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            text-decoration: none !important;
            box-shadow: 0 12px 30px rgba(37, 211, 102, 0.45) !important;
            z-index: 99999 !important;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) !important;
            border: 2px solid rgba(255, 255, 255, 0.2) !important;
        }
        .whatsapp-float:hover {
            transform: translateY(-8px) scale(1.1) rotate(10deg) !important;
            box-shadow: 0 18px 40px rgba(37, 211, 102, 0.5) !important;
            background: #20ba5a !important;
        }
        .whatsapp-icon {
            width: 32px !important;
            height: 32px !important;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1)) !important;
        }
    </style>
</head>
<body>
    <!-- Hidden toggle for Login Card -->
    <!-- Hidden toggles for Footer Modals -->
    <input type="checkbox" id="login-toggle" class="login-toggle-input" style="display:none">
    <input type="checkbox" id="privacy-toggle" class="footer-modal-input" style="display:none">
    <input type="checkbox" id="terms-toggle" class="footer-modal-input" style="display:none">
    <input type="checkbox" id="support-toggle" class="footer-modal-input" style="display:none">

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

                                    <div class="form-group" style="margin-bottom: 0;">
                                        <span class="input-icon">&#x1F4CD;</span>
                                        <input type="text" name="address" id="patientAddress" class="form-input" placeholder="Full Home Address">
                                    </div>
                                </div>
                                
                                <!-- Doctor specific fields (hidden by default) -->
                                <div id="doctorFields" style="display: none; background: rgba(37,99,235,0.03); padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px dashed rgba(37,99,235,0.3);">
                                    <p style="font-size: 0.8rem; color: #2563eb; margin-top: 0; margin-bottom: 10px; font-weight: 600;">Doctor Details</p>
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
                                         <span class="input-icon">&#x1F194;</span>
                                         <input type="text" name="govIdNumber" id="receptionistGovId" class="form-input" placeholder="Government ID Number">
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
                                         <span class="input-icon">&#x1F464;</span>
                                         <input type="text" name="staffId" id="staffId" class="form-input" placeholder="Staff Role (e.g. Nurse, Technician)" required>
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
            <div class="feature-image-top" style="height: 170px !important; overflow: hidden !important; border-radius: 12px !important; margin-bottom: 20px !important; display: block !important;">
              <img src="https://images.pexels.com/photos/7089020/pexels-photo-7089020.jpeg?auto=compress&cs=tinysrgb&w=800&h=500&fit=crop" alt="Appointment Management" style="width: 100% !important; height: 170px !important; min-height: 170px !important; max-height: 170px !important; object-fit: cover !important; display: block !important; border-radius: 12px !important;" />
            </div>
            <div class="feature-content" style="padding: 0 !important;">
              <h3>Appointment Management</h3>
              <p>Schedule, track and manage patient appointments efficiently.</p>
            </div>
          </div>
    
          <div class="feature-card">
            <div class="feature-image-top" style="height: 170px !important; overflow: hidden !important; border-radius: 12px !important; margin-bottom: 20px !important; display: block !important;">
              <img src="https://images.pexels.com/photos/4386464/pexels-photo-4386464.jpeg?auto=compress&cs=tinysrgb&w=800&h=500&fit=crop" alt="Patient Records" style="width: 100% !important; height: 170px !important; min-height: 170px !important; max-height: 170px !important; object-fit: cover !important; display: block !important; border-radius: 12px !important;" />
            </div>
            <div class="feature-content" style="padding: 0 !important;">
              <h3>Patient Records</h3>
              <p>Maintain complete patient history, reports and profiles.</p>
            </div>
          </div>
    
          <div class="feature-card">
            <div class="feature-image-top" style="height: 170px !important; overflow: hidden !important; border-radius: 12px !important; margin-bottom: 20px !important; display: block !important;">
              <img src="https://images.pexels.com/photos/3825539/pexels-photo-3825539.jpeg?auto=compress&cs=tinysrgb&w=800&h=500&fit=crop" alt="Lab Integration" style="width: 100% !important; height: 170px !important; min-height: 170px !important; max-height: 170px !important; object-fit: cover !important; display: block !important; border-radius: 12px !important;" />
            </div>
            <div class="feature-content" style="padding: 0 !important;">
              <h3>Lab Integration</h3>
              <p>Manage test requests, results and lab workflows efficiently.</p>
            </div>
          </div>
    
          <div class="feature-card">
            <div class="feature-image-top" style="height: 170px !important; overflow: hidden !important; border-radius: 12px !important; margin-bottom: 20px !important; display: block !important;">
              <img src="https://images.pexels.com/photos/3652103/pexels-photo-3652103.jpeg?auto=compress&cs=tinysrgb&w=800&h=500&fit=crop" alt="Pharmacy Management" style="width: 100% !important; height: 170px !important; min-height: 170px !important; max-height: 170px !important; object-fit: cover !important; display: block !important; border-radius: 12px !important;" />
            </div>
            <div class="feature-content" style="padding: 0 !important;">
              <h3>Pharmacy Management</h3>
              <p>Handle medicines, prescriptions and stock tracking.</p>
            </div>
          </div>
    
          <div class="feature-card">
            <div class="feature-image-top" style="height: 170px !important; overflow: hidden !important; border-radius: 12px !important; margin-bottom: 20px !important; display: block !important;">
              <img src="https://images.pexels.com/photos/5849581/pexels-photo-5849581.jpeg?auto=compress&cs=tinysrgb&w=800&h=500&fit=crop" alt="Billing & Payments" style="width: 100% !important; height: 170px !important; min-height: 170px !important; max-height: 170px !important; object-fit: cover !important; display: block !important; border-radius: 12px !important;" />
            </div>
            <div class="feature-content" style="padding: 0 !important;">
              <h3>Billing & Payments</h3>
              <p>Generate invoices and manage payments securely.</p>
            </div>
          </div>
    
          <div class="feature-card">
            <div class="feature-image-top" style="height: 170px !important; overflow: hidden !important; border-radius: 12px !important; margin-bottom: 20px !important; display: block !important;">
              <img src="https://images.pexels.com/photos/3184435/pexels-photo-3184435.jpeg?auto=compress&cs=tinysrgb&w=800&h=500&fit=crop" alt="Staff Management" style="width: 100% !important; height: 170px !important; min-height: 170px !important; max-height: 170px !important; object-fit: cover !important; display: block !important; border-radius: 12px !important;" />
            </div>
            <div class="feature-content" style="padding: 0 !important;">
              <h3>Staff Management</h3>
              <p>Manage staff roles, schedules and daily operations.</p>
            </div>
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
          All essential modules in one integrated system
        </p>
    
        <div class="modules-grid">
    
          <div class="module-card">
            <div class="module-image-top">
              <img src="https://images.pexels.com/photos/4173251/pexels-photo-4173251.jpeg?auto=compress&cs=tinysrgb&w=600" alt="Doctor Module" />
            </div>
            <div class="module-content">
              <div class="module-title-row">
                <div class="module-icon doctor-icon">👨‍⚕️</div>
                <h3>Doctor Module</h3>
              </div>
              <p>Manage consultations and patient treatments.</p>
              <ul class="module-features">
                <li>View Appointments</li>
                <li>Patient History</li>
                <li>Prescriptions</li>
                <li>Consultation Notes</li>
              </ul>
              <a href="#" class="explore-module-btn">Explore Module &rarr;</a>
            </div>
          </div>
    
          <div class="module-card">
            <div class="module-image-top">
              <img src="https://images.pexels.com/photos/3844581/pexels-photo-3844581.jpeg?auto=compress&cs=tinysrgb&w=800" alt="Medical Receptionist" style="width: 100%; height: 100%; object-fit: cover;" />
            </div>
            <div class="module-content">
              <div class="module-title-row">
                <div class="module-icon reception-icon">📋</div>
                <h3>Reception Module</h3>
              </div>
              <p>Handle registrations and appointments.</p>
              <ul class="module-features">
                <li>Patient Check-in</li>
                <li>Appointment Booking</li>
                <li>Queue Management</li>
                <li>Front Desk Operations</li>
              </ul>
              <a href="#" class="explore-module-btn">Explore Module &rarr;</a>
            </div>
          </div>
    
          <div class="module-card">
            <div class="module-image-top">
              <img src="https://images.pexels.com/photos/2280571/pexels-photo-2280571.jpeg?auto=compress&cs=tinysrgb&w=600" alt="Lab Module" />
            </div>
            <div class="module-content">
              <div class="module-title-row">
                <div class="module-icon lab-icon">🔬</div>
                <h3>Lab Module</h3>
              </div>
              <p>Manage tests, reports and sample tracking.</p>
              <ul class="module-features">
                <li>Test Requests</li>
                <li>Sample Collection</li>
                <li>Report Generation</li>
                <li>Result Tracking</li>
              </ul>
              <a href="#" class="explore-module-btn">Explore Module &rarr;</a>
            </div>
          </div>
    
          <div class="module-card">
            <div class="module-image-top">
              <img src="https://images.pexels.com/photos/5910956/pexels-photo-5910956.jpeg?auto=compress&cs=tinysrgb&w=600" alt="Pharmacy Module" />
            </div>
            <div class="module-content">
              <div class="module-title-row">
                <div class="module-icon pharmacy-icon">💊</div>
                <h3>Pharmacy Module</h3>
              </div>
              <p>Manage medicines, stock and prescriptions.</p>
              <ul class="module-features">
                <li>Inventory Tracking</li>
                <li>Prescription Handling</li>
                <li>Billing Support</li>
                <li>Stock Alerts</li>
              </ul>
              <a href="#" class="explore-module-btn">Explore Module &rarr;</a>
            </div>
          </div>
    
          <div class="module-card">
            <div class="module-image-top">
              <img src="https://images.pexels.com/photos/4386339/pexels-photo-4386339.jpeg?auto=compress&cs=tinysrgb&w=600" alt="Billing Module" />
            </div>
            <div class="module-content">
              <div class="module-title-row">
                <div class="module-icon billing-icon">📑</div>
                <h3>Billing Module</h3>
              </div>
              <p>Generate invoices and manage payments.</p>
              <ul class="module-features">
                <li>Invoice Generation</li>
                <li>Payment Tracking</li>
                <li>Financial Reports</li>
                <li>Insurance Claims</li>
              </ul>
              <a href="#" class="explore-module-btn">Explore Module &rarr;</a>
            </div>
          </div>
    
          <div class="module-card">
            <div class="module-image-top">
              <img src="https://images.pexels.com/photos/3184418/pexels-photo-3184418.jpeg?auto=compress&cs=tinysrgb&w=600" alt="Staff Module" />
            </div>
            <div class="module-content">
              <div class="module-title-row">
                <div class="module-icon staff-icon">👥</div>
                <h3>Staff Module</h3>
              </div>
              <p>Manage staff roles and daily operations.</p>
              <ul class="module-features">
                <li>Staff Scheduling</li>
                <li>Task Management</li>
                <li>Role Control</li>
                <li>Attendance Tracking</li>
              </ul>
              <a href="#" class="explore-module-btn">Explore Module &rarr;</a>
            </div>
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
          <div class="about-card">Doctor Management</div>
          <div class="about-card">Patient Records</div>
          <div class="about-card">Lab Reports</div>
          <div class="about-card">Pharmacy & Billing</div>
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
          <form class="contact-form" action="/submit-contact" method="post">
            <c:if test="${not empty contactSuccess}">
                <div style="background: #ecfdf5; color: #059669; padding: 12px; border-radius: 8px; margin-bottom: 15px; font-size: 14px; text-align: center; border: 1px solid #10b981;">
                    ${contactSuccess}
                </div>
            </c:if>
            <input type="text" name="name" placeholder="Your Name" required />
            <input type="email" name="email" placeholder="Your Email" required />
            <textarea name="message" placeholder="Your Message" required></textarea>
            <button type="submit">Send Message</button>
          </form>
        </div>
    
      </div>
    </section>
    <footer class="footer" id="footer">
      <div class="footer-container">
        <div class="footer-top">
          <!-- Column 1: Brand Info -->
          <div class="footer-column brand-info">
            <div class="footer-logo">
              <div class="logo-square">M+</div>
              <span>MediCare+</span>
            </div>
            <p>All-in-one Clinic Management System to streamline your clinic operations and improve patient care.</p>
            <div class="footer-social">
              <a href="#" class="social-icon fb">f</a>
              <a href="#" class="social-icon tw">t</a>
              <a href="#" class="social-icon ln">in</a>
              <a href="#" class="social-icon ig">ig</a>
            </div>
          </div>

          <!-- Column 2: Quick Links -->
          <div class="footer-column">
            <h3>Quick Links</h3>
            <ul>
              <li><a href="#hero">Home</a></li>
              <li><a href="#features">Features</a></li>
              <li><a href="#modules">Modules</a></li>
              <li><a href="#how-it-works">How It Works</a></li>
              <li><a href="#about">About Us</a></li>
              <li><a href="#contact">Contact</a></li>
            </ul>
          </div>

          <!-- Column 3: Support -->
          <div class="footer-column">
            <h3>Support</h3>
            <ul>
              <li><a href="javascript:void(0)" onclick="openFooterModal('help-modal')">Help Center</a></li>
              <li><a href="javascript:void(0)" onclick="openFooterModal('faq-modal')">FAQ</a></li>
              <li><a href="javascript:void(0)" onclick="openFooterModal('privacy-modal')">Privacy Policy</a></li>
              <li><a href="javascript:void(0)" onclick="openFooterModal('terms-modal')">Terms & Conditions</a></li>
              <li><a href="javascript:void(0)" onclick="openFooterModal('support-modal')">Support</a></li>
            </ul>
          </div>

          <!-- Column 4: Newsletter -->
          <div class="footer-column newsletter">
            <h3>Newsletter</h3>
            <p>Subscribe to our newsletter to get updates and offers.</p>
            <div class="newsletter-form">
              <input type="email" id="newsletterEmail" placeholder="Enter your email" />
              <button type="button" onclick="subscribeNewsletter()">Subscribe</button>
            </div>
            <div id="newsletterStatus" style="margin-top: 12px; font-size: 13px; font-weight: 700; display: none; color: #10b981; animation: fadeIn 0.3s ease;"></div>
          </div>
        </div>

        <div class="footer-bottom">
          <div class="footer-copyright">
            &copy; 2024 MediCare+ Clinic Management System. All rights reserved.
          </div>
          <div class="footer-policy-links">
            <a href="javascript:void(0)" onclick="openFooterModal('privacy-modal')">Privacy Policy</a>
            <span>|</span>
            <a href="javascript:void(0)" onclick="openFooterModal('terms-modal')">Terms & Conditions</a>
            <span>|</span>
            <a href="javascript:void(0)" onclick="openFooterModal('support-modal')">Support</a>
          </div>
        </div>
      </div>
    </footer>

    <!-- Help Center Modal -->
    <div class="footer-modal-overlay" id="help-modal">
        <div class="footer-modal-card">
            <span class="footer-modal-close" onclick="closeFooterModal('help-modal')">&times;</span>
            <h2>📖 Help Center</h2>
            <p>Welcome to the MediCare+ Help Center. Learn how to navigate and use our Clinic Management System effectively.</p>
            <div class="support-info">
                <div style="font-size:16px; margin-bottom:15px; color:#7c3aed;">Quick Tutorials:</div>
                <ul style="border:none;">
                    <li><strong>Registration:</strong> Click "Get Started" and select your role (Doctor, Patient, etc.) to create an account.</li>
                    <li><strong>Dashboard:</strong> Once logged in, use the sidebar to access your specific modules.</li>
                    <li><strong>Appointments:</strong> Patients can book appointments via the "Appointments" tab in their portal.</li>
                    <li><strong>Lab Reports:</strong> View and download your test results directly from the "Lab" section.</li>
                </ul>
            </div>
        </div>
    </div>

    <!-- FAQ Modal -->
    <div class="footer-modal-overlay" id="faq-modal">
        <div class="footer-modal-card">
            <span class="footer-modal-close" onclick="closeFooterModal('faq-modal')">&times;</span>
            <h2>❓ Frequently Asked Questions</h2>
            <p>Common questions about MediCare+ Clinic Management System.</p>
            <div class="support-info">
                <div style="margin-bottom:15px;">
                    <strong style="color:#0f172a;">Q: Is my medical data secure?</strong>
                    <p style="font-size:14px; margin-top:5px;">A: Yes, we use high-level encryption and secure role-based access to protect all patient and clinic data.</p>
                </div>
                <div style="margin-bottom:15px;">
                    <strong style="color:#0f172a;">Q: How can I reset my password?</strong>
                    <p style="font-size:14px; margin-top:5px;">A: Contact your clinic administrator or use the "Forgot Password" link on the login screen.</p>
                </div>
                <div>
                    <strong style="color:#0f172a;">Q: Can I access MediCare+ on mobile?</strong>
                    <p style="font-size:14px; margin-top:5px;">A: Yes, our platform is fully responsive and works on all smartphones and tablets.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Privacy Policy Modal -->
    <div class="footer-modal-overlay" id="privacy-modal">
        <div class="footer-modal-card">
            <span class="footer-modal-close" onclick="closeFooterModal('privacy-modal')">&times;</span>
            <h2>🛡️ Privacy Policy</h2>
            <p>MediCare+ Clinic Management System values patient privacy and data security. All medical records, appointments, prescriptions, billing details, and lab reports are stored securely within the system.</p>
            <ul>
                <li>Patient information is securely managed</li>
                <li>Only authorized staff can access records</li>
                <li>Password-protected login system</li>
                <li>Secure appointment and billing management</li>
                <li>Lab reports and prescriptions remain confidential</li>
                <li>System data is maintained for clinic operations only</li>
            </ul>
        </div>
    </div>

    <!-- Terms & Conditions Modal -->
    <div class="footer-modal-overlay" id="terms-modal">
        <div class="footer-modal-card">
            <span class="footer-modal-close" onclick="closeFooterModal('terms-modal')">&times;</span>
            <h2>📜 Terms & Conditions</h2>
            <p>By using the MediCare+ Clinic Management System, users agree to use the platform responsibly for clinic and healthcare management purposes only.</p>
            <ul>
                <li>Users must provide valid information</li>
                <li>Unauthorized access is prohibited</li>
                <li>Patient data must remain confidential</li>
                <li>Staff accounts are role-based and secure</li>
                <li>System misuse may result in account restriction</li>
                <li>Clinic administrators manage all user access</li>
            </ul>
        </div>
    </div>

    <!-- Support Modal -->
    <div class="footer-modal-overlay" id="support-modal">
        <div class="footer-modal-card">
            <span class="footer-modal-close" onclick="closeFooterModal('support-modal')">&times;</span>
            <h2>🎧 Support</h2>
            <p>Need help with MediCare+ Clinic Management System? Our support section helps users manage technical and operational issues efficiently.</p>
            
            <div class="support-info">
                <div>✉️ Email: support@medicareplus.com</div>
                <div>📞 Phone: +91 9876543210</div>
                <div>⏰ Working Hours: Monday – Saturday | 9:00 AM – 6:00 PM</div>
            </div>

            <h3 style="margin-top:25px; font-size:16px; color:#0f172a; font-weight:800;">Support Features:</h3>
            <ul>
                <li>Appointment assistance</li>
                <li>Login issue support</li>
                <li>Patient record management help</li>
                <li>Lab and pharmacy workflow support</li>
                <li>Billing and payment assistance</li>
                <li>Technical troubleshooting</li>
            </ul>
        </div>
    </div>

    <script>
        function openFooterModal(id) {
            const modal = document.getElementById(id);
            if (modal) {
                modal.classList.add('active');
                document.body.style.overflow = 'hidden';
            }
        }

        function closeFooterModal(id) {
            const modal = document.getElementById(id);
            if (modal) {
                modal.classList.remove('active');
                document.body.style.overflow = 'auto';
            }
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('footer-modal-overlay')) {
                event.target.classList.remove('active');
                document.body.style.overflow = 'auto';
            }
        }

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
            if(doctorSpec) doctorSpec.required = false;
            if(doctorExp) doctorExp.required = false;
            if(doctorLic) doctorLic.required = false;

            if(labNameInput) labNameInput.required = false;
            if(labAddrInput) labAddrInput.required = false;
            if(labIdInput) labIdInput.required = false;

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
        function subscribeNewsletter() {
            const emailInput = document.getElementById('newsletterEmail');
            const statusDiv = document.getElementById('newsletterStatus');
            const email = emailInput.value;
            
            if (email && email.includes('@')) {
                // Send to server
                fetch('/newsletter/subscribe?email=' + encodeURIComponent(email), {
                    method: 'POST'
                }).then(response => {
                    statusDiv.innerText = "✓ Thank you! You've been subscribed.";
                    statusDiv.style.display = "block";
                    statusDiv.style.color = "#10b981";
                    emailInput.value = "";
                    setTimeout(() => { statusDiv.style.display = "none"; }, 5000);
                }).catch(err => {
                    statusDiv.innerText = "⚠ Server error. Please try again.";
                    statusDiv.style.display = "block";
                    statusDiv.style.color = "#ef4444";
                });
            } else {
                statusDiv.innerText = "⚠ Please enter a valid email address.";
                statusDiv.style.display = "block";
                statusDiv.style.color = "#ef4444";
            }
        }

        // Hero Background Slider Logic
        document.addEventListener("DOMContentLoaded", function () {
          const heroImages = [
            "/hero-backdrop/hero1.jpg",
            "/hero-backdrop/hero2.jpg",
            "/hero-backdrop/hero3.jpg",
            "/hero-backdrop/hero4.jpg",
            "/hero-backdrop/hero5.jpg"
          ];

          let index = 0;

          const heroSection =
            document.querySelector(".hero") ||
            document.querySelector(".hero-section") ||
            document.querySelector("#hero");

          if (!heroSection) {
            console.error("Hero section not found");
            return;
          }

          function changeHeroBackground() {
            heroSection.style.backgroundImage =
              "linear-gradient(rgba(0,0,0,0.45), rgba(0,0,0,0.45)), url('" +
              heroImages[index] +
              "')";

            heroSection.style.backgroundSize = "cover";
            heroSection.style.backgroundPosition = "center";
            heroSection.style.backgroundRepeat = "no-repeat";

            index = (index + 1) % heroImages.length;
          }

          changeHeroBackground();
          setInterval(changeHeroBackground, 5000);
          
          // Also call role toggle
          if (typeof toggleRoleFields === 'function') toggleRoleFields();
        });

    </script>

    <!-- WhatsApp Integration Button -->
    <a href="https://wa.me/919876543210" class="whatsapp-float" target="_blank" title="Chat with us on WhatsApp">
        <img src="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg" class="whatsapp-icon" alt="WhatsApp">
    </a>

</body>
</html>
