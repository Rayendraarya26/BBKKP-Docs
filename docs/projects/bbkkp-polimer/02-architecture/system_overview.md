# Dokumentasi Komprehensif Repositori BBKKP Polimer

> **Portal Utama Pelanggan Balai Besar Kulit, Karet, dan Plastik (BBKKP)**  
> **Kementerian Perindustrian Republik Indonesia**

---

## 1. Ringkasan Eksekutif

**BBKKP Polimer** adalah sistem aplikasi web berbasis **Laravel 11** dan **React 18 (TypeScript)** yang berfungsi sebagai portal utama layanan publik dan internal bagi Balai Besar Kulit, Karet, dan Plastik (BBKKP), Kementerian Perindustrian RI.

Sistem ini mengintegrasikan seluruh workflow layanan publik—mulai dari pendaftaran akun pelanggan, pengajuan permohonan layanan (Pengujian Laboratorium, Pelatihan/Bimtek, Sertifikasi/LSP, Bimtek Halal), pelacakan permohonan (*tracking*), proses verifikasi dan persetujuan internal, penagihan/pembayaran (Invoice & Kuitansi), hingga penerbitan sertifikat/dokumen digital ber-**TTE (Tanda Tangan Elektronik)**.

---

## 2. Arsitektur & Teknologi Stack

### 2.1 Technology Stack Summary

| Komponen | Teknologi / Library Utama | Keterangan |
| :--- | :--- | :--- |
| **Backend Framework** | PHP 8.2+, Laravel 11.9 | Framework PHP modern dengan arsitektur modular |
| **Modular Engine** | `nwidart/laravel-modules` (v11) | Pemisahan kode menjadi 7 modul domain-driven |
| **Frontend SPA** | React 18, TypeScript, Vite 5.3 | Digunakan untuk portal pelanggan (`/app`) dan admin live UI |
| **Styling & UI Kit** | Tailwind CSS 3.4, PostCSS, Lucide Icons | Antarmuka kustom terpadu (AppShell, AdminShell, Modal, DataTable, Card) |
| **Data Fetching & Cache** | TanStack React Query (`@tanstack/react-query`) | Optimistic updates, background revalidation, & unified cache layer |
| **Form & Validation** | `react-hook-form`, `yup`, `@hookform/resolvers` | Manajemen validasi form multi-step wizard & dynamic items |
| **Database Primary** | MySQL / MariaDB (`bbkkp_polimer`) | Database utama portal |
| **Legacy Multi-DB** | `bbkkp_sis`, `apps`, `puk`, `sil` | Koneksi ke DB SIS Legacy, Pelatihan, Lab, & Sertifikasi |
| **Payment Gateway** | BNI e-Collection Virtual Account | Double XOR encryption, webhook idempotency, & async queue |
| **Electronic Signature** | HTTP Client ➡️ `bbkkp-internal-service` | FrankenPHP Octane (Port 10020) + BSrE BSSN Engine & MD5 Checksum |
| **PDF Engine** | `barryvdh/laravel-dompdf` | Generasi dokumen Invoice, Kuitansi ber-QR, & Sertifikat TTE |
| **Queue & Worker** | Redis (`phpredis`) | Pemrosesan background invoice, kuitansi, & notifikasi async |
| **Object Storage** | `league/flysystem-aws-s3-v3` (S3 / MinIO) | Storage berkas digital (`storage.bbkkp.kemenperin.go.id`) |
| **Error Tracking** | Sentry (`sentry/sentry-laravel`) | Tracking log error server & trace performa transaksi |
| **Notifikasi & OTP** | WhatsApp Cast API & Web Notification | Pengiriman OTP login, status VA, & progress workflow |

---

## 3. Struktur Direktori & Modul (Laravel Modules)

Aplikasi ini mengadopsi pola arsitektur **Modular (Domain-Driven Structure)** dengan `nwidart/laravel-modules`. Setiap modul memiliki controller, model, route, view, dan komponen asset tersendiri.

```
bbkkp-polimer/
├── app/                        # Modul Inti Framework (Models, Helpers, Enums, Middleware)
│   ├── Enums/                  # Enum PHP untuk status & tipe data
│   ├── Helpers/                # Custom helper functions (`helpers.php`)
│   ├── Http/Middleware/        # Middleware global (CustomAuth, Restriction, SentryContext)
│   └── Models/                 # Eloquent Models (Db1, Db2, Passport)
├── config/                     # Konfigurasi aplikasi & database
├── database/                   # Migrasi & Seeder Database (33+ File Migrasi)
├── Modules/                    # 7 Modul Utama Aplikasi
│   ├── Admin/                  # Pengelolaan CMS, Banner, FAQ, Contact Us, Order Review
│   ├── Auth/                   # Login, Register, Forget Password, Email Verification
│   ├── Eksternal/              # Portal Pelanggan Public & React SPA (`/app`, REST API)
│   ├── Home/                   # Dashboard Staff Internal, Profil, & Security
│   ├── Integration/            # Endpoint API Integrasi Eksternal (API Key Protected)
│   ├── Permohonan/             # Workflow Internal (Approval, Revisi, Invoice, Kuitansi, TTE)
│   └── System/                 # Manajemen RBAC (User, Group/Role, Menu, Menu Action)
├── public/                     # Static assets & entry point (`index.php`)
├── resources/                  # Common Blade views & global layout assets
├── routes/                     # Master route files
├── vite.config.js              # Build bundler Vite
└── composer.json / package.json
```

---

## 4. Rincian 7 Modul Utama

```mermaid
graph TD
    User([Pengguna / Pelanggan]) -->|Akses Public & React SPA| ModEksternal[Modules/Eksternal]
    User -->|Autentikasi & Registrasi| ModAuth[Modules/Auth]
    
    Staff([Staff Internal / Admin]) -->|Dashboard Staff| ModHome[Modules/Home]
    Staff -->|Manajemen Permohonan & Invoice| ModPermohonan[Modules/Permohonan]
    Staff -->|Pengelolaan CMS & Portal| ModAdmin[Modules/Admin]
    Admin([Super Admin]) -->|RBAC & Akses Menu| ModSystem[Modules/System]

    ExtApp([Sistem Eksternal Pihak Ke-3]) -->|API Key Protected| ModIntegration[Modules/Integration]
```

### 4.1. Modul Auth (`Modules/Auth`)
* **Tujuan**: Mengelola siklus hidup autentikasi pengguna (pelanggan & internal).
* **Fitur Utama**:
  * Login Pengguna (`LoginController.php`)
  * Registrasi Akun Pelanggan Baru (`RegisterController.php`)
  * Lupa Kata Kunci & Reset Password (`ForgetPasswordController.php`)
  * Verifikasi Email (`VerificationController.php`)
  * Fitur Beralih Role / Switch Role (`switchRole`)

### 4.2. Modul Eksternal (`Modules/Eksternal`)
* **Tujuan**: Portal utama publik pelanggan, landing page, dan aplikasi React Single Page Application (SPA) di rute `/app`.
* **Fitur Utama**:
  * Landing page publik (`/`), FAQ (`/faq`), Tracking Permohonan (`/tracking/permohonan`), Verifikasi Dokumen TTE (`/tte/verify`).
  * API Eksternal (`/api/eksternal/*`):
    * Form Pendaftaran Pelatihan / Bimtek Halal (`PelatihanController`, `BimtekController`)
    * Form Pendaftaran Sertifikasi LSP / Transformasi Industri (`LSPController`)
    * Manajemen Profil Pelanggan & OTP WhatsApp (`UserController`)
    * Modul Pertanyaan & Ticketing CS (`PertanyaanController`)
    * Riwayat Permohonan & Pembayaran (`PermohonanController`, `PembayaranController`)
    * Preview & Stream Invoice / Kuitansi PDF.

### 4.3. Modul Permohonan (`Modules/Permohonan`)
* **Tujuan**: Pusat pemrosesan permohonan layanan oleh petugas internal BBKKP.
* **Fitur Utama**:
  * Daftar Permohonan & Detail Layanan (`PermohonanController.php`)
  * Aksi Approval (Persetujuan), Revisi, dan Rejection (Penolakan) permohonan tunggal maupun *bulk* (`bulkApprove`, `bulkRevisi`, `bulkReject`).
  * Pengaturan Tarif Layanan (`simpanTarif`).
  * Generasi & Persetujuan Invoice / Kuitansi (`InvoiceController.php`).
  * Integrasi TTE: Stream & Download dokumen ber-TTE (`downloadTte`, `streamTte`).
  * Master Data Lokasi (Provinsi, Kabupaten, Kecamatan) & Master Jenis/Lingkup Layanan.

### 4.4. Modul Admin (`Modules/Admin`)
* **Tujuan**: Panel kontrol administrasi konten (*Content Management System*) portal.
* **Fitur Utama**:
  * Pengelolaan Banner Homepage (`BannerController.php`).
  * Manajemen Topik Pertanyaan & FAQ Layanan (`ManageTopikPertanyaanController`, `ManageFaqController`).
  * Pengelolaan Pesan Contact Us & Konten Homepage (`ManageContactUsController`, `ManageHomepageController`).
  * Pengelolaan Data Layanan & Pesanan Layanan (`ManageLayananController`, `ManageOrderController`).
  * Pengaturan Integrasi Single Sign-On / SSO (`IntegrasiSsoController.php`).

### 4.5. Modul System (`Modules/System`)
* **Tujuan**: Manajemen hak akses pengguna (*Role-Based Access Control / RBAC*) dan hierarki sistem.
* **Fitur Utama**:
  * Manajemen Pengguna Internal & Banned User (`ManageUserController.php`).
  * Manajemen Kelompok Hak Akses / Group (`ManageGroupController.php`).
  * Manajemen Menu Sistem (`ManageMenuController.php`).
  * Manajemen Aksi Menu / Permission (`ManageMenuActionController.php`).

### 4.6. Modul Home (`Modules/Home`)
* **Tujuan**: Halaman landing & dashboard untuk pengguna internal terautentikasi.
* **Fitur Utama**:
  * Dashboard Utama Staff Internal (`DashboardController.php`).
  * Manajemen Profil & Keamanan Akun Internal (`AccountController.php`).
  * Pusat Notifikasi Internal & Sinkronisasi Token FCM (`NotificationController.php`).
  * Layanan Unduh Berkas (`DownloaderController.php`).

### 4.7. Modul Integration (`Modules/Integration`)
* **Tujuan**: Endpoint API khusus untuk menerima data permohonan dari aplikasi atau sistem eksternal lain.
* **Keamanan**: Dilindungi middleware `RequireApiKeyMiddleware` (`INTEGRATION_API_KEY`).

---

## 5. Arsitektur Database & Multi-Database Connection

Aplikasi ini menggunakan struktur data terpisah untuk memisahkan entitas inti portal dengan data transaksi layanan, serta mendukung integrasi lintas sistem internal BBKKP.

```mermaid
graph LR
    subgraph BBKKP Polimer Application
        App[Laravel Engine]
    end

    subgraph Primary Databases
        DB1[(bbkkp_polimer / Db1)]
        DB2[(bbkkp_services / Db2)]
    end

    subgraph External Connected Systems
        APPS[(bbkkp_sso)]
        PUK[(bbkkp_training)]
        SIL[(bbkkp_sil)]
        SIS[(bbkkp_sis)]
    end

    App -->|Core Auth, User, CMS, Chat| DB1
    App -->|Permohonan, Form, Invoice| DB2
    App -.->|SSO Integration| APPS
    App -.->|Data Pelatihan| PUK
    App -.->|Data Lab Testing| SIL
    App -.->|Data Sertifikasi| SIS
```

### 5.1. Skema Model `Db1` (Core Portal Database)
* **Pengguna & Akses**: `sys_user`, `sys_group`, `sys_menu`, `sys_group_permission`, `sys_user_group`, `sys_user_notif`, `sys_user_fbtoken`, `pegawai`.
* **Pelanggan**: `pelanggan`, `pelanggan_perorangan`, `pelanggan_perusahaan`, `pelanggan_instansi`.
* **CMS & Bantuan**: `setting_banner`, `master_faq`, `master_layanan`, `master_topik_pertanyaan`, `site_contact_us`, `site_manajemen`.
* **Bantuan & Chat**: `pertanyaan_pelanggan`, `pertanyaan_pelanggan_pesan`.
* **Wilayah**: `master_provinsi`, `master_kabupaten`, `master_kecamatan`.
* **OAuth**: `oauth_access_tokens`, `oauth_auth_codes`, `oauth_clients`, `oauth_refresh_tokens`.

### 5.2. Skema Model `Db2` (Transaksional Layanan)
* **Permohonan**: `permohonan`, `detail_permohonan`, `form_pelatihan`, `form_lsp`.
* **Keuangan**: `detail_pembayaran`.
* **Master Layanan**: `master_jenis_layanan`, `master_lingkup_layanan`.

---

## 6. Alur Kerja Utama (Business Workflows)

### 6.1. Alur Pengajuan & Pemrosesan Permohonan Layanan

```mermaid
sequenceDiagram
    autonumber
    actor Pelanggan as Pelanggan (Public)
    participant AppReact as React SPA Frontend
    participant API as Laravel API (Eksternal)
    participant DB as Database (Db1/Db2)
    actor Staff as Staff BBKKP (Internal)
    participant TTE as E-Sign Service (BSrE)

    Pelanggan->>AppReact: Isi Form Layanan (Pelatihan / LSP / Bimtek)
    AppReact->>API: POST /api/eksternal/pelatihan (atau lsp)
    API->>DB: Simpan Data Permohonan (Status: DRAFT / DIAJUKAN)
    API-->>AppReact: Response Sukses & Kode Permohonan

    Staff->>API: Akses Panel Internal /permohonan/layanan
    Staff->>API: Review Data & Klik "Approve" / "Revisi" / "Reject"
    API->>DB: Update Status Permohonan

    alt Status Disetujui (Approved)
        Staff->>API: Input Tarif & Generate Invoice
        API->>DB: Simpan Invoice (Detail Pembayaran)
        Pelanggan->>AppReact: Lihat Invoice & Lakukan Pembayaran
        Staff->>API: Approve Pembayaran & Issue Kuitansi
        API->>TTE: Kirim Dokumen untuk Tanda Tangan Elektronik
        TTE-->>API: Kembalikan Dokumen Signed (PDF + QR)
        Pelanggan->>AppReact: Unduh Sertifikat / Kuitansi Ber-TTE
    end
```

### 6.2. Alur Verifikasi TTE Dokumen (Tanda Tangan Elektronik)

```mermaid
sequenceDiagram
    autonumber
    actor Public as Pengguna / Pemeriksa Dokumen
    participant Web as Web Portal (/tte/verify)
    participant TTEController as TteController
    participant SDK as SDK E-Sign BBKKP

    Public->>Web: Upload File PDF atau Input ID Dokumen
    Web->>TTEController: POST /tte/verify-by-doc (atau verify-by-id)
    TTEController->>SDK: Panggil API Verifikasi BSrE
    SDK-->>TTEController: Return Status Kebenaran TTE & Identitas Penandatangan
    TTEController-->>Web: Tampilkan Hasil Verifikasi (Valid / Invalid, Penandatangan, Waktu)
```

---

## 7. Variabel Lingkungan & Konfigurasi (.env)

Berikut adalah variabel lingkungan utama yang dikonfigurasi pada file `.env`:

```ini
APP_NAME="BBKKP Polimer"
APP_ENV=local
APP_KEY=base64:...
APP_URL=http://localhost:7000

# Database Utama
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bbkkp_polimer
DB_USERNAME=root
DB_PASSWORD=

# Database Multi-Connection (External DB)
DB_URL_APPS=mysql://user:pass@127.0.0.1:2010/bbkkp_sso
DB_URL_PUK=mysql://user:pass@127.0.0.1:2010/bbkkp_training
DB_URL_SIL=mysql://user:pass@127.0.0.1:2010/bbkkp_sil
DB_URL_SIS=mysql://user:pass@127.0.0.1:2010/bbkkp_sis

# Cloud Object Storage (MinIO / S3)
AWS_ENDPOINT=https://storage.bbkkp.kemenperin.go.id
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_BUCKET=dev-polimer

# Integrasi TTE (E-Sign BSrE)
TTE_BASE_URL=http://bbkkp_internal_service
TTE_API_KEY=

# Notifikasi WhatsApp
WHATSAPP_ENABLED=false
WHATSAPP_BASE_URL=https://cast.bbkkp.kemenperin.go.id
WHATSAPP_USERNAME=
WHATSAPP_PASSWORD=

# Integrasi API External Key
INTEGRATION_API_KEY=secretIntegrationAPIKey
```

---

## 8. Panduan Instalasi & Pengoperasian Aplikasi

### 8.1. Persyaratan Sistem
* **PHP**: versi 8.2 atau lebih tinggi (dengan ekstensi `pdo_mysql`, `gd`, `zip`, `mbstring`, `openssl`, `bcmath`).
* **Composer**: versi 2.x.
* **Node.js**: versi 18.x atau 20.x dan **npm**.
* **Database**: MySQL 8.0+ atau MariaDB 10.5+.

### 8.2. Langkah-Langkah Instalasi (Local Development)

1. **Clone Repositori & Masuk Direktori**:
   ```bash
   git clone <repository-url>
   cd bbkkp-polimer
   ```

2. **Pengaturan File Environment**:
   ```bash
   cp .env.example .env
   ```
   *Sesuaikan kredensial database (`DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`) pada file `.env`.*

3. **Instal Dependency Backend (PHP)**:
   ```bash
   composer install
   ```

4. **Instal Dependency Frontend (Node.js)**:
   ```bash
   npm install
   ```

5. **Generasi Application Key & Storage Link**:
   ```bash
   php artisan key:generate
   php artisan storage:link
   ```

6. **Migrasi Database & Seeding Initial Data**:
   ```bash
   php artisan migrate:fresh --seed
   ```

7. **Generasi Kunci OAuth Passport**:
   ```bash
   php artisan passport:keys
   ```

8. **Menjalankan Dev Server**:
   * **Menjalankan Backend Laravel**:
     ```bash
     php artisan serve --port=7000
     ```
   * **Menjalankan Frontend Vite (Hot Reloading)**:
     ```bash
     npm run dev
     ```

---

## 9. Ringkasan Perintah Artisan Khusus Modul

Aplikasi ini menggunakan `nwidart/laravel-modules`. Beberapa perintah artisan berguna untuk pengembangan modul:

* **Melihat Daftar Modul & Status**:
  ```bash
  php artisan module:list
  ```
* **Membuat Modul Baru**:
  ```bash
  php artisan module:make NamaModul
  ```
* **Membuat Controller di Modul Tertentu**:
  ```bash
  php artisan module:make-controller NamaController NamaModul
  ```
* **Clear Cache Lengkap**:
  ```bash
  php artisan optimize:clear
  ```

---

## 10. Kesimpulan & Ringkasan Pengembang

Repositori **BBKKP Polimer** dirancang dengan arsitektur yang sangat modular, bersih, dan *scalable*. Pemisahan antara modul publik (`Eksternal`), modul operasional internal (`Permohonan`, `Admin`), serta modul keamanan dan sistem (`Auth`, `System`) memudahkan maintenance jangka panjang. 

Dengan integrasi layanan modern seperti **TTE (Tanda Tangan Elektronik)**, **WhatsApp Notification**, dan **AWS S3 MinIO Storage**, aplikasi ini menjadi fondasi utama transformasi digital pelayanan di lingkungan Balai Besar Kulit, Karet, dan Plastik (BBKKP).
