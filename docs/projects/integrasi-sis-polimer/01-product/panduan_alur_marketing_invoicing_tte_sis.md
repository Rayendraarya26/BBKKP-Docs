# 📘 Panduan Alur Baru: Verifikasi Marketing, Otomasi Invoicing, TTE On-Demand & Integrasi SIS

> **Dokumen Panduan Pengguna & Pengembang (User & Technical Guide)**  
> **Sistem**: BBKKP Polimer v2.1 & SIS Legacy  
> **Pembaruan Terakhir**: 01 September 2026

---

## 📌 1. Ikhtisar Alur Baru

Sistem Polimer v2.1 menerapkan alur operasional permohonan sertifikasi SPPT SNI terintegrasi:

1. **Pemohon Mengajukan Permohonan**: Mengisi form sertifikasi multi-item dan data pabrik (termasuk hierarki wilayah atau pabrik luar negeri).
2. **Tim Marketing Memverifikasi & Menetapkan Biaya**: Tim Marketing me-review berkas, menentukan tarif PNBP, dan mengunggah dokumen penawaran harga.
3. **Otomatisasi Penerbitan Dokumen Finansial**:
   - Nomor Invoice resmi otomatis terbit.
   - Dokumen PDF Invoice digenerate secara otomatis (format resmi DomPDF).
   - Nomor Virtual Account (VA) BNI otomatis dibuat via API BNI.
4. **Pembayaran oleh Pemohon**: Pemohon membayar melalui Virtual Account BNI.
5. **Penerbitan Kuitansi Otomatis**: Ketika webhook BNI menerima pembayaran (status `LUNAS`), sistem secara otomatis menerbitkan dokumen Kuitansi resmi.
6. **Data Bridging Otomatis ke SIS & BSKJI**: Data permohonan yang lunas dijembatani langsung ke database `bbkkp_sis` dan antrean API BSKJI.
7. **TTE Finansial On-Demand**: Dokumen diterbitkan secara standar dengan *Digital Seal*. Jika pemohon memerlukan TTE resmi BSrE Bendahara, pemohon dapat menekan tombol **"Minta TTE"**, dan Bendahara menandatanganinya melalui antarmuka Admin dengan passphrase BSrE.

---

## 👥 2. Panduan untuk Role Marketing

### A. Login Akun Marketing
- **Email**: `marketing@mailinator.com`
- **Password**: `password`
- **Grup Akses**: `Marketing` (`c3877664-427b-11ef-9454-0242ac120002`)

### B. Memverifikasi Permohonan & Menerbitkan Invoice
1. Buka menu **Kelola Permohonan** (`/admin/permohonan`).
2. Pilih permohonan dengan status **"Menunggu Verifikasi"** (`PERMOHONAN`).
3. Pada halaman detail permohonan, tinjau tab:
   - **Identitas & Pemohon**: Data legalitas dan kontak PIC.
   - **Komoditas & Produk**: Varian produk, standar SNI, dan spesifikasi.
   - **Lokasi Pabrik**: Daftar fasilitas pabrik pemohon.
4. Klik tombol **"Verifikasi & Tetapkan Biaya"** pada baris tombol aksi.
5. Pada modal **"Form Penerbitan Invoice & Tarif PNBP"**:
   - Nomor order telah otomatis terpilih (*pre-filled*).
   - Tambah/atur baris tarif PNBP (Deskripsi item, Qty, Tarif Rp). Total biaya akan terhitung otomatis.
   - Unggah berkas **Dokumen Penawaran Harga Resmi (.pdf)**.
   - Klik **"Simpan & Terbitkan Invoice"**.
6. Sistem akan otomatis menerbitkan Nomor Invoice, PDF Invoice, dan nomor BNI Virtual Account untuk pemohon.

---

## 💳 3. Panduan untuk Pemohon (Portal Client)

### A. Memantau Tagihan & Mengakses Virtual Account
1. Buka menu **Riwayat Pembayaran** (`/app/#/pembayaran`) atau **Detail Permohonan** (`/app/#/permohonan/detail/:id`).
2. Periksa **Nomor Virtual Account BNI** dan batas waktu pembayaran.
3. Klik tombol **"Invoice"** untuk melihat rincian tagihan resmi.

### B. Mengajukan Permohonan TTE BSrE (Opsional)
- Secara default, dokumen Invoice dan Kuitansi memiliki cap pengesahan digital resmi (*Digital Seal*).
- Jika perusahaan/instansi Anda mewajibkan tanda tangan elektronik tersertifikasi BSrE:
  1. Pada halaman pembayaran/detail, klik tombol **"Minta TTE"** di sebelah tombol Invoice atau Kuitansi.
  2. Konfirmasi pengajuan pada dialog SweetAlert2.
  3. Status dokumen akan berubah menjadi **"Menunggu TTE Bendahara"**.
  4. Setelah Bendahara memprosesnya, status akan berubah menjadi **"TTE BSrE Sah"** dan dokumen ber-TTE siap diunduh.

---

## 🏛️ 4. Panduan untuk Role Bendahara (Admin TTE Panel)

### A. Memproses TTE Invoice / Kuitansi
1. Buka detail permohonan yang memiliki badge **"Diminta Pemohon"** pada tab **Panel TTE Bendahara**.
2. Masukkan **Passphrase Sertifikat Elektronik BSrE** Anda.
3. Klik tombol **"Tanda Tangani (TTE BSrE)"**.
4. Sistem akan memproses penandatanganan digital via `bbkkp-internal-service` dan menyematkan barcode verifikasi BSrE pada dokumen PDF.

---

## 🔄 5. Spesifikasi Teknis & Data Bridging

### A. Endpoint API Baru & Integrasi

| Method | Endpoint | Fungsi | Akses |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/eksternal/permohonan/{id}/request-tte-invoice` | Pengajuan TTE BSrE Invoice | Pemohon |
| `POST` | `/api/eksternal/permohonan/{id}/request-tte-kuitansi` | Pengajuan TTE BSrE Kuitansi | Pemohon |
| `POST` | `/permohonan/layanan/{id}/approval-invoice` | Penandatanganan TTE Invoice BSrE | Bendahara |
| `POST` | `/permohonan/layanan/{id}/approval-kuitansi-tte` | Penandatanganan TTE Kuitansi BSrE | Bendahara |
| `POST` | `/integrasi/sync-manual-sis/{id}` | Trigger sinkronisasi manual ke SIS | Admin |

### B. Database Mapping ke SIS (`bbkkp_sis`)

```
[ Polimer Database (DB2) ]                  [ SIS Database (bbkkp_sis) ]
permohonan.no_permohonan          ----->     sis_permohonan_detail.mohon_det_no_referensi
permohonan.created_by (SysUser)   ----->     sis_pelanggan.user_id & cust_id
form_sertifikasi.komoditas_json   ----->     sis_permohonan_komoditi (multi-rows)
form_sertifikasi.pabrik_json      ----->     sis_permohonan_pabrik (multi-rows)
permohonan.status_bayar = LUNAS   ----->     sis_permohonan.mohon_pembayaran_status = 'lunas'
```
