# 🔑 Daftar Akun Pengujian & Login Info (Database Seeder) — BBKKP Polimer

> **File Sumber Seeder**:
> - [`database/seeders/UserSeeder.php`](file:///f:/!Productive/BBKKP/private-polimer/database/seeders/UserSeeder.php) (Akun Dasar Sistem)
> - [`database/seeders/MarketingUserSeeder.php`](file:///f:/!Productive/BBKKP/private-polimer/database/seeders/MarketingUserSeeder.php) (Akun Verifikasi & Role Pegawai)
> - [`database/seeders/DummyPolimerSeeder.php`](file:///f:/!Productive/BBKKP/private-polimer/database/seeders/DummyPolimerSeeder.php) (Data Mock Permohonan & Tiket Helpdesk)  
> **Password Default Seluruh Akun**: `password`  
> **Perintah Seeding Lengkap**:
> ```bash
> php artisan db:seed --class=UserSeeder
> php artisan db:seed --class=MarketingUserSeeder
> php artisan db:seed --class=DummyPolimerSeeder
> ```

---

## 1. Pengguna Internal (Admin, Pegawai & Keuangan)

Pengguna internal digunakan untuk mengelola permohonan, verifikasi dokumen, penetapan tarif, pembuatan invoice, layanan helpdesk, dan administrasi sistem.

| Role / Group | Nama User | Email Login | Password | NIP / NIK | Keterangan & Hak Akses |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Root** | Developer | `dolkode@mailinator.com` | `password` | NIP: `198707062014022001` | Super Administrator, hak akses penuh ke seluruh menu & konfigurasi sistem |
| **Pegawai (Marketing)** | Tim Marketing & Verifikasi | `marketing@mailinator.com` | `password` | NIP: `199001012015011001`<br>NIK: `3271012345670009` | Khusus operasional: verifikasi berkas permohonan masuk, penetapan tarif PNBP, dan respon tiket helpdesk |
| **Pegawai** | Pegawai Operasional | `pegawai@mailinator.com` | `password` | NIP: `198706192009012001`<br>NIK: `1290412412120932` | Akun staf teknis laboratorium/audit |
| **Pegawai** | Dolkode Solutions | `dolkodesolutions@gmail.com` | `password` | NIP: `199104282018012001`<br>NIK: `0803202100007062` | Akun staf pengembang & pemeliharaan |
| **Bendahara** | Bendahara Penerima PNBP | `bendahara@mailinator.com` | `password` | NIP: `199203120101801001`<br>NIK: `1234567890123452` | Khusus modul invoice, verifikasi pembayaran VA, & approval keuangan |

---

## 2. Pengguna Eksternal (Pelanggan / Pemohon Layanan)

Pengguna eksternal mewakili pemohon layanan pengujian, kalibrasi, konsultansi, pelatihan, atau sertifikasi di BBKKP Polimer.

### A. Pelanggan Perorangan
* **Email Login**: `perorangan@mailinator.com`
* **Password**: `password`
* **Group**: `PELANGGAN`
* **Jenis Pelanggan**: `Perorangan`
* **Profil Detail**:
  * **Nama Lengkap**: Ahmad Zulfikar
  * **NIK**: `1234567890123456`
  * **Tempat, Tgl Lahir**: Bandung, 1980-01-01
  * **Alamat**: Jl. Pribadi No. 123, Bandung
  * **WhatsApp**: `085678901234`
  * **NPWP**: `1234567890`
  * **NIB**: `0987654321`

### B. Pelanggan Instansi Pemerintah
* **Email Login**: `instansi@mailinator.com`
* **Password**: `password`
* **Group**: `PELANGGAN`
* **Jenis Pelanggan**: `Instansi Pemerintah`
* **Profil Detail**:
  * **Nama Instansi**: Dinas Perindustrian dan Perdagangan Example
  * **Pimpinan**: Alice Smith
  * **Surel Instansi**: `info@dinas.example.com`
  * **Telepon**: `62214810912`
  * **WhatsApp**: `08234567890`
  * **NPWP**: `9876543210`
  * **NIB**: `1234567890`
  * **Penanggung Jawab (PJ)**: Alice Smith

### C. Pelanggan Badan Usaha / Perusahaan (Swasta)
* **Email Login**: `perusahaan@mailinator.com`
* **Password**: `password`
* **Group**: `PELANGGAN`
* **Jenis Pelanggan**: `Badan Usaha`
* **Profil Detail**:
  * **Nama Perusahaan**: PT Indorubber Polymer Tech (PT. Example)
  * **Badan Hukum**: PT (Swasta Nasional)
  * **Pemilik / Pimpinan**: Ir. Hendri Gunawan / Jane Doe
  * **Alamat**: Kawasan Industri Jababeka V, Cikarang
  * **Surel Perusahaan**: `perusahaan@mailinator.com` / `info@example.com`
  * **Telepon**: `622112345678`
  * **WhatsApp**: `08123456789`
  * **NPWP**: `1234567890`
  * **NIB**: `0987654321`
  * **Penanggung Jawab (PJ)**: John Doe

---

## 3. Data Mock DummyPolimerSeeder

Saat menjalankan `php artisan db:seed --class=DummyPolimerSeeder`, sistem otomatis mengenerate:
* **Permohonan Simulasi**: Berbagai status siklus (`DRAFT`, `PERMOHONAN`, `PEMBAYARAN`, `PROCESS`, `DONE`, `DITOLAK`) untuk layanan Kalibrasi, Lab Uji, Konsultansi, Pelatihan, dan Multi-Sertifikasi.
* **Tiket Helpdesk / Tanya Jawab**: Beragam kasus tiket (`OPEN`, `PROCESSED`, `ANSWERED`, `CLOSED`) dengan riwayat chat bolak-balik antara pemohon dan admin.
* **Virtual Account & Invoice**: Nomor tagihan dan VA simulasi untuk menguji halaman pembayaran `/app/pembayaran` dan kuitansi.
