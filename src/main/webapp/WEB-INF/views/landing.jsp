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
                <li><a href="#roles">Modules</a></li>
                <li><a href="#stats">How It Works</a></li>
                <li><a href="#footer">About Us</a></li>
                <li><a href="#footer">Contact</a></li>
            </ul>
        </nav>
        <div class="header-actions">
            <a href="#login-section" class="btn-get-started">Get Started</a>
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

                <div class="hero-features" id="features">
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

            <!-- Center - Clinic Building Illustration (Pure CSS) -->
            <div class="hero-center">
                <div class="clinic-building-css">
                    <div class="building-top">
                        <div class="building-cross">+</div>
                    </div>
                    <div class="building-main">
                        <div class="building-name">MediCare+</div>
                        <div class="building-windows">
                            <div class="window"></div>
                            <div class="window"></div>
                            <div class="window"></div>
                            <div class="window"></div>
                            <div class="window"></div>
                            <div class="window"></div>
                        </div>
                        <div class="building-door"></div>
                    </div>
                    <div class="building-trees">
                        <div class="tree"><div class="tree-top"></div><div class="tree-trunk"></div></div>
                        <div class="tree"><div class="tree-top"></div><div class="tree-trunk"></div></div>
                    </div>
                </div>
            </div>

            <!-- Right Side - Login Card -->
            <div class="hero-right" id="login-section">
                <div class="login-card">
                    <h3>Welcome Back!</h3>
                    <p class="subtitle">Login to access your dashboard</p>

                    <!-- Flash Messages -->
                    <c:if test="${not empty loginError}">
                        <div class="alert alert-error">${loginError}</div>
                    </c:if>
                    <c:if test="${not empty registerSuccess}">
                        <div class="alert alert-success">${registerSuccess}</div>
                    </c:if>

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

                    <div class="or-divider">OR</div>

                    <a href="#register-section">
                        <button type="button" class="btn-create-account">&#x1F464; Create New Account</button>
                    </a>
                </div>
            </div>

        </div>
    </section>

    <!-- ==================== MODULES SECTION ==================== -->
    <section class="login-as-section" id="roles">
        <div class="section-header">
            <div class="section-dot"></div>
            <h2>Our Modules</h2>
            <p>Powerful tools for every role in your clinic</p>
        </div>

        <div class="roles-grid">

            <div class="role-card">
                <div class="role-icon doctor">&#x1FA7A;</div>
                <h4>Doctor</h4>
                <p>Manage appointments, patients and prescriptions.</p>
            </div>
            <div class="role-card">
                <div class="role-icon receptionist">&#x1F4CB;</div>
                <h4>Receptionist</h4>
                <p>Handle appointments, registrations and check-ins.</p>
            </div>
            <div class="role-card">
                <div class="role-icon patient">&#x1F9D1;</div>
                <h4>Patient</h4>
                <p>Book appointments, view reports and history.</p>
            </div>
            <div class="role-card">
                <div class="role-icon lab">&#x1F9EA;</div>
                <h4>Lab</h4>
                <p>Manage test requests, reports and samples.</p>
            </div>
            <div class="role-card">
                <div class="role-icon pharmacy">&#x1F48A;</div>
                <h4>Pharmacy</h4>
                <p>Manage medicines, stock, prescriptions and sales.</p>
            </div>
            <div class="role-card">
                <div class="role-icon staff">&#x1F465;</div>
                <h4>Staff</h4>
                <p>Manage daily tasks, schedules and operations.</p>
            </div>
        </div>
    </section>

    <!-- ==================== REGISTER SECTION ==================== -->
    <section class="register-section" id="register-section">
        <div class="register-container">
            <div class="register-card">
                <h3>Create New Account</h3>
                <p class="subtitle">Register to get started</p>

                <c:if test="${not empty registerError}">
                    <div class="alert alert-error">${registerError}</div>
                </c:if>

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
                        <input type="password" name="password" class="form-input" placeholder="Password" required>
                    </div>
                    <div class="form-group">
                        <span class="input-icon">&#x1F512;</span>
                        <input type="password" name="confirmPassword" class="form-input" placeholder="Confirm Password" required>
                    </div>
                    <div class="form-group">
                        <span class="input-icon">&#x1F464;</span>
                        <select name="role" class="form-select" required>
                            <option value="" disabled selected>Select Role</option>
                            <option value="Admin">Admin</option>
                            <option value="Doctor">Doctor</option>
                            <option value="Receptionist">Receptionist</option>
                            <option value="Patient">Patient</option>
                            <option value="Lab">Lab</option>
                            <option value="Pharmacy">Pharmacy</option>
                            <option value="Staff">Staff</option>
                        </select>
                    </div>
                    <div class="terms-row">
                        <input type="checkbox" name="terms" required>
                        <span>I agree to the <a href="#">Terms &amp; Conditions</a></span>
                    </div>
                    <button type="submit" class="btn-register">Register &#x27A1;</button>
                </form>

                <div class="login-link">
                    Already have an account? <a href="#login-section">Login</a>
                </div>
            </div>
        </div>
    </section>

    <!-- ==================== STATS SECTION ==================== -->
    <section class="stats-section" id="stats">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">&#x1F46B;</div>
                <h3>500+</h3>
                <p>Happy Users</p>
            </div>
            <div class="stat-card">
                <div class="stat-icon">&#x1F3E5;</div>
                <h3>50+</h3>
                <p>Clinics Managed</p>
            </div>
            <div class="stat-card">
                <div class="stat-icon">&#x1F9EA;</div>
                <h3>10K+</h3>
                <p>Lab Tests Processed</p>
            </div>
            <div class="stat-card">
                <div class="stat-icon">&#x1F4C5;</div>
                <h3>20K+</h3>
                <p>Appointments</p>
            </div>
            <div class="stat-card">
                <div class="stat-icon">&#x1F6E1;</div>
                <h3>99.9%</h3>
                <p>Uptime &amp; Secure</p>
            </div>
        </div>
    </section>

    <!-- ==================== FOOTER ==================== -->
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

</body>
</html>
