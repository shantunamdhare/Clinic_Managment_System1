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

                            <form action="/register" method="post">
                                <div class="form-group">
                                    <span class="input-icon">&#x1F464;</span>
                                    <input type="text" name="fullName" class="form-input" placeholder="Full Name" required>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x2709;</span>
                                    <input type="email" name="email" class="form-input" placeholder="Email Address" required>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x1F512;</span>
                                    <input type="password" name="password" class="form-input" placeholder="Create Password" required>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x1F512;</span>
                                    <input type="password" name="confirmPassword" class="form-input" placeholder="Confirm Password" required>
                                </div>
                                <div class="form-group">
                                    <span class="input-icon">&#x1F464;</span>
                                    <select name="role" id="registerRoleSelect" class="form-select" required onchange="toggleDoctorFields()">
                                        <option value="" disabled selected>Select Your Role</option>
                                        <option value="Admin">Admin</option>
                                        <option value="Doctor">Doctor</option>
                                        <option value="Receptionist">Receptionist</option>
                                        <option value="Patient">Patient</option>
                                        <option value="Lab">Lab</option>
                                        <option value="Pharmacy">Pharmacy</option>
                                        <option value="Staff">Staff</option>
                                    </select>
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
            <div class="icon">📅</div>
            <h3>Appointment Management</h3>
            <p>Schedule, track and manage patient appointments efficiently.</p>
          </div>
    
          <div class="feature-card">
            <div class="icon">👤</div>
            <h3>Patient Records</h3>
            <p>Maintain complete patient history, reports and profiles.</p>
          </div>
    
          <div class="feature-card">
            <div class="icon">🧪</div>
            <h3>Lab Integration</h3>
            <p>Manage test requests, results and lab workflows efficiently.</p>
          </div>
    
          <div class="feature-card">
            <div class="icon">💊</div>
            <h3>Pharmacy Management</h3>
            <p>Handle medicines, prescriptions and stock tracking.</p>
          </div>
    
          <div class="feature-card">
            <div class="icon">💳</div>
            <h3>Billing & Payments</h3>
            <p>Generate invoices and manage payments securely.</p>
          </div>
    
          <div class="feature-card">
            <div class="icon">👥</div>
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
            <h3>🩺 Doctor Module</h3>
            <p>Manage patient consultations, prescriptions, medical history and appointments efficiently.</p>
            <ul>
              <li>✔ View patient records</li>
              <li>✔ Manage prescriptions</li>
              <li>✔ Track appointments</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3844581/pexels-photo-3844581.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Receptionist" />
            </div>
            <h3>📋 Receptionist Module</h3>
            <p>Handle patient registrations, appointment scheduling and front-desk operations.</p>
            <ul>
              <li>✔ Register patients</li>
              <li>✔ Book appointments</li>
              <li>✔ Manage check-ins</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3769151/pexels-photo-3769151.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Patient" />
            </div>
            <h3>👤 Patient Module</h3>
            <p>Allow patients to access their medical records, reports and appointments.</p>
            <ul>
              <li>✔ View reports</li>
              <li>✔ Book appointments</li>
              <li>✔ Track history</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3735770/pexels-photo-3735770.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Lab" />
            </div>
            <h3>🧪 Lab Module</h3>
            <p>Manage lab tests, sample collection and report generation efficiently.</p>
            <ul>
              <li>✔ Test requests</li>
              <li>✔ Upload reports</li>
              <li>✔ Track samples</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3652103/pexels-photo-3652103.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Pharmacy" />
            </div>
            <h3>💊 Pharmacy Module</h3>
            <p>Manage medicines, prescriptions, stock and sales records.</p>
            <ul>
              <li>✔ Inventory tracking</li>
              <li>✔ Prescription handling</li>
              <li>✔ Billing support</li>
            </ul>
          </div>
    
          <div class="module-card">
            <div class="module-image-small">
              <img src="https://images.pexels.com/photos/3825539/pexels-photo-3825539.jpeg?auto=compress&cs=tinysrgb&w=200" alt="Staff" />
            </div>
            <h3>👥 Staff Module</h3>
            <p>Manage staff roles, schedules and daily operational tasks.</p>
            <ul>
              <li>✔ Staff scheduling</li>
              <li>✔ Task management</li>
              <li>✔ Role control</li>
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
          <div class="about-card">🩺 Doctor Management</div>
          <div class="about-card">👥 Patient Records</div>
          <div class="about-card">🧪 Lab Reports</div>
          <div class="about-card">💊 Pharmacy & Billing</div>
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
    
            <div class="contact-item">📍 Bangalore, India</div>
            <div class="contact-item">📞 +91 9876543210</div>
            <div class="contact-item">📧 support@medicare.com</div>
            <div class="contact-item">⏰ Mon - Sat : 9 AM - 6 PM</div>
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
        function toggleDoctorFields() {
            var roleSelect = document.getElementById("registerRoleSelect");
            var doctorFields = document.getElementById("doctorFields");
            var phoneInput = document.getElementById("doctorPhone");
            var specInput = document.getElementById("doctorSpecialization");
            var expInput = document.getElementById("doctorExperience");
            var licInput = document.getElementById("doctorLicenseId");

            if (roleSelect.value === "Doctor") {
                doctorFields.style.display = "block";
                phoneInput.required = true;
                specInput.required = true;
                expInput.required = true;
                licInput.required = true;
            } else {
                doctorFields.style.display = "none";
                phoneInput.required = false;
                specInput.required = false;
                expInput.required = false;
                licInput.required = false;
            }
        }
    </script>
</body>
</html>
