# 📑 Laporan Rekonsiliasi & Integrasi Branch `origin/polimer_sis` ke `v2.1_internal-system-migration`

> **Proyek**: BBKKP Polimer (`private-polimer`)  
> **Tanggal Rekonsiliasi**: 28 Agustus 2026  
> **Branch Target (Utama)**: `v2.1_internal-system-migration` (HEAD)  
> **Branch Sumber**: `origin/polimer_sis`  
> **Merge Commit**: [`fc2d592`](file:///f:/!Productive/BBKKP/private-polimer/) (*Merge remote-tracking branch 'origin/polimer_sis' into v2.1_internal-system-migration*)  
> **Status Akhir**: ✅ **100% Selesai & Terverifikasi (Build 0 Error)**

---

## 1. Latar Belakang & Tujuan

Branch `origin/polimer_sis` dan `v2.1_internal-system-migration` berkembang secara terpisah setelah titik pisah commit `6583fee`. Branch `v2.1_internal-system-migration` berfokus pada modernisasi arsitektur relasional, modul operasional internal (Audit, LKS, Komite), integrasi pembayaran VA BNI, RBAC terpusat, dan Auto-Generate PDF dokumen. Sementara itu, branch `origin/polimer_sis` berfokus pada kelengkapan isian formulir permohonan sertifikasi LSPro BBSPJIKKP (30+ field), autosave IndexedDB browser, auto-populate profil, dan template dokumen Word.

Tujuan dari proses ini adalah **mengadopsi seluruh fitur unggulan dari `origin/polimer_sis` tanpa merusak fondasi arsitektur relasional dan tetap mempertahankan sistem desain frontend 100% konsisten dengan branch `v2.1_internal-system-migration`**.

---

## 2. Matriks Keputusan Arsitektural

```
+---------------------------------------------------------------------------------------------------------+
|                                    HASIL REKONSILIASI ARSITEKTUR                                        |
+------------------------------------+------------------------------------+-------------------------------+
| Komponen / Modul                   | Keputusan Rekonsiliasi             | Alasan & Dampak Teknis        |
+------------------------------------+------------------------------------+-------------------------------+
| 1. Struktur Database Sertifikasi   | 🟢 Skema Relasional HEAD           | Multi-item & multi-pabrik     |
| 2. Client-side Autosave (Draft)    | 🌟 Ambil dari polimer_sis (IndexedDB)| Mencegah data hilang di web  |
| 3. Master Komoditi & SNI           | 🌟 Ambil dari polimer_sis          | Menjamin master data lokal    |
| 4. Integrasi TTE BSrE              | 🟢 HTTP Client + Dummy Mode (HEAD) | Fleksibel di lokal & prod     |
| 5. Alur Operasional (Audit/LKS)    | 🟢 Pertahankan HEAD                | Siklus audit & komite lengkap |
| 6. Integrasi Pembayaran BNI VA     | 🟢 Pertahankan HEAD                | E-Collection & webhook        |
| 7. Auto-populate Profil Pemohon    | 🌟 Ambil dari polimer_sis          | Auto-isi Akta & NIB pemohon   |
| 8. PDF Auto-Generate (AG)          | 🟢 Gunakan AG DomPDF HEAD          | LHU, Invoice & Kuitansi aman  |
| 9. Frontend Styling & Theme        | 🟢 100% Sistem Desain HEAD        | Konsistensi UI/UX Tailwind    |
| 10. Object Storage Emulation       | 🌟 MinIO S3 Docker polimer_sis     | Testing S3 lokal tanpa cloud  |
+------------------------------------+------------------------------------+-------------------------------+
```

---

## 3. Rincian Teknis Implementasi Per Lapisan

### 3.1. Database, Model & Seeder

1. **Model `MasterKomoditi` & Migrasi**:
   - File Model: [`app/Models/Db2/MasterKomoditi.php`](file:///f:/!Productive/BBKKP/private-polimer/app/Models/Db2/MasterKomoditi.php)
   - File Migrasi: [`database/migrations/2026_08_24_132446_create_master_komoditi_table.php`](file:///f:/!Productive/BBKKP/private-polimer/database/migrations/2026_08_24_132446_create_master_komoditi_table.php)
   - Seeder: [`database/seeders/MasterKomoditiSeeder.php`](file:///f:/!Productive/BBKKP/private-polimer/database/seeders/MasterKomoditiSeeder.php) (memuat komoditi sepatu karet, ban, helm, mainan anak, pupuk, tekstil, dsb.)
2. **Kolom `sertifikat_lama_nomor`**:
   - File Migrasi: [`database/migrations/2026_08_28_000001_add_sertifikat_lama_nomor_to_form_sertifikasi_table.php`](file:///f:/!Productive/BBKKP/private-polimer/database/migrations/2026_08_28_000001_add_sertifikat_lama_nomor_to_form_sertifikasi_table.php)
   - Ditambahkan ke `$fillable` pada [`app/Models/Db2/FormSertifikasi.php`](file:///f:/!Productive/BBKKP/private-polimer/app/Models/Db2/FormSertifikasi.php).
3. **Seeder Riwayat Sertifikat Aktif**:
   - File Seeder: [`database/seeders/SertifikatSeeder.php`](file:///f:/!Productive/BBKKP/private-polimer/database/seeders/SertifikatSeeder.php)
   - Disesuaikan dengan skema relasional HEAD (`FormSertifikasi` + `FormSertifikasiItem` + `DetailPermohonan`), membuat 4 data riwayat sertifikasi dummy (SMM, SML, SPPT SNI, Industri Hijau) untuk user `perusahaan@mailinator.com`.
   - Didaftarkan pada [`database/seeders/DatabaseSeeder.php`](file:///f:/!Productive/BBKKP/private-polimer/database/seeders/DatabaseSeeder.php).

---

### 3.2. Backend API & Routing

1. **Endpoint Riwayat Sertifikasi Aktif**:
   - Method `getRiwayatSertifikasi(Request $request)` pada [`Modules/Eksternal/app/Http/Controllers/Api/SertifikasiController.php`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/app/Http/Controllers/Api/SertifikasiController.php).
   - Mengambil permohonan sertifikasi dengan status `DONE` dan nomor `SRT%` milik user login.
   - Mengembalikan data terstruktur (`nomor_sertifikat`, `lingkup_id`, `skema_sertifikasi`, `komoditi`, `sni`, `tgl_terbit`).
2. **Pendaftaran Rute**:
   - Ditambahkan `GET /eksternal/sertifikasi/riwayat-aktif` pada [`Modules/Eksternal/routes/web.php`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/routes/web.php).

---

### 3.3. Client-Side Draft Engine (IndexedDB)

1. **Database Utility**:
   - File: [`Modules/Eksternal/resources/assets/js/utils/indexedDB.ts`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/utils/indexedDB.ts)
   - Mengelola object store `sertifikasi_drafts` di database browser `BBSPJIKKP_Polimer_DB`.
2. **Custom Hook React**:
   - File: [`Modules/Eksternal/resources/assets/js/hooks/useSertifikasiDraft.tsx`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/hooks/useSertifikasiDraft.tsx)
   - Fitur debounced autosave 1 detik, load draf tersimpan saat mount, dan fungsi pembersihan draf (`clearDraft()`).

---

### 3.4. Frontend Multi-Step Form Wizard (100% Styling HEAD)

1. **TypeScript Definitions**:
   - File: [`Modules/Eksternal/resources/assets/js/types/sertifikasi.ts`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/types/sertifikasi.ts)
   - Diperkaya dengan 30+ field ketenagakerjaan, multi-pabrik, daftar `DokumenPersyaratanItem` (6 jenis dokumen resmi + template URL), dan detail komoditi (`ukuran`, `satuan_produksi`, `keterangan`).
2. **Step 1 — Jenis Permohonan**:
   - File: [`Step1JenisPermohonan.tsx`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/components/input-service-requests/multiSertifikasi/Step1JenisPermohonan.tsx)
   - Menampilkan dropdown selector sertifikat aktif yang diambil secara dinamis dari API `/api/eksternal/sertifikasi/riwayat-aktif` dengan fallback input manual.
3. **Step 2 — Kategori, Komoditi & Dokumen**:
   - File: [`Step2KategoriDanKomoditi.tsx`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/components/input-service-requests/multiSertifikasi/Step2KategoriDanKomoditi.tsx)
   - Auto-populate berkas Akta Pendirian dan NIB dari profil perusahaan (`isFromProfile` dengan badge "Tersedia dari Profil").
   - Tautan unduh template dokumen Word resmi (`.docx`) untuk Formulir Permohonan (F.01.01) dan Kuesioner Mandiri (F.01.02).
   - Form komoditi lengkap (`ukuran`, `satuan_produksi`, `keterangan`).
4. **Step 3 — Kondisi Perusahaan & Fasilitas Pabrik**:
   - File: [`Step3PerusahaanDanPabrik.tsx`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/components/input-service-requests/multiSertifikasi/Step3PerusahaanDanPabrik.tsx)
   - Input ketenagakerjaan terperinci (Total, Manajemen, Administrasi, Operasional, Part-time, Non-permanen, Shift 1, 2, 3, dan Jumlah Bagian).
   - Input luas tanah & luas bangunan perusahaan serta upload file berkas gabungan.
   - Form multi-pabrik lengkap (nama, negara, provinsi, kontak, HP, fax, luas tanah, luas bangunan, kegiatan utama).
5. **Wizard Container & Hook Integration**:
   - File: [`FormSertifikasiWizard.tsx`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/components/input-service-requests/multiSertifikasi/FormSertifikasiWizard.tsx)
   - Banner pemulihan draf interaktif dengan opsi "Lanjutkan Draf" atau "Buang Draf".
   - Pembersihan otomatis draf IndexedDB saat permohonan berhasil diajukan.
6. **Submit Mutation**:
   - File: [`useSertifikasi.tsx`](file:///f:/!Productive/BBKKP/private-polimer/Modules/Eksternal/resources/assets/js/hooks/service-requests/useSertifikasi.tsx)
   - Fungsi `buildFormData` diperbarui untuk memuat seluruh field ketenagakerjaan, pabrik, komoditi, dan berkas dokumen dalam multipart `FormData`.

---

### 3.5. Analisis Dokumen PDF: Auto-Generate (AG) vs Statis

Berdasarkan audit teknis terhadap modul pencetakan dokumen PDF:

| Dokumen | Di Branch `polimer_sis` (Lama) | Di Branch `HEAD` (`v2.1_internal-system-migration`) | Status Implementasi |
| :--- | :--- | :--- | :--- |
| **PDF LHU (Laporan Hasil Uji)** | ❌ Belum ada endpoint / generator. | ✅ **Auto-Generate (AG)** via DomPDF pada `previewHasilUji()`. | Aktif di HEAD |
| **PDF Invoice PNBP** | ⚠️ Hanya membaca file fisik / TTE call. Error 404 jika belum terbit. | ✅ **Auto-Generate (AG) dengan Dynamic Fallback** via DomPDF pada `streamInvoice()`. | Aktif di HEAD |
| **PDF Kuitansi Sah** | ⚠️ Hanya membaca file TTE BSrE. Error 404 jika belum terbit. | ✅ **Auto-Generate (AG) dengan Dynamic Fallback** via DomPDF pada `streamKuitansi()`. | Aktif di HEAD |

---

### 3.6. Static Assets & DevOps

1. **Dokumen Template Word**:
   - `public/files/pengajuan/sertifikasi/F MHN 1 Permohonan Sertifikasi.docx`
   - `public/files/pengajuan/sertifikasi/F MHN 2 Kondisi Umum Perusahaan.doc`
   - `public/files/pengajuan/sertifikasi/F MHN 3 Surat Pernyataan Perusahaan.docx`
2. **Aset Gambar Badge**:
   - `public/images/sertifikasi-asset/cert_jeca.png`
   - `public/images/sertifikasi-asset/cert_jpa.png`
   - `public/images/sertifikasi-asset/cert_jpa2.png`
   - `public/images/sertifikasi-asset/cert_yok3.png`
   - `public/images/sertifikasi-asset/cert_yq.png`
   - `public/images/sertifikasi-asset/pengajuan_baru.jpg`
   - `public/images/sertifikasi-asset/pengajuan_lama.jpg`
3. **Docker Compose**:
   - Menambahkan service `minio` (port 9000/9001) dan volume `private_minio_data` pada [`docker-compose.yml`](file:///f:/!Productive/BBKKP/private-polimer/docker-compose.yml).

---

## 4. Hasil Verifikasi & Uji Mutu

| Komponen Pengujian | Perintah / Uji | Hasil | Status |
| :--- | :--- | :--- | :--- |
| **Migrasi Database** | `php artisan migrate` | 2 migrasi baru berhasil dieksekusi tanpa konflik | ✅ PASS |
| **Master Komoditi Seeder** | `php artisan db:seed --class=MasterKomoditiSeeder` | Data master komoditi terisi lengkap | ✅ PASS |
| **Riwayat Sertifikat Seeder** | `php artisan db:seed --class=SertifikatSeeder` | 4 data riwayat sertifikat terbuat relasional | ✅ PASS |
| **Frontend Production Build** | `npm run build` | 2.790 modul terkompilasi dalam 22.87 detik (0 error) | ✅ PASS |
| **Git Repository Status** | `git status` | Working tree clean, commit `fc2d592` pushed | ✅ PASS |
