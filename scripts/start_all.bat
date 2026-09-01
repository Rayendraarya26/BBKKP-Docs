@echo off
title BBKKP Local Services Launcher
echo ========================================================
echo   Memulai Layanan Lokal BBKKP (Non-Docker)
echo ========================================================
echo.

echo [1/3] Menjalankan MinIO Object Storage...
start "MinIO Server" cmd /c "%~dp0start_minio.bat"
timeout /t 3 /nobreak >nul

echo [2/3] Menjalankan Polimer Web Portal (Port 4900)...
start "Polimer Server" cmd /c "%~dp0start_polimer.bat"
timeout /t 2 /nobreak >nul

echo [3/3] Menjalankan SIS Sertifikasi (Port 4800)...
start "SIS Server" cmd /c "%~dp0start_sis.bat"

echo.
echo ========================================================
echo   Semua layanan berhasil dijalankan!
echo.
echo   * Polimer Portal : http://localhost:4900
echo   * SIS Portal     : http://localhost:4800
echo   * MinIO Console  : http://localhost:9001
echo   * MinIO S3 API   : http://localhost:9002
echo ========================================================
echo.
echo Tutup jendela masing-masing terminal untuk menghentikan service.
pause
