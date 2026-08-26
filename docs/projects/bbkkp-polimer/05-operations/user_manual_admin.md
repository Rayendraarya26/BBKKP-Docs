# Panduan Pengguna (User Manual) — Portal Operasional Internal & Administrator
## Balai Besar Standardisasi dan Pelayanan Jasa Industri Kulit, Karet dan Plastik (BBKKP)

---

## 1. Pendahuluan
Portal Admin BBKKP Polimer adalah sistem operasional terpadu berbasis *Unified React SPA* untuk seluruh unit kerja balai:
- **Petugas Loket / Customer Service**: Penerimaan berkas, disposisi awal, dan manajemen tiket bantuan.
- **Verifikator Berkas**: Peninjauan kelayakan dokumen teknis & legalitas, approval, dan permintaan revisi.
- **Asesor LSP / Petugas Laboratorium**: Penginputan parameter hasil uji lab, penilaian kompetensi, dan draft laporan teknis.
- **Bendahara Keuangan**: Penetapan rincian tarif PNBP, penerbitan invoice billing, monitoring VA BNI, dan validasi kuitansi sah.
- **Kepala Balai / Pejabat Penandatangan**: Tanda Tangan Elektronik (TTE) sertifikat dan invoice berbasis sertifikat digital BSrE.
- **Super Administrator**: Konfigurasi master data, manajemen pengguna, pengaturan hak akses dinamis (RBAC), dan integrasi SSO ekosistem.

---

## 2. Navigasi & Tampilan Antarmuka Terpadu (Admin Shell)

Sistem admin menggunakan struktur **Dual-Rail Navigation**:
1. **Primary Navigation Rail (Kiri Sempit)**:
   - 🏠 **Home**: Dashboard KPI & Ikhtisar Operasional.
   - 📋 **Permohonan**: Antrean Permohonan, Hasil Uji Lab & TTE, Invoice & Pembayaran, Helpdesk.
   - 🗄️ **Master Data**: Master Layanan, Tarif PNBP, Lokasi/Wilayah, Banner Homepage, Integrasi SSO.
   - 🛡️ **System**: Manajemen User, Grup Role & RBAC, Hierarki Menu Sistem.
2. **Secondary Sub-Menu Panel**: Menampilkan sub-menu kontekstual sesuai modul utama yang dipilih.
3. **Dynamic Role Switcher (Top Navbar)**: Bagi pegawai yang memiliki lebih dari satu penugasan (contoh: *Verifikator* sekaligus *Asesor*), dapat berganti peran secara instan tanpa perlu logout.

---

## 3. Prosedur Operasional per Modul

---

### A. Modul Verifikasi & Approval Permohonan (`/admin/permohonan`)
1. Buka menu **Antrean Permohonan**.
2. Gunakan filter tab status (*Menunggu Verifikasi*, *Sedang Diproses*, *Menunggu Pembayaran*, *Selesai*).
3. Klik tombol **Tinjau Berkas** pada baris permohonan yang dituju.
4. Pada halaman detail permohonan:
   - Periksa kelengkapan identitas pelanggan dan kontak PIC.
   - Gunakan fitur **File Previewer Terpadu** untuk memeriksa dokumen persyaratan (KTP, NIB, NPWP, Form APL, dsb.).
5. Lakukan salah satu dari 3 tindakan persetujuan:
   - **Setujui Permohonan (Approve)**: Berkas lengkap dan valid. Permohonan diteruskan ke Bendahara untuk penetapan tarif tagihan PNBP.
   - **Minta Revisi Dokumen**: Masukkan catatan revisi spesifik pada dokumen yang tidak sesuai agar pemohon mengunggah ulang perbaikan.
   - **Tolak Permohonan (Reject)**: Berikan alasan penolakan resmi (misal: *Layanan di luar lingkup akreditasi balai*).
6. **Disposisi Petugas**: Tetapkan tim verifikator dan penguji lab penanggung jawab pengerjaan sampel.

---

### B. Modul Keuangan, Invoice PNBP & Kuitansi (`/admin/finance`)

#### 1. Pembuatan & Penerbitan Invoice Billing (`/admin/finance/invoice`)
1. Buka menu **Manajemen Invoice**.
2. Pilih permohonan yang berstatus *Menunggu Penetapan Tarif*.
3. Masukkan item rincian tarif PNBP sesuai PP Tarif yang berlaku:
   - Biaya Pengujian per Parameter / Paket.
   - Biaya Asesmen / Pelatihan.
   - Biaya Sertifikasi / Biaya Administrasi.
4. Klik **Generate Draf Invoice**. Sistem akan menghitung total otomatis dan menyematkan nomor billing SIMPONI serta kode Virtual Account BNI.
5. Lakukan persetujuan penerbitan invoice resmi bertanda tangan elektronik (TTE).

#### 2. Monitoring Pembayaran & Validasi Kuitansi (`/admin/finance/pembayaran`)
1. Pembayaran yang masuk via Virtual Account BNI akan tercatat **otomatis secara real-time**.
2. Untuk pembayaran manual (transfer bank langsung/teller), periksa bukti bayar yang diunggah pelanggan, lalu klik **Verifikasi & Validasi Lunas**.
3. Sistem secara otomatis menerbitkan **Kuitansi Sah Lunas PNBP** lengkap dengan nomor kuitansi resmi dan QR Code pengesahan bendahara.

---

### C. Modul Hasil Pengujian & Penerbitan Sertifikat TTE (`/admin/sertifikasi/hasil-uji`)
1. Buka menu **Hasil Uji Lab & TTE**.
2. Pilih permohonan yang sampelnya telah selesai diuji di laboratorium balai.
3. Klik tombol **Input Hasil Pengujian**:
   - Masukkan nama parameter uji, metode uji (SNI/ISO/ASTM), satuan, nilai spesifikasi standar, dan hasil pengukuran riil.
   - Unggah draf dokumen Laporan Hasil Pengujian (LHU) / Sertifikat Kompetensi format PDF.
4. Klik **Pratinjau Sertifikat** untuk memastikan tata letak dan data telah sesuai standar mutu ISO/IEC 17025.
5. Klik **Terbitkan & Tanda Tangani (TTE BSrE)**:
   - Masukkan Passphrase TTE pejabat berwenang.
   - Sistem akan menyematkan digital signature BSrE pada file PDF dan mengubah status permohonan menjadi **Selesai**.

---

### D. Modul Pusat Bantuan & Helpdesk Tiket (`/admin/helpdesk`)
1. Buka menu **Tiket Tanya Jawab**.
2. Buka tiket dengan status *Open* / *Menunggu Balasan*.
3. Tulis balasan atau penjelasan solusi atas pertanyaan pemohon.
4. Jika masalah telah terselesaikan, klik **Tutup Tiket (Close Ticket)**.
5. Kelola daftar pertanyaan umum pada sub-menu **Master FAQ Layanan** untuk memperbarui basis pengetahuan publik.

---

### E. Modul Manajemen Hak Akses & Sistem RBAC (`/admin/system`) *(Super Admin Only)*

#### 1. Manajemen Pengguna (`/admin/system/users`)
- **Tambah Pengguna Baru**: Daftarkan pegawai balai dengan NIP, nama, email dinas, dan unit bagian.
- **Penugasan Grup Role**: Pasangkan satu atau lebih peran (misal: *Verifikator*, *Penguji Lab*, *Bendahara*).
- **Aksi Keamanan**: Fitur Reset Password, Aktivasi Akun, dan Pemblokiran Akses (*Ban User*).

#### 2. Pengaturan Grup Role & Matriks Permission (`/admin/system/groups`)
- Kelola daftar grup sistem (`sys_group`).
- Buka **Treeview Hak Akses** untuk mencentang/membatalkan izin aksi spesifik (*Create, Read, Update, Delete, Approve, Export, Sign TTE*) pada setiap menu sistem.

#### 3. Manajemen Hierarki Menu (`/admin/system/menu`)
- Konfigurasi struktur menu navigasi, urutan (*order*), ikon, dan pengelompokan sub-menu sistem.
