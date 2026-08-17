# Sprint 2 Breakdown: Multi-Item Application Wizard, Factory Info & Marketing Inbox
## Integrasi BBKKP-SIS ke Dalam BBKKP Polimer

> **Sprint**: 2 of 4  
> **Durasi**: 2 Minggu (10 Hari Kerja)  
> **Fokus Utama**: Antarmuka Form Wizard React SPA untuk Pengajuan Sertifikasi Multi-Item & Profil Pabrik, Endpoint REST API Eksternal, serta Dashboard Inbox & Verifikasi Tim Marketing.  
> **Tanggal**: 14 Agustus 2026

---

## 1. Sasaran & Tujuan Sprint (Sprint Goals)
1. Membangun form wizard modern di React SPA (`/app/sertifikasi`) yang memungkinkan pelanggan mengajukan beberapa permohonan sertifikasi (Baru/Perpanjang/Perubahan Scope) dalam 1 kali proses *checkout*.
2. Menyediakan fitur manajemen data lokasi pabrik/fasilitas produksi di portal pelanggan.
3. Membangun REST API Controller `POST /api/eksternal/sertifikasi` untuk validasi berkas dan penyimpanan data transaksional.
4. Membangun antarmuka Inbox Marketing di Modul `Permohonan` (`/permohonan/marketing`) untuk me-review permohonan masuk, menghitung/menyesuaikan tarif PNBP, serta melakukan aksi *Approve*, *Revisi*, atau *Reject*.

---

## 2. User Stories & Acceptance Criteria

### User Story 1: Form Wizard Pengajuan Sertifikasi Multi-Item (Frontend React SPA)
* **Sebagai**: Pelanggan (Perusahaan / Industri)
* **Saya ingin**: Mengisi formulir pengajuan sertifikasi dengan beberapa produk sekaligus serta melampirkan profil pabrik dalam satu wizard pengajuan.
* **Agar**: Saya tidak perlu mengulang pengisian data perusahaan dan dapat menghemat waktu pendaftaran.

#### Kriteria Keberterimaan (Acceptance Criteria):
- [ ] Tersedia langkah-langkah wizard: (1) Data Perusahaan & Tipe Pengajuan -> (2) Data Pabrik / Lokasi Audit -> (3) Daftar Komoditi & Standar (Multi-Item) -> (4) Unggah Dokumen Persyaratan -> (5) Review & Submit.
- [ ] Pengguna dapat menambahkan > 1 komoditi/produk dalam daftar pengajuan (*Cart/Item List*).
- [ ] Validasi form menggunakan `react-hook-form` + `yup` dengan pesan error yang jelas per input.
- [ ] Progress penyimpanan draft otomatis (*Auto-save to LocalStorage / Draft API*).

### User Story 2: REST API Submission Permohonan Sertifikasi (Backend Eksternal)
* **Sebagai**: Frontend Developer / Pelanggan
* **Saya ingin**: Mengirimkan payload pengajuan sertifikasi lengkap dengan multiple item dan file lampiran ke API Polimer.
* **Agar**: Data permohonan tersimpan secara aman dengan status awal `DIAJUKAN_MARKETING`.

#### Kriteria Keberterimaan (Acceptance Criteria):
- [ ] Endpoint `POST /api/eksternal/sertifikasi` menerima payload multipart/form-data.
- [ ] Validasi request memastikan tipe file yang diizinkan (PDF, JPG, PNG max 5MB).
- [ ] Permohonan tersimpan di tabel `permohonan`, `detail_permohonan`, `form_sertifikasi`, `form_sertifikasi_item`, dan `form_sertifikasi_pabrik` dalam satu *Database Transaction*.
- [ ] Mengembalikan response JSON standar dengan `status: true`, `message`, dan `no_permohonan`.

### User Story 3: Inbox & Verifikasi Permohonan Tim Marketing (Backend Admin)
* **Sebagai**: Petugas Tim Marketing
* **Saya ingin**: Melihat daftar antrean permohonan sertifikasi baru di Inbox Marketing, memeriksa kelengkapan berkas, dan menetapkan rincian tarif layanan.
* **Agar**: Saya dapat memvalidasi kelayakan berkas sebelum menagihkan pembayaran ke pelanggan.

#### Kriteria Keberterimaan (Acceptance Criteria):
- [ ] Halaman `/permohonan/marketing` menampilkan tabel permohonan dengan filter status (`DIAJUKAN`, `REVISI`, `APPROVED`, `REJECTED`).
- [ ] Tombol **Lihat Detail** menampilkan popup/halaman rincian profil perusahaan, lokasi pabrik, rincian komoditi yang diajukan, dan preview berkas lampiran.
- [ ] Tim Marketing dapat menginputkan item tarif PNBP (Biaya Asesmen, Biaya Audit Pabrik, Biaya Sertifikasi) yang langsung menjumlahkan total biaya tagihan.
- [ ] Aksi Marketing:
  - **Approve**: Mengubah status menjadi `PROCESSING_INVOICE` dan memicu dispatch queue job.
  - **Minta Revisi**: Mengubah status menjadi `REVISI_PELANGGAN` dan mengirimkan catatan catatan perbaikan ke portal pelanggan.
  - **Reject**: Mengubah status menjadi `REJECTED` dengan alasan penolakan.

---

## 3. Spesifikasi Kontrak API & Desain UI

### 3.1 Kontrak REST API Submission (`POST /api/eksternal/sertifikasi`)

#### Request Payload (Multipart/Form-Data):
```json
{
  "tipe_pengajuan": "BARU",
  "referensi_sertifikat_id": null,
  "nama_perusahaan": "PT Maju Bersama Polimer",
  "alamat_kantor": "Jl. Industri No. 45, Jakarta Barat",
  "kontak_person": "Budi Santoso",
  "no_telp": "021-5551234",
  "no_whatsapp": "081234567890",
  "email": "budi@majubersama.co.id",
  "pabrik": [
    {
      "nama_pabrik": "Pabrik Utama Cikarang",
      "alamat_pabrik": "Kawasan Industri GIIC Blok C-12, Cikarang",
      "provinsi_id": 32,
      "kabupaten_id": 3216,
      "kontak_pabrik": "021-8989123",
      "jumlah_karyawan": 150,
      "luas_fasilitas": "5000 m2"
    }
  ],
  "items": [
    {
      "komoditi_id": 12,
      "nama_produk": "Sol Sepatu Karet Vulkanisir",
      "merk_dagang": "KaretKu",
      "tipe_jenis": "Tipe A High-Tension",
      "standar_sni_iso": "SNI 0111:2009"
    },
    {
      "komoditi_id": 14,
      "nama_produk": "Pipa PVC Tipe AW",
      "merk_dagang": "PolimerPipe",
      "tipe_jenis": "Ukuran 3 inch",
      "standar_sni_iso": "SNI 06-0084-2002"
    }
  ],
  "dokumen_legalitas": "(FILE_BINARY)",
  "dokumen_manual_mutu": "(FILE_BINARY)",
  "dokumen_diagram_alir": "(FILE_BINARY)"
}
```

#### Response Success (201 Created):
```json
{
  "success": true,
  "message": "Permohonan sertifikasi berhasil diajukan dan sedang dalam antrean verifikasi Marketing.",
  "data": {
    "permohonan_id": "9b8e21aa-4c7b-45e2-98ab-3123456789ab",
    "no_permohonan": "CERT-202608-0012",
    "status_workflow": "DIAJUKAN_MARKETING",
    "total_items": 2,
    "created_at": "2026-08-20T10:30:00.000000Z"
  }
}
```

---

## 4. Breakdown Pekerjaan & Task List

| Task ID | Nama Task | Deskripsi Detail | Bobot (SP) | Penanggung Jawab | Status |
| :--- | :--- | :--- | :-: | :--- | :-: |
| **TS2-01.1** | UI Wizard Layout | Buat komponen langkah wizard di React SPA (`Modules/Eksternal/resources/assets/js/pages/Sertifikasi/Wizard.tsx`). | 5 | Frontend Dev | To Do |
| **TS2-01.2** | Multi-Item Cart UI | Buat komponen dinamis untuk penambahan dan penghapusan item sertifikasi (*Repeater Form*). | 3 | Frontend Dev | To Do |
| **TS2-02.1** | Factory Selector UI | Buat komponen manajemen dan pemilihan alamat pabrik produksi. | 3 | Frontend Dev | To Do |
| **TS2-02.2** | File Uploader UI | Buat komponen drag-and-drop upload dokumen dengan preview dan validasi tipe file. | 3 | Frontend Dev | To Do |
| **TS2-03.1** | API Controller | Kembangkan `SertifikasiController.php` di Modul `Eksternal` dengan validasi `FormRequest`. | 5 | Backend Dev | To Do |
| **TS2-04.1** | Marketing Inbox UI | Buat tampilan dashboard Inbox Marketing di Modul `Permohonan` dengan DataTables dan filter. | 5 | Fullstack / Blade | To Do |
| **TS2-04.2** | Detail & Tariff Form | Buat form modal peninjauan berkas permohonan dan kalkulator penetapan tarif PNBP. | 5 | Fullstack / Blade | To Do |
| **TS2-05.1** | Action Handlers | Buat controller actions untuk *Approve*, *Revisi*, dan *Reject* beserta pencatatan ke `sys_audit_log`. | 3 | Backend Dev | To Do |
| **TS2-05.2** | End-to-End Test | Uji integrasi pengisian form di React SPA hingga muncul di Inbox Marketing dan di-approve. | 3 | QA Dev | To Do |

---

## 5. Rencana Pengujian (Test Scenarios)

### 5.1 Automated Tests (Feature Tests)
```bash
# Menjalankan test endpoint submission sertifikasi
php artisan test --filter=SertifikasiSubmissionApiTest
# Menjalankan test aksi verifikasi dan penetapan tarif marketing
php artisan test --filter=MarketingInboxActionTest
```

### 5.2 Skenario Pengujian Manual (QA Checklist):
1. **Pengujian Form Submission**:
   - Isi form wizard dengan 3 item komoditi dan 2 alamat pabrik.
   - Unggah file PDF kelengkapan (dokumen izin usaha, manual mutu).
   - Pastikan form berhasil disubmit dan redirect ke halaman *Detail Permohonan*.
2. **Pengujian Inbox Marketing**:
   - Login sebagai user role `MARKETING`.
   - Buka menu `/permohonan/marketing` -> permohonan baru harus muncul di urutan teratas.
   - Buka rincian permohonan -> cek kelengkapan file dan data pabrik.
   - Masukkan rincian biaya tarif PNBP -> klik tombol **Approve**.
   - Pastikan status permohonan berubah menjadi `PROCESSING_INVOICE`.

---

## 6. Definition of Done (DoD) Sprint 2
* [x] Pelanggan dapat mengajukan permohonan sertifikasi multi-item dan data pabrik melalui React SPA tanpa error.
* [x] REST API menerima dan memvalidasi payload multi-item secara presisi.
* [x] Tim Marketing dapat memverifikasi, menyesuaikan tarif, meminta revisi, dan menyetujui (*Approve*) permohonan.
* [x] Seluruh feature tests lulus pengujian otomatis.
