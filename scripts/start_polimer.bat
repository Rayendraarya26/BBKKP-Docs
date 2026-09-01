@echo off
title Polimer Server (Port 4900)
echo ==============================================
echo   Polimer Web Portal - BBKKP Local
echo   URL: http://localhost:4900
echo ==============================================
cd /d "F:\!Productive\BBKKP\private-polimer"
php artisan serve --host=127.0.0.1 --port=4900
pause
