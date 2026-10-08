# 🧪 Panduan Pengujian (Testing Guide) Integrasi API SIPPT BSKJI

> **Versi Dokumen:** 1.0  
> **Tanggal:** 08 Oktober 2026  
> **Target Pengujian:** Integrasi API SIPPT BSKJI pada BBKKP Polimer  
> **Status:** 📘 Petunjuk Operasional & Verifikasi UAT  
> **Dokumen Terkait:** [Laporan Implementasi](file:///F:/%21Productive/BBKKP/BBKKP-Docs/docs/projects/bbkkp-polimer/02-architecture/laporan_implementasi_integrasi_sippt_bskji.md) | [Postman Collection](file:///F:/%21Productive/BBKKP/BBKKP-Docs/docs/projects/bbkkp-polimer/02-architecture/SIPPT_BSKJI_API_v13.postman_collection.json)

---

## 1. Persiapan Awal (Prerequisites)

Sebelum menjalankan pengujian, pastikan langkah-langkah persiapan berikut sudah dilakukan:

### 1.1 Menjalankan Migrasi Database
Buka terminal di root direktori project `private-polimer` dan jalankan migrasi tabel SIPPT:

```bash
php artisan migrate
```

Pastikan 4 tabel baru berhasil dibuat:
1. `sippt_sync_logs`
2. `sippt_ref_negara`
3. `sippt_ref_provinsi`
4. `sippt_ref_kabupaten`

### 1.2 Mengisi Konfigurasi Kredensial di `.env`
Buka file `.env` di root project dan sesuaikan variabel konfigurasi berikut:

```env
# Mode server: 'dev' untuk server testing atau 'prod' untuk production
SIPPT_ENVIRONMENT=dev

# URL API (Development & Production)
SIPPT_DEV_URL=https://newtesting-bskji.kemenperin.go.id/api
SIPPT_PROD_URL=https://sippt-bskji.kemenperin.go.id/api

# Kredensial Akun SIPPT Anda
SIPPT_USERNAME=username_anda
SIPPT_PASSWORD=password_anda

# ID Satker BBKKP (Didapatkan dari menu Dashboard SIPPT > Sinkronisasi API)
SIPPT_SATKER_ID=24

# Pengaturan Koneksi
SIPPT_TIMEOUT=30
SIPPT_RETRY_MAX=3
SIPPT_SSL_VERIFY=false
```

> [!TIP]
> Nilai `SIPPT_SSL_VERIFY=false` direkomendasikan pada server development untuk mencegah penolakan koneksi akibat konfigurasi SSL internal BSKJI.

---

## 2. Skenario Pengujian Teknis

---

### Skenario 1: Uji Sinkronisasi Master Data (CLI)

**Tujuan:** Memvalidasi bahwa koneksi autentikasi berhasil, token diperoleh, serta data wilayah berhasil ditarik dan di-cache ke database lokal.

**Langkah Uji:**
1. Jalankan perintah artisan berikut di terminal:
   ```bash
   php artisan sippt:sync-master --provinsi=34
   ```
   *(Catatan: Opsi `--provinsi=34` digunakan untuk menguji penarikan negara, provinsi, dan spesifik kabupaten di wilayah DI Yogyakarta agar proses pengujian berjalan cepat).*

2. Untuk sinkronisasi penuh seluruh Indonesia, jalankan tanpa opsi:
   ```bash
   php artisan sippt:sync-master
   ```

**Kriteria Keberhasilan:**
* Output konsol menampilkan baris hijau:
  ```text
  [1/3] Mengambil data Negara dari /api/list_negara...
    Berhasil memperbarui X data negara.
  [2/3] Mengambil data Provinsi dari /api/list_provinsi...
    Berhasil memperbarui X data provinsi.
  [3/3] Mengambil data Kabupaten/Kota...
    Berhasil memperbarui X data kabupaten/kota.
  ✅ Seluruh master data SIPPT berhasil disinkronkan.
  ```
* Buka database Polimer dan periksa tabel `sippt_ref_negara`, `sippt_ref_provinsi`, dan `sippt_ref_kabupaten`. Data negara Indonesia (`kode: 62`) dan provinsi telah terisi.

---

### Skenario 2: Uji Auto-Sync via Observer (Status Berubah ke DONE / LUNAS)

**Tujuan:** Memvalidasi bahwa perubahan status permohonan secara otomatis memicu antrean job sinkronisasi tanpa intervensi manual.

**Langkah Uji:**
1. Pastikan Queue Worker aktif di salah satu terminal:
   ```bash
   php artisan queue:work
   ```
2. Buka aplikasi Polimer melalui browser dan login sebagai Petugas/Admin.
3. Buka salah satu permohonan layanan (contoh: Pengujian Laboratorium).
4. Selesaikan permohonan hingga status workflow berubah menjadi **`DONE`** (atau tandai status pembayaran menjadi **`LUNAS`**).
5. Perhatikan log di terminal `queue:work`.

**Kriteria Keberhasilan:**
* Terminal queue menampilkan proses eksekusi:
  ```text
  Processing: Modules\Integration\Jobs\SyncPermohonanToSipptJob
  [SIPPT Queue] Memulai eksekusi job sync SIPPT untuk permohonan TEST/...
  Processed:  Modules\Integration\Jobs\SyncPermohonanToSipptJob
  ```
* Data log baru tercatat di tabel `sippt_sync_logs` dengan status `success`.
* Pada halaman detail permohonan admin, badge indikator status SIPPT berubah menjadi **`✓ Synced`** (berwarna hijau).

---

### Skenario 3: Uji Dashboard Monitoring Web Admin

**Tujuan:** Memverifikasi fungsionalitas antarmuka admin untuk memantau transaksi, memeriksa payload JSON, dan melihat metrik.

**Langkah Uji:**
1. Login sebagai Admin di aplikasi Polimer.
2. Akses URL monitoring integrasi:
   ```text
   http://localhost:7000/integrasi/sippt
   ```
3. Periksa tampilan halaman:
   * **Kartu Metrik:** Angka *Total Terkirim*, *Berhasil*, *Gagal*, dan *Pending* tampil sesuai data riil.
   * **Filter Bar:** Coba filter berdasarkan modul layanan (misal: `Pengujian`) atau status (`Success`).
   * **Pencarian:** Masukkan nomor permohonan pada kolom search dan klik Filter.
4. Klik tautan **No Order** atau tombol **Lihat Detail (ikon mata)** pada salah satu baris tabel.

**Kriteria Keberhasilan:**
* Halaman detail (`/integrasi/sippt/{id}`) terbuka.
* Tampil informasi lengkap: Status, Modul, Endpoint, HTTP Status Code, dan Waktu Sync.
* Panel **Payload Request** menampilkan JSON array terformat rapi (`[ { "no_order": "...", ... } ]`).
* Panel **Payload Response** menampilkan balasan JSON resmi dari API SIPPT.

---

### Skenario 4: Uji Coba Ulang (Retry Mechanism) Saat Transaksi Gagal

**Tujuan:** Memvalidasi bahwa transaksi yang sempat gagal (akibat timeout / kendala server) dapat dicoba ulang tanpa merusak data transaksi.

**Langkah Uji:**
1. **Uji Single Retry via Web:**
   * Di dashboard `/integrasi/sippt`, cari baris data yang berstatus **Failed**.
   * Klik tombol **Retry (ikon panah melingkar)** pada kolom aksi.
   * Periksa pesan notifikasi di layar atas.
2. **Uji Bulk Retry All via Web:**
   * Jika terdapat lebih dari 1 transaksi gagal, klik tombol kuning **"Retry Semua Gagal"** di pojok kanan atas dashboard.
   * Konfirmasi dialog browser.
3. **Uji Retry via Terminal (CLI):**
   * Buka terminal dan jalankan perintah:
     ```bash
     # Retry semua yang gagal
     php artisan sippt:retry-sync --all

     # Atau retry berdasarkan nomor permohonan tertentu
     php artisan sippt:retry-sync --order=TEST/PUJ/2026/00001
     ```

**Kriteria Keberhasilan:**
* Nilai `retry_count` pada log bertambah (+1).
* Jika server SIPPT merespon sukses, status log berubah menjadi `success` dan kolom `last_error` menjadi null.
* Pada halaman detail permohonan, badge berubah dari `✕ Failed` menjadi `✓ Synced`.

---

### Skenario 5: Uji Pelaporan Proyeksi Penerimaan PNBP (Endpoint 22)

**Tujuan:** Memverifikasi pengiriman data target proyeksi PNBP tahunan ke SIPPT BSKJI.

**Langkah Uji:**
1. Buka halaman:
   ```text
   http://localhost:7000/integrasi/sippt/proyeksi
   ```
2. Pada form **Kirim Data Proyeksi Baru**:
   * Pilih Jenis Layanan: misal **`PENGUJIAN`**
   * Tahun Anggaran: misal **`2026`**
   * Proyeksi Penerimaan: misal **`50000000`**
3. Klik tombol **"Laporkan ke SIPPT BSKJI"**.

**Kriteria Keberhasilan:**
* Muncul pesan sukses: *"Proyeksi penerimaan PENGUJIAN tahun 2026 berhasil dilaporkan ke SIPPT BSKJI."*
* Baris baru muncul di tabel **Riwayat Pelaporan Proyeksi** di sebelah kanan dengan status `Success` dan HTTP code `200`.

---

### Skenario 6: Uji Proteksi Idempotensi (Mencegah Duplikasi)

**Tujuan:** Memastikan permohonan yang sama tidak terkirim dua kali ke server SIPPT.

**Langkah Uji:**
1. Ambil salah satu permohonan yang sudah berhasil disinkronkan (`status: success`).
2. Melalui kode atau controller, coba panggil kembali:
   ```php
   app(\Modules\Integration\Services\Sippt\SipptSyncService::class)->syncPermohonan($permohonan);
   ```
3. Periksa log aplikasi di `storage/logs/laravel.log`.

**Kriteria Keberhasilan:**
* Muncul log informasi: `[SIPPT Sync] Permohonan XXX sudah tersinkronisasi sebelumnya. Skip.`
* Tidak ada duplikasi record request baru ke API BSKJI.

---

### Skenario 7: Uji Auto-Healing Token Kedaluwarsa (HTTP 401)

**Tujuan:** Memastikan sistem mampu memperbarui token secara otomatis jika token di cache kedaluwarsa.

**Langkah Uji:**
1. Hapus cache token secara manual:
   ```bash
   php artisan cache:forget sippt_bearer_token
   ```
   *(atau isi cache dengan token palsu yang tidak valid).*
2. Picu proses sinkronisasi permohonan baru atau lakukan retry.

**Kriteria Keberhasilan:**
* `SipptApiClient` mendeteksi `HTTP 401 Unauthorized`.
* Muncul log di `storage/logs/laravel.log`:
  ```text
  [SIPPT API] 401 Unauthorized terdeteksi. Memperbarui token dan mencoba ulang...
  [SIPPT Auth] Login berhasil, token baru telah disimpan ke cache.
  ```
* Request kedua berhasil dijalankan dengan token baru tanpa menghasilkan exception fatal ke pengguna.

---

## 3. Panduan Pemecahan Masalah (Troubleshooting)

| Gejala Error | Kemungkinan Penyebab | Tindakan Solusi |
|---|---|---|
| **`Login SIPPT gagal [HTTP 401]: Unauthorised`** | Username atau password di `.env` salah, atau akun terdaftar di server Production tetapi `SIPPT_ENVIRONMENT` diset ke `dev`. | 1. Pastikan kecocokan environment: jika akun dibuat di portal production, ubah `SIPPT_ENVIRONMENT=prod`.<br>2. Verifikasi ulang password di portal web BSKJI. |
| **`cURL error 60: SSL certificate problem`** | Sertifikat SSL server testing BSKJI tidak diverifikasi oleh sistem operasi. | Setel `SIPPT_SSL_VERIFY=false` pada file `.env`. |
| **`Connection timed out after 30000ms`** | Jaringan VPN Kemenperin atau firewall memblokir port outbound. | 1. Naikkan `SIPPT_TIMEOUT=60` di `.env`.<br>2. Pastikan server Polimer memiliki akses internet terbuka ke domain `*.kemenperin.go.id`. |
| **`Token tidak ditemukan dalam payload response`** | Struktur respons endpoint `/api/login` berbeda format. | `SipptAuthService` sudah mendukung 5 format response (`api_token`, `token`, `data.token`, `access_token`, string). Periksa log raw response di `storage/logs/laravel.log`. |
| **Data sync masuk status `failed`** | ID Satker kosong atau kode klasifikasi tidak sesuai ketentuan. | 1. Pastikan `SIPPT_SATKER_ID` di `.env` sudah diisi (contoh: `24`).<br>2. Buka detail log di `/integrasi/sippt/{id}` untuk membaca pesan validasi spesifik dari BSKJI. |

---

## 4. Lembar Checklist Verifikasi UAT

| No | Komponen Pengujian | Perintah / Halaman | Status | Catatan |
|:--:|---|---|:--:|---|
| 1 | Database Migrations | `php artisan migrate` | ⬜ | 4 tabel terbentuk |
| 2 | Master Data Sync | `php artisan sippt:sync-master` | ⬜ | Negara & Provinsi tersimpan |
| 3 | Auto-Sync on DONE | Ubah status permohonan ke DONE | ⬜ | Queue job tereksekusi |
| 4 | Auto-Sync on LUNAS | Ubah status bayar ke LUNAS | ⬜ | Queue job tereksekusi |
| 5 | Web Monitoring List | `/integrasi/sippt` | ⬜ | Tabel & metrik tampil |
| 6 | Detail Payload Inspector | `/integrasi/sippt/{id}` | ⬜ | Request & Response JSON rapi |
| 7 | Single Retry Action | Tombol Retry di tabel log | ⬜ | Log terupdate |
| 8 | Bulk Retry All Action | Tombol "Retry Semua Gagal" | ⬜ | Notifikasi batch selesai |
| 9 | Proyeksi Penerimaan Form | `/integrasi/sippt/proyeksi` | ⬜ | Sukses terkirim ke SIPPT |
| 10 | Status Badge di Detail Mohon | Detail Permohonan Admin | ⬜ | Badge `✓ Synced` muncul |
