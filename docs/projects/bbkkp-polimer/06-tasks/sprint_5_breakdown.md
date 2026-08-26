# Sprint 5 Breakdown — Dynamic RBAC Matrix, Testing Komprehensif, Optimasi & Production Cutover
## Proyek Modernisasi Tech Stack BBKKP Polimer

> **Sprint**: 5 dari 5 (Sprint Final / Release Milestone)  
> **Durasi**: 2 Minggu  
> **Fokus Utama**: Implementasi Dynamic RBAC Permission Guard di Frontend, QA & E2E Lifecycle Testing, Optimasi Bundle Vite & Asset, Dokumentasi User & Developer Guide di BBKKP-Docs, serta SOP Cutover & Deployment Production  
> **Target Branch**: `feature/rbac-testing-and-production-cutover`

---

## 1. Sasaran Sprint (Sprint Goal)
1. **Dynamic RBAC & Granular Security**: Mengintegrasikan otorisasi dinamis di frontend (`PermissionGuard`, `usePermission`, `PermissionGate`/`Can`) yang sinkron dengan tabel hak akses database backend (`sys_group_permission`, `sys_menu_action`, `sys_user_group`). Memastikan navigasi menu dan tombol aksi (*CanCreate*, *CanApprove*, *CanExport*, *CanDelete*) terlindungi secara berlapis.
2. **QA & Automated Testing Terpadu**: Menyusun suite pengujian komprehensif mulai dari unit test logika otorisasi dan validasi skema form Zod, hingga skrip skenario pengujian E2E (*End-to-End*) yang menguji siklus hidup lengkap permohonan (*Pendaftaran Pemohon → Input Permohonan → Verifikasi Admin → Penagihan Invoice PNBP → Pembayaran VA → Terbit Sertifikat TTE*).
3. **Performa & Bundle Optimization**: Mengonfigurasi `vite.config.js` dengan pemisahan chunk vendor (`manualChunks`), eliminasi kode mati (*tree-shaking*), kompresi asset, dan optimasi performa render untuk mencapai skor Lighthouse optimal.
4. **Dokumentasi Sistem Lengkap**: Menyediakan User Manual Pemohon/Pelanggan, User Manual Petugas Internal Balai, dan Developer Guide Arsitektur di repositori `BBKKP-Docs`.
5. **SOP Cutover & Kesiapan Rilis**: Menyusun standar operasional prosedur transisi sistem tanpa downtime (*Zero-Downtime Cutover*), checklist verifikasi staging, dan skenario mitigasi rollback.

---

## 2. Rincian Task Breakdown Komprehensif (5 Pilar Modul)

---

### 🔐 PILAR 1: Dynamic RBAC Matrix & Permission Guard Frontend (TS5-01)
* **TS5-01A: Definisi Tipe RBAC & Schema Hak Akses (`types/rbac.ts`)**
  - Pemodelan interface `PermissionAction` (`view`, `create`, `edit`, `delete`, `approve`, `export`, `assign`, `reject`).
  - Pemodelan grup sistem (`SUPER_ADMIN`, `VERIFIKATOR`, `ASESOR`, `BENDAHARA`, `PELANGGAN`, `PETUGAS_LAB`).
  - Struktur data session permission yang dikirim dari backend Laravel.
* **TS5-01B: Permission Context & Custom Hook (`context/PermissionContext.tsx` & `hooks/usePermission.ts`)**
  - Manajemen state hak akses aktif pengguna, role aktif, daftar role multi-grup yang dimiliki, dan fungsi `switchRole(groupId)`.
  - Fungsi utilitas evaluasi:
    - `can(action, module)`: Evaluasi izin aksi spesifik pada modul tertentu.
    - `hasRole(roles)`: Evaluasi apakah pengguna memiliki peran tertentu.
    - `canAccessRoute(path)`: Evaluasi hak akses rute menu admin/pelanggan.
* **TS5-01C: Route Guard & 403 Forbidden View (`guards/PermissionGuard.tsx`)**
  - Komponen pembungkus rute yang memvalidasi role / permission sebelum merender halaman.
  - Tampilan visual *Access Denied / 403 Forbidden* yang informatif jika pengguna tidak memiliki izin akses.
* **TS5-01D: Declarative UI Gate (`components/common/PermissionGate.tsx`)**
  - Komponen deklaratif untuk kontrol visibilitas tombol aksi:
    ```tsx
    <PermissionGate action="approve" module="permohonan">
      <Button onClick={handleApprove}>Setujui Permohonan</Button>
    </PermissionGate>
    ```
* **TS5-01E: Dynamic Navigation & Role Switcher di Admin Layout (`AdminShell.tsx` & `routes.tsx`)**
  - Filter item sidebar dinamis berdasarkan modul dan permission yang aktif.
  - Quick role switcher pada top navbar bagi pengguna dengan multi-grup (misal: Verifikator yang juga bertindak sebagai Asesor).
  - Proteksi seluruh sub-rute admin sensitif menggunakan `PermissionGuard`.

---

### 🧪 PILAR 2: QA & Comprehensive Automated Testing Suite (TS5-02)
* **TS5-02A: Unit Test Logika Otorisasi RBAC (`tests/frontend/rbac.test.ts`)**
  - Pengujian fungsi `can()`, `hasRole()`, `canAccessRoute()` dalam berbagai skenario hak akses (Super Admin, Verifikator, Bendahara, Pelanggan).
  - Pengujian perilaku perenderan `PermissionGuard` dan `PermissionGate` saat izin diberikan vs ditolak.
* **TS5-02B: Unit Test Validasi Skema Form Zod (`tests/frontend/schemas.test.ts`)**
  - Validasi schema otentikasi (login, register, ubah sandi, format password kuat).
  - Validasi schema profil (Perorangan, Perusahaan, Instansi Pemerintah, format NIK 16 digit & NPWP 15/16 digit).
  - Validasi schema formulir permohonan layanan (Uji Lab, Kalibrasi, LSP, Pelatihan).
* **TS5-02C: Automated E2E Lifecycle Test Suite (`tests/e2e/e2e_permohonan_lifecycle.spec.ts`)**
  - Skenario terpadu 6 langkah pengujian siklus bisnis inti:
    1. **Tahap 1**: Registrasi akun pelanggan baru & verifikasi kredensial.
    2. **Tahap 2**: Pengajuan permohonan layanan uji laboratorium & unggah dokumen persyaratan.
    3. **Tahap 3**: Login verifikator admin, tinjauan berkas, dan approval permohonan.
    4. **Tahap 4**: Penerbitan invoice tarif PNBP oleh bendahara & simulasi billing VA BNI.
    5. **Tahap 5**: Konfirmasi pembayaran & verifikasi kuitansi lunas sah.
    6. **Tahap 6**: Penginputan hasil uji laboratorium dan penerbitan sertifikat digital TTE.

---

### ⚡ PILAR 3: Production Build Optimization & Asset Tuning (TS5-03)
* **TS5-03A: Konfigurasi Chunk Splitting di Vite (`vite.config.js`)**
  - Pemisahan bundle vendor menjadi chunk terisolasi:
    - `vendor-react`: `react`, `react-dom`, `react-router-dom`
    - `vendor-tanstack`: `@tanstack/react-query`
    - `vendor-ui`: `lucide-react`, `react-feather`, `sweetalert2`, `react-hot-toast`
    - `vendor-forms`: `react-hook-form`, `@hookform/resolvers`, `zod`
* **TS5-03B: Tree-Shaking, Minifikasi & Optimasi Asset**
  - Eliminasi fungsi `console.log` dan `console.debug` pada build environment production.
  - Kompresi asset statis dan pembersihan CSS tak terpakai melalui konfigurasi PostCSS/Tailwind.

---

### 📖 PILAR 4: Dokumentasi Operasional & Pengembang (TS5-04)
* **TS5-04A: Panduan Pengguna Pelanggan / Eksternal (`user_manual_customer.md`)**
  - Panduan lengkap mulai dari pembuatan akun, tata cara pengajuan uji/kalibrasi/LSP, pelacakan status permohonan (*tracking timeline*), tata cara pembayaran melalui Virtual Account, hingga proses mengunduh sertifikat ber-TTE.
* **TS5-04B: Panduan Pengguna Petugas Internal Balai (`user_manual_admin.md`)**
  - Panduan verifikasi berkas permohonan, disposisi petugas/asesor, pembuatan invoice tarif PNBP, verifikasi pembayaran, input parameter hasil uji laboratorium, dan manajemen pengguna/role sistem.
* **TS5-04C: Panduan Pengembang & Arsitektur (`developer_guide.md`)**
  - Panduan teknis arsitektur: standar arsitektur SPA + Laravel REST API, pola pengelolaan state TanStack Query v5, validasi Zod schema, mekanisme RBAC dinamis, dan panduan menambahkan modul baru.

---

### 🚀 PILAR 5: SOP Cutover & Zero-Downtime Deployment (TS5-05)
* **TS5-05A: Standar Operasional Prosedur Cutover (`cutover_and_deployment_sop.md`)**
  - Checklist pra-cutover: verifikasi integritas database, backup skema & data eksisting, validasi env variable staging & production.
  - Alur eksekusi migrasi tanpa gangguan layanan (*Zero-Downtime Strategy*):
    - Build asset frontend production (`npm run build`).
    - Cache warm-up & route switching di Laravel.
    - Smoke test pasca-rilis.
  - Prosedur mitigasi & rollback instan apabila ditemukan anomali kritis.

---

## 3. Matriks Kriteria Penerimaan (Definition of Done)
1. Seluruh rute dan aksi di portal admin terproteksi oleh `PermissionGuard` dan `PermissionGate` yang terhubung secara dinamis dengan context RBAC.
2. Test suite frontend (Unit Test RBAC, Skema Zod, dan E2E Lifecycle) lolos pengujian 100%.
3. Konfigurasi build Vite teroptimasi dengan chunk vendor terpisah dan lolos kompilasi production build.
4. Repositori `BBKKP-Docs` terisi lengkap dengan User Manual Pelanggan, User Manual Admin, Developer Guide, dan SOP Cutover.
5. Seluruh deliverable siap untuk rilis production final modernisasi BBKKP Polimer.
