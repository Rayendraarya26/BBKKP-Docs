# ⚙️ Setup & Onboarding Guide — BBKKP SIS (Legacy)
## Panduan Instalasi dan Pengaturan Database Legacy BBKKP SIS

> **Project**: `bbkkp-sis`  
> **Repositori**: `Rayendraarya26/private-sis` (Private) / `bakulkapas/bbkkp-sis` (Upstream)  
> **Target Stack**: PHP 7.4 / 8.0+, MySQL 5.7 / 8.0+

---

## 1. Pendahuluan

Aplikasi **BBKKP SIS** adalah sistem informasi sertifikasi legacy yang menyimpan data historis pelanggan, sertifikat aktif masa lalu, dan transaksi permohonan lama.

Setiap engineer yang bertugas mengurus migrasi atau integrasi perlu menginstall `bbkkp-sis` di lingkungan lokal untuk keperluan pengujian dan pembacaan skema database legacy.

---

## 2. Langkah-Langkah Instalasi Lokal

### Langkah 1: Clone Repositori
```bash
git clone https://github.com/Rayendraarya26/private-sis.git bbkkp-sis
cd bbkkp-sis

# Tambahkan upstream repo resmi BBKKP
git remote rename origin upstream
git remote add origin https://github.com/Rayendraarya26/private-sis.git
```

### Langkah 2: Install Dependensi PHP
```bash
composer install
```

### Langkah 3: Import Dump Database SIS Legacy
1. Buat database baru di MySQL lokal bernama `bbkkp_sis`:
   ```sql
   CREATE DATABASE bbkkp_sis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
2. Import file dump SQL legacy (`database/dumps/bbkkp_sis_schema.sql` atau file dump terbaru):
   ```bash
   mysql -u root -p bbkkp_sis < database/dumps/bbkkp_sis_schema.sql
   ```

### Langkah 4: Konfigurasi `.env`
```bash
cp .env.example .env
php artisan key:generate
```

Sesuaikan koneksi DB pada `.env`:
```ini
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bbkkp_sis
DB_USERNAME=root
DB_PASSWORD=
```

### Langkah 5: Jalankan Server Lokal
```bash
php artisan serve --port=8001
```
Aplikasi SIS legacy berjalan di **`http://127.0.0.1:8001`**.
