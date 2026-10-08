# Dokumentasi Integrasi API SIPPT BSKJI

> **Versi Dokumen:** 1.0  
> **Tanggal:** 08 Oktober 2026  
> **Sumber:** Dokumentasi API v13 — PT Metanouva Informatika / BSKJI Kemenperin  
> **Status:** 📋 Referensi Arsitektur

---

## 1. Ringkasan Eksekutif

API **Sistem Informasi Pelayanan Publik Terpadu (SIPPT)** milik **Badan Standardisasi dan Kebijakan Jasa Industri (BSKJI)** Kementerian Perindustrian merupakan API wajib-integrasi yang digunakan seluruh Satuan Kerja (Satker) untuk melaporkan data layanan dan penerimaan negara bukan pajak (PNBP).

Integrasi ini menghubungkan aplikasi **BBKKP Polimer** (internal) ke sistem pelaporan nasional BSKJI, sehingga setiap transaksi layanan yang diproses di Polimer otomatis disinkronkan ke SIPPT.

### 1.1 Tujuan Integrasi

| # | Tujuan | Deskripsi |
|---|--------|-----------|
| 1 | **Pelaporan Otomatis** | Sinkronisasi data permohonan layanan ke SIPPT secara real-time ketika permohonan selesai (status `DONE`/`LUNAS`) |
| 2 | **Eliminasi Input Ganda** | Menghilangkan kebutuhan operator memasukkan data secara manual ke dua sistem |
| 3 | **Konsistensi Data** | Menjamin data yang dilaporkan ke BSKJI identik dengan data transaksi internal |
| 4 | **Proyeksi Penerimaan** | Pelaporan proyeksi PNBP tahunan per jenis layanan |

### 1.2 Cakupan Integrasi

API SIPPT mencakup **22 endpoint** yang terbagi dalam:

- **4 Endpoint Master Data** (read-only) — Satker, Negara, Provinsi, Kabupaten/Kota
- **1 Endpoint Autentikasi** — Login & Token
- **15 Endpoint Modul Layanan** (insert data) — Pengujian, Kalibrasi, Sertifikasi, dll.
- **1 Endpoint Proyeksi Penerimaan**
- **1 Endpoint Non-Aktif** (soft-delete data)

---

## 2. Konfigurasi Server & Autentikasi

### 2.1 Base URL

| Environment | URL |
|-------------|-----|
| **Development** | `http://newtesting-bskji.kemenperin.go.id/api/{modul}/{jenis}/{id_satker}` |
| **Production** | `https://sippt-bskji.kemenperin.go.id/api/{modul}/{jenis}/{id_satker}` |

### 2.2 Parameter URL

| Parameter | Keterangan |
|-----------|------------|
| `{modul}` | Nama modul layanan (contoh: `pengujian`, `kalibrasi`, `sertifikasi`) |
| `{jenis}` | Jenis operasi: `insert` (tambah data), `non_aktif` (soft-delete), atau dikosongkan + `GET` untuk melihat data |
| `{id_satker}` | ID 4-digit satuan kerja. Diperoleh dari Dashboard Admin → Sinkronisasi API |

### 2.3 Autentikasi

API menggunakan **dual-layer authentication**:

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: Basic Auth                                     │
│  ├── Username & Password credentials                     │
│  └── Dikirim sebagai HTTP Basic Auth header               │
│                                                          │
│  Layer 2: Bearer Token                                   │
│  ├── POST /api/login → mendapatkan token                 │
│  └── Token dikirim via header: Authorization: Bearer xxx │
└─────────────────────────────────────────────────────────┘
```

#### Login Endpoint

- **URL:** `POST https://newtesting-bskji.kemenperin.go.id/api/login`
- **Body:** `{ "username": "...", "password": "..." }`
- **Response:** Bearer token untuk digunakan di semua request selanjutnya

#### Request Headers (Semua Endpoint)

```
Accept: application/json
Authorization: Bearer {token}
```

### 2.4 ID Satker

ID Satker (4 digit) diperoleh melalui:
1. Login dengan role **Admin Satker** di SIPPT
2. Buka menu **Dashboard** → pilih submenu
3. Klik tombol merah **"Sinkronisasi API"**
4. ID Satker akan ditampilkan

---

## 3. Master Data API (Read-Only)

### 3.1 Daftar Endpoint Master

| # | Endpoint | Method | Deskripsi |
|---|----------|--------|-----------|
| 1 | `/api/list_satker` | `GET` | Daftar seluruh Satuan Kerja |
| 2 | `/api/list_negara` | `GET` | Daftar kode negara |
| 3 | `/api/list_provinsi` | `GET` | Daftar kode provinsi |
| 4 | `/api/list_kabupaten_kota/{kode_provinsi}` | `GET` | Daftar kabupaten/kota per provinsi |

### 3.2 Strategi Caching

Master data bersifat statis dan jarang berubah, sehingga direkomendasikan:
- **Cache di database lokal** (tabel `sippt_ref_negara`, `sippt_ref_provinsi`, `sippt_ref_kabupaten`)
- **Refresh interval:** Harian atau on-demand via artisan command
- **Fallback:** Gunakan cache lokal jika API tidak tersedia

---

## 4. Kode Modul & Mapping Layanan

### 4.1 Kode Modul Utama

| `jns_pengujian` | `kode_uji` | Endpoint API | Modul Polimer |
|----------------|------------|-------------|---------------|
| Pengujian | 01 | `/api/pengujian/insert/{id}` | `FormPengujian` |
| Sampling dan Pengujian | 02 | — | — |
| Kalibrasi | 03 | `/api/kalibrasi/insert/{id}` | `FormKalibrasi` |
| Sertifikasi | 05 | `/api/sertifikasi/insert/{id}` | `FormSertifikasi` |
| Pelatihan | 06 | `/api/pelatihan/insert/{id}` | `FormPelatihan` |
| Inspeksi Teknis | 07 | `/api/inspeksi/insert/{id}` | `FormInspeksi` |
| Teknologi Proses dan Mesin | 08 | `/api/teknologiproses/insert/{id}` | `FormTekPro` |
| Konsultasi | 09 | `/api/konsultasi/insert/{id}` | `FormKonsultasi` |
| Inkubator Bisnis | 10 | `/api/inkubator/insert/{id}` | `FormInkubator` |
| Teknologi Informasi | 11 | `/api/ti/insert/{id}` | `FormTI` |
| Jasa Lainnya | 12 | `/api/lainnya/insert/{id}` | `FormJasaLainnya` |
| Pelaksanaan Litbangyasa | 13 | — | — |
| Alih Teknologi dan RBPI | 14 | — | — |
| Rancang Bangun | 15 | `/api/rbpi/insert/{id}` | `FormRBPI` |

### 4.2 Kode Modul Pengembangan

| `jns_pengujian` | `kode_uji` | Endpoint API | Modul Polimer |
|----------------|------------|-------------|---------------|
| Penyelenggara Uji Profisiensi | 16 | `/api/uji_profisiensi/insert/{id}` | `FormPUP` |
| Produsen Bahan Acuan | 17 | `/api/produsen_bahan_acuan/insert/{id}` | `FormPBA` |
| Verifikasi | 18 | `/api/verifikasi/insert/{id}` | `FormVerifikasi` |
| Pemeriksaan Produk Halal | 19 | `/api/halal/insert/{id}` | `FormHalal` |

---

## 5. Spesifikasi Endpoint Per Modul

### 5.1 Field Umum (Shared Across All Modules)

Semua modul layanan (kecuali Proyeksi Penerimaan) memiliki field dasar yang sama:

| Field | Tipe | Wajib | Keterangan |
|-------|------|-------|------------|
| `no_order` | string | ✅ | Identitas order pelanggan (mapping: nomor permohonan Polimer) |
| `nama_pelanggan` | string | ✅ | Nama pelanggan |
| `jenis_pelanggan` | string | ✅ | `INDUSTRI` atau `NON-INDUSTRI` |
| `tanggal_order` | date | ✅ | Format: `dd-mm-yyyy` |
| `tanggal_selesai` | date | ❌ | Tanggal selesai order |
| `total_bayar` | float | ✅ | Total bayar pelanggan |
| `tanggal_bayar` | date | ✅ | Tanggal pembayaran |
| `tanggal_pengesahan` | date | ❌ | Tanggal pengesahan |
| `kode_negara` | int | ✅ | Kode negara (ref: `/api/list_negara`) |
| `kode_provinsi` | int | ✅ | Kode provinsi (ref: `/api/list_provinsi`) |
| `kode_kabupaten` | int | ✅ | Kode kabupaten (ref: `/api/list_kabupaten_kota`) |

### 5.2 Field Spesifik Per Modul

Selain field umum, setiap modul memiliki field keterangan dan jumlah yang unik:

| Modul | Field Keterangan (✅ wajib) | Field Uraian (❌ opsional) | Field Jumlah (✅ wajib) | Field Tambahan |
|-------|---------------------------|--------------------------|------------------------|----------------|
| **Pengujian** | `keterangan_uji` | `uraian_pengujian` | `jml_sample` | `jenis_klasifikasi` ✅ |
| **Kalibrasi** | `keterangan_kalibrasi` | `uraian_kalibrasi` | `jml_alat` | `jenis_klasifikasi` ✅ |
| **Sertifikasi** | `keterangan_sertifikasi` | `uraian_sertifikasi` | `jml_sertifikat` | `jenis_sertifikasi` ✅ |
| **Pelatihan** | `keterangan_pelatihan` | `uraian_pelatihan` | `jml_peserta` | — |
| **Inspeksi** | `keterangan_inspeksi` | `uraian_inspeksi` | `jml_sample` | — |
| **Teknologi Proses** | `keterangan_tekpro` | `uraian_tekpro` | `jml_alat` | — |
| **Konsultasi** | `keterangan_konsultasi` | `uraian_konsultasi` | `jml_laporan` | — |
| **Inkubator** | `keterangan_inkubasi` | `uraian_inkubasi` | `jml_laporan` | — |
| **Teknologi Informasi** | `keterangan_ti` | `uraian_ti` | `jml_laporan` | — |
| **Jasa Lainnya** | `keterangan_jasalainnya` | `uraian_jasalainnya` | `jml_laporan` | — |
| **Rancang Bangun** | `keterangan_rbpi` | `uraian_rbpi` | `jml_alat` | — |
| **Uji Profisiensi** | `keterangan_uji` | `uraian_pengujian` | `jml_laporan` | — |
| **Produsen Bahan Acuan** | `keterangan_uji` | `uraian_pengujian` | `jml_sample` | — |
| **Verifikasi** | `keterangan_verifikasi` | `uraian_verifikasi` | `jml_sample` | `jenis_verifikasi` ❌ |
| **Halal** | `keterangan_uji` | `uraian_pengujian` | `jml_sample` | — |

### 5.3 Ketentuan Jenis (Enum Values)

#### Jenis Pelanggan (Semua Modul)
- `(1) INDUSTRI`
- `(2) NON-INDUSTRI`

#### Jenis Klasifikasi — Pengujian
`FISIKA`, `KIMIA`, `MEKANIK`, `MIKROBIOLOGI`, `LINGKUNGAN`, `ELEKTRONIKA`, `TELEMATIKA`, `KELISTRIKAN`

#### Jenis Klasifikasi — Kalibrasi
`SUHU DAN KELEMBABAN`, `MASSA DAN BESARAN TERKAIT`, `PANJANG DAN BESARAN TERKAIT`, `KELISTRIKAN DAN KEMAGNETAN`, `WAKTU DAN FREKUENSI`, `AKUSTIK DAN GETARAN`, `FOTOMETRI DAN RADIOMETRI`, `INSTRUMEN PENGUJIAN`, `RADIASI PENGIONAN`, `PERALATAN KESEHATAN`

#### Jenis Sertifikasi
`PRODUK`, `SISTEM MANAJEMEN MUTU`, `INDUSTRI HIJAU`, `PROFESI`, `EKOLABEL`, `SKEM`, `SISTEM HACCP`, `SISTEM K3`, `SISTEM MANAJEMEN LINGKUNGAN`, `SISTEM MANAJEMEN KEAMANAN PANGAN`, `LAINNYA`

#### Jenis Verifikasi
`TKDN`, `GRK DAN NEK`, `EKOLABEL`, `ALKOHOL`, `LAINNYA`

#### Jenis Layanan — Proyeksi Penerimaan
`PENGUJIAN`, `KALIBRASI`, `SERTIFIKASI`, `PELATIHAN`, `INSPEKSI TEKNIS`, `TEKNOLOGI PROSES`, `KONSULTASI`, `INKUBATOR`, `TEKNOLOGI INFORMASI`, `JASA LAINNYA`, `RANCANG BANGUN`, `UJI PROFISIENSI`, `PRODUSEN BAHAN ACUAN`, `VERIFIKASI`, `HALAL`

---

## 6. Endpoint Proyeksi Penerimaan

Berbeda dari modul layanan, endpoint ini melaporkan **target penerimaan tahunan** per jenis layanan.

- **URL:** `POST /api/proyeksi_penerimaan/insert/{id_satker}`

| Field | Tipe | Wajib | Keterangan |
|-------|------|-------|------------|
| `jenis_layanan` | string | ✅ | Salah satu dari 15 jenis layanan |
| `proyeksi_penerimaan` | integer | ✅ | Jumlah total proyeksi tahun tersebut |
| `tahun` | integer | ✅ | Tahun pengajuan |

---

## 7. Format Request & Response

### 7.1 Request Body Format

Semua endpoint modul layanan menerima **array of objects** (mendukung batch insert):

```json
[
    {
        "no_order": "BBKKP/PUJ/2026/00001",
        "nama_pelanggan": "PT. AKUA KITA",
        "jenis_pelanggan": "INDUSTRI",
        "tanggal_order": "12-10-2026",
        "tanggal_selesai": "15-10-2026",
        "keterangan_uji": "Pengujian kadar air",
        "keterangan_lainnya": "",
        "uraian_pengujian": "Pengujian sampel air limbah industri",
        "total_bayar": "500000",
        "jml_sample": "3",
        "tanggal_bayar": "12-10-2026",
        "tanggal_pengesahan": "15-10-2026",
        "kode_negara": "62",
        "kode_provinsi": "33",
        "kode_kabupaten": "3374"
    }
]
```

> **Catatan:** Format tanggal adalah `dd-mm-yyyy`. Semua value dikirim sebagai **string** meskipun tipe datanya integer/float.

### 7.2 Response Format

#### Success
```json
{
    "status": true,
    "message": "Data berhasil di tambah"
}
```

#### Error (Expected Pattern)
```json
{
    "status": false,
    "message": "Error description"
}
```

---

## 8. Operasi Non-Aktif (Soft Delete)

Untuk menonaktifkan data yang sudah dikirim:

- **URL Pattern:** `POST /api/{modul}/non_aktif/{id_satker}`
- **Kegunaan:** Membatalkan/menonaktifkan record yang sudah dikirim ke SIPPT
- **Use Case Polimer:** Ketika permohonan dibatalkan setelah data sudah di-sync

---

## 9. Arsitektur Integrasi di Polimer

### 9.1 Diagram Alur Sinkronisasi

```
┌───────────────┐    Status DONE/LUNAS    ┌─────────────────────┐
│   Polimer     │ ──────────────────────► │   SIPPT Sync Job    │
│  (Permohonan) │                         │                     │
│               │                         │  1. Map fields      │
│  formable:    │                         │  2. Resolve refs    │
│  - Pengujian  │                         │  3. POST to API     │
│  - Kalibrasi  │    Sync Result Log      │  4. Log response    │
│  - ...        │ ◄────────────────────── │                     │
└───────────────┘                         └─────────┬───────────┘
                                                     │
                                                     ▼
                                          ┌─────────────────────┐
                                          │   SIPPT BSKJI API   │
                                          │                     │
                                          │  newtesting-bskji.  │
                                          │  kemenperin.go.id   │
                                          └─────────────────────┘
```

### 9.2 Mapping Polimer → SIPPT

| Data Polimer | Field SIPPT | Keterangan |
|-------------|-------------|------------|
| `Permohonan.nomor_permohonan` | `no_order` | Nomor permohonan internal |
| `Permohonan.formable.nama_pelanggan` / `User.name` | `nama_pelanggan` | Nama pelanggan/pemohon |
| Derived from `User.jenis_usaha` | `jenis_pelanggan` | Mapping ke INDUSTRI/NON-INDUSTRI |
| `Permohonan.created_at` | `tanggal_order` | Format: dd-mm-yyyy |
| `Permohonan.tanggal_selesai` | `tanggal_selesai` | — |
| Derived from formable | `keterangan_*` | Field keterangan spesifik modul |
| `Permohonan.formable.total_biaya` | `total_bayar` | Total pembayaran |
| `Permohonan.tanggal_bayar` / Payment record | `tanggal_bayar` | Tanggal pembayaran aktual |
| `User.negara` → ref lookup | `kode_negara` | Lookup ke master negara SIPPT |
| `User.provinsi` → ref lookup | `kode_provinsi` | Lookup ke master provinsi SIPPT |
| `User.kota` → ref lookup | `kode_kabupaten` | Lookup ke master kab/kota SIPPT |

### 9.3 Komponen yang Akan Dibuat

```
app/
├── Services/
│   └── Sippt/
│       ├── SipptApiClient.php          # HTTP client wrapper
│       ├── SipptAuthService.php        # Login & token management
│       ├── SipptSyncService.php        # Orchestrator sinkronisasi
│       └── Mappers/
│           ├── SipptFieldMapper.php    # Base mapper (shared fields)
│           ├── PengujianMapper.php     # Modul-specific mapper
│           ├── KalibrasiMapper.php
│           └── ...
├── Models/
│   └── Db2/
│       ├── SipptSyncLog.php            # Log sinkronisasi
│       ├── SipptRefNegara.php          # Cache master negara
│       ├── SipptRefProvinsi.php        # Cache master provinsi
│       └── SipptRefKabupaten.php       # Cache master kabupaten
├── Jobs/
│   └── SyncPermohonanToSipptJob.php    # Queue job untuk async sync
└── Console/
    └── Commands/
        ├── SipptSyncMasterDataCommand.php  # Refresh master data
        └── SipptRetrySyncCommand.php       # Retry failed syncs
```

---

## 10. Pertimbangan Teknis

### 10.1 Keamanan

- **Token Storage:** Bearer token disimpan encrypted di database atau cache (Redis/file) dengan TTL
- **Credential Management:** Username/password SIPPT disimpan di `.env` file, TIDAK di source code
- **HTTPS Enforcement:** Production wajib menggunakan HTTPS (`sippt-bskji.kemenperin.go.id`)

### 10.2 Resiliensi

- **Retry Logic:** Implementasi exponential backoff untuk network failure (max 3 retries)
- **Circuit Breaker:** Jika API SIPPT down berturut-turut, pause sync dan alert admin
- **Idempotency:** Track `no_order` yang sudah dikirim untuk mencegah duplikasi
- **Fallback Queue:** Jika sync gagal, masukkan ke antrian retry

### 10.3 Monitoring & Logging

- **Sync Log Table:** Setiap sinkronisasi dicatat di `sippt_sync_logs` (status, response, retry count)
- **Dashboard Admin:** Panel monitoring status sinkronisasi per permohonan
- **Alert:** Notifikasi admin jika ada sync failure yang melebihi threshold

### 10.4 Format Tanggal

> ⚠️ **PENTING:** API SIPPT menggunakan format tanggal `dd-mm-yyyy` (contoh: `12-10-2021`), BUKAN format ISO 8601. Semua tanggal harus di-format sebelum dikirim.

### 10.5 Batch vs Single Insert

API mendukung array request body, memungkinkan batch insert. Strategi:
- **Real-time:** Single insert per permohonan saat status berubah ke DONE
- **Batch:** Scheduled job untuk sync bulk data historis atau retry

---

## 11. Referensi Silang

| Dokumen | Path |
|---------|------|
| Arsitektur Polimer | [`system_overview.md`](system_overview.md) |
| Arsitektur Pengajuan Aset & Jasa Lainnya | [`arsitektur_pengajuan_aset_dan_jasa_lainnya.md`](arsitektur_pengajuan_aset_dan_jasa_lainnya.md) |
| Audit Alur Permohonan | [`../07-audit/laporan_audit_alur_permohonan_11_layanan_dan_keamanan.md`](../07-audit/laporan_audit_alur_permohonan_11_layanan_dan_keamanan.md) |
| Dokumentasi API Sumber (Markdown) | `F:\!Productive\BBKKP\dokumentasi_api_sipp_bskji.md` |
