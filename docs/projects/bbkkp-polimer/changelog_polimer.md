# 📜 Changelog Proyek: BBKKP Polimer (`bbkkp-polimer`)

> **Repositori**: `Rayendraarya26/private-polimer` / `bakulkapas/bbkkp-polimer`  
> **Periode Log**: 18 Agustus 2026 s/d 21 Agustus 2026 (4 Hari Terakhir)  
> **Total Commit**: 38 commit  
> **Teknologi Utama**: Laravel 11, React 18 (TypeScript), Tailwind CSS, TanStack Query, BNI e-Collection, FrankenPHP TTE Client

---

## 📑 Ringkasan Log Harian

```
8307b8a (2026-08-21 13:05) feat: Add admin helpdesk APIs, UI and seeders
37d425c (2026-08-21 10:21) feat: Add multi-certification wizard and API support
c1d8db4 (2026-08-20 15:20) feat: Add i18n, locale middleware & homepage optimizations
7fddd3e (2026-08-20 14:58) feat: Refine homepage layout & carousel styles
1f582ac (2026-08-20 14:47) feat: Add caching and nginx asset optimizations
927dcc5 (2026-08-20 11:48) feat: Add async BNI payment processing
78e651f (2026-08-20 11:36) feat: Add BNI VA webhook handler and routes
04dc2b0 (2026-08-20 11:30) feat: Integrate BNI VA issuance & expose VA in API/UI
a2d2c1a (2026-08-20 11:26) feat: Add BNI VA e-Collection integration
935abdc (2026-08-20 09:31) feat: Refactor TTE to HTTP client; add dummy mode
4487588 (2026-08-20 09:20) Merge branch 'polimer_v2.1' into v2.1_internal-system-migration
a041de9 (2026-08-19 14:59) feat: Improve user role handling and permission context
6583fee (2026-08-19 14:54) chore: sesuaikan driver filesystem dan migrasi form lsp
2d3d9f4 (2026-08-19 14:54) fix: perbaikan komponen React form wizard dan API Eksternal
ddbb58f (2026-08-19 14:53) feat: tambahkan dukungan autofill pada form data akun
2205828 (2026-08-19 14:53) fix(ui): perbaiki tampilan ikon profil pengguna dan menu navigasi
7352619 (2026-08-19 14:53) feat(tte): tambahkan fitur bypass dummy TTE saat API Key tidak diset
a9211fb (2026-08-19 14:48) style(eksternal): update tagline logo menjadi portal layanan dan informasi terintegrasi
9b533c7 (2026-08-19 11:36) feat: Add TTE certificate issuance and SIS bridging
318e315 (2026-08-19 11:27) feat: Add audit, LKS, and komite sertifikasi modules
411efdb (2026-08-19 11:21) feat: Add multi-item Sertifikasi API & frontend wizard
e5c1fdd (2026-08-19 11:13) feat: Add sertifikasi data models and SIS migration
c1e9497 (2026-08-19 11:03) chore: add favicon icon
35fe8cd (2026-08-19 09:35) fix(nginx): use loopback fastcgi_pass and clean up config formatting
56580c1 (2026-08-19 09:32) chore(docker): menyesuaikan konfigurasi service app dan mysql database
5e58a79 (2026-08-18 21:27) feat: Add dynamic RBAC context, guards and UI
49bbe15 (2026-08-18 14:55) feat: Migrate Admin portal & SSO hub UI and routes
96e0fae (2026-08-18 12:50) feat: Refactor region/profile hooks; improve UI & caching
d6a3bcc (2026-08-18 12:37) feat: Add query layer and validation schemas
a69c352 (2026-08-18 12:26) feat: Refactor feedback form to new UI/Tailwind
f20d0e7 (2026-08-18 11:14) feat: Refactor forms to new UI components & wizards
020b7e5 (2026-08-18 11:05) style: Improve layout responsiveness and input styling
f9bd091 (2026-08-18 10:56) feat: Modernize help and profile forms
832e8f4 (2026-08-18 10:36) feat: Revamp eksternal portal UX and routes
cffdf2a (2026-08-18 10:24) feat: Refresh external dashboard UI and asset setup
47480cd (2026-08-18 10:09) feat: Add Tailwind UI shell and reusable components
de1ca50 (2026-08-18 09:49) feat: Guard reCAPTCHA when disabled
c8ff4a3 (2026-08-18 06:19) fix: invoice template rendering
```

---

## 🔍 Detail Perubahan Berdasarkan Hari & Fitur

### 📅 21 Agustus 2026

#### 1. Admin Helpdesk APIs, Live UI, & Seeders (`8307b8a`)
* **Backend API (`PertanyaanController.php`)**:
  * Menambahkan endpoint `adminList`: Mendukung filtering berdasarkan status (`OPEN`, `PROCESSED`, `ANSWERED`, `CLOSED`), pencarian tiket, dan relasi user pemohon.
  * Menambahkan endpoint `adminReply`: Mengirimkan balasan resmi staff internal/admin ke tiket pemohon.
  * Menambahkan endpoint `adminClose`: Menutup tiket pertanyaan dengan status final `CLOSED`.
* **Sidebar Counter API (`DashboardController.php`)**:
  * Endpoint `sidebarCounts` mengembalikan jumlah notifikasi aktif dan tiket helpdesk berstatus pending untuk ditampilkan di badge navigasi admin.
* **Frontend Admin Interface (`AdminPertanyaanPage.tsx`)**:
  * Antarmuka helpdesk real-time dengan search bar, filter tabs status, drawer/modal detail thread pesan, formulir reply langsung, dan tombol konfirmasi penutupan tiket.
* **Live Permohonan Pages**:
  * `AdminPermohonanListPage.tsx` dan `AdminPermohonanDetailPage.tsx` beralih dari static mockup ke query API live.
* **Database Mock Seeders**:
  * `DummyPolimerSeeder.php`: Mengisi puluhan permohonan simulasi lintas semua modul (Lab, Kalibrasi, Konsultansi, Pelatihan, LSP, Sertifikasi) lengkap dengan riwayat status workflow dan tiket tanya-jawab.
  * `MarketingUserSeeder.php`: Menginisialisasi akun login `marketing@mailinator.com` dan role tim verifikasi internal.

#### 2. Multi-Certification Submission Wizard (`37d425c`)
* **Multi-Pengajuan Architecture**:
  * Mendukung pendaftaran beberapa jenis produk dan skema sertifikasi sekaligus dalam satu ID permohonan.
* **Wizard 4 Langkah Modern (`FormSertifikasiWizard.tsx`)**:
  * `Step1JenisPermohonan.tsx`: Pemilihan skema sertifikasi (SPPT SNI, Sertifikasi Produk Baru, dsb.).
  * `Step2KategoriDanKomoditi.tsx`: Input komoditi, pemilihan standar SNI, deskripsi merek, tipe produk, dan upload dokumen pendukung per item.
  * `Step3PerusahaanDanPabrik.tsx`: Input lokasi pabrik, jalur produksi, dan profil legalitas perusahaan.
  * `Step4PernyataanKonfirmasi.tsx`: Ringkasan checklist berkas, estimasi biaya, dan persetujuan pakta integritas.
* **Backend Controller (`SertifikasiController.php`)**:
  * Validasi dynamic array `pengajuan.*`, pembuatan record relasional `FormSertifikasiItem` dan `FormSertifikasiPabrik`, kalkulasi PNBP, dan penautan ke polymorphic `detail_permohonan`.
* **Catalog API (`DashboardController.php`)**:
  * Endpoint `layanan` untuk memuat master opsi sertifikasi aktif.

---

### 📅 20 Agustus 2026

#### 1. Arsitektur Pembayaran BNI Virtual Account (e-Collection) (`a2d2c1a`, `04dc2b0`, `78e651f`, `927dcc5`)
* **BNI Service Layer (`BniVaService.php`)**:
  * Implementasi enkripsi 2-step Double Hashing XOR standar BNI e-Collection.
  * Pembuatan nomor VA dinamis saat penetapan invoice biaya layanan.
* **Webhook Controller (`BniWebhookController.php`)**:
  * Endpoint `POST /api/v1/payment/bni/callback` menerima real-time payment push notification dari BNI.
  * **Idempotency Guard**: Logging transaksi di `bni_va_logs` untuk mencegah update berulang jika bank mengirim webhook lebih dari sekali.
* **Asynchronous Queue Worker (`ProcessBniPaymentJob.php`)**:
  * Pengalihan kompilasi PDF Kuitansi ber-QR code dan pengubahan status permohonan dari `PEMBAYARAN` ke `PROCESS` melalui Redis Queue Worker.
* **Testing Sandbox**:
  * Penyediaan opsi `BNI_VA_DUMMY=true` pada `.env` untuk kemudahan simulasi bayar instan di lingkungan development lokal.

#### 2. Decouple BSrE TTE ke Internal Microservice (`935abdc`)
* **Guzzle HTTP Client Migration**:
  * Menggantikan library SDK lawas dengan HTTP Client langsung ke `bbkkp-internal-service` (FrankenPHP Octane di port `10020`).
* **Verifikasi Hash Dokumen**:
  * Penambahan verifikasi keaslian PDF via MD5 checksum di `/api/esign/verify/doc`.
* **Dummy Bypass Mode**:
  * Mode `TTE_DUMMY=true` memungkinkan alur approval berjalan mulus dan menerbitkan dummy certificate saat API key BSrE BSSN belum dikonfigurasi.

#### 3. Internasionalisasi & Optimasi Performa (`c1d8db4`, `7fddd3e`, `1f582ac`)
* **i18n Multi-bahasa**:
  * `SetLocaleMiddleware.php` mendeteksi sesi bahasa pengguna (ID/EN) dan mengarahkan ke kamus terjemahan `lang/{id,en}`.
* **Asset & HTTP Caching**:
  * Penambahan directive Nginx gzip/brotli dan Cache-Control headers untuk asset static JS/CSS hasil kompilasi Vite.

---

### 📅 19 Agustus 2026

#### 1. Model Data Sertifikasi & Modul Audit (`e5c1fdd`, `411efdb`, `318e315`, `9b533c7`)
* **Database Models**:
  * `FormSertifikasi`, `FormSertifikasiItem`, `FormSertifikasiPabrik`.
* **Modul Audit & Komite**:
  * `SertifikasiAudit.php`: Pencatatan jadwal audit lapang dan auditor penanggung jawab.
  * `LaporanKesesuaian.php` (LKS): Pencatatan temuan audit mutu dan perbaikan dari pemohon.
  * `KomiteKeputusan.php`: Risalah rapat dan hasil keputusan sertifikasi (Lolos / Tunda / Tolak).
* **SIS Bridging Service**:
  * `SisSyncBridgingService.php`: Sinkronisasi status dan nomor sertifikat yang terbit ke tabel database legacy SIS.

#### 2. Refinement Frontend Eksternal (`a9211fb`, `7352619`, `2205828`, `ddbb58f`, `2d3d9f4`, `6583fee`, `a041de9`)
* Penyempurnaan UX form wizard, penambahan autofill profil perusahaan/instansi, perbaikan navigasi ikon, dan penyesuaian driver filesystem.

---

### 📅 18 Agustus 2026

#### 1. Desain Sistem Tailwind & Modern UI Kit (`47480cd`, `020b7e5`)
* Migrasi konfigurasi `tailwind.config.js` dan `postcss.config.js`.
* Pembuatan reusable components:
  * `AppShell.tsx`: Container layout dengan sidebar collapsible, header, dan notification badge.
  * `Button.tsx`, `Card.tsx`, `Badge.tsx`, `Input.tsx`, `Modal.tsx`, `DataTable.tsx`, `StatsCard.tsx`.

#### 2. Revamp Portal Pelanggan, Profil, & Form Layanan (`cffdf2a`, `832e8f4`, `f9bd091`, `f20d0e7`, `a69c352`)
* Refactoring form:
  * Form Lab Pengujian (`PengujianPage.tsx`)
  * Form Kalibrasi Alat (`KalibrasiPage.tsx`)
  * Form Konsultansi Teknis (`KonsultansiPage.tsx`)
  * Form Pelatihan & Bimtek Halal (`PelatihanPage.tsx`)
  * Form Sertifikasi LSP (`LSPPage.tsx`)
  * Form Update Profil (`FormPerorangan.tsx`, `FormInstansi.tsx`, `FormPerusahaan.tsx`)
  * Form Tanya Jawab / Helpdesk Pelanggan (`AskQuestionsPage.tsx`)
  * Form Feedback / Indeks Kepuasan (`FeedbacksPage.tsx`)

#### 3. Dynamic RBAC Context & Query Architecture (`d6a3bcc`, `96e0fae`, `49bbe15`, `5e58a79`, `de1ca50`, `c8ff4a3`)
* **Dynamic RoleContext**:
  * Proteksi rute berbasis role (Admin, Pelanggan, Pegawai, Bendahara).
* **React Query Layer**:
  * Custom hooks `useMasterQuery`, `useRegionQuery`, dan `useProfileQuery`.
* **Invoice Template Blade Cleanup**:
  * Perbaikan formatting PDF Invoice pada `layanan/invoice.blade.php`.
