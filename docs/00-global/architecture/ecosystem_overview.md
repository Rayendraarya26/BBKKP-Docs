# 🌐 Overview Arsitektur Ekosistem BBKKP
## Gambaran Umum Arsitektur Sistem, Modul, dan Integrasi Lintas Aplikasi

> **Dokumen Arsitektur Ekosistem BBKKP**  
> **Balai Besar Kulit, Karet, dan Plastik (BBKKP) - Kementerian Perindustrian RI**  
> **Status Dokumen**: Active / Architecture Baseline  
> **Tanggal Efektif**: 17 Agustus 2026

---

## 1. Pendahuluan

Ekosistem aplikasi pada **Balai Besar Kulit, Karet, dan Plastik (BBKKP)** terdiri dari beberapa aplikasi utama yang menangani pelayanan sertifikasi industri, pengujian laboratorium, manajemen pelanggan, hingga integrasi dengan instansi/penyedia layanan eksternal.

Dokumen ini memberikan panduan arsitektural tingkat tinggi (*high-level architecture*) mengenai model **Co-Existence & Data Bridging** antara:
1. **BBKKP Polimer** (sistem operasional modern terpadu & portal utama bagi seluruh pengguna BBKKP).
2. **BBKKP SIS** (sistem informasi sertifikasi resmi terpusat dari Kementerian Perindustrian yang tetap aktif dan berjalan normal).
3. **Repo Services & External Services** (Layanan TTE BSrE, BNI Virtual Account, WhatsApp Gateway).

---

## 2. Diagram Arsitektur Ekosistem

```mermaid
graph TB
    subgraph Client Layer [Pengguna / Klien BBKKP]
        Pelanggan[Pelanggan Industri / Pabrik]
        Petugas[Petugas BBKKP / Auditor / Marketing / Komite / Ka Balai]
    end

    subgraph Gateway Layer [Load Balancer & Web Server]
        Nginx[Nginx / Reverse Proxy & SSL]
    end

    subgraph Application Layer [Aplikasi Utama]
        Polimer[BBKKP Polimer - Laravel 10 + React SPA\n(Primary Unified Portal for All Users)]
        SIS[BBKKP SIS - Central System\n(Live & Operational Central System)]
    end

    subgraph Service Layer [Infrastructure Services]
        Redis[Redis - Session & Background Queue]
        MySQL_Polimer[(Database MySQL - Polimer)]
        MySQL_SIS[(Database MySQL - SIS Pusat)]
    end

    subgraph External Integrations [Layanan Pihak Ke-3]
        RepoSvc[Repo Services Hub]
        BNI[BNI Virtual Account API]
        BSrE[BSrE E-Sign TTE Service]
        WACast[WhatsApp Notification API]
    end

    %% Flow connections
    Pelanggan -->|100% Interaksi| Nginx
    Petugas -->|100% Interaksi| Nginx
    Nginx --> Polimer

    Polimer --> MySQL_Polimer
    Polimer --> Redis

    %% Two-Way Bridging Flow
    Polimer <-->|Two-Way Sync / Bridging Engine| MySQL_SIS
    SIS --> MySQL_SIS

    %% Repo Services Integrations
    Polimer <--> RepoSvc
    RepoSvc --> BNI
    RepoSvc --> BSrE
    RepoSvc --> WACast
```

---

## 3. Komponen Utama Ekosistem

### 3.1. BBKKP Polimer (`bbkkp-polimer`)
* **Peran**: *Single Unified Operation Hub (Super App)* dan portal pintu masuk tunggal (*Single Front-Door*) untuk seluruh pelanggan dan staf internal BBKKP.
* **Tech Stack**: PHP 8.2+, Laravel 10+, MySQL 8.0+, Redis, React 18 + Vite + Tailwind SPA.
* **Fitur Utama**:
  * Portal Permohonan Sertifikasi Pelanggan Multi-Item (Baru, Surveilans, Perpanjangan, Perubahan Scope).
  * Manajemen Profil Pabrik & Lokasi Fasilitas Produksi Industri.
  * Billing & Integrasi Pembayaran Otomatis BNI Virtual Account.
  * Alur Teknis Evaluasi Audit 2-Tahap, Penanganan LKS, & Rekomendasi Komite.
  * Penerbitan Dokumen Resmi Ber-TTE (Invoice, Kwitansi, Sertifikat via BSrE).
  * *Two-Way Sync Engine* untuk menjembatani data ke sistem pusat SIS.

### 3.2. BBKKP SIS (`bbkkp-sis`)
* **Peran**: Sistem Informasi Sertifikasi terpusat resmi dari Kementerian Perindustrian (Pusat).
* **Status**: **Active & Live Central System**. Sistem dan database SIS tetap beroperasi normal untuk menjamin kepatuhan pelaporan terpusat, interoperabilitas data nasional, dan audit pusat.
* **Akses Pengguna**: Pengguna BBKKP dialihkan menggunakan Polimer sebagai *front-end*, sementara backend/database SIS terus dimutakhirkan secara otomatis melalui *Data Bridging Engine*.

### 3.3. DB & Queue Infrastructure
* **MySQL Database**: Dipisahkan antara DB Polimer (`bbkkp_polimer`) dan DB SIS Pusat (`bbkkp_sis`).
* **Redis**: Digunakan untuk manajemen sesi pengguna dan *distributed queue* untuk background synchronization, pengiriman notifikasi WhatsApp, serta pemanggilan API TTE BSrE dan BNI VA secara asinkron.

### 3.4. Integration Services (Pihak Ke-3)
1. **BNI Virtual Account**: Menerima callback status pembayaran otomatis (*Real-time Webhook Notification*).
2. **BSrE E-Sign (BSSN)**: Melakukan verifikasi dan pembubuhan TTE berstandar hukum pada file PDF Invoice, Kwitansi, dan Sertifikat.
3. **WhatsApp Gateway**: Pengiriman notifikasi tagihan VA, bukti kwitansi lunas, peringatan perbaikan LKS, dan terbit sertifikat ke WhatsApp pelanggan.

---

## 4. Alur Integrasi & Sinkronisasi Data (Co-Existence & Bridging)

Dalam strategi *Co-Existence* Polimer & SIS Pusat:
1. **Unified Front-Door (Tanpa Redirect)**: Seluruh interaksi pengguna lokal BBKKP (pendaftaran, audit, perbaikan temuan, komite) dipusatkan di Polimer tanpa melempar pengguna ke web interface SIS legacy.
2. **Sinkronisasi Dua Arah (*Two-Way Data Bridging*)**:
   - **Master Data (SIS Pusat ➡️ Polimer)**: Data komoditi, regulasi SNI, kode EA/NACE disinkronkan secara berkala dari SIS ke Polimer (`SertifikasiMasterSeeder`).
   - **Data Transaksional (Polimer ➡️ SIS Pusat)**: Setiap mutasi permohonan baru, update status pembayaran, rekaman audit, temuan LKS, dan sertifikat terbit di Polimer otomatis di-*bridge* / dituliskan ke tabel terkait di DB SIS (`sis_permohonan`, `sis_audit`, `sis_sertifikat`).
3. **Idempotensi & Keandalan**: Seluruh proses migrasi historis dan sinkronisasi berkala dibangun dengan mekanisme *idempotent upsert* sehingga aman dijalankan berulang tanpa duplikasi.

---

## 5. Dokumen Referensi Terkait
* **[SOP Git Dual-Remote Workflow](../standards/git_dual_remote_workflow.md)**
* **[Coding & Security Guidelines](../standards/coding_guidelines.md)**
* **[Spesifikasi Migrasi DB SIS ke Polimer](../../projects/integrasi-sis-polimer/02-architecture/db_schema_migration.md)**
* **[Functional Requirements Document (FRD) Integrasi](../../projects/integrasi-sis-polimer/01-product/frd_integrasi.md)**
