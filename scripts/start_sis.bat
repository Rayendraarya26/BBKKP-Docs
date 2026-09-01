@echo off
title SIS Server (Port 4800)
echo ==============================================
echo   SIS Sertifikasi - BBKKP Local
echo   URL: http://localhost:4800
echo ==============================================
cd /d "F:\!Productive\BBKKP\private-sis"
php artisan serve --host=127.0.0.1 --port=4800
pause
