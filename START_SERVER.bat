@echo off
title MediCare+ Clinic Management System
color 0A
echo.
echo ============================================
echo   MediCare+ Clinic Management System
echo   Starting Spring Boot Server...
echo ============================================
echo.

cd /d "%~dp0"

echo Checking Java installation...
java -version 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Java is not installed or not in PATH!
    echo Please install Java 17 or higher.
    pause
    exit /b 1
)

echo.
echo Starting application...
echo Once started, open: http://localhost:8080
echo Press Ctrl+C to stop the server.
echo.
call mvnw.cmd spring-boot:run -DskipTests

pause
