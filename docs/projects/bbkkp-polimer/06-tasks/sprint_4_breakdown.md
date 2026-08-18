# Sprint 4 Breakdown — Migrasi Total Seluruh Modul Admin & Operasional Internal ke Unified React SPA
## Proyek Modernisasi Tech Stack BBKKP Polimer

> **Sprint**: 4 dari 5  
> **Durasi**: 2 Minggu  
> **Fokus Utama**: Memindahkan 100% Seluruh Modul Operasional Internal (Permohonan, Verifikasi, Pengujian, Keuangan/Invoice TTE, Bantuan/Tiket, Banner/Homepage, SSO, Master Data & RBAC System) dari Blade SSR Metronic ke Ekosistem React 18 + Vite + Tailwind SPA  
> **Target Branch**: `feature/admin-portal-spa-migration`

---

## 1. Sasaran Sprint (Sprint Goal)
Menyatukan seluruh operasional internal balai (Admin, Petugas CS, Verifikator Berkas, Asesor LSP/Penguji Lab, Bendahara PNBP, dan Super Admin Sistem) ke dalam **satu arsitektur Unified React 18 SPA terpadu**. Menghilangkan full page reload, menyederhanakan alur verifikasi berkas dan approval bertingkat, serta mengintegrasikan sistem permission RBAC dinamis.

---

## 2. Rincian Task Breakdown Komprehensif (6 Pilar Modul)

---

### 🏛️ PILAR 1: Admin Layout Shell & Workspace Dashboard
* **TS4-01A: Admin Layout Shell (`AdminShell.tsx`)**
  - Sidebar hierarkis bertingkat (*Operasional*, *Keuangan*, *Komunikasi & Bantuan*, *Master Data*, *Sistem & Akses*).
  - Quick role switch / badge (*Super Admin*, *Verifikator*, *Penguji*, *Bendahara*).
  - Header dengan global quick search, notifikasi tugas masuk, dan shortcut switch ke Portal Pelanggan.
* **TS4-01B: Workspace Dashboard Admin (`AdminDashboardPage.tsx`)**
  - 4 Kartu KPI Utama: *Permohonan Masuk Hari Ini*, *Menunggu Verifikasi*, *Sedang Uji Lab*, *Menunggu Approval TTE*.
  - Grafik Distribusi Permohonan per Jenis Layanan (Chart Bar/Donut).
  - Grafik Realisasi Pendapatan PNBP Bulanan.
  - Tabel *Urgent SLA Alert*: Permohonan yang mendekati batas waktu pengerjaan.

---

### 📋 PILAR 2: Modul Manajemen Permohonan, Verifikasi & Penugasan (`Modules/Permohonan`)
* **TS4-02A: Tabel Antrean Permohonan Masuk (`AdminPermohonanListPage.tsx`)**
  - Multi-tab status: *Semua*, *Menunggu Verifikasi*, *Sedang Diproses*, *Menunggu Pembayaran*, *Selesai*, *Revisi*, *Ditolak*.
  - Multi-filter: *Jenis Layanan (Uji, Kalibrasi, LSP, Bimtek)*, *Rentang Tanggal*, *Pencarian No Order / Nama Pelanggan*.
  - **Fitur Bulk Action**: *Bulk Approve*, *Bulk Revisi*, *Bulk Reject*.
* **TS4-02B: Detail Permohonan & Peninjauan Dokumen (`AdminPermohonanDetailPage.tsx`)**
  - Rekap identitas pemohon, instansi/perusahaan, kontak PIC, dan riwayat status timeline.
  - File Viewer terpadu untuk berkas persyaratan: KTP, Legalitas (NIB/NPWP), Form APL-01/02, Ijazah, CV, SK Penugasan, Sampel Uji.
* **TS4-02C: Approval Bertingkat & Disposisi Petugas (`AdminApprovalModal.tsx`)**
  - Aksi **Setujui Permohonan** ➔ Lanjut ke penagihan invoice tarif PNBP.
  - Aksi **Minta Revisi Dokumen** ➔ Form input catatan revisi spesifik per dokumen.
  - Aksi **Tolak Permohonan** ➔ Form alasan penolakan resmi.
  - Aksi **Disposisi Penugasan** ➔ Assign tim verifikator / asesor / penguji penanggung jawab.

---

### 💳 PILAR 3: Modul Bendahara, Keuangan & Penerbitan Sertifikat TTE (`Modules/Permohonan`)
* **TS4-03A: Manajemen Tarif & Pembuatan Invoice (`AdminInvoiceManagementPage.tsx`)**
  - Form rincian tarif PNBP per parameter uji / paket layanan (`simpan-tarif`).
  - Generator draf Invoice resmi PNBP lengkap dengan nomor billing & kode VA BNI.
  - Approval penerbitan invoice bertanda tangan elektronik (TTE BSrE).
* **TS4-03B: Monitoring Pembayaran & Verifikasi Kuitansi (`AdminPembayaranManagementPage.tsx`)**
  - Rekap transaksi Virtual Account BNI otomatis & verifikasi upload bukti bayar manual.
  - Approval penerbitan Kuitansi Resmi Lunas (`approval-kuitansi`) & preview PDF TTE.
* **TS4-03C: Modul Input Hasil Uji & Draf Sertifikat (`AdminHasilUjiPage.tsx`)**
  - Input parameter hasil pengujian laboratorium (metode uji, standar SNI/ISO, nilai hasil).
  - Upload draf laporan hasil uji dan peninjauan pratinjau sertifikat PDF sebelum TTE.

---

### 💬 PILAR 4: Modul Pusat Bantuan, Tiket, FAQ & Kontak Masuk (`Modules/Admin`)
* **TS4-04A: Manajemen Tiket Tanya Jawab (`AdminPertanyaanPage.tsx`)**
  - Antrean tiket pertanyaan masuk dari pelanggan.
  - Antarmuka chat balasan oleh petugas internal / helpdesk balai.
  - Aksi *Close Ticket* resmi dengan rangkuman solusi.
* **TS4-04B: Master Topik Pertanyaan & FAQ Layanan (`AdminMasterFaqPage.tsx`)**
  - CRUD Topik Pertanyaan (`/admin/topik-pertanyaan`).
  - CRUD Tanya Jawab Umum (FAQ) per kategori layanan (`/admin/faq-layanan`).
* **TS4-04C: Rekap Pesan Kontak Masuk (`AdminContactUsPage.tsx`)**
  - Tabel dan detail pesan *Contact Us* yang dikirimkan melalui portal publik.

---

### 🌐 PILAR 5: Modul Master Data, Homepage, Banner & Integrasi SSO (`Modules/Admin` & `Permohonan`)
* **TS4-05A: Master Katalog Layanan & Parameter Uji (`AdminMasterLayananPage.tsx`)**
  - CRUD Jenis Layanan (`/permohonan/master-jenis-layanan`).
  - CRUD Lingkup Layanan & Parameter Uji SNI/ISO (`/permohonan/master-lingkup-layanan`).
  - Edit konten publik layanan & kuesioner feedback spesifik (`/admin/layanan`).
* **TS4-05B: Master Wilayah / Lokasi (`AdminMasterLokasiPage.tsx`)**
  - CRUD bertingkat Provinsi, Kabupaten/Kota, dan Kecamatan (`/permohonan/master-lokasi`).
* **TS4-05C: Manajemen Banner & Konten Homepage (`AdminBannerHomepagePage.tsx`)**
  - Upload & urutan slide banner slider (`/admin/setting-banner`).
  - Pengaturan informasi profil balai, sambutan, dan kontak kantor (`/admin/manajemen-homepage`).
* **TS4-05D: Manajemen Integrasi Client SSO (`AdminIntegrasiSsoPage.tsx`)**
  - CRUD Client App SSO OAuth (Client ID, Client Secret, Callback URL, Regenerate Secret).

---

### 🔐 PILAR 6: Modul Manajemen Sistem, User & Hak Akses RBAC (`Modules/System`)
* **TS4-06A: Manajemen Pengguna Internal & Pelanggan (`AdminManageUsersPage.tsx`)**
  - CRUD Akun Pengguna Pegawai & Pelanggan Eksternal (`/system/user`).
  - Penugasan Bagian & Sub-Bagian unit kerja balai.
  - Aksi Reset Password, Aktivasi Akun, dan Pemblokiran (*Banned User*).
* **TS4-06B: Manajemen Grup & Matriks Role Permissions (`AdminManageGroupsPage.tsx`)**
  - CRUD Grup / Role Pengguna (`/system/group`).
  - **Treeview Hak Akses**: Pengaturan checklist permission per grup menu.
* **TS4-06C: Manajemen Menu Sistem & Action Actions (`AdminManageMenuPage.tsx`)**
  - Treegrid hierarki menu sistem (Menu Utama & Sub Menu) (`/system/menu`).
  - Pengaturan aksi tombol dinamis per menu (*Create, Read, Update, Delete, Approve, Export*) (`/system/menu/{id}/menu-action`).

---

## 3. Matriks Kriteria Penerimaan (Definition of Done)
1. 100% Seluruh halaman dan fitur operasional dari 6 pilar di atas dapat diakses dan digunakan melalui React SPA baru.
2. Form validasi admin terintegrasi dengan skema Zod dan pemrosesan data menggunakan TanStack Query v5.
3. Seluruh fitur lolos pengujian kompilasi `npx tsc --noEmit` (0 error) dan `npm run build` (100% PASS).
