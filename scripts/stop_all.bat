@echo off
title BBKKP Stop All Services
echo Menghentikan proses MinIO dan PHP Artisan Serve...
taskkill /F /IM minio.exe /T 2>nul
taskkill /F /IM php.exe /FI "WINDOWTITLE eq Polimer Server*" 2>nul
taskkill /F /IM php.exe /FI "WINDOWTITLE eq SIS Server*" 2>nul
echo Selesai.
pause
