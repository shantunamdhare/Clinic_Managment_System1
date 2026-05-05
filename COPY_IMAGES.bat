@echo off
echo Finalizing Hero Background...

set "SRC=C:\Users\shant\.gemini\antigravity\brain\c22a9af4-38d6-44b2-908b-4a2094310a35"
set "PROJECT_ROOT=d:\Clinic Managemet System\Clinic_Managment_Sytem"

:: Copy the exact clinic building image to the root static folder as clinic-bg.jpg
echo Copying clinic background...
copy "%SRC%\ai_clinic_hero_ultra_hd_1777888574141.png" "%PROJECT_ROOT%\src\main\resources\static\clinic-bg.jpg" /Y
copy "%SRC%\ai_clinic_hero_ultra_hd_1777888574141.png" "%PROJECT_ROOT%\target\classes\static\clinic-bg.jpg" /Y

echo.
echo Hero background image saved as clinic-bg.jpg.
echo Please Refresh your browser (localhost:8080).
pause
