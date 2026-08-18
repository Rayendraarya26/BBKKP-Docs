# 🔑 Daftar Akun Pengujian & Login Info (Database Seeder) — BBKKP Polimer

> **File Sumber**: [`database/seeders/UserSeeder.php`](file:///f:/!Productive/BBKKP/private-polimer/database/seeders/UserSeeder.php)  
> **Password Default Seluruh Akun**: `password`  
> **Perintah Seeding**: `php artisan migrate:fresh --seed` atau `php artisan db:seed`

---

## 1. Pengguna Internal (Admin, Pegawai & Keuangan)

Pengguna internal digunakan untuk mengelola permohonan, verifikasi dokumen, pembuatan invoice, dan administrasi sistem.

| Role / Group | Nama User | Email Login | Password | NIP / NIK | Keterangan & Hak Akses |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Root** | Developer | `dolkode@mailinator.com` | `password` | NIP: `198707062014022001` | Super Administrator, hak akses penuh ke seluruh menu & aksi |
| **Pegawai** | Pegawai | `pegawai@mailinator.com` | `password` | NIP: `198706192009012001`<br>NIK: `1290412412120932` | Akun pegawai operasional |
| **Pegawai** | Dolkode | `dolkodesolutions@gmail.com` | `password` | NIP: `199104282018012001`<br>NIK: `0803202100007062` | Akun staf developer / pegawai |
| **Bendahara** | Bendahara | `bendahara@mailinator.com` | `password` | NIP: `199203120101801001`<br>NIK: `1234567890123452` | Khusus modul invoice, verifikasi pembayaran, & approval keuangan |

---

## 2. Pengguna Eksternal (Pelanggan / Pemohon Layanan)

Pengguna eksternal mewakili pemohon layanan pengujian, kalibrasi, pelatihan, atau sertifikasi di BBKKP Polimer dengan profil entitas yang berbeda.

### A. Pelanggan Perorangan
* **Email Login**: `perorangan@mailinator.com`
* **Password**: `password`
* **Group**: `PELANGGAN`
* **Jenis Pelanggan**: `Perorangan`
* **Profil Detail**:
  * **Nama Lengkap**: Ahmad Zulfikar
  * **NIK**: `1234567890123456`
  * **Tempat, Tgl Lahir**: Bandung, 1980-01-01
  * **Jenis Kelamin**: Laki-laki
  * **Kewarganegaraan**: WNI
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
  * **Nama Instansi**: Dinas Example
  * **Pimpinan**: Alice Smith
  * **Surel Instansi**: `info@dinas.example.com`
  * **Telepon**: `62214810912`
  * **WhatsApp**: `08234567890`
  * **NPWP**: `9876543210`
  * **NIB**: `1234567890`
  * **Penanggung Jawab (PJ)**: Alice Smith (`alice.smith@dinas.example.com`, `08234567890`)

### C. Pelanggan Badan Usaha / Perusahaan (Swasta)
* **Email Login**: `perusahaan@mailinator.com`
* **Password**: `password`
* **Group**: `PELANGGAN`
* **Jenis Pelanggan**: `Badan Usaha`
* **Profil Detail**:
  * **Nama Perusahaan**: PT. Example
  * **Badan Hukum**: PT (Swasta)
  * **Pemilik**: John Doe
  * **Pimpinan**: Jane Doe
  * **Alamat**: Jl. Contoh No. 1, Jakarta
  * **Surel Perusahaan**: `info@example.com`
  * **Telepon**: `622112345678`
  * **WhatsApp**: `08123456789`
  * **NPWP**: `1234567890`
  * **NIB**: `0987654321`
  * **No. Akta Pendirian**: `1234567890`
  * **Penanggung Jawab (PJ)**: John Doe (`john.doe@example.com`, `08123456789`)
