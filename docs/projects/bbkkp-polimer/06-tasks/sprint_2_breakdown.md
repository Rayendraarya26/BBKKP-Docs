# Sprint 2 Breakdown — Modernisasi Total Portal Pelanggan (React SPA)
## Proyek Modernisasi Tech Stack BBKKP Polimer

> **Sprint**: 2 dari 5  
> **Durasi**: 2 Minggu  
> **Fokus Utama**: Redesign Total Halaman Pelanggan (Dashboard, Permohonan, Tracking, Invoice & Profil) dengan UI Kit Baru  
> **Target Branch**: `feature/modern-customer-portal-spa`

---

## 1. Sasaran Sprint (Sprint Goal)
Menggantikan seluruh komponen lama di portal pelanggan yang tidak terstandarisasi dengan **AppShell** dan **Komponen UI Tailwind CSS**, memberikan pengalaman visual yang bersih, rapi, dan responsif bagi pengguna eksternal (Pelanggan Perorangan, Instansi Pemerintah, dan Perusahaan).

---

## 2. Rincian Task Breakdown

### 🔹 TS2-01: Integrasi Layout AppShell Modern
* **Deskripsi**: Menghubungkan layout `AppShell.tsx` baru ke dalam `PrivateLayout.tsx` dan sistem perutean React (`routes.tsx`).
* **Deliverables**: [PrivateLayout.tsx](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/layouts/PrivateLayout.tsx) & [routes.tsx](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/routes.tsx).

---

### 🔹 TS2-02: Redesign Halaman Dashboard Pelanggan
* **Deskripsi**: Merombak total `DashboardPage.tsx`:
  1. **Banner Carousel**: Slider promosi layanan BBKKP dengan desain kartu rounded dan rasio aspek responsif.
  2. **Statistik KPI**: 4 `StatsCard` interaktif (Total Permohonan, Menunggu Pembayaran, Sedang Diproses, Sertifikat Terbit).
  3. **Akses Cepat Pengajuan**: Kartu aksi cepat pengajuan layanan pengujian kulit, karet, plastik, kalibrasi, bimtek, dan sertifikasi LSP.
  4. **Tabel Riwayat Terkini**: Tabel `DataTable` ringkasan permohonan terbaru dengan status badge dan tombol unduh/detail.
* **Deliverables**: [DashboardPage.tsx](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/pages/dashboard/DashboardPage.tsx).

---

### 🔹 TS2-03: Redesign Halaman Tracking & Riwayat Permohonan
* **Deskripsi**: Menyediakan antarmuka penelusuran status permohonan dengan timeline visual (Verifikasi Dokumen → Penagihan Invoice → Pengujian Laboratorium → Penerbitan Sertifikat TTE).
* **Deliverables**: Halaman di `pages/service-requests/`.

---

### 🔹 TS2-04: Redesign Modul Pembayaran & Invoice
* **Deskripsi**: Antarmuka invoice modern dengan integrasi nomor Virtual Account BNI, status real-time, dan pengunduhan kuitansi lunas.
* **Deliverables**: Halaman di `pages/payment-history/`.

---

### 🔹 TS2-05: Redesign Halaman Profil Akun
* **Deskripsi**: Tampilan profil akun terorganisir per tab (Informasi Umum, Legalitas Instansi/Perusahaan, Ganti Password & Keamanan).
* **Deliverables**: Halaman di `pages/profile/`.
