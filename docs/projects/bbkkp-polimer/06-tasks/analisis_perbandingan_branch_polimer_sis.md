# 📑 Dokumen Analisis Perbedaan & Panduan Rekonsiliasi (Merging Reference)
## Perbandingan Branch `v2.1_internal-system-migration` (Lokal/HEAD) vs `origin/polimer_sis` (Teman)

> **Proyek**: BBKKP Polimer  
> **Titik Pisah (*Merge Base*)**: Commit [`6583fee`](file:///d:/Productive/BBKKP/private-polimer/) (*chore: sesuaikan driver filesystem dan migrasi form lsp*)  
> **Tujuan**: Mengidentifikasi kesamaan tugas (*overlapping work*), potensi konflik (*merge conflicts*), evaluasi kelebihan/kekurangan masing-masing branch, serta rekomendasi pemilihan komponen yang perlu dibawa ke branch utama.

---

## 1. Ringkasan Eksekutif Perbandingan

Kedua branch sama-sama mengerjakan modul **Pendaftaran Sertifikasi Produk & Sistem (LSPro)** setelah commit `6583fee`, namun mengambil pendekatan arsitektur dan ruang lingkup yang berbeda:

```
+---------------------------------------------------------------------------------------------------------+
|                                    TITIK PISAH (Commit 6583fee)                                         |
+----------------------------------------------------+----------------------------------------------------+
| Branch: v2.1_internal-system-migration (HEAD)      | Branch: origin/polimer_sis (Teman)                 |
+----------------------------------------------------+----------------------------------------------------+
| 1. Arsitektur Relasional Multi-Item & Multi-Pabrik | 1. Arsitektur Flat Table (JSON Columns)            |
| 2. Siklus Lengkap: Audit, LKS, Komite & Penerbitan | 2. Fokus pada Form Input Wizard & Validasi Berkas   |
| 3. Integrasi BNI Virtual Account & Webhook Payment | 3. Fitur Autosave Draft di Browser (IndexedDB)      |
| 4. Layanan TTE (HTTP Client + Configurable Dummy)  | 4. Draf Dokumen Template Word (.docx) & Asset Badge|
| 5. Bridging & Sinkronisasi DB SIS Legacy           | 5. Master Data Komoditi Standar BBSPJIKKP (SNI)    |
| 6. Dynamic RBAC, Admin Portal, i18n & Caching      | 6. Auto-populate Berkas Legalitas dari Profil      |
+----------------------------------------------------+----------------------------------------------------+
```

---

## 2. Matriks Komparasi Fitur & Komponen

| Komponen / Fitur | Branch `v2.1_internal-system-migration` (HEAD) | Branch `origin/polimer_sis` (Teman) | Rekomendasi Keputusan Merging |
| :--- | :--- | :--- | :--- |
| **Struktur Database Form Sertifikasi** | **Ternormalisasi Relasional**: `form_sertifikasi`, `form_sertifikasi_item`, `form_sertifikasi_pabrik`, `pelanggan_pabrik`, `pelanggan_sertifikasi`. | **Flat + JSON**: Menyimpan `komoditas_json` dan `pabrik_json` dalam 1 baris tabel. | 🟢 **Gunakan versi HEAD**. Struktur relasional lebih terukur untuk reporting, multi-komoditi, dan integrasi audit/SIS. |
| **Fitur Autosave Draft** | Belum ada (mengandalkan state React memori). | **Tersedia (IndexedDB)**: Menyimpan draf form lokal di browser via `indexedDB.ts` + `useSertifikasiDraft.tsx`. | 🌟 **Ambil dari branch Teman**. Sangat bernilai untuk UX agar pengisian form tidak hilang saat browser tertutup. |
| **Master Komoditi & SNI** | Mengambil master dari DB SIS via bridging seeder. | **Tersedia Lokal**: Model `MasterKomoditi`, migrasi `master_komoditi`, dan seeder `MasterKomoditiSeeder` berisi standar komoditi BBSPJIKKP. | 🌟 **Ambil dari branch Teman**. Menjamin data komoditi dan nomor SNI tetap tersedia meski tanpa koneksi live SIS. |
| **Berkas Template & Asset Banner** | Template belum disertakan di public asset. | **Tersedia**: 3 File Word template pengajuan (`.docx`/`.doc`) dan 7 gambar badge sertifikasi di `public/`. | 🌟 **Ambil dari branch Teman**. Langsung copy file asset statis ke branch saat ini. |
| **Integrasi TTE (Tanda Tangan Digital)** | **HTTP Client Terisolasi + Configurable Dummy Mode** (`TTE_DUMMY=true/false` di `.env`). | Menghapus dummy mode, memanggil endpoint real secara langsung. | 🟢 **Gunakan versi HEAD**. Dummy mode sangat dibutuhkan developer lain saat bekerja di lingkungan lokal tanpa kredensial BSSN. |
| **Alur Operasional (Audit, LKS, Komite)** | **Lengkap**: Modul Audit sertifikasi, LKS revisi ketidaksesuaian, dan komite sertifikasi. | Belum diimplementasikan. | 🟢 **Gunakan versi HEAD**. |
| **Integrasi Pembayaran BNI VA** | **Lengkap**: Service BNI VA e-Collection, webhook handler, retry queue, dan UI status bayar. | Belum diimplementasikan. | 🟢 **Gunakan versi HEAD**. |
| **Penyimpanan Berkas (AWS S3 vs Lokal)** | Menggunakan disk `public` / fallback lokal di `config/filesystems.php`. | **Storage Adaptif**: Driver `s3` otomatis fallback ke disk `public` jika `AWS_ENABLED=false`. Endpoint asinkron upload berkas & helper `getFileUrl` (`temporaryUrl`). | 🌟 **Ambil dari Teman**. Helper `getFileUrl` & storage adaptif sangat baik untuk transisi mulus antara server lokal dan cloud S3 produksi. |
| **Arsitektur Frontend Admin & RBAC** | **100% Unified React 18 SPA**: Dynamic RBAC, Role switcher, helpdesk, invoice management. | Sebagian view masih merujuk ke Blade / Metronic lama. | 🟢 **Gunakan versi HEAD**. |

---

## 3. Rincian Analisis Per File Konflik / Beririsan

### 1. `app/Libraries/TteService.php`
* **Perbedaan**:
  - `HEAD`: Menggunakan wrapper Guzzle terpusat, support logging terstruktur, dan fitur simulasi aman (`TTE_DUMMY=true`).
  - `polimer_sis`: Mengubah penanganan parsing response (`results` vs `data`) dan menghapus logika dummy.
* **Tindakan**: **Pertahankan versi HEAD**, pastikan parsing response sudah mendukung format `results`.

---

### 2. `database/migrations/` & Model Database
* **Perbedaan**:
  - `polimer_sis` membuat migrasi `2026_08_24_114229_create_form_sertifikasi.php` (flat schema).
  - `HEAD` sudah memiliki `2026_08_17_000001_create_form_sertifikasi_table.php` (relational schema).
  - `polimer_sis` memiliki migrasi baru `2026_08_24_132446_create_master_komoditi_table.php` dan `MasterKomoditi.php`.
* **Tindakan**:
  - ❌ **JANGAN jalankan** migrasi `2026_08_24_114229_create_form_sertifikasi.php` agar tidak bentrok dengan tabel yang sudah ada.
  - ✅ **AMBIL** migrasi `2026_08_24_132446_create_master_komoditi_table.php`, model `MasterKomoditi.php`, dan `MasterKomoditiSeeder.php`.

---

### 3. Controller Sertifikasi (`Api/SertifikasiController.php`)
* **Perbedaan**:
  - `polimer_sis`: Endpoint berorientasi pada 1 pengajuan dengan file dokumen tetap (`file_pertanyaan_tambahan`, dll).
  - `HEAD`: Endpoint berorientasi multi-item (`form_sertifikasi_item`), multi-pabrik, download sertifikat, preview hasil uji PDF, dan LKS client.
* **Tindakan**: **Pertahankan controller HEAD**, tambahkan endpoint helper jika diperlukan untuk kompatibilitas master komoditi.

---

### 4. Frontend & Autosave Draft (`resources/assets/js/`)
* **Hal Hebat dari `polimer_sis` yang Wajib Diadopsi**:
  1. `Modules/Eksternal/resources/assets/js/utils/indexedDB.ts`: Engine client-side database IndexedDB.
  2. `Modules/Eksternal/resources/assets/js/hooks/useSertifikasiDraft.tsx`: Custom React Hook yang otomatis menyimpan draf input formulir tiap detik ke IndexedDB dan memunculkan banner pemulihan draf.
  3. `public/files/pengajuan/sertifikasi/*`: Template dokumen Word resmi dari BBSPJIKKP.
  4. `public/images/sertifikasi-asset/*`: Asset ilustrasi jenis sertifikat SNI/ISO.
* **Tindakan**:
  - Salin file utility dan hook IndexedDB.
  - Integrasikan hook `useSertifikasiDraft` ke dalam komponen `FormSertifikasiWizard.tsx`.
  - Salin seluruh file asset statis Word dan gambar.

---

### 5. Integrasi AWS S3 & Adaptive Storage (Upload Berkas)
* **Temuan Teknis**:
  - Di commit `6583fee`, teman Anda memperbarui `config/filesystems.php` agar disk `s3` otomatis fallback ke disk `local` (`storage/app/public`) saat `AWS_ENABLED=false` tanpa memicu error authentication AWS SDK.
  - Di commit `8bd23f8`, teman Anda menambahkan helper `saveCustomerFile` dan `getFileUrl` yang cerdas:
    - Jika di production (`AWS_ENABLED=true` / `filesystems.default=s3`), fungsi menghasilkan **Presigned URL aman sementara** via `Storage::disk('s3')->temporaryUrl(...)`.
    - Jika di lokal, fungsi fallback ke URL lokal `asset('storage/' . $path)`.
  - Endpoint upload dokumen mandiri `POST /api/v1/sertifikasi/upload-dokumen` juga disediakan untuk mendukung upload berkas asinkron dari wizard form.
* **Tindakan**:
  - Di branch `HEAD`, konfigurasi `config/filesystems.php` dan `.env` (`AWS_ENABLED=false`) sudah sejalan.
  - Helper `getFileUrl` dan endpoint upload asinkron ini sangat baik untuk diintegrasikan ke `SertifikasiController.php` di branch `HEAD`.

---

## 4. Langkah Bertahap untuk Membawa Changes (Cherry-Pick & Integration Guide)

Untuk menggabungkan perubahan tanpa merusak arsitektur `HEAD` dan tanpa memicu konflik git yang berantakan:

### Tahap 1: Salin Asset Statis Dokumen & Gambar
```bash
git checkout origin/polimer_sis -- "public/files/pengajuan/sertifikasi/"
git checkout origin/polimer_sis -- "public/images/sertifikasi-asset/"
```

### Tahap 2: Salin Utility IndexedDB & Hook Draft
```bash
git checkout origin/polimer_sis -- "Modules/Eksternal/resources/assets/js/utils/indexedDB.ts"
git checkout origin/polimer_sis -- "Modules/Eksternal/resources/assets/js/hooks/useSertifikasiDraft.tsx"
```

### Tahap 3: Salin Master Komoditi (Tabel, Model & Seeder)
```bash
git checkout origin/polimer_sis -- "app/Models/Db2/MasterKomoditi.php"
git checkout origin/polimer_sis -- "database/migrations/2026_08_24_132446_create_master_komoditi_table.php"
git checkout origin/polimer_sis -- "database/seeders/MasterKomoditiSeeder.php"
```

### Tahap 4: Hubungkan IndexedDB Draft ke Wizard Form Sertifikasi
Tambahkan pemanggilan `useSertifikasiDraft` pada `FormSertifikasiWizard.tsx` agar formulir otomatis menyimpan progres pengisian pengguna ke IndexedDB lokal browser.

### Tahap 5: Jalankan Migrasi & Seeder Master Komoditi
```bash
php artisan migrate --force
php artisan db:seed --class=MasterKomoditiSeeder
```
