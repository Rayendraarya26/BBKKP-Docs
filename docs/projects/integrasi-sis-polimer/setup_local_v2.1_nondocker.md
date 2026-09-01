# 🚀 Panduan Setup Lokal — SIS `v2.1` & Polimer `v2.1_internal-system-migration` (Non-Docker / Native Windows)

> **Dokumen Panduan Alternatif Non-Docker**  
> **Tanggal**: 31 Agustus 2026  
> **Branch**:
> - `private-sis` → branch `v2.1`
> - `private-polimer` → branch `v2.1_internal-system-migration`

---

## 1. Ringkasan Arsitektur Non-Docker

Panduan ini digunakan jika environment sistem operasi tidak memungkinkan untuk menginstal **Docker Desktop**. Seluruh service berjalan secara **Native / Standalone** di Windows host.

| Layanan | Binary / Runtime | Host & Port | Keterangan |
|---------|------------------|-------------|------------|
| **Polimer** | PHP 8.3 CLI (`artisan serve`) | `http://localhost:4900` | Web Portal Utama |
| **SIS** | PHP 8.3 CLI (`artisan serve`) | `http://localhost:4800` | Web Sertifikasi |
| **MySQL Server** | Windows Service `MySQL80` | `127.0.0.1:3306` | Database: `bbkkp_polimer`, `bbkkp_sis`, `bbkkp_sis_log` |
| **MinIO API** | `minio.exe` standalone | `http://localhost:9002` | S3 API endpoint (Bucket: `dev-polimer`) |
| **MinIO Console** | `minio.exe` Web UI | `http://localhost:9001` | Management GUI (`minioadmin` / `miniopassword123`) |

---

## 2. Cara Menjalankan Layanan (Sekali Klik)

Tersedia skrip batch di folder `BBKKP-Docs/scripts/` untuk kemudahan:

1. **Jalankan Semua Layanan Sekaligus**:
   - Double-click [`BBKKP-Docs/scripts/start_all.bat`](file:///f:/!Productive/BBKKP/BBKKP-Docs/scripts/start_all.bat)
   - Skrip akan otomatis membuka 3 jendela terminal terpisah untuk **MinIO**, **Polimer (4900)**, dan **SIS (4800)**.

2. **Jalankan Layanan Tertentu**:
   - MinIO: [`BBKKP-Docs/scripts/start_minio.bat`](file:///f:/!Productive/BBKKP/BBKKP-Docs/scripts/start_minio.bat)
   - Polimer: [`BBKKP-Docs/scripts/start_polimer.bat`](file:///f:/!Productive/BBKKP/BBKKP-Docs/scripts/start_polimer.bat)
   - SIS: [`BBKKP-Docs/scripts/start_sis.bat`](file:///f:/!Productive/BBKKP/BBKKP-Docs/scripts/start_sis.bat)

3. **Menghentikan Layanan**:
   - Tutup jendela terminal masing-masing, atau jalankan [`BBKKP-Docs/scripts/stop_all.bat`](file:///f:/!Productive/BBKKP/BBKKP-Docs/scripts/stop_all.bat).

---

## 3. Konfigurasi Environment (`.env`)

### 3.1. Polimer (`private-polimer/.env`)
```ini
APP_URL=http://localhost:4900

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bbkkp_polimer
DB_USERNAME=root
DB_PASSWORD=

# Bridging ke database SIS
DB_URL_SIS=mysql://root:@127.0.0.1:3306/bbkkp_sis

# MinIO Local
AWS_ENDPOINT=http://127.0.0.1:9002
AWS_ACCESS_KEY_ID=minioadmin
AWS_SECRET_ACCESS_KEY=miniopassword123
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=dev-polimer
AWS_USE_PATH_STYLE_ENDPOINT=true
AWS_ENABLED=false
```

### 3.2. SIS (`private-sis/.env`)
```ini
APP_URL=http://localhost:4800

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bbkkp_sis
DB_USERNAME=root
DB_PASSWORD=

DB2_CONNECTION=mysql
DB2_HOST=127.0.0.1
DB2_PORT=3306
DB2_DATABASE=bbkkp_sis_log
DB2_USERNAME=root
DB2_PASSWORD=

SSO_IS_ENABLED=false
```

### 3.3. Instalasi Dependensi Frontend SIS (Wajib Sekali Saja)
Template web SIS memerlukan library JavaScript & CSS (jQuery, Bootstrap, Moment, SweetAlert, dll.) yang tersimpan di dalam folder `public/`:
```bash
cd private-sis/public
npm install --legacy-peer-deps
```
> [!NOTE]
> Dependensi asset frontend SIS didefinisikan pada `private-sis/public/package.json` dan dimuat oleh layout SIS melalui path `public/node_modules/`.

---

## 4. Sinkronisasi Data Bridging (Polimer ↔ SIS)

Untuk menyinkronkan data permohonan sertifikasi dari Polimer ke SIS:
```bash
cd private-polimer
php artisan integration:sync-sertifikasi-sis
```

---

## 5. Akun Login Testing

### Polimer (`http://localhost:4900`)
| Role | Email | Password |
|------|-------|----------|
| Root / Admin | `dolkode@mailinator.com` | `password` |
| Marketing | `marketing@mailinator.com` | `password` |
| Pelanggan (Perusahaan) | `perusahaan@mailinator.com` | `password` |
| Pelanggan (Perorangan) | `perorangan@mailinator.com` | `password` |
| Bendahara | `bendahara@mailinator.com` | `password` |

### SIS (`http://localhost:4800`)
| Role | Email | Password |
|------|-------|----------|
| Root / Admin | `kemal@mailinator.com` | `2104` |

---

## 6. MinIO Management Console

- **URL**: `http://localhost:9001`
- **Username**: `minioadmin`
- **Password**: `miniopassword123`
- **Bucket**: `dev-polimer`
