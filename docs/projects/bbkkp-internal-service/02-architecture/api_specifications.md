# API Specifications - BBKKP Internal Service
## Dokumentasi Endpoint REST API & OpenAPI 3.0 Reference

> **Base URL**: `http://localhost:10020` (Local/Dev) / `https://internal.bbkkp.kemenperin.go.id` (Prod)  
> **API Version**: 1.0.8  
> **Autentikasi**: Header `X-API-KEY` pada setiap request

---

## 1. Skema Autentikasi

Setiap pemanggilan API wajib menyertakan header kunci layanan:

| Header Name | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `X-API-KEY` | `string` | Kunci API unik yang terdaftar pada tabel `layanan` | `sec_polimer_bbkkp_2026_x871` |

Jika header tidak disertakan atau tidak valid, sistem mengembalikan error HTTP:
```json
{
  "code": "UNAUTHORIZED",
  "message": "API Key is missing"
}
```

---

## 2. Ringkasan Endpoint

| HTTP Method | Endpoint | Fungsi | Input Utama |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/esign/nik/{nik}` | Mengecek status sertifikat digital pejabat/aparatur di BSrE | Parameter path `nik` |
| `POST` | `/api/esign/sign` | Membubuhkan tanda tangan elektronik (invisible) pada file PDF | Form-Data: `file`, `nik`, `passphrase`, `ref_code` |
| `GET` | `/api/esign/verify/id` | Memverifikasi TTE berdasarkan ID / Reference Code | Query param `id` |
| `POST` | `/api/esign/verify/doc` | Memverifikasi keaslian dokumen PDF berdasarkan checksum file | Form-Data: `signed_file` |

---

## 3. Rincian Endpoint

### 3.1. Pengecekan Status NIK BSrE
Memeriksa apakah pemilik NIK memiliki sertifikat aktif yang siap digunakan untuk penandatanganan di server BSrE.

* **Endpoint**: `GET /api/esign/nik/{nik}`
* **Headers**: `X-API-KEY: {API_KEY}`

#### Path Parameters
| Parameter | Tipe | Wajib | Keterangan |
| :--- | :--- | :--- | :--- |
| `nik` | `string` | Ya | Nomor Induk Kependudukan (16 digit) |

#### Contoh Request (cURL)
```bash
curl -X GET "http://localhost:10020/api/esign/nik/3304091234567890" \
     -H "X-API-KEY: sec_polimer_bbkkp_2026_x871"
```

#### Contoh Response Sukses (`200 OK`)
```json
{
  "message": "User dengan nik 3304091234567890 Terdaftar",
  "results": true
}
```

#### Contoh Response Gagal (`500 / 400`)
```json
{
  "code": "INTERNAL_SERVER_ERROR",
  "message": "User dengan nik 3304091234567890 Belum terdaftar pada server TTE",
  "results": []
}
```

---

### 3.2. Pembubuhan Tanda Tangan Elektronik Dokumen (Sign Document)
Mengunggah file PDF dan membubuhkan sertifikat digital BSrE secara *invisible*.

* **Endpoint**: `POST /api/esign/sign`
* **Content-Type**: `multipart/form-data`
* **Headers**: `X-API-KEY: {API_KEY}`

#### Body Parameters (Form-Data)
| Field | Tipe | Wajib | Keterangan |
| :--- | :--- | :--- | :--- |
| `file` | `file (binary)` | Ya | Berkas PDF yang akan ditandatangani (`mimes:pdf`) |
| `nik` | `string` | Ya | NIK pejabat/penandatangan |
| `passphrase` | `string` | Ya | Kata sandi sertifikat digital penandatangan |
| `ref_code` | `string` | Ya | Nomor referensi unik dokumen pada sistem klien |
| `ref_metadata` | `string` | Tidak | Metadata tambahan dalam format JSON yang di-encode Base64 |
| `file_name` | `string` | Tidak | Nama kustom berkas dokumen (default: nama asli file) |

#### Contoh Request (cURL)
```bash
curl -X POST "http://localhost:10020/api/esign/sign" \
     -H "X-API-KEY: sec_polimer_bbkkp_2026_x871" \
     -F "file=@/path/to/invoice-001.pdf" \
     -F "nik=3304091234567890" \
     -F "passphrase=rahasiaPassphrase123" \
     -F "ref_code=INV-2026-08-0098" \
     -F "ref_metadata=eyJKZW5pcyBMYXlhbmFuIjoiU2VydGlmaWthc2kgU05JIn0=" \
     -F "file_name=Invoice-Resmi-INV0098.pdf"
```

#### Contoh Response Sukses (`200 OK`)
```json
{
  "message": "Tanda tangan berhasil",
  "results": {
    "id": "9c96caee-6b7e-491c-bbab-30c3da0442a9",
    "layanan": "POLIMER",
    "ref_code": "INV-2026-08-0098",
    "ref_metadata": "{\"Jenis Layanan\":\"Sertifikasi SNI\"}",
    "file_name": "Invoice-Resmi-INV0098.pdf",
    "file_link": "https://storage.bbkkp.kemenperin.go.id/dev-esign/esign/1d77d74c22914956a19342a56d0e48aa.pdf?X-Amz-Expires=86400&X-Amz-Signature=..."
  }
}
```

---

### 3.3. Verifikasi TTE Berdasarkan ID / Reference Code
Memeriksa status dan detail keabsahan tanda tangan dokumen menggunakan pengenal unik.

* **Endpoint**: `GET /api/esign/verify/id`
* **Headers**: `X-API-KEY: {API_KEY}`

#### Query Parameters
| Parameter | Tipe | Wajib | Keterangan |
| :--- | :--- | :--- | :--- |
| `id` | `string` | Ya | Nilai `ref_code`, `esign_doc_id`, atau UUID `id` rekaman |

#### Contoh Request (cURL)
```bash
curl -X GET "http://localhost:10020/api/esign/verify/id?id=INV-2026-08-0098" \
     -H "X-API-KEY: sec_polimer_bbkkp_2026_x871"
```

#### Contoh Response Sukses (`200 OK`)
```json
{
  "message": "Data TTE ditemukan",
  "results": {
    "id": "9c96caee-6b7e-491c-bbab-30c3da0442a9",
    "layanan": "POLIMER",
    "ref_code": "INV-2026-08-0098",
    "ref_metadata": "{\"Jenis Layanan\":\"Sertifikasi SNI\"}",
    "file_name": "Invoice-Resmi-INV0098.pdf",
    "file_link": "https://storage.bbkkp.kemenperin.go.id/dev-esign/esign/1d77d74c.pdf?...",
    "date_signed": "2026-08-19T04:20:00.000000Z",
    "esign_details": {
      "nama_dokumen": "Invoice-Resmi-INV0098.pdf",
      "jumlah_signature": 1,
      "summary": "VALID",
      "notes": "Dokumen valid, Sertifikat yang digunakan terpercaya",
      "details": [
        {
          "signature_field": "sig_1721714634534",
          "info_tsa": {
            "name": "Timestamp Authority Badan Siber dan Sandi Negara",
            "tsa_cert_validity": null
          },
          "info_signer": {
            "issuer_dn": "C=ID,O=Lembaga Sandi Negara,CN=OSD LU Kelas 2",
            "signer_name": "Dr. Ir. Pejabat Penandatangan, M.T.",
            "signer_cert_validity": "2024-01-01 to 2026-12-31",
            "signer_dn": "C=ID,OU=BBSPJIKKP,CN=Dr. Ir. Pejabat Penandatangan",
            "cert_user_certified": true
          },
          "signature_document": {
            "signed_using_tsa": true,
            "document_integrity": true,
            "signed_in": "2026-08-19 11:20:00.603"
          }
        }
      ]
    }
  }
}
```

---

### 3.4. Verifikasi TTE Berdasarkan Berkas Fisik (Verify by Document)
Memverifikasi dokumen PDF hasil unduhan pihak eksternal untuk membuktikan integritas fisik dokumen.

* **Endpoint**: `POST /api/esign/verify/doc`
* **Content-Type**: `multipart/form-data`
* **Headers**: `X-API-KEY: {API_KEY}`

#### Body Parameters (Form-Data)
| Field | Tipe | Wajib | Keterangan |
| :--- | :--- | :--- | :--- |
| `signed_file` | `file (binary)` | Ya | Berkas PDF yang akan diverifikasi integritasnya |

#### Contoh Request (cURL)
```bash
curl -X POST "http://localhost:10020/api/esign/verify/doc" \
     -H "X-API-KEY: sec_polimer_bbkkp_2026_x871" \
     -F "signed_file=@/path/to/downloaded-sertifikat.pdf"
```

#### Contoh Response Sukses (`200 OK`)
```json
{
  "message": "Dokumen valid",
  "results": {
    "id": "9c96caee-6b7e-491c-bbab-30c3da0442a9",
    "layanan": "POLIMER",
    "ref_code": "CERT-SNI-2026-0012",
    "file_name": "Sertifikat-SNI-Resmi.pdf",
    "file_link": "https://storage.bbkkp.kemenperin.go.id/dev-esign/esign/1d77d74c.pdf?...",
    "date_signed": "2026-08-19T04:20:00.000000Z",
    "esign_details": {
      "summary": "VALID",
      "notes": "Dokumen valid, Sertifikat yang digunakan terpercaya"
    }
  }
}
```

#### Contoh Response Dokumen Tidak Valid / Telah Dimodifikasi (`404 Not Found`)
```json
{
  "code": "NOT_FOUND",
  "message": "Data TTE tidak ditemukan",
  "results": []
}
```
