@echo off
set "TARGET=src\main\resources\static"
echo Creating directory %TARGET%...
if not exist "%TARGET%" mkdir "%TARGET%"

echo Downloading Ultra HD Medical Images...

echo [1/8] Doctor...
curl -L -o "%TARGET%\doctor.jpg" "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=100&w=1200&auto=format&fit=crop"

echo [2/8] Receptionist...
curl -L -o "%TARGET%\receptionist.jpg" "https://images.unsplash.com/photo-1516549655169-df83a0774514?q=100&w=1200&auto=format&fit=crop"

echo [3/8] Patient...
curl -L -o "%TARGET%\patient.jpg" "https://images.unsplash.com/photo-1505751172876-fa1923c5c528?q=100&w=1200&auto=format&fit=crop"

echo [4/8] Lab...
curl -L -o "%TARGET%\lab.jpg" "https://images.unsplash.com/photo-1581093458791-9f3c3250bb8b?q=100&w=1200&auto=format&fit=crop"

echo [5/8] Pharmacy...
curl -L -o "%TARGET%\pharmacy.jpg" "https://images.unsplash.com/photo-1587854692152-cbe660dbbb88?q=100&w=1200&auto=format&fit=crop"

echo [6/8] Staff...
curl -L -o "%TARGET%\staff.jpg" "https://images.unsplash.com/photo-1576091160550-2173bdd99802?q=100&w=1200&auto=format&fit=crop"

echo [7/8] Hero Background...
curl -L -o "%TARGET%\clinic-building.jpg" "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=100&w=2560&auto=format&fit=crop"

echo [8/8] Stats Background...
curl -L -o "%TARGET%\clinic-bg.jpg" "https://images.unsplash.com/photo-1516549655169-df83a0774514?q=100&w=1600&auto=format&fit=crop"

echo.
echo All Ultra HD images downloaded successfully!
echo Please refresh your browser (localhost:8080).
pause
