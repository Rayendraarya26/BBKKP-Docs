# Deployment & Operations Guide - BBKKP Internal Service
## Panduan Instalasi, Konfigurasi Lingkungan, Containerization, dan Pemeliharaan

> **Status**: Operational Runbook  
> **Container Engine**: Docker / Docker Compose + Laravel Octane (FrankenPHP)  
> **Default Port**: `10020`

---

## 1. Prasyarat Sistem

* **PHP Runtime**: PHP 8.2+ dengan ekstensi `pdo_mysql`, `curl`, `fileinfo`, `zip`, `pcntl`, `posix`, `intl`, `mbstring`.
* **Database Engine**: MySQL 8.0+ / MariaDB 10.6+.
* **Storage Engine**: S3-compatible Object Storage (MinIO lokal atau AWS S3).
* **Container Environment**: Docker 24.0+ & Docker Compose v2.

---

## 2. Konfigurasi Environment (`.env`)

Salin file template `.env.example` menjadi `.env` dan lengkapi variabel berikut:

```dotenv
APP_NAME=InternalService
APP_ENV=production
APP_DEBUG=false
APP_PORT=10020
APP_URL=http://127.0.0.1:10020

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bbkkp_esign
DB_USERNAME=root
DB_PASSWORD=secret

# S3 Object Storage Configuration
AWS_ENDPOINT=https://storage.bbkkp.kemenperin.go.id
AWS_ACCESS_KEY_ID=your_s3_access_key
AWS_SECRET_ACCESS_KEY=your_s3_secret_key
AWS_DEFAULT_REGION=s3
AWS_BUCKET=dev-esign
AWS_USE_PATH_STYLE_ENDPOINT=false

# Octane & Server
OCTANE_SERVER=frankenphp

# BSrE Authority Server Credentials
BSRE_HOST=http://10.1.0.243
BSRE_USERNAME=BBSPJIKKP
BSRE_PASSWORD=your_bsre_official_password

# Queue Connection
QUEUE_CONNECTION=database
```

---

## 3. Langkah Instalasi & Migrasi

### A. Menjalankan secara Lokal / Standalone
```bash
# 1. Install dependensi composer
composer install --no-dev --optimize-autoloader

# 2. Generate application key
php artisan key:generate

# 3. Jalankan migrasi tabel layanan dan esign
php artisan migrate --force

# 4. Jalankan server Octane FrankenPHP
php artisan octane:start --server=frankenphp --port=10020 --host=0.0.0.0
```

### B. Menjalankan via Docker Compose
Pastikan jaringan eksternal `bbkkp_network` telah dibuat:
```bash
docker network create bbkkp_network || true
docker compose up -d --build
```

---

## 4. Konfigurasi Client Service (Registrasi API Key)

Sebelum aplikasi seperti **Polimer**, **SIL**, atau **PUK** dapat menggunakan Internal Service, buat rekaman di tabel `layanan`:

```sql
INSERT INTO `layanan` (`id`, `name`, `api_key`, `created_at`, `updated_at`)
VALUES 
  (UUID(), 'POLIMER', 'sec_polimer_bbkkp_2026_x871', NOW(), NOW()),
  (UUID(), 'SIL', 'sec_sil_bbkkp_2026_a129', NOW(), NOW()),
  (UUID(), 'PUK', 'sec_puk_bbkkp_2026_m451', NOW(), NOW()),
  (UUID(), 'SIS', 'sec_sis_bbkkp_2026_c882', NOW(), NOW());
```

---

## 5. Menjalankan Background Queue Worker

Background queue menangani job `ExtractEsignDetail` untuk mengekstrak metadata audit trail dari BSrE.

### Menjalankan via Supervisor / Daemon:
Konfigurasikan Supervisor `/etc/supervisor/conf.d/bbkkp-internal-worker.conf`:
```ini
[program:bbkkp-internal-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/html/artisan queue:work --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/log/supervisor/bbkkp-internal-worker.log
```

---

## 6. Binary Helper: PDF Stamping Tool (`marker`)

Repositori dilengkapi dengan utilitas CLI `marker` (`markpdf`) untuk pembubuhan teks/tanda digital visual pada berkas PDF sebelum ditandatangani:

```bash
./marker "input.pdf" "Dokumen ini telah ditandatangani secara digital oleh Balai Besar Kulit, Karet, dan Plastik" "output.pdf" --offset-x=20 --offset-y=-20 --font-size=10.0
```

---

## 7. Pemantauan & Health Check

* **Cek Status Service**: `curl -I http://localhost:10020/`
* **Log Error & Transaksi**: `storage/logs/laravel-{Y-m-d}.log`
* **Pembersihan Cache Framework**:
  ```bash
  php artisan optimize:clear
  ```
