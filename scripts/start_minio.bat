@echo off
title MinIO Object Storage (Port 9002 / Console 9001)
echo ==============================================
echo   MinIO Object Storage - BBKKP Local
echo   Console: http://localhost:9001
echo   S3 API : http://localhost:9002
echo   User   : minioadmin
echo   Pass   : miniopassword123
echo ==============================================
set MINIO_ROOT_USER=minioadmin
set MINIO_ROOT_PASSWORD=miniopassword123
cd /d "F:\!Productive\BBKKP\minio"
"F:\!Productive\BBKKP\minio\minio.exe" server "F:\!Productive\BBKKP\minio\data" --address :9002 --console-address :9001
pause
