# 📑 Dokumen Analisis Perbedaan & Panduan Rekonsiliasi (Merging Reference)
## Perbandingan Branch `v2.1_internal-system-migration` (Lokal/HEAD) vs `origin/polimer_sis` (Teman)

> **Proyek**: BBKKP Polimer  
> **Titik Pisah (*Merge Base*)**: Commit [`6583fee`](file:///f:/%21Productive/BBKKP/private-polimer/) (*chore: sesuaikan driver filesystem dan migrasi form lsp*)  
> **Tujuan**: Mengidentifikasi kesamaan tugas (*overlapping work*), potensi konflik (*merge conflicts*), evaluasi kelebihan/kekurangan masing-masing branch, serta rekomendasi pemilihan komponen yang perlu dibawa ke branch utama.

> [!IMPORTANT]
> **Pembaruan 28 Agustus 2026**: Dokumen ini telah diperbarui untuk mencakup **3 commit baru** di branch `origin/polimer_sis` yang belum ada di analisis sebelumnya. Lihat [Bagian 6](#6-analisis-commit-baru-28-agustus-2026) untuk detail lengkap.

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
|                                                    | 7. ✨ Submit Multipart FormData ke API Backend      |
|                                                    | 8. ✨ Endpoint Riwayat Sertifikasi Aktif Pemohon   |
|                                                    | 9. ✨ Seeder Dummy Riwayat Sertifikat              |
|                                                    | 10. ✨ MinIO S3-Compatible Object Storage (Docker) |
+----------------------------------------------------+----------------------------------------------------+
```

---

## 2. Matriks Komparasi Fitur & Komponen

| Komponen / Fitur | Branch `v2.1_internal-system-migration` (HEAD) | Branch `origin/polimer_sis` (Teman) | Rekomendasi Keputusan Merging |
| :--- | :--- | :--- | :--- |
| **Struktur Database Form Sertifikasi** | **Ternormalisasi Relasional**: `form_sertifikasi`, `form_sertifikasi_item`, `form_sertifikasi_pabrik`, `pelanggan_pabrik`, `pelanggan_sertifikasi`. | **Flat + JSON**: Menyimpan `komoditas_json` dan `pabrik_json` dalam 1 baris tabel. | 🟢 **Gunakan versi HEAD**. Struktur relasional lebih terukur untuk reporting, multi-komoditi, dan integrasi audit/SIS. |
| **Fitur Autosave Draft** | Belum ada (mengandalkan state React memori). | **Tersedia (IndexedDB)**: Menyimpan draf form lokal di browser via `indexedDB.ts` + `useSertifikasiDraft.tsx`. ✨ *Update*: Kini sudah terintegrasi penuh dengan banner pemulihan draf dan debounce 1 detik. | 🌟 **Ambil dari branch Teman**. Sangat bernilai untuk UX agar pengisian form tidak hilang saat browser tertutup. |
| **Master Komoditi & SNI** | Mengambil master dari DB SIS via bridging seeder. | **Tersedia Lokal**: Model `MasterKomoditi`, migrasi `master_komoditi`, dan seeder `MasterKomoditiSeeder` berisi standar komoditi BBSPJIKKP. | 🌟 **Ambil dari branch Teman**. Menjamin data komoditi dan nomor SNI tetap tersedia meski tanpa koneksi live SIS. |
| **Berkas Template & Asset Banner** | Template belum disertakan di public asset. | **Tersedia**: 3 File Word template pengajuan (`.docx`/`.doc`) dan 7 gambar badge sertifikasi di `public/`. | 🌟 **Ambil dari branch Teman**. Langsung copy file asset statis ke branch saat ini. |
| **Integrasi TTE (Tanda Tangan Digital)** | **HTTP Client Terisolasi + Configurable Dummy Mode** (`TTE_DUMMY=true/false` di `.env`). | Menghapus dummy mode, memanggil endpoint real secara langsung. | 🟢 **Gunakan versi HEAD**. Dummy mode sangat dibutuhkan developer lain saat bekerja di lingkungan lokal tanpa kredensial BSSN. |
| **Alur Operasional (Audit, LKS, Komite)** | **Lengkap**: Modul Audit sertifikasi, LKS revisi ketidaksesuaian, dan komite sertifikasi. | Belum diimplementasikan. | 🟢 **Gunakan versi HEAD**. |
| **Integrasi Pembayaran BNI VA** | **Lengkap**: Service BNI VA e-Collection, webhook handler, retry queue, dan UI status bayar. | Belum diimplementasikan. | 🟢 **Gunakan versi HEAD**. |
| **Penyimpanan Berkas (AWS S3 vs Lokal)** | Menggunakan disk `public` / fallback lokal di `config/filesystems.php`. | **Storage Adaptif**: Driver `s3` otomatis fallback ke disk `public` jika `AWS_ENABLED=false`. Endpoint asinkron upload berkas & helper `getFileUrl` (`temporaryUrl`). | 🌟 **Ambil dari Teman**. Helper `getFileUrl` & storage adaptif sangat baik untuk transisi mulus antara server lokal dan cloud S3 produksi. |
| **Arsitektur Frontend Admin & RBAC** | **100% Unified React 18 SPA**: Dynamic RBAC, Role switcher, helpdesk, invoice management. | Sebagian view masih merujuk ke Blade / Metronic lama. | 🟢 **Gunakan versi HEAD**. |
| ✨ **Auto-populate Dokumen Legalitas** | Belum ada. | **Tersedia**: Otomatis mengisi file Akta Pendirian dan NIB dari profil perusahaan ke tabel dokumen persyaratan. | 🌟 **Ambil dari branch Teman**. Mengurangi langkah input manual pada wizard form. |
| ✨ **Submit Permohonan ke API** | Sudah ada handler submit pada arsitektur relasional sendiri. | **Tersedia**: Handler `handleSubmitPermohonan` multipart FormData dengan dukungan *draft* dan *ajukan*, toast notifikasi, loading state, serta auto-clear IndexedDB setelah sukses. | ⚠️ **Evaluasi selektif**. Logika pembangunan FormData bisa diadopsi, tapi harus disesuaikan dengan skema relasional HEAD. |
| ✨ **Endpoint Riwayat Sertifikasi** | Belum ada endpoint dedicated. | **Tersedia**: `GET /eksternal/sertifikasi/riwayat-aktif` yang mengambil sertifikat aktif pemohon dari permohonan `status_workflow=DONE`, termasuk fallback dummy data. | 🌟 **Ambil dari branch Teman**. Digunakan oleh dropdown perpanjangan sertifikat di Step 1 form. |
| ✨ **Seeder Riwayat Sertifikat** | Belum ada. | **Tersedia**: `SertifikatSeeder.php` membuat 4 riwayat sertifikat dummy (SMM, SML, SPPT SNI, Industri Hijau) untuk user `perusahaan@mailinator.com`. | 🌟 **Ambil dari branch Teman**. Berguna untuk pengembangan dan pengujian fitur perpanjangan sertifikasi. |
| ✨ **MinIO S3 (Docker)** | Belum ada service MinIO. | **Tersedia**: Service MinIO ditambahkan di `docker-compose.yml` dengan port 9000/9001 untuk emulasi S3 di lokal. | 🌟 **Ambil dari branch Teman**. Memungkinkan pengujian storage S3 di environment Docker lokal tanpa AWS. |
| ✨ **Kelengkapan Field Form LSPro** | Field cukup dasar: data perusahaan, pabrik (nama, alamat, kontak, karyawan, luas), dan produk. Belum ada field ketenagakerjaan detail (shift, part-time, non-permanen). Dokumen persyaratan hanya 4 field file generik. | **Lebih lengkap & sesuai kebutuhan BBSPJIKKP**: 30+ field termasuk data ketenagakerjaan rinci (manajemen, administrasi, operasional, shift 1/2/3, part-time, non-permanen), multi-pabrik terperinci, 6 jenis dokumen persyaratan spesifik, dan file berkas gabungan. | 🌟 **Gunakan kelengkapan field dari branch Teman**. Lihat [Bagian 2.1](#21-perbandingan-kelengkapan-field-form-lspro-sertifikasi) untuk mapping detail. |

---

### 2.1. Perbandingan Kelengkapan Field Form LSPro Sertifikasi

> [!IMPORTANT]
> Branch `polimer_sis` memiliki field form yang **jauh lebih lengkap dan sesuai** dengan kebutuhan formulir LSPro BBSPJIKKP. Rekomendasi: **adopsi definisi field dari branch teman**, kemudian integrasikan ke arsitektur komponen dan tipe data HEAD.

#### A. Data Kondisi Perusahaan & Ketenagakerjaan (Step 3)

| Field | HEAD (`SertifikasiFormData`) | polimer_sis (`KondisiPerusahaanData`) | Status |
| :--- | :--- | :--- | :--- |
| Nama Perusahaan | ✅ `nama_perusahaan` | ✅ `namaPerusahaan` | Sama |
| Nomor Akta Pendirian | ✅ `nomor_akta_pendirian` | ✅ `nomorAktaPendirian` | Sama |
| Nama Pemilik | ✅ `nama_pemilik` | ✅ `namaPemilik` | Sama |
| Nama Pimpinan | ✅ `nama_pimpinan` | ✅ `namaPimpinan` | Sama |
| Nama Wakil Manajemen / MR | ✅ `nama_wakil_manajemen` | ✅ `namaWakilManajemen` | Sama |
| No. Telepon | ✅ `no_telp` | ✅ `noTelp` | Sama |
| No. WhatsApp / HP | ✅ `no_whatsapp` | ✅ `noHp` | Sama |
| Email | ✅ `email` | ❌ — | Hanya di HEAD |
| Kontak Person | ✅ `kontak_person` | ❌ — | Hanya di HEAD |
| Fax | ❌ — | ✅ `fax` | 🌟 **Hanya di Teman** |
| Badan Hukum (PT/CV/Koperasi) | ❌ — | ✅ `badanHukum` | 🌟 **Hanya di Teman** |
| Jenis Perusahaan (Swasta/BUMN/PMA) | ❌ — | ✅ `jenisPerusahaan` | 🌟 **Hanya di Teman** |
| Negara | ❌ — | ✅ `negara` | 🌟 **Hanya di Teman** |
| Provinsi | ❌ — | ✅ `provinsi` | 🌟 **Hanya di Teman** |
| Kabupaten/Kota | ❌ — | ✅ `kabupaten` | 🌟 **Hanya di Teman** |
| Kecamatan | ❌ — | ✅ `kecamatan` | 🌟 **Hanya di Teman** |
| Kode Pos | ❌ — | ✅ `kodePos` | 🌟 **Hanya di Teman** |
| Alamat Lengkap | ✅ `alamat_kantor` | ✅ `alamatLengkap` | Sama |
| Luas Tanah | ❌ — | ✅ `luasTanah` | 🌟 **Hanya di Teman** |
| Luas Bangunan | ❌ — | ✅ `luasBangunan` | 🌟 **Hanya di Teman** |
| **Jumlah Karyawan Total** | ❌ — | ✅ `jumlahKaryawanTotal` | 🌟 **Hanya di Teman** |
| Jumlah Manajemen | ❌ — | ✅ `jumlahManajemen` | 🌟 **Hanya di Teman** |
| Jumlah Administrasi | ❌ — | ✅ `jumlahAdministrasi` | 🌟 **Hanya di Teman** |
| Jumlah Operasional | ❌ — | ✅ `jumlahOperasional` | 🌟 **Hanya di Teman** |
| Jumlah Part Time | ❌ — | ✅ `jumlahPartTime` | 🌟 **Hanya di Teman** |
| Jumlah Non-Permanen | ❌ — | ✅ `jumlahNonPermanen` | 🌟 **Hanya di Teman** |
| Jumlah Shift | ❌ — | ✅ `jumlahShift` | 🌟 **Hanya di Teman** |
| Jumlah Bagian/Departemen | ❌ — | ✅ `jumlahBagian` | 🌟 **Hanya di Teman** |
| Karyawan Shift 1 | ❌ — | ✅ `jumlahShift1` | 🌟 **Hanya di Teman** |
| Karyawan Shift 2 | ❌ — | ✅ `jumlahShift2` | 🌟 **Hanya di Teman** |
| Karyawan Shift 3 | ❌ — | ✅ `jumlahShift3` | 🌟 **Hanya di Teman** |
| File Berkas Gabungan | ❌ — | ✅ `fileBerkasGabungan` | 🌟 **Hanya di Teman** |

**Kesimpulan**: HEAD hanya memiliki **~10 field** dasar perusahaan. Branch teman memiliki **30+ field** termasuk seluruh data ketenagakerjaan per kategori (manajemen, administrasi, operasional, part-time, non-permanen) dan data shift kerja — **sesuai dengan formulir resmi permohonan sertifikasi BBSPJIKKP**.

#### B. Data Multi-Pabrik

| Field Pabrik | HEAD (`SertifikasiPabrikItem`) | polimer_sis (`PabrikItem`) | Status |
| :--- | :--- | :--- | :--- |
| Nama Pabrik | ✅ `nama_pabrik` | ✅ `namaPabrik` | Sama |
| Alamat Pabrik | ✅ `alamat_pabrik` | ✅ `alamatPabrik` | Sama |
| No. Telepon Pabrik | ✅ `kontak_pabrik` | ✅ `noTelp` | Sama |
| No. HP Pabrik | ❌ — | ✅ `noHp` | 🌟 **Hanya di Teman** |
| Fax Pabrik | ❌ — | ✅ `fax` | 🌟 **Hanya di Teman** |
| Negara Pabrik | ❌ — | ✅ `negara` (dropdown 8 negara ASEAN+) | 🌟 **Hanya di Teman** |
| Kode Pos Pabrik | ❌ — | ✅ `kodePos` | 🌟 **Hanya di Teman** |
| Jumlah Karyawan Pabrik | ✅ `jumlah_karyawan` | ✅ `jumlahKaryawan` | Sama |
| Kegiatan Utama Pabrik | ❌ — | ✅ `kegiatanUtama` | 🌟 **Hanya di Teman** |
| Luas Tanah Pabrik | ❌ — | ✅ `luasTanah` | 🌟 **Hanya di Teman** |
| Luas Bangunan Pabrik | ❌ — | ✅ `luasBangunan` | 🌟 **Hanya di Teman** |
| Email Pabrik | ✅ `email_pabrik` | ❌ — | Hanya di HEAD |
| Luas Fasilitas (text) | ✅ `luas_fasilitas` | ❌ (diganti `luasTanah` + `luasBangunan` terpisah) | Teman lebih detail |
| Provinsi ID | ✅ `provinsi_id` | ❌ — | Hanya di HEAD |
| Kabupaten ID | ✅ `kabupaten_id` | ❌ — | Hanya di HEAD |
| Kecamatan ID | ✅ `kecamatan_id` | ❌ — | Hanya di HEAD |

**Kesimpulan**: Branch teman memiliki field pabrik yang lebih relevan untuk formulir LSPro (negara, kegiatan utama, luas tanah/bangunan terpisah), sedangkan HEAD memiliki referensi wilayah (provinsi/kabupaten/kecamatan ID). **Rekomendasi: gabungkan keduanya** — adopsi field dari teman lalu pertahankan referensi wilayah ID dari HEAD.

#### C. Data Komoditi / Produk (Step 2)

| Field Komoditi | HEAD (`SertifikasiProductItem`) | polimer_sis (`KomoditiData`) | Status |
| :--- | :--- | :--- | :--- |
| Nama Produk / Komoditi | ✅ `nama_produk` | ✅ `nama` | Sama |
| Merek Dagang | ✅ `merk_dagang` | ✅ `merek` | Sama |
| Tipe / Jenis | ✅ `tipe_jenis` | ✅ `tipe` | Sama |
| Ukuran | ❌ — | ✅ `ukuran` | 🌟 **Hanya di Teman** |
| No. SNI | ✅ `standar_sni_iso` | ✅ `noSni` | Sama |
| Satuan Produksi | ❌ — | ✅ `satuanProduksi` | 🌟 **Hanya di Teman** |
| Jumlah/Kapasitas Produksi | ✅ `kapasitas_produksi` | ✅ `jumlahProduksi` | Sama |
| Keterangan | ❌ — | ✅ `keterangan` | 🌟 **Hanya di Teman** |
| Ruang Lingkup | ✅ `ruang_lingkup` | ❌ — | Hanya di HEAD |
| Estimasi Tarif | ✅ `estimasi_tarif` | ❌ — | Hanya di HEAD |
| Komoditi ID (relasi master) | ✅ `komoditi_id` | ❌ — | Hanya di HEAD |

**Kesimpulan**: Branch teman memiliki field `ukuran`, `satuanProduksi`, dan `keterangan` yang penting untuk formulir LSPro. HEAD memiliki `ruang_lingkup` dan `estimasi_tarif` untuk kebutuhan internal. **Rekomendasi: gabungkan semua field**.

#### D. Dokumen Persyaratan (Step 2)

| Dokumen | HEAD (`SertifikasiPengajuanItem`) | polimer_sis (`defaultDokumenList`) | Status |
| :--- | :--- | :--- | :--- |
| Surat Permohonan Sertifikasi | ❌ — | ✅ `surat_permohonan` (wajib) | 🌟 **Hanya di Teman** |
| Akta Pendirian & SK Kemenkumham | ✅ `dok_legalitas` (field file generik) | ✅ `legalitas_perusahaan` (wajib, auto-populate dari profil) | Teman lebih baik |
| NIB / IUI | ❌ (digabung ke `dok_legalitas`) | ✅ `nib_iui` (wajib, auto-populate dari profil) | 🌟 **Hanya di Teman** |
| Sertifikat Merek / DJKI | ❌ — | ✅ `sertifikat_merek` (wajib) | 🌟 **Hanya di Teman** |
| Manual Mutu / ISO 9001 | ✅ `dok_manual_mutu` | ✅ `sistem_mutu` (opsional) | Sama |
| Diagram Alir & Denah Pabrik | ✅ `dok_diagram_alir` | ✅ `alur_produksi` (opsional) | Sama |
| Dokumen Lainnya | ✅ `dok_lainnya` | ❌ — | Hanya di HEAD |
| Berkas Gabungan (PDF) | ❌ — | ✅ `fileBerkasGabungan` (upload di KondisiPerusahaan) | 🌟 **Hanya di Teman** |

**Kesimpulan**: Branch teman memiliki **6 jenis dokumen spesifik** sesuai persyaratan resmi sertifikasi BBSPJIKKP, dengan fitur auto-populate dari profil dan upload asinkron. HEAD hanya memiliki 4 field file generik. **Rekomendasi: adopsi definisi dokumen dari branch teman**, pertahankan `dok_lainnya` dari HEAD sebagai tambahan.

#### E. Rekomendasi Integrasi Field

> [!TIP]
> **Langkah yang disarankan**: Perbarui `types/sertifikasi.ts` di branch HEAD dengan menggabungkan field dari kedua branch:
> 1. Tambahkan semua field ketenagakerjaan (`jumlahManajemen`, `jumlahShift1-3`, `jumlahPartTime`, dll.) ke `SertifikasiFormData`
> 2. Perkaya `SertifikasiPabrikItem` dengan `fax`, `noHp`, `negara`, `kodePos`, `kegiatanUtama`, `luasTanah`, `luasBangunan`
> 3. Perkaya `SertifikasiProductItem` dengan `ukuran`, `satuanProduksi`, `keterangan`
> 4. Ganti 4 field file generik dengan daftar `DokumenPersyaratan[]` dari branch teman (6 dokumen spesifik + `dok_lainnya`)
> 5. Pertahankan field unik HEAD: `email`, `kontak_person`, `provinsi_id`/`kabupaten_id`/`kecamatan_id`, `ruang_lingkup`, `estimasi_tarif`, `komoditi_id`

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
  - ✨ `polimer_sis` menambahkan field `sertifikat_lama_nomor` ke `$fillable` pada model `FormSertifikasi.php`.
* **Tindakan**:
  - ❌ **JANGAN jalankan** migrasi `2026_08_24_114229_create_form_sertifikasi.php` agar tidak bentrok dengan tabel yang sudah ada.
  - ✅ **AMBIL** migrasi `2026_08_24_132446_create_master_komoditi_table.php`, model `MasterKomoditi.php`, dan `MasterKomoditiSeeder.php`.
  - ✅ **AMBIL** penambahan `sertifikat_lama_nomor` ke `$fillable` di `FormSertifikasi.php` — diperlukan untuk menyimpan nomor sertifikat lama saat perpanjangan.

---

### 3. Controller Sertifikasi (`Api/SertifikasiController.php`)
* **Perbedaan**:
  - `polimer_sis`: Endpoint berorientasi pada 1 pengajuan dengan file dokumen tetap (`file_pertanyaan_tambahan`, dll).
  - `HEAD`: Endpoint berorientasi multi-item (`form_sertifikasi_item`), multi-pabrik, download sertifikat, preview hasil uji PDF, dan LKS client.
  - ✨ `polimer_sis` menambahkan method `getRiwayatSertifikasi()` — endpoint baru untuk mengambil riwayat sertifikat aktif milik pemohon yang sudah terbit.
* **Tindakan**: **Pertahankan controller HEAD**, kemudian:
  - ✅ **Port** method `getRiwayatSertifikasi()` ke controller HEAD. Perlu disesuaikan query `Permohonan::where(...)` agar kompatibel dengan relasi `formSertifikasi` versi HEAD (relasional, bukan flat).
  - ✅ **Tambahkan** route `GET /sertifikasi/riwayat-aktif` di file routes.

---

### 4. Frontend & Autosave Draft (`resources/assets/js/`)
* **Hal Hebat dari `polimer_sis` yang Wajib Diadopsi**:
  1. `Modules/Eksternal/resources/assets/js/utils/indexedDB.ts`: Engine client-side database IndexedDB.
  2. `Modules/Eksternal/resources/assets/js/hooks/useSertifikasiDraft.tsx`: Custom React Hook yang otomatis menyimpan draf input formulir tiap detik ke IndexedDB dan memunculkan banner pemulihan draf.
  3. `public/files/pengajuan/sertifikasi/*`: Template dokumen Word resmi dari BBSPJIKKP.
  4. `public/images/sertifikasi-asset/*`: Asset ilustrasi jenis sertifikat SNI/ISO.
* ✨ **Peningkatan Baru dari 3 Commit Terakhir**:
  5. **Integrasi Autosave Penuh ke `SertifikasiPage.tsx`**: Hook `useSertifikasiDraft` kini sudah terhubung ke halaman utama wizard, menyimpan state `currentStep`, `pengajuans`, `kondisiPerusahaan`, dan `isAgreed` secara otomatis dengan debounce. Banner pemulihan draf muncul dengan opsi "Lanjutkan Draf" atau "Buang Draf".
  6. **Auto-populate Dokumen Legalitas** (`KategoriSertifikat.tsx`): Jika profil perusahaan memiliki `dok_akta_pendirian` atau `dok_nib`, file tersebut otomatis dimasukkan ke tabel dokumen persyaratan dengan label "Tersedia dari Profil" — pengguna tidak perlu mengunggah ulang.
  7. **Controlled Inputs pada `KondisiPerusahaan.tsx`**: Semua field (jumlahKaryawanTotal, jumlahManajemen, jumlahShift1-3, pabrikList, dll.) kini menggunakan controlled `value` + `onChange` handler yang terhubung ke state parent, memungkinkan autosave dan submit.
  8. **Dropdown Riwayat Sertifikat** (`JenisPermohonan.tsx`): Dropdown sertifikat lama kini mengambil data dari API `GET /sertifikasi/riwayat-aktif` alih-alih opsi statis hardcoded. Memilih item mengembalikan objek `SertifikatRiwayat` lengkap ke parent.
  9. **Submit Handler Multipart** (`SertifikasiPage.tsx`): Fungsi `handleSubmitPermohonan('draft' | 'ajukan')` membangun multipart `FormData` yang mencakup data ketenagakerjaan, pabrik, pengajuan per-skema (komoditas + dokumen), dan file gabungan. Setelah sukses, IndexedDB draft otomatis dihapus.
  10. **Validasi Per Step**: `handleNext()` kini memvalidasi kelengkapan data di setiap step sebelum navigasi berikutnya, dengan toast error jika belum lengkap.
* **Tindakan**:
  - Salin file utility dan hook IndexedDB.
  - Integrasikan hook `useSertifikasiDraft` ke dalam komponen wizard di branch HEAD.
  - ⚠️ **Perhatian**: Komponen `SertifikasiPage.tsx`, `KondisiPerusahaan.tsx`, `KategoriSertifikat.tsx`, dan `JenisPermohonan.tsx` di branch teman sudah sangat berbeda dari versi HEAD. **Jangan cherry-pick langsung** — sebaliknya, adaptasi fitur-fitur baru (autosave, auto-populate, controlled inputs, validasi, submit handler) ke komponen versi HEAD secara manual.
  - Salin seluruh file asset statis Word dan gambar.

---

### 5. Integrasi AWS S3 & Adaptive Storage (Upload Berkas)
* **Temuan Teknis**:
  - Di commit `6583fee`, teman Anda memperbarui `config/filesystems.php` agar disk `s3` otomatis fallback ke disk `local` (`storage/app/public`) saat `AWS_ENABLED=false` tanpa memicu error authentication AWS SDK.
  - Di commit `8bd23f8`, teman Anda menambahkan helper `saveCustomerFile` dan `getFileUrl` yang cerdas:
    - Jika di production (`AWS_ENABLED=true` / `filesystems.default=s3`), fungsi menghasilkan **Presigned URL aman sementara** via `Storage::disk('s3')->temporaryUrl(...)`.
    - Jika di lokal, fungsi fallback ke URL lokal `asset('storage/' . $path)`.
  - Endpoint upload dokumen mandiri `POST /api/v1/sertifikasi/upload-dokumen` juga disediakan untuk mendukung upload berkas asinkron dari wizard form.
* ✨ **Perubahan Baru pada `HomeController.php`**: Teman mengubah URL gambar banner, services, dan partners dari `asset('storage/...')` ke `Storage::disk('s3')->temporaryUrl(...)` — mengaktifkan presigned URL S3 sebagai default.
* **Tindakan**:
  - Di branch `HEAD`, konfigurasi `config/filesystems.php` dan `.env` (`AWS_ENABLED=false`) sudah sejalan.
  - Helper `getFileUrl` dan endpoint upload asinkron ini sangat baik untuk diintegrasikan ke `SertifikasiController.php` di branch `HEAD`.
  - ⚠️ **JANGAN ambil** perubahan `HomeController.php` secara langsung — di branch HEAD, `HomeController` sudah direfactor dengan caching. Perubahan URL S3 perlu diterapkan secara manual sesuai konteks HEAD.

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

### ✨ Tahap 4: Salin Seeder Riwayat Sertifikat (BARU)
```bash
git checkout origin/polimer_sis -- "database/seeders/SertifikatSeeder.php"
```
Kemudian tambahkan secara manual di `DatabaseSeeder.php`:
```php
$this->call(SertifikatSeeder::class);
```

### ✨ Tahap 5: Tambahkan Field `sertifikat_lama_nomor` ke Model (BARU)
Tambahkan `'sertifikat_lama_nomor'` ke array `$fillable` di `app/Models/Db2/FormSertifikasi.php` secara manual.

### ✨ Tahap 6: Port Endpoint Riwayat Sertifikasi ke Controller HEAD (BARU)
1. Salin method `getRiwayatSertifikasi()` dari `SertifikasiController.php` branch teman.
2. Sesuaikan query agar kompatibel dengan model relasional HEAD (relasi `formSertifikasiItems`, bukan `formSertifikasi` flat).
3. Tambahkan route di `Modules/Eksternal/routes/web.php`:
```php
Route::get('/sertifikasi/riwayat-aktif', [SertifikasiController::class, 'getRiwayatSertifikasi']);
```

### ✨ Tahap 7: Adaptasi Fitur Frontend Baru ke Komponen HEAD (BARU)
> [!WARNING]
> Komponen frontend di branch teman sudah sangat berbeda. **Jangan cherry-pick langsung** file `.tsx` — adaptasi secara manual fitur berikut ke komponen HEAD:

| Fitur | File Sumber (Branch Teman) | Yang Perlu Diadaptasi |
| :--- | :--- | :--- |
| Integrasi autosave + banner pemulihan | `SertifikasiPage.tsx` | Import `useSertifikasiDraft`, panggil `autoSave()` di `useEffect`, render banner `existingDraft` |
| Auto-populate dokumen legalitas | `KategoriSertifikat.tsx` | Logika `useEffect` yang membaca `detailPerusahaan.dok_akta_pendirian` dan `dok_nib` |
| Controlled inputs KondisiPerusahaan | `KondisiPerusahaan.tsx` | Tambahkan props `value` + `onChange` lalu bind semua input ke state parent |
| Dropdown riwayat sertifikat dari API | `JenisPermohonan.tsx` | Ganti opsi hardcoded dengan `useEffect` + `api.get('/sertifikasi/riwayat-aktif')` |
| Submit handler multipart FormData | `SertifikasiPage.tsx` | Adopsi logika `handleSubmitPermohonan()` lalu sesuaikan field ke schema relasional HEAD |
| Validasi per step | `SertifikasiPage.tsx` | Adopsi logika `handleNext()` dengan validasi tiap step |

### ✨ Tahap 8: Tambahkan MinIO ke Docker Compose (BARU, Opsional)
Jika ingin menguji S3-compatible storage di lokal:
```bash
git checkout origin/polimer_sis -- "docker-compose.yml"
```
> [!CAUTION]
> Pastikan `docker-compose.yml` HEAD tidak memiliki perubahan lain yang akan tertimpa. Sebaiknya merge manual hanya blok service `minio` dan volume `private_minio_data`.

### Tahap 9: Hubungkan IndexedDB Draft ke Wizard Form Sertifikasi
Tambahkan pemanggilan `useSertifikasiDraft` pada `FormSertifikasiWizard.tsx` agar formulir otomatis menyimpan progres pengisian pengguna ke IndexedDB lokal browser.

### Tahap 10: Jalankan Migrasi & Seeder
```bash
php artisan migrate --force
php artisan db:seed --class=MasterKomoditiSeeder
php artisan db:seed --class=SertifikatSeeder
```

---

## 5. Potensi Konflik Baru yang Harus Diwaspadai

> [!WARNING]
> File-file berikut telah dimodifikasi di **kedua branch** dan memerlukan penanganan manual saat merge:

| File | Modifikasi di HEAD | Modifikasi di polimer_sis | Tingkat Risiko |
| :--- | :--- | :--- | :--- |
| `Modules/Eksternal/routes/web.php` | Route sertifikasi, admin, helpdesk, invoice | Route sertifikasi di-refactor ke prefix group + route baru `riwayat-aktif`, `show`, `update`, `destroy`, `ajukan-ulang` | 🔴 **Tinggi** — Kedua branch mengubah blok route sertifikasi. Harus merge manual. |
| `database/seeders/DatabaseSeeder.php` | Sudah menambahkan seeder baru (admin, helpdesk, dll.) | Menambahkan `SertifikatSeeder::class` | 🟡 **Sedang** — Tambahkan 1 baris saja secara manual. |
| `docker-compose.yml` | Sudah ada perubahan konfigurasi service | Menambahkan service `minio` dan volume `private_minio_data` | 🟡 **Sedang** — Tambahkan blok MinIO secara manual. |
| `Modules/Eksternal/app/Http/Controllers/HomeController.php` | Sudah direfactor dengan caching dan parsing optimizations | Mengubah URL gambar dari `asset()` ke `Storage::disk('s3')->temporaryUrl()` | 🔴 **Tinggi** — Kedua branch mengubah file ini secara signifikan. Adaptasi perubahan S3 URL secara manual. |
| `Modules/Eksternal/resources/assets/js/hooks/queries/useProfileQuery.ts` | Kemungkinan sudah memiliki versi berbeda | Mengubah endpoint dari `/eksternal/profile` ke `/eksternal/user` dan prioritas parsing response | 🟡 **Sedang** — Verifikasi endpoint mana yang benar di backend HEAD. |

---

## 6. Analisis Commit Baru (28 Agustus 2026)

### Daftar 3 Commit Baru Setelah `8bd23f8`

| # | Hash | Pesan Commit | File Berubah | Baris (+/-) |
| :--- | :--- | :--- | :--- | :--- |
| 1 | [`06ab8c3`](file:///f:/%21Productive/BBKKP/private-polimer/) | feat(frontend): integrasi auto-populate dokumen legalitas dari profil perusahaan pada form sertifikasi | 1 file | +34 |
| 2 | [`3508159`](file:///f:/%21Productive/BBKKP/private-polimer/) | feat(sertifikasi): implement autosave draft indexedDB and refine step components | 8 file | +351 / -31 |
| 3 | [`05d4bf3`](file:///f:/%21Productive/BBKKP/private-polimer/) | feat(sertifikasi): integrasi frontend multi-step form, state binding, dan submit mutasi API | 8 file | +796 / -151 |

**Total perubahan baru**: 14 file, +1.181 baris, -182 baris

---

### 6.1. Commit `06ab8c3` — Auto-populate Dokumen Legalitas

**Ruang Lingkup**: 1 file (`KategoriSertifikat.tsx`)

Menambahkan logika untuk secara otomatis mengisi dokumen persyaratan dari data profil perusahaan yang sudah terdaftar:
- Jika perusahaan sudah mengunggah **Akta Pendirian** (`dok_akta_pendirian`) → otomatis terisi di tabel dokumen.
- Jika perusahaan sudah mengunggah **NIB** (`dok_nib`) → otomatis terisi di tabel dokumen.
- Ditandai dengan label `isFromProfile: true` dan nama file "Tersedia dari Profil".

**Dampak terhadap HEAD**: Fitur ini bisa langsung diport karena hanya menambahkan `useEffect` di komponen — tidak mengubah kontrak API.

---

### 6.2. Commit `3508159` — Autosave IndexedDB & Refinement Komponen

**Ruang Lingkup**: 8 file

| File | Perubahan |
| :--- | :--- |
| `indexedDB.ts` | **[NEW]** Utility IndexedDB: `openDB()`, `saveSertifikasiDraft()`, `getSertifikasiDraft()`, `deleteSertifikasiDraft()` |
| `useSertifikasiDraft.tsx` | **[NEW]** Custom hook: debounced autosave (1 detik), load existing draft on mount, `clearDraft()` |
| `SertifikasiPage.tsx` | Integrasi hook autosave, render banner pemulihan draf dengan tombol "Lanjutkan" dan "Buang" |
| `KategoriSertifikat.tsx` | Tambah props `dokumenListValue` + `onChangeDokumenList` untuk sinkronisasi state dokumen ke parent/IndexedDB |
| `KondisiPerusahaan.tsx` | Tambah props `value` + `onChange` (TypeScript interface), refactor dari uncontrolled ke controlled input |
| `useProfileQuery.ts` | Ubah endpoint `/eksternal/profile` → `/eksternal/user`, ubah prioritas parsing response |
| `HomeController.php` | Ubah URL gambar dari `asset('storage/...')` ke `Storage::disk('s3')->temporaryUrl(...)` |
| `docker-compose.yml` | Tambah service MinIO (S3-compatible) dengan port 9000/9001 |

**Dampak terhadap HEAD**: 
- `indexedDB.ts` dan `useSertifikasiDraft.tsx` → **Aman diambil langsung** (file baru).
- `KondisiPerusahaan.tsx` → Perubahan besar di controlled inputs, harus **adaptasi manual**.
- `HomeController.php` → **Jangan ambil langsung**, sudah berbeda di HEAD.
- `useProfileQuery.ts` → **Perlu verifikasi** endpoint yang benar di backend HEAD.

---

### 6.3. Commit `05d4bf3` — Multi-step Form Binding, Submit API & Seeder

**Ruang Lingkup**: 8 file (perubahan terbesar: +796 baris)

| File | Perubahan |
| :--- | :--- |
| `SertifikasiController.php` | **+80 baris**: Method `getRiwayatSertifikasi()` — endpoint baru untuk dropdown perpanjangan sertifikat |
| `JenisPermohonan.tsx` | **+63 baris**: Fetch riwayat dari API, populate dropdown dinamis, return objek `SertifikatRiwayat` |
| `KondisiPerusahaan.tsx` | **+337 baris**: Seluruh input di-bind ke controlled state: jumlahBagian, jumlahManajemen, shift 1-3, pabrik list, file berkas gabungan |
| `SertifikasiPage.tsx` | **+271 baris**: `handleSubmitPermohonan()` multipart FormData, validasi per-step, pemisahan kondisiPerusahaan ke level pemohon |
| `Modules/Eksternal/routes/web.php` | Route sertifikasi di-refactor ke prefix group + route baru (`riwayat-aktif`, `show`, `update`, `destroy`, `ajukan-ulang`) |
| `FormSertifikasi.php` | +1 baris: `sertifikat_lama_nomor` di `$fillable` |
| `DatabaseSeeder.php` | +1 baris: `SertifikatSeeder::class` |
| `SertifikatSeeder.php` | **[NEW] +173 baris**: 4 riwayat sertifikat dummy (SMM, SML, SPPT SNI, Industri Hijau) untuk `perusahaan@mailinator.com` |

**Dampak terhadap HEAD**:
- `SertifikasiController.php` → Method `getRiwayatSertifikasi()` **aman diport** dengan penyesuaian query.
- `SertifikatSeeder.php` → **Aman diambil langsung** (file baru), pastikan model `DetailPermohonan` dan `FormSertifikasi` kompatibel.
- `SertifikasiPage.tsx` & `KondisiPerusahaan.tsx` → **Tidak bisa cherry-pick**, harus adaptasi manual ke arsitektur HEAD.
- `routes/web.php` → **Harus merge manual** karena kedua branch mengubah route sertifikasi.

---

## 7. Ringkasan Rekomendasi Akhir (Diperbarui)

### ✅ Ambil Langsung (Safe Cherry-Pick / Checkout)
| File | Sumber Commit |
| :--- | :--- |
| `public/files/pengajuan/sertifikasi/*` | `cf4cdfa` |
| `public/images/sertifikasi-asset/*` | `08ff85c` |
| `Modules/.../utils/indexedDB.ts` | `3508159` |
| `Modules/.../hooks/useSertifikasiDraft.tsx` | `3508159` |
| `app/Models/Db2/MasterKomoditi.php` | `784ce3c` |
| `database/migrations/2026_08_24_132446_create_master_komoditi_table.php` | `784ce3c` |
| `database/seeders/MasterKomoditiSeeder.php` | `cce8e2f` |
| `database/seeders/SertifikatSeeder.php` | `05d4bf3` |

### ⚙️ Adaptasi Manual (Port Selektif)
| Komponen | Tindakan |
| :--- | :--- |
| `FormSertifikasi.php` `$fillable` | Tambah `sertifikat_lama_nomor` |
| `SertifikasiController.php` → `getRiwayatSertifikasi()` | Port method + sesuaikan query ke relasional HEAD |
| `routes/web.php` | Tambah route `riwayat-aktif` ke blok sertifikasi HEAD |
| `DatabaseSeeder.php` | Tambah `$this->call(SertifikatSeeder::class)` |
| `docker-compose.yml` | Tambah blok MinIO secara manual |
| Frontend: autosave, auto-populate, controlled inputs, validasi, submit handler | Adaptasi manual fitur-fitur ke komponen wizard HEAD |

### ❌ Jangan Ambil
| File | Alasan |
| :--- | :--- |
| `2026_08_24_114229_create_form_sertifikasi.php` | Tabel sudah ada di HEAD dengan skema relasional |
| `HomeController.php` | Sudah di-refactor di HEAD, perubahan S3 URL harus diterapkan manual |
| `useProfileQuery.ts` | Perlu verifikasi endpoint backend HEAD terlebih dahulu |
| `SertifikasiPage.tsx` (langsung) | Terlalu berbeda, harus adaptasi manual |
| `KondisiPerusahaan.tsx` (langsung) | Terlalu berbeda, harus adaptasi manual |
| `KategoriSertifikat.tsx` (langsung) | Sudah diverge, adaptasi manual fitur auto-populate |
| `JenisPermohonan.tsx` (langsung) | Sudah diverge, adaptasi manual dropdown API |
