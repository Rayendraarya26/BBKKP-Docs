# Functional Requirements Document (FRD)
## Formulir Permohonan Pengujian Laboratorium Sisi Klien (Self-Service Client Portal)

> **Spesifikasi Kebutuhan Fungsional Layanan Pengujian BBKKP Polimer**  
> **Balai Besar Kulit, Karet, dan Plastik (BBKKP) - Kementerian Perindustrian RI**  
> **Dokumen Versi**: 1.0  
> **Tanggal Efektif**: 17 September 2026  
> **Target Pengguna**: Pelanggan Eksternal (Perusahaan Industri, Perorangan, Mahasiswa, Lembaga Penelitian)  

---

## 1. Pendahuluan

### 1.1 Latar Belakang
Layanan Pengujian Laboratorium BBKKP melayani berbagai komoditas industri strategis, meliputi karet dan barang karet, plastik dan polimer, kulit dan produk kulit, alas kaki, serta tekstil/sepatu. Pada sistem sebelumnya, proses input permohonan pengujian masih mengandalkan staf loket balai (Admin-facing). Klien tidak memiliki fleksibilitas untuk memilih parameter pengujian secara spesifik sebelum datang ke balai atau mengirimkan sampel.

Implementasi **Form Pengujian Sisi Klien** pada aplikasi BBKKP Polimer dirancang untuk memberikan transparansi penuh, kemandirian pengajuan oleh klien, estimasi tarif PNBP otomatis, serta percepatan alur penerimaan sampel (*speed of delivery*).

### 1.2 Tujuan Dokumen
Dokumen FRD ini mendefinisikan seluruh kebutuhan fungsional, aturan bisnis (*business rules*), skenario validasi data, serta kriteria penerimaan (*acceptance criteria*) untuk modul wizard pengajuan pengujian laboratorium 4-tahap di portal pelanggan.

---

## 2. Aktor & Peran Pengguna (User Roles)

| Aktor | Peran & Tanggung Jawab |
| :--- | :--- |
| **Klien / Pelanggan Eksternal** | Mengisi form pengujian 4-tahap, menentukan bahasa laporan, mendaftarkan 1 s/d N sampel uji, memilih parameter uji, mengunggah surat pengantar / KTM, serta melakukan konfirmasi permohonan. |
| **Petugas Verifikasi Loket / Admin Lab** | Menerima berkas permohonan, mencocokkan kelengkapan sampel fisik yang tiba di laboratorium, memeriksa keabsahan dokumen (KTM jika tarif mahasiswa / Surat Pengantar), dan menyetujui penerbitan STPCU. |
| **Sistem Polimer** | Menyediakan master data komoditas & parameter uji, mengkalkulasi tarif estimasi, memvalidasi ukuran & format berkas, serta menerbitkan nomor permohonan dan tagihan Virtual Account (VA) BNI. |

---

## 3. Matriks Kebutuhan Fungsional (Functional Requirements)

### FR-01: Tahap 1 — Preferensi Bahasa Laporan Hasil Uji (LHU)
- **FR-01.1**: Sistem harus menyediakan pilihan bahasa laporan hasil uji dengan opsi:
  - **Bahasa Indonesia** (`id`) — *Default*
  - **English** (`en`)
- **FR-01.2**: Pilihan bahasa ini mengikat format penerbitan dokumen sertifikat/LHU pada saat hasil pengujian selesai diterbitkan oleh laboratorium.

### FR-02: Tahap 2 — Data Permintaan & Administrasi Layanan
- **FR-02.1 Tanggal Permohonan**: Terisi secara otomatis dengan tanggal saat formulir diakses/diajukan dan berstatus *read-only*.
- **FR-02.2 Diajukan Oleh**: Menampilkan nama pemohon / akun terdaftar di portal BBSPJIKKP (autofill).
- **FR-02.3 Checkbox Relasi Pihak Biaya**:
  - Checkbox: "Biaya pengujian ditanggung oleh pemohon / instansi sendiri" (Default: **Dicentang**).
  - Bila dicentang: Input manual disembunyikan, sistem menggunakan profil akun pemohon secara otomatis.
  - Bila tidak dicentang: Muncul input teks wajib nama pihak ketiga atau instansi penanggung jawab biaya.
- **FR-02.4 Checkbox Relasi Pihak Pengiriman Laporan**:
  - Checkbox: "Laporan pengujian dialamatkan kepada pemohon / instansi sendiri" (Default: **Dicentang**).
  - Bila dicentang: Input manual disembunyikan, sistem menggunakan data pemohon.
  - Bila tidak dicentang: Muncul input teks wajib tujuan pengiriman fisik/dokumen LHU untuk pihak ketiga.
- **FR-02.5 Keterangan Permintaan**:
  - Kolom teks tambahan untuk instruksi atau catatan umum permohonan pengujian (opsional).

### FR-03: Tahap 3 — Pendaftaran Sampel & Pemilihan Parameter Uji
- **FR-03.1 Multi-Sample Management**:
  - Pengguna dapat mendaftarkan 1 atau lebih sampel uji (minimal 1 sampel wajib ada).
  - Pengguna dapat menghapus sampel tertentu selama jumlah sampel tidak kurang dari 1.
- **FR-03.2 Metadata Sampel**:
  - Setiap sampel memiliki: **Nama Sampel**, **Bentuk Fisik** (Lembaran/Film, Butiran/Granul, Serbuk, Cairan, Barang Jadi, Lainnya), **Jumlah/Volume Sampel**, **Satuan** (kg, gram, liter, ml, pcs, pasang, meter), **Kondisi Fisik Awal** (Baik, Rusak, Tersegel, Terbuka), dan **Nomor Lot / Bets** (opsional).
- **FR-03.3 Pemilihan Komoditas & Inline Checklist Parameter Uji**:
  - Pengguna memilih Komoditas / Ruang Lingkup dari daftar master data (misal: "Karet dan Barang Karet", "Plastik dan Polimer", "Alas Kaki").
  - Setelah komoditas dipilih, sistem langsung menampilkan daftar seluruh parameter uji yang tersedia secara *inline* dengan **checkbox multi-select**.
  - Setiap parameter menampilkan Nama Parameter, Kode, **Metode Uji Acuan Baku** (SNI, ASTM, ISO) yang otomatis melekat, Satuan, dan Tarif PNBP.
  - Dilengkapi fitur filter pencarian cepat serta tombol "Pilih Semua" dan "Batal Semua".
- **FR-03.4 Kategori Tarif**:
  - Pilihan: **Umum** atau **Mahasiswa PP 54**.
  - Tarif parameter secara otomatis beralih dan menghitung diskon pendidikan PP 54 secara reaktif bila opsi Mahasiswa dipilih.
- **FR-03.5 Kalkulasi Tarif Subtotal & Grand Total**:
  - Subtotal per sampel dan grand total seluruh sampel terhitung secara reaktif real-time.

### FR-04: Tahap 4 — Tambahan, Pembayaran & Konfirmasi Akhir
- **FR-04.1 Data Tambahan BAPC & Sampel (Opsional)**:
  - Input Tanggal BAPC, Nomor BAPC, Nomor Sample, dan Merek/Kode (opsional).
- **FR-04.2 Permintaan Evaluasi / Pernyataan Kesesuaian**:
  - Opsi radio/toggle: **Ya** atau **Tidak**.
  - Jika **Ya**, muncul kolom input teks wajib untuk menuliskan standar/spesifikasi acuan evaluasi yang diminta pemohon (contoh: "Evaluasi kesesuaian terhadap SNI 06-4965-1999").
- **FR-04.3 Pilihan Menyaksikan Pengujian (Kehadiran di Lab)**:
  - Opsi radio/toggle: **Ya** atau **Tidak**.
  - Jika **Ya**, menampilkan informasi ketentuan/SOP K3 keselamatan laboratorium balai dan kolom catatan perkiraan tanggal hadir & personil perwakilan.
- **FR-04.4 Cara Pembayaran**:
  - Opsi pilihan: **Transfer BNI VA** (Virtual Account otomatis), **Tunai di Loket**, **Dibayar di Belakang** (khusus instansi rekanan MoU/PKS aktif).
- **FR-04.5 Berkas Persyaratan**:
  - Nomor dan Tanggal Surat Pengantar (opsional).
  - Unggah Berkas Surat Pengantar (PDF/JPG/PNG max 5MB).
  - Unggah Kartu Tanda Mahasiswa (KTM) — *Wajib jika Kategori Tarif = Mahasiswa PP 54*.
- **FR-04.6 Ringkasan Permohonan (Order Review)**:
  - Menampilkan ringkasan lengkap data administrasi, bahasa laporan, rincian parameter uji per sampel, dan total estimasi tarif.
- **FR-04.7 Persetujuan Pernyataan Integritas**:
  - Checkbox pernyataan integritas bahwa sampel yang diserahkan adalah benar milik pemohon dan bersedia mematuhi syarat dan ketentuan pengujian di BBKKP.
- **FR-04.8 Submit / Simpan Draft Permohonan**:
  - Tombol Submit dinonaktifkan jika syarat persetujuan belum dicentang atau berkas wajib belum terunggah.

---

## 4. Aturan Bisnis & Validasi (Business Rules)

1. **BR-01 (Kewajiban Sampel Minimal)**: Satu permohonan pengujian wajib memiliki minimal 1 (satu) sampel uji, dan setiap sampel wajib memiliki minimal 1 (satu) parameter uji terpilih.
2. **BR-02 (Validasi Mahasiswa)**: Jika Kategori Tarif `mahasiswa_pp54` dipilih, form tidak dapat disubmit tanpa mengunggah berkas identitas KTM yang valid.
3. **BR-03 (Format & Ukuran Berkas)**: Seluruh berkas unggahan dibatasi maksimal 5 MB dengan format MIME yang diizinkan: `application/pdf`, `image/jpeg`, `image/png`.
4. **BR-04 (Pemisahan Ranah Admin vs Client)**: Data **Analis Penerima STPCU** tidak ditampilkan di formulir klien karena penentuan analis penerima adalah kewenangan internal loket laboratorium.
5. **BR-05 (Kebijakan Pembayaran Belakang)**: Permohonan dengan opsi *Dibayar di Belakang* akan masuk status penelaahan administratif tambahan oleh tim pemasaran/keuangan sebelum sampel fisik dapat diproses di laboratorium.

---

## 5. Kriteria Penerimaan (Acceptance Criteria)

- [ ] **AC-01**: Pengguna dapat memilih opsi bahasa laporan pengujian (Indonesia atau English) dan tersimpan di database.
- [ ] **AC-02**: Field tanggal permohonan terkunci otomatis sesuai tanggal pengajuan sistem.
- [ ] **AC-03**: Form mendukung penambahan lebih dari 1 sampel dengan parameter uji yang berbeda antar sampel.
- [ ] **AC-04**: Estimasi total biaya secara dinamis terhitung dan terbarukan setiap kali pengguna mencentang/menghapus parameter uji.
- [ ] **AC-05**: Tarif parameter secara otomatis beralih ke tarif mahasiswa jika kategori tarif mahasiswa dipilih.
- [ ] **AC-06**: Validasi mencegah pengiriman jika tarif mahasiswa dipilih namun file KTM belum diunggah.
- [ ] **AC-07**: Setelah submit berhasil, pengguna diarahkan ke halaman detail permohonan beserta nomor permohonan resmi dan instruksi pembayaran/pengiriman sampel fisik.
