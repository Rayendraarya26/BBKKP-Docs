# Breakdown Milestone & Sprint Plan
## Modernisasi Tech Stack & Unified UI/UX BBKKP Polimer

> **Dokumen Perencanaan Proyek, Milestone, dan Sprint Plan Terintegrasi**  
> **Balai Besar Standarisasi dan Pelayanan Jasa Industri Kulit, Karet, dan Plastik (BBSPJIKKP / BBKKP)**  
> **Arsitektur Target**: Unified React 18 + Vite + TypeScript + Tailwind CSS + Laravel 10 REST API  
> **Estimasi Total Durasi**: 10 Minggu (5 Milestone / 5 Sprint @ 2 Minggu)  
> **Versi**: 1.0  
> **Tanggal**: 18 Agustus 2026

---

## 1. Ringkasan Eksekutif & Linimasa Proyek

Proyek modernisasi ini bertujuan menyatukan dua arsitektur frontend yang saat ini terpisah (Portal Admin berbasis Blade SSR + Metronic vs Portal Pelanggan berbasis React SPA yang belum terstandarisasi) ke dalam **satu ekosistem Single Page Application (SPA) modern yang rapi, cepat, responsif, dan konsisten secara UI/UX**.

```mermaid
gantt
    title Linimasa Milestone & Sprint Modernisasi Polimer
    dateFormat  YYYY-MM-DD
    section M1: Design System & Foundation
    Sprint 1: Tailwind CSS, Design Tokens & Core UI Kit :active, s1, 2026-08-18, 14d
    section M2: Customer Portal Modernization
    Sprint 2: Redesign Pelanggan (Dashboard, Permohonan, Tracking, Invoice) : s2, after s1, 14d
    section M3: State & API Standardization
    Sprint 3: TanStack Query, React Hook Form + Zod & REST API Alignment : s3, after s2, 14d
    section M4: Admin Portal Migration to React
    Sprint 4: Admin Workspace, Monitoring, Verifikasi & Modul Keuangan : s4, after s3, 14d
    section M5: RBAC, Performance & Production Cutover
    Sprint 5: Dynamic RBAC Matrix, E2E Testing, Lighthouse Audit & Cutover : s5, after s4, 14d
```

---

## 2. Rincian Milestone & Pembagian Sprint

---

### 📍 Milestone 1: Design System, Tailwind Setup & Enterprise UI Kit
* **Target Fokus**: Membangun fondasi visual modern, konsisten, dan mudah digunakan (reusable). Mengintegrasikan Tailwind CSS dengan token desain Kemenperin/BBKKP, serta membangun library komponen inti yang bersih (*clean UI*).
* **Alokasi Waktu**: **Sprint 1 (Minggu 1 - 2)**

#### 🎯 Sprint 1 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS1-01** | Frontend | Konfigurasi Tailwind CSS di Vite, PostCSS, Autoprefixer, dan Tailwind Merge / clsx helper. | 3 | `tailwind.config.js`, `postcss.config.js` |
| **TS1-02** | Design Tokens | Definisi palet warna standar (Navy Kemenperin `#1E3A8A`, Emerald, Neutral Slate), tipografi Montserrat/Inter, spacing, border-radius, dan bayangan (*elevation tokens*). | 3 | Tokens di `tailwind.config.js` & `tokens.css` |
| **TS1-03** | UI Components | Membangun komponen dasar: `Button` (berbagai varian + loading state), `Input`, `Select/Combobox`, `Textarea`, `Checkbox`, `Switch`, dan `Badge`. | 5 | Direktori `components/ui/` |
| **TS1-04** | UI Components | Membangun komponen data & layout: `Card`, `StatsCard/MetricCard`, `Modal/Dialog`, `Drawer/Offcanvas`, `DropdownMenu`, `Tabs`, dan `SkeletonLoader`. | 5 | Direktori `components/ui/` |
| **TS1-05** | UI Components | Membangun komponen tabel enterprise `DataTable`: fitur server-side/client-side pagination, global & column search, sorting, multi-filter, dan empty/error state. | 8 | `components/ui/DataTable.tsx` |
| **TS1-06** | Layout Shell | Membangun layout kerangka utama (*AppShell*): `Sidebar` collapsible dengan hierarki menu rapi, `Navbar` dengan notifikasi & quick search, serta `Breadcrumbs` otomatis. | 5 | `components/layouts/AppShell.tsx` |

* **Definition of Done (DoD) Sprint 1**:
  - Seluruh komponen UI inti terdokumentasi dan dapat dirender dengan preview terisolasi.
  - Zero conflict antara style lama dan styling Tailwind baru.

---

### 📍 Milestone 2: Modernisasi Total Portal Pelanggan (React SPA)
* **Target Fokus**: Merekonstruksi seluruh antarmuka pelanggan menggunakan UI Kit baru dengan layout bersih, hierarki informasi jelas, dan formulir permohonan yang interaktif.
* **Alokasi Waktu**: **Sprint 2 (Minggu 3 - 4)**

#### 🎯 Sprint 2 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS2-01** | Pelanggan | Redesign Halaman **Dashboard Pelanggan**: banner slider modern, kartu ringkasan status permohonan aktif, akses cepat pengajuan layanan, dan grafik riwayat pengujian. | 5 | `pages/dashboard/DashboardPage.tsx` |
| **TS2-02** | Pelanggan | Redesign Form Wizard **Pengajuan Layanan** (Uji Polimer, Kalibrasi, Pelatihan, Sertifikasi) dengan stepper interaktif, auto-save draf, dan drag-and-drop file upload. | 8 | `pages/service-requests/` |
| **TS2-03** | Pelanggan | Redesign Halaman **Tracking & Detail Permohonan**: visualisasi status permohonan berbasis timeline vertikal/horizontal, catatan verifikator, dan download berkas draft. | 5 | `pages/service-requests/detail/` |
| **TS2-04** | Pelanggan | Redesign Modul **Pembayaran & Invoice**: tampilan invoice resmi, kode Virtual Account BNI, status real-time, upload bukti manual, dan unduh kuitansi TTE. | 5 | `pages/payment/` |
| **TS2-05** | Pelanggan | Redesign Modul **Pusat Bantuan, FAQ, & Ulasan/Feedback**: antarmuka tiket tanya jawab bergaya chat interaktif dan form feedback bintang 5 pasca layanan selesai. | 5 | `pages/ask-questions/` & `pages/feedbacks/` |
| **TS2-06** | Pelanggan | Redesign Halaman **Profil Pengguna**: tab data umum, data instansi/perusahaan, nomor kontak WhatsApp, ganti password, dan upload kelengkapan legalitas. | 5 | `pages/profile/` |

* **Definition of Done (DoD) Sprint 2**:
  - Pelanggan dapat menyelesaikan alur dari pendaftaran permohonan hingga download dokumen hasil uji/sertifikat dengan tampilan modern tanpa kendala UX.

---

### 📍 Milestone 3: Standardisasi Backend API, State Management & Validasi
* **Target Fokus**: Menyelaraskan seluruh endpoint REST API backend Laravel, mengoptimasi query database, serta migrasi state management dari Redux boilerplate ke **TanStack Query + React Hook Form + Zod**.
* **Alokasi Waktu**: **Sprint 3 (Minggu 5 - 6)**

#### 🎯 Sprint 3 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS3-01** | Backend | Standardisasi JSON Resource Response & Error Handler di Laravel untuk seluruh endpoint internal & eksternal (`success`, `data`, `meta`, `errors`). | 5 | `app/Http/Resources/` |
| **TS3-02** | Frontend | Implementasi **TanStack Query (React Query)**: setup QueryClient, automatic cache invalidation, polling notifikasi latar belakang, dan optimistic updates. | 5 | `services/api/` & `hooks/queries/` |
| **TS3-03** | Frontend | Standardisasi Validasi Formulir menggunakan **React Hook Form + Zod**: type-safety skema validasi untuk setiap modul input. | 5 | `schemas/` & Form Components |
| **TS3-04** | Backend | Penyediaan REST API Admin: Endpoint CRUD Master Data, Endpoint Manajemen Permohonan Admin, dan Endpoint Modul Keuangan. | 8 | `Modules/Admin/Http/Controllers/Api/` |
| **TS3-05** | Security | Penguatan Keamanan API: Rate limiting, IDOR prevention middleware, validasi sanitasi input, dan penanganan token expired yang mulus (*silent refresh*). | 5 | Middlewares & Axios Interceptor |

* **Definition of Done (DoD) Sprint 3**:
  - Loading data di frontend menggunakan caching pintar tanpa refetch berulang yang tidak perlu.
  - Form validation 100% konsisten antara client-side (Zod) dan server-side (FormRequest).

---

### 📍 Milestone 4: Migrasi Portal Admin / Operasional Internal ke Unified React SPA
* **Target Fokus**: Memindahkan seluruh modul operasional internal (Admin, Pegawai, Bendahara) dari Blade Metronic ke dalam satu bundle React SPA terpadu dengan hak akses berbasis RBAC.
* **Alokasi Waktu**: **Sprint 4 (Minggu 7 - 8)**

#### 🎯 Sprint 4 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS4-01** | Admin SPA | Workspace & Dashboard Admin: Monitoring antrean permohonan masuk, grafik pencapaian PNBP, metrik waktu pengerjaan (SLA), dan quick action approval. | 5 | `pages/admin/dashboard/` |
| **TS4-02** | Admin SPA | Modul **Verifikasi & Penugasan Permohonan**: Tinjauan berkas persyaratan, assign tim penguji / verifikator, disposisi permohonan, dan status approval bertingkat. | 8 | `pages/admin/permohonan/` |
| **TS4-03** | Admin SPA | Modul **Input Hasil Uji & Penerbitan Sertifikat TTE**: Input parameter uji, upload draf laporan, generate PDF sertifikat, dan integrasi penandatanganan elektronik BSrE. | 8 | `pages/admin/sertifikasi/` |
| **TS4-04** | Admin SPA | Modul **Bendahara & Keuangan**: Pembuatan invoice tarif PNBP, verifikasi konfirmasi pembayaran, monitoring Virtual Account BNI, dan rekap kuitansi lunas. | 5 | `pages/admin/finance/` |
| **TS4-05** | Admin SPA | Modul **Master Data Management**: Manajemen Layanan, Parameter Uji, Komoditi SNI/ISO, Wilayah (Provinsi/Kabupaten/Kecamatan), dan Template Dokumen. | 5 | `pages/admin/master/` |
| **TS4-06** | Admin SPA | Modul **Manajemen Pengguna & Konfigurasi Grup**: CRUD User Pegawai/Pelanggan, aktivasi/blokir akun, dan pengaturan profil instansi. | 5 | `pages/admin/users/` |

* **Definition of Done (DoD) Sprint 4**:
  - Pegawai, Verifikator, dan Bendahara dapat melakukan seluruh operasional harian melalui portal React SPA baru dengan kenyamanan dan kerapian setara/lebih baik dari Metronic lama.

---

### 📍 Milestone 5: Dynamic RBAC Matrix, Testing Komprehensif & Production Cutover
* **Target Fokus**: Memastikan keamanan hak akses dinamis, pengujian menyeluruh (E2E & Unit), audit performa Lighthouse, dan proses transisi sistem tanpa gangguan (*Zero-Downtime Cutover*).
* **Alokasi Waktu**: **Sprint 5 (Minggu 9 - 10)**

#### 🎯 Sprint 5 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS5-01** | Security | Implementasi **Dynamic RBAC Permission Guard** di Frontend: Proteksi route, kontrol visibilitas tombol aksi (*CanCreate*, *CanApprove*, *CanExport*) berdasarkan `sys_group_permission`. | 5 | `guards/PermissionGuard.tsx` |
| **TS5-02** | QA & Testing | Pembuatan Automated Test & E2E Testing skenario utama (Pendaftaran Pelanggan → Permohonan → Verifikasi Admin → Invoice → Bayar → Terbit Sertifikat). | 8 | E2E Tests suite |
| **TS5-03** | Optimization | Optimasi Bundle Vite & Performa: Code-splitting via `React.lazy`, tree-shaking icon, optimasi asset gambar webp/svg, dan Lighthouse Score >= 90. | 5 | Production Build Optimization |
| **TS5-04** | Operations | Dokumentasi Panduan Pengguna (User Manual) untuk Pelanggan & Petugas Internal, serta Panduan Pengembang (Developer Guide). | 3 | Docs di `BBKKP-Docs` |
| **TS5-05** | Deployment | Uji Coba Staging, Simulasi Cutover, dan Penerapan Production Deployment secara bertahap. | 5 | Release Tag & SOP Cutover |

* **Definition of Done (DoD) Sprint 5**:
  - Sistem Polimer versi modern lolos seluruh skenario pengujian, performa cepat, dan siap digunakan secara penuh menggantikan versi lama.

---

## 3. Matriks Perbandingan Sebelum vs Sesudah Migrasi

| Parameter | Versi Eksisting | Target Versi Baru (Modern) |
| :--- | :--- | :--- |
| **Arsitektur** | Hybrid (Blade SSR Admin + React Pelanggan) | **100% Unified React 18 + Vite SPA** |
| **Styling Framework** | Metronic CSS Bundle (Admin) + Bootstrap/Styled-Comp (Pelanggan) | **Tailwind CSS + Reusable Enterprise UI Kit** |
| **User Experience (UX)** | Full page reload di Admin; UI Pelanggan kurang rapi | **Instant Client-Side Navigation, Smooth Transitions & Skeleton Loaders** |
| **Komponen Reusability** | Terduplikasi dan sulit dipelihara | **100% Shared UI Component Library (Table, Modal, Form)** |
| **State & Data Fetching** | Redux Toolkit boilerplate berat + fetch manual | **TanStack Query (Smart Cache, Auto Retry, Background Sync)** |
| **Validasi Form** | Tersebar di jQuery validate & React custom | **React Hook Form + Zod Type-Safe Schema** |
| **Responsivitas Mobile** | Admin kurang optimal di mobile/tablet | **Mobile-First Responsive Design di Semua Layar** |
