@echo off
title Polimer Schedule & Queue Worker
echo ========================================================
echo   Menjalankan Polimer Scheduler & Queue Worker
echo ========================================================
cd /d "f:\!Productive\BBKKP\private-polimer"
php artisan schedule:work
pause
