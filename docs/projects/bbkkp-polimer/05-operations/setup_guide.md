# ⚙️ Setup & Onboarding Guide — BBKKP Polimer
## Panduan Instalasi dan Konfigurasi Lingkungan Pengembangan Lokal

> **Project**: `bbkkp-polimer`  
> **Repositori**: `Rayendraarya26/private-polimer` (Private) / `bakulkapas/bbkkp-polimer` (Upstream)  
> **Target Stack**: PHP 8.2+, Laravel 10+, MySQL 8.0+, Node.js 18+, Redis

---

## 1. Prasyarat Perangkat Lunak (Prerequisites)

Sebelum melakukan clone dan instalasi project, pastikan perangkat komputer lokal Anda telah terinstall:
* **PHP** >= 8.2 (dengan ekstensi `pdo_mysql`, `mbstring`, `openssl`, `curl`, `gd`, `zip`, `xml`)
* **Composer** >= 2.5
* **MySQL** >= 8.0 / MariaDB >= 10.6
* **Node.js** >= 18.x & **NPM** >= 9.x
* **Redis Server** (Opsional untuk Queue/Cache lokal)
* **Git** CLI

---

## 2. Langkah-Langkah Instalasi Lokal

### Langkah 1: Clone Repositori (Dual-Remote)
```bash
# Clone dari repo private Anda
git clone https://github.com/Rayendraarya26/private-polimer.git bbkkp-polimer
cd bbkkp-polimer

# Tambahkan upstream repo resmi BBKKP
git remote rename origin upstream
git remote add origin https://github.com/Rayendraarya26/private-polimer.git
```

### Langkah 2: Install Dependensi PHP & Node.js
```bash
# Install paket PHP via Composer
composer install

# Install paket Frontend via NPM
npm install
```

### Langkah 3: Konfigurasi Environment (`.env`)
```bash
# Salin file contoh environment
cp .env.example .env

# Generate Application Encryption Key
php artisan key:generate
```

Buka file `.env` di VS Code / editor pilihan Anda, lalu sesuaikan konfigurasi database:
```ini
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bbkkp_polimer
DB_USERNAME=root
DB_PASSWORD=
```

### Langkah 4: Migrasi Database & Seeder
Pastikan database MySQL bernama `bbkkp_polimer` telah dibuat di MySQL lokal Anda, kemudian jalankan:
```bash
# Jalankan migrasi tabel dan data awal
php artisan migrate --seed
```

### Langkah 5: Storage Symlink
```bash
# Buat link direktori storage publik untuk gambar/dokumen
php artisan storage:link
```

### Langkah 6: Jalankan Server Lokal
Di terminal 1 (Laravel Dev Server):
```bash
php artisan serve
```

Di terminal 2 (Asset Bundler / Vite):
```bash
npm run dev
```

Aplikasi `bbkkp-polimer` sekarang dapat diakses melalui browser di **`http://127.0.0.1:8000`**.

---

## 3. Jalankan Background Queue Worker (Opsional)
Jika Anda menguji pengiriman notifikasi WhatsApp atau integrasi background job:
```bash
php artisan queue:work --queue=default,notifications,pdf-signing
```
