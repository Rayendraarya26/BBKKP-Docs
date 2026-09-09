# 📑 Analisis Komparasi Mendalam: Branch `v2.1_internal-system-migration` vs `polimer_sis`
**Tanggal Analisis**: 09 September 2026  
**Repositori**: `Rayendraarya26/private-polimer`  
**Branch Sumber 1 (Pengembangan Utama Anda)**: `v2.1_internal-system-migration` (HEAD)  
**Branch Sumber 2 (Branch Utama Permanff)**: `polimer_sis`  
**Titik Pisah (*Merge Base*)**: Commit [`6583fee`](file:///f:/%21Productive/BBKKP/private-polimer/) (*chore: sesuaikan driver filesystem dan migrasi form lsp*)  
**Status Hubungan Git**: Divergen (Kedua branch memiliki commit independen setelah rekonsiliasi awal 28 Agustus 2026)  
**Total File Berbeda**: 207 files (+7.723 / -16.426 baris)

---

## 1. Ringkasan Eksekutif: Mengapa Terjadi Banyak Perbedaan?

Setelah titik pisah commit `6583fee` dan rekonsiliasi awal tanggal 28 Agustus 2026 (commit `fc2d592`), kedua branch dikembangkan secara paralel dengan fokus kebutuhan yang berbeda:

```
                                [Merge Base: 6583fee]
                                          |
        +---------------------------------+---------------------------------+
        |                                                                   |
[v2.1_internal-system-migration (Anda)]                       [polimer_sis (Permanff)]
* 100% Unified React 18 Admin SPA                           * Admin tetap di Laravel Blade + DataTables
* Dynamic RBAC Context & Permission Guard                   * Layout Dual-Rail Sidebar & App Launcher
* Siklus Lengkap: Audit, LKS, Komite & TTE                  * Modul Baru Modules/Webhook (Integrasi SIS)
* Backend BNI VA Service & Webhook Controller               * Alur Approval 2 Tahap (Verif -> Penawaran)
* 15+ Automated Test Suites (Feature, Unit, e2e)            * Sub-modul Tagihan Biaya (WIP)
* DummyPolimerSeeder (738 baris) & Marketing Seeder         * Master Komoditi Seeder 7 Lingkup Layanan
* i18n Localization (id/en)                                 * DetailPermohonanPage React Timeline SIS
        |                                                                   |
        +---------------------------------+---------------------------------+
                                          |
                     [POTENSI MERGE CONFLICT: ~18 File Kunci]
```

---

## 2. Matriks Komparasi Fitur & Arsitektur

| Aspek / Modul | Branch Anda (`v2.1_internal-system-migration`) | Branch Permanff (`polimer_sis`) | Analisis & Dampak |
| :--- | :--- | :--- | :--- |
| **Arsitektur Antarmuka Admin** | **100% React 18 SPA**: Memiliki `AdminShell.tsx`, `AdminDashboardPage`, `AdminPermohonanListPage`, `AdminPermohonanDetailPage`, `AdminInvoiceManagementPage`, `AdminPertanyaanPage`. | **Laravel Blade + Metronic + DataTables**: Menggunakan `layouts/app.blade.php`, `Modules/Permohonan/resources/views/layanan/`, dan `Modules/Home/resources/views/home/`. | **Perbedaan Filosofi UI Terbesar**. Anda memigrasi Admin ke SPA, sedangkan Permanff memodernisasi Admin di Blade dengan Dual-Rail Sidebar. |
| **Navigasi & Sidebar Admin** | Single rail React sidebar dengan dynamic permission tree. | **Dual-Rail Sidebar**: `_rail_primary.blade.php` (ikon ringkas) + `_rail_secondary.blade.php` (menu pohon & badges), plus `_app_launcher.blade.php`. | Desain Blade milik Permanff sangat modern dan terintegrasi dengan ekosistem aplikasi BBKKP (SIS, SILAB, SILAP). |
| **Integrasi SIS (Sistem Informasi Sertifikasi)** | Service bridging internal `app/Services/SisSyncBridgingService.php` dan sync manual route. | **Modul Terdedikasi `Modules/Webhook`**: `WebhookReceiverController.php`, `SisSyncBridgingService.php`, queue job `DispatchPermohonanToSisJob.php`, dan middleware `VerifyWebhookSignature.php`. | **Versi Permanff Lebih Lengkap untuk Integrasi**. Telah siap menerima callback webhook status dari SIS secara live. |
| **Tabel Audit & Tracking Integrasi** | Mengandalkan tabel bawaan permohonan. | **4 Tabel Database Baru**: `integration_logs`, `permohonan_tracking_logs`, `permohonan_penawaran_biaya`, serta field `sis_id`, `sis_status` di `permohonan`. | **Keunggulan Permanff**: Sangat penting untuk audit trail tahapan milestone permohonan antar sistem. |
| **Alur Verifikasi Admin Permohonan** | Approval standar langsung penetapan nominal biaya dan invoice. | **Alur 2 Tahap Adaptif**: Tahap 1 Verifikasi Administrasi $\rightarrow$ auto-dispatch ke SIS; Tahap 2 Penerbitan Penawaran Biaya resmi $\rightarrow$ Pembayaran. | **Keunggulan Permanff**: Alur ini sesuai dengan SOP Lembaga Sertifikasi (LS) BBKKP di mana kajian teknis dilakukan di SIS. |
| **Modul Tagihan Biaya (Admin)** | Tergabung dalam `AdminInvoiceManagementPage.tsx` dan `InvoiceController.php`. | **Sub-Modul Khusus (WIP)**: Mendaftarkan rute `tagihan-biaya` (`TagihanBiayaController`) dan method `kirimPenawaranBiaya` dengan array rincian biaya JSON. | Sedang dalam tahap pengerjaan aktif oleh Permanff. |
| **Wizard Sertifikasi Pemohon (React)** | 4-step form wizard di `Modules/Eksternal/resources/assets/js/components/multiSertifikasi/`. | 4-step form wizard di `multiSertifikasi/`. | 🟢 **100% IDENTIK!** Permanff telah mengadopsi seluruh komponen wizard buatan Anda (`Step1`, `Step2`, `Step3`, `Step4`, `FormSertifikasiWizard`). |
| **Detail Permohonan Pemohon (React)** | Menampilkan data permohonan, dokumen, dan tombol aksi bayar/TTE. | Menampilkan **5 Milestone Alur SIS** (`PERMOHONAN`, `KAJIAN_TEKNIS`, `PENAWARAN_BIAYA`, `PEMBAYARAN`, `PROCESS`) + Modal Persetujuan/Penolakan Penawaran Biaya. | **Keunggulan Permanff**: Tampilan tracking pemohon di `DetailPermohonanPage.tsx` lebih kaya dan interaktif. |
| **Backend BNI Virtual Account** | **Lengkap**: `app/Libraries/BniVaService.php`, `BniWebhookController.php`, `BniVaLog.php`, dan tes unit. | **Hanya Migrasi & Frontend**: Memiliki migrasi field VA dan halaman React `PembayaranPage.tsx`, namun file class `BniVaService.php` dan `BniWebhookController.php` **hilang/belum ada**. | ⚠️ **Kekurangan di `polimer_sis`**: BNI VA di branch Permanff belum bisa menerbitkan VA riil di backend karena service library-nya belum disertakan. |
| **Modul Audit, LKS, & Komite Sertifikasi** | **Lengkap di Backend**: Controller `AuditSertifikasiController`, `LksSertifikasiController`, `KomiteSertifikasiController`, `PenerbitanSertifikasiController`, dan model terkait. | Controller audit, LKS, dan komite **ditiadakan/dihapus**. Migrasi tabel tetap ada. | Permanff meniadakan controller ini karena proses audit teknis dan komite diserahkan ke sistem SIS legacy. |
| **Tanda Tangan Elektronik (TTE)** | HTTP Client standar Guzzle dengan modul dummy berbasis path lokal. | Menggunakan Guzzle client + OpenAPI generated client (`EsignResultResults`) + dummy mode file cache. | Kode di branch Anda lebih bersih (*clean code*), sedangkan versi Permanff memiliki penyesuaian untuk format respons server internal TTE. |
| **Master Komoditi BBSPJIKKP** | Master komoditi generik via seeder. | **Tersegmentasi Rapi (7 Lingkup)**: SPPT SNI, Halal Reguler, Halal UMK, ISO 9001, ISO 14001, Industri Hijau, INDI 4.0. | **Keunggulan Permanff**: Seeder komoditas jauh lebih akurat sesuai ruang lingkup layanan balai. |
| **Role & Akun Marketing** | `SysGroup::MARKETING` di `SysGroup.php` dan seeder `MarketingUserSeeder.php` (`marketing@mailinator.com`). | Enum `MARKETING` dan seeder marketing **belum ada** di `SysGroup.php`. | ⚠️ Di `polimer_sis`, alur verifikasi menyebut marketing tapi enumn-nya belum terdaftar. |
| **Automated Test Suite** | **15+ File Tes Lengkap**: Feature tests, Unit tests, frontend test (`rbac.test.ts`), e2e Playwright. 100% PASS. | **Tidak Ada File Pengujian**: Seluruh folder `tests/Feature` dan `tests/Unit` terkait sertifikasi dan BNI tidak ada. | **Keunggulan Mutlak Branch Anda**: Menjamin stabilitas kode dari regresi bug. |
| **Konfigurasi Docker WSL** | Port default `4900` (web), `3308` (mysql), `9000/9001` (minio). | Port khusus WSL `4903` (web), `3311` (mysql), `9004/9005` (minio). | Versi Permanff mencegah konflik port jika menjalankan service SIS dan Internal Service secara bersamaan di WSL. |

---

## 3. Daftar File yang Mengalami Konflik (Merge Conflict Simulation)

Berdasarkan simulasi `git merge-tree`, terdapat 18 file yang akan mengalami konflik langsung jika di-merge:

1. **Backend Permohonan & Invoice**:
   - `Modules/Permohonan/app/Http/Controllers/PermohonanController.php` *(Logika approval 2-tahap Permanff vs approval 1-tahap Anda)*
   - `Modules/Permohonan/app/Http/Controllers/InvoiceController.php`
   - `Modules/Permohonan/routes/web.php` *(Rute `tagihan-biaya` Permanff vs rute admin SPA/audit Anda)*
2. **Dashboard & Layout**:
   - `Modules/Home/app/Http/Controllers/DashboardController.php` *(KPI dan SLA urgent list Permanff vs parser dashboard Anda)*
3. **Frontend Routes & Service Requests**:
   - `Modules/Eksternal/resources/assets/js/routes.tsx` *(Rute Admin SPA Anda vs rute murni eksternal Permanff)*
   - `Modules/Eksternal/resources/assets/js/pages/service-requests/DetailPermohonanPage.tsx`
   - `Modules/Eksternal/resources/assets/js/pages/service-requests/PermohonanPage.tsx`
   - `Modules/Eksternal/routes/web.php`
4. **Service & Library Core**:
   - `app/Libraries/TteService.php` *(Implementasi Guzzle dummy)*
   - `app/Jobs/GenerateKwitansiDigitalJob.php`
5. **Database Seeder & Migration**:
   - `database/seeders/DatabaseSeeder.php`
   - `database/seeders/MasterKomoditiSeeder.php`
   - `database/seeders/SertifikatSeeder.php`
   - `database/migrations/2026_08_17_000001_create_form_sertifikasi_table.php`
6. **Environment & DevOps**:
   - `docker-compose.yml` *(Port 4900 vs 4903)*
   - `.env.example`
   - `.gitignore`

---

## 4. Rekomendasi Solusi & Rencana Aksi Rekonsiliasi (Action Plan)

Melihat kondisi di atas, strategi terbaik adalah **menggabungkan keunggulan kedua branch secara selektif (*Cherry-Pick & Reconcile*)** tanpa memaksakan merge kasar yang dapat merusak alur SIS maupun fitur admin yang sudah Anda bangun:

### Langkah 1: Tentukan Keputusan Arsitektur UI Admin
* **Kenyataan Lapangan**: Permanff telah mendesain antarmuka Admin menggunakan **Laravel Blade + Dual-Rail Sidebar** dan menambahkan metrik dashboard eksekutif serta form approval bertahap.
* **Rekomendasi**: 
  - Gunakan arsitektur **Admin Blade + Dual-Rail** milik `polimer_sis` untuk modul operasional harian balai (agar selaras dengan pekerjaan tim Permanff).
  - Simpan komponen **React Admin SPA** yang sudah Anda buat sebagai modul alternatif atau portal mandiri bila sewaktu-waktu balai menginginkan full-SPA.

### Langkah 2: Lengkapi Kekurangan Backend di `polimer_sis` Menggunakan Kode Branch Anda
Ada beberapa aset vital di branch Anda yang **wajib dibawa ke `polimer_sis`**:
1. **Salin BNI VA Backend**:
   - Salin `app/Libraries/BniVaService.php`
   - Salin `app/Http/Controllers/Api/BniWebhookController.php`
   - Salin `app/Models/Db2/BniVaLog.php`
   - Daftarkan rute webhook BNI di `routes/api.php`
2. **Salin Enum & Seeder Marketing**:
   - Tambahkan `case MARKETING = 'c3877664-427b-11ef-9454-0242ac120002';` ke [app/Enums/SysGroup.php](file:///f:/%21Productive/BBKKP/private-polimer/app/Enums/SysGroup.php).
   - Salin `database/seeders/MarketingUserSeeder.php`.
   - Salin `database/seeders/DummyPolimerSeeder.php` (sangat berharga untuk pengujian lokal).
3. **Salin Seluruh Automated Test Suites**:
   - Salin folder `tests/Feature/` dan `tests/Unit/` buatan Anda.
   - Jalankan `php artisan test` untuk memverifikasi bridging SIS, BNI VA, dan alur permohonan tetap berjalan 100% tanpa error.

### Langkah 3: Adopsi Fitur Baru dari `polimer_sis`
Pastikan fitur-fitur baru berikut dari Permanff tetap aktif:
1. Modul [Modules/Webhook/](file:///f:/%21Productive/BBKKP/private-polimer/Modules/Webhook/) (SisSyncBridgingService & WebhookReceiver).
2. Tabel integrasi dan tracking logs (`integration_logs`, `permohonan_tracking_logs`, `permohonan_penawaran_biaya`).
3. Alur verifikasi bertahap pada [PermohonanController.php](file:///f:/%21Productive/BBKKP/private-polimer/Modules/Permohonan/app/Http/Controllers/PermohonanController.php).
4. Master komoditi seeder dengan 7 lingkup layanan.
5. Konfigurasi port Docker WSL (`4903`, `3311`, `9004`).
