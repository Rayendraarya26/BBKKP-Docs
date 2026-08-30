# 🚀 Panduan Setup Lokal — SIS `v2.1` & Polimer `v2.1_internal-system-migration`

> **Dokumen Onboarding untuk Developer**
> **Tanggal**: 30 Agustus 2026
> **Branch yang digunakan**:
> - `private-sis` → branch `v2.1`
> - `private-polimer` → branch `v2.1_internal-system-migration`

---

## 1. Prasyarat

| Komponen | Versi Minimum | Keterangan |
|----------|--------------|------------|
| **Docker Desktop** | 4.x+ | Wajib — kedua project berjalan dalam container |
| **Git** | 2.x+ | Untuk clone & checkout branch |
| **MySQL Client** (opsional) | 8.0+ | Untuk debug database dari host |

> [!IMPORTANT]
> Kedua project menggunakan **Docker Network eksternal** bernama `bbkkp_network`.
> Network ini harus dibuat **sekali** sebelum menjalankan kedua project.

---

## 2. Struktur Layanan & Port

Saat kedua project berjalan, berikut layanan yang aktif:

| Service | Container | Port Lokal | Database |
|---------|-----------|-----------|----------|
| **Polimer** (Portal Utama) | `private-polimer-private_polimer-1` | `http://localhost:4900` | `bbkkp_polimer` |
| **SIS** (Sertifikasi) | `private-sis-bbkkp_sis-1` | `http://localhost:4800` | `bbkkp_sis` |
| **MySQL** | `private-mysql` | `localhost:3308` (host) / `3306` (internal) | — |
| **MinIO** (Object Storage) | `private-minio` | Console: `localhost:9001`, S3 API: `localhost:9002` | — |

> [!NOTE]
> MySQL, MinIO, dan Docker Network semuanya di-manage oleh `docker-compose` milik **Polimer**.
> Oleh karena itu, **Polimer harus di-start terlebih dahulu** sebelum SIS.

---

## 3. Langkah Instalasi

### 3.1. Buat Docker Network (sekali saja)

```bash
docker network create bbkkp_network
```

### 3.2. Clone & Checkout Branch Polimer

```bash
git clone https://github.com/Rayendraarya26/private-polimer.git
cd private-polimer
git checkout v2.1_internal-system-migration
```

### 3.3. Clone & Checkout Branch SIS

```bash
git clone https://github.com/Rayendraarya26/private-sis.git
cd private-sis
git checkout v2.1
```

### 3.4. Konfigurasi Environment Polimer

```bash
cd private-polimer
cp .env.example .env
```

Edit `.env` Polimer, pastikan konfigurasi berikut:

```ini
# Database utama Polimer
DB_CONNECTION=mysql
DB_HOST=bbkkp_mysql
DB_PORT=3306
DB_DATABASE=bbkkp_polimer
DB_USERNAME=root
DB_PASSWORD=secret

# Koneksi ke database SIS (untuk bridging/integrasi)
DB_URL_SIS=mysql://root:secret@bbkkp_mysql:3306/bbkkp_sis

# MinIO / Object Storage (local)
AWS_ENDPOINT=http://private-minio:9000
AWS_ACCESS_KEY_ID=minioadmin
AWS_SECRET_ACCESS_KEY=miniopassword123
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=dev-polimer
AWS_USE_PATH_STYLE_ENDPOINT=true
AWS_ENABLED=false
```

> [!WARNING]
> `DB_HOST` harus `bbkkp_mysql` (nama container MySQL), **bukan** `127.0.0.1`.
> Hal ini karena aplikasi berjalan di dalam Docker container yang berkomunikasi via Docker Network.

### 3.5. Konfigurasi Environment SIS

```bash
cd private-sis
cp .env.example .env
```

Edit `.env` SIS:

```ini
APP_URL=http://localhost:4800

DB_CONNECTION=mysql
DB_HOST=bbkkp_mysql
DB_PORT=3306
DB_DATABASE=bbkkp_sis
DB_USERNAME=root
DB_PASSWORD=secret

DB2_CONNECTION=mysql
DB2_HOST=bbkkp_mysql
DB2_PORT=3306
DB2_DATABASE=bbkkp_sis_log
DB2_USERNAME=root
DB2_PASSWORD=secret

# SSO ke Polimer (disable untuk local)
SSO_IS_ENABLED=false
```

---

## 4. Menjalankan Project

### 4.1. Start Polimer (MySQL + MinIO + App)

```bash
cd private-polimer
docker compose up -d --build
```

Tunggu sampai semua container running, kemudian:

```bash
# Install dependensi PHP
docker exec private-polimer-private_polimer-1 composer install

# Generate app key
docker exec private-polimer-private_polimer-1 php artisan key:generate

# Buat database yang dibutuhkan di MySQL
docker exec private-mysql mysql -uroot -psecret -e "CREATE DATABASE IF NOT EXISTS bbkkp_polimer CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
docker exec private-mysql mysql -uroot -psecret -e "CREATE DATABASE IF NOT EXISTS bbkkp_sis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
docker exec private-mysql mysql -uroot -psecret -e "CREATE DATABASE IF NOT EXISTS bbkkp_sis_log CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Jalankan migrasi & seeder Polimer
docker exec private-polimer-private_polimer-1 php artisan migrate --seed

# Buat storage link
docker exec private-polimer-private_polimer-1 php artisan storage:link
```

### 4.2. Start SIS

```bash
cd private-sis
docker compose up -d --build
```

Kemudian:

```bash
# Install dependensi PHP
docker exec private-sis-bbkkp_sis-1 composer install

# Generate app key
docker exec private-sis-bbkkp_sis-1 php artisan key:generate

# Jalankan migrasi & seeder SIS
docker exec private-sis-bbkkp_sis-1 php artisan migrate --seed

# Buat storage link
docker exec private-sis-bbkkp_sis-1 php artisan storage:link
```

### 4.3. Sinkronisasi Data Polimer → SIS

Setelah **kedua** project berjalan dan database sudah ter-seed, jalankan perintah bridging:

```bash
docker exec private-polimer-private_polimer-1 php artisan integration:sync-sertifikasi-sis
```

Perintah ini akan mensinkronkan data permohonan sertifikasi dari Polimer ke SIS, termasuk:
- Data header permohonan (`sis_permohonan`)
- Detail permohonan (`sis_permohonan_detail`)
- Komoditi/item (`sis_permohonan_komoditi`)
- Data pabrik (`sis_permohonan_pabrik`)
- Status workflow dan pembayaran

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

> [!NOTE]
> Akun pelanggan di SIS dibuat secara otomatis oleh proses bridging saat menjalankan
> `php artisan integration:sync-sertifikasi-sis`. Akun tersebut menggunakan email
> dari data pelanggan Polimer.

---

## 6. Hal-Hal yang Perlu Diperhatikan

### 6.1. Urutan Start Wajib

```
1. Polimer (docker compose up)     → MySQL & MinIO hidup
2. SIS (docker compose up)         → konek ke MySQL via bbkkp_network
3. Sync bridging (artisan command) → data permohonan tersinkron
```

Jika SIS di-start sebelum Polimer, container SIS akan gagal konek ke database karena MySQL belum hidup.

### 6.2. Database Sharing

Kedua project menggunakan **satu MySQL instance** yang sama (`private-mysql`), namun dengan database berbeda:

| Database | Pemilik | Keterangan |
|----------|---------|------------|
| `bbkkp_polimer` | Polimer | Database utama portal Polimer |
| `bbkkp_sis` | SIS | Database sertifikasi, juga diakses oleh Polimer via koneksi `sis` |
| `bbkkp_sis_log` | SIS | Database log SIS |

> [!CAUTION]
> Polimer memiliki **akses tulis** ke database `bbkkp_sis` melalui koneksi `DB_URL_SIS`.
> Perubahan data di Polimer (terutama via bridging) akan langsung berdampak ke SIS.

### 6.3. Migrasi Database SIS Branch `v2.1`

Branch `v2.1` menyertakan **2 migration baru** yang menambahkan tabel dan kolom yang belum ada di database SIS legacy:

| Migration | Isi |
|-----------|-----|
| `2026_08_30_000000_create_missing_sis_tables.php` | Membuat tabel-tabel yang belum ada |
| `2026_08_30_000001_add_missing_columns_to_sis_tables.php` | Menambahkan kolom baru di 24 tabel existing |

Migration ini **idempotent** — menggunakan `Schema::hasTable()` dan `Schema::hasColumn()` sehingga aman dijalankan berulang.

### 6.4. Sidebar Navigation SIS

Branch `v2.1` memperbaiki bug sidebar SIS yang tidak berpindah halaman. Fix dilakukan di:
- `app/Http/Middleware/Authenticate.php` — Otomatis sinkronisasi permission menu (setAccess) setiap request
- `resources/views/layouts/component/renderMenu.blade.php` — Null safety pada menu children

### 6.5. Bridging Polimer ↔ SIS

Branch `v2.1_internal-system-migration` di Polimer memiliki service bridging di:
`Modules/Integration/app/Services/SisSyncBridgingService.php`

**Mapping status workflow Polimer → SIS:**

| Status Polimer | Status SIS |
|---------------|-----------|
| `DRAFT`, `PERMOHONAN`, `IN_REVIEW`, `PEMBAYARAN`, `PROCESS`, `REVISI` | `on-progress` |
| `DONE`, `SELESAI` | `accepted` |
| `DITOLAK`, `BATAL` | `rejected` |

**Mapping status bayar:**

| Status Polimer | Status SIS |
|---------------|-----------|
| `BELUM` | `proses` |
| `LUNAS` | `lunas` |
| `BATAL` | `batal` |

### 6.6. MinIO (Object Storage)

MinIO digunakan untuk menyimpan file dokumen (upload PDF, gambar, dsb). Untuk development lokal:

- **Console**: `http://localhost:9001`
- **User**: `minioadmin`
- **Password**: `miniopassword123`

Buat bucket `dev-polimer` secara manual di console MinIO jika belum ada.

### 6.7. Firebase Notification (Abaikan)

Saat membuka SIS/Polimer di browser, akan muncul error di console:
```
Messaging: The notification permission was not granted and blocked instead.
```
Error ini **bisa diabaikan** — hanya terjadi karena Firebase push notification tidak dikonfigurasi di lingkungan lokal.

---

## 7. Troubleshooting

### Container SIS tidak bisa konek database
```
SQLSTATE[HY000] [2002] Connection refused
```
**Solusi**: Pastikan Polimer sudah di-start terlebih dahulu (`docker compose up -d` di folder Polimer), karena MySQL berjalan di container milik Polimer.

### Error "Table doesn't exist" di SIS
**Solusi**: Jalankan migrasi:
```bash
docker exec private-sis-bbkkp_sis-1 php artisan migrate
```

### Data permohonan tidak muncul di SIS
**Solusi**: Jalankan ulang sinkronisasi:
```bash
docker exec private-polimer-private_polimer-1 php artisan integration:sync-sertifikasi-sis
```

### Sidebar SIS tidak berpindah halaman
**Solusi**: Pastikan branch `v2.1` sudah di-checkout dan container SIS sudah di-rebuild:
```bash
docker compose up -d --build
```

### MinIO bucket tidak ditemukan
**Solusi**: Akses MinIO console di `http://localhost:9001`, login, lalu buat bucket `dev-polimer`.

---

## 8. Quick Start (TL;DR)

```bash
# 1. Buat network
docker network create bbkkp_network

# 2. Start Polimer
cd private-polimer
git checkout v2.1_internal-system-migration
cp .env.example .env  # lalu edit sesuai panduan
docker compose up -d --build
docker exec private-polimer-private_polimer-1 composer install
docker exec private-polimer-private_polimer-1 php artisan key:generate
docker exec private-mysql mysql -uroot -psecret -e "CREATE DATABASE IF NOT EXISTS bbkkp_polimer;"
docker exec private-mysql mysql -uroot -psecret -e "CREATE DATABASE IF NOT EXISTS bbkkp_sis;"
docker exec private-mysql mysql -uroot -psecret -e "CREATE DATABASE IF NOT EXISTS bbkkp_sis_log;"
docker exec private-polimer-private_polimer-1 php artisan migrate --seed
docker exec private-polimer-private_polimer-1 php artisan storage:link

# 3. Start SIS
cd ../private-sis
git checkout v2.1
cp .env.example .env  # lalu edit sesuai panduan
docker compose up -d --build
docker exec private-sis-bbkkp_sis-1 composer install
docker exec private-sis-bbkkp_sis-1 php artisan key:generate
docker exec private-sis-bbkkp_sis-1 php artisan migrate --seed
docker exec private-sis-bbkkp_sis-1 php artisan storage:link

# 4. Sinkronisasi data
docker exec private-polimer-private_polimer-1 php artisan integration:sync-sertifikasi-sis

# 5. Buka di browser
# Polimer: http://localhost:4900
# SIS:     http://localhost:4800
```
