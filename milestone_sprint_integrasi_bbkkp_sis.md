# Breakdown Milestone & Sprint Plan
## Integrasi BBKKP-SIS ke Dalam BBKKP Polimer

> **Dokumen Perencanaan Proyek, Milestone, dan Sprint Plan Terintegrasi**  
> **Balai Besar Kulit, Karet, dan Plastik (BBKKP) - Kementerian Perindustrian RI**  
> **Estimasi Total Durasi**: 8 Minggu (4 Milestone / 4 Sprint @ 2 Minggu)  
> **Versi**: 2.0 (Updated & Enhanced)  
> **Tanggal Dokumen**: 14 Agustus 2026

---

## 1. Ringkasan Eksekutif & Linimasa Proyek

Proyek integrasi **`bbkkp-sis`** ke **BBKKP Polimer** dirancang untuk mentransformasi sistem sertifikasi dari yang sebelumnya terpisah menjadi terintegrasi penuh (*Single System*). Proyek ini dibagi menjadi **4 Milestone Utama** dengan total **4 Sprint** (durasi masing-masing sprint 2 minggu).

```mermaid
gantt
    title Linimasa Milestone & Sprint Integrasi BBKKP-SIS
    dateFormat  YYYY-MM-DD
    section Milestone 1: DB & Migration
    Sprint 1: Schema Alignment, Master Data & Migration Engine :active, s1, 2026-08-17, 14d
    section Milestone 2: Application & Marketing
    Sprint 2: Multi-Item Wizard, Factory Info & Marketing Inbox : s2, after s1, 14d
    section Milestone 3: Repo Services (TTE & VA)
    Sprint 3: Invoice TTE, BNI VA, Kwitansi TTE & Notifications : s3, after s2, 14d
    section Milestone 4: Audit, LKS, Committee & Cutover
    Sprint 4: 2-Stage Audit, LKS, Committee, Cert TTE & Cutover : s4, after s3, 14d
```

---

## 2. Rincian Milestone & Breakdown Sprint

---

### 📍 Milestone 1: Database Alignment, Master Data & Data Migration Engine
* **Target Fokus**: Menyelaraskan struktur database `bbkkp_polimer` (`Db2`) untuk menampung entitas sertifikasi multi-item, profil pabrik, riwayat audit, dan data sertifikat aktif dari `bbkkp_sis`, serta membangun engine migrasi ETL.
* **Alokasi Waktu**: **Sprint 1 (Minggu 1 - 2)**

#### 🎯 Sprint 1 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS1-01** | Database | Migrasi Skema DB: Pembuatan tabel `form_sertifikasi`, `form_sertifikasi_item`, `form_sertifikasi_pabrik`, dan penyesuaian tabel `permohonan` / `detail_permohonan`. | 5 | Migration files di `database/migrations` |
| **TS1-02** | Master Data | Import & Sinkronisasi Master Data Sertifikasi (Komoditi, Standar SNI/ISO, Kode EA/NACE, dan Tarif PNBP) dari `bbkkp_sis`. | 3 | Database Seeder (`SertifikasiMasterSeeder.php`) |
| **TS1-03** | Data Engine | Upgrade Command `integration:sync-user-sis` agar mampu melakukan *two-way mapping* identitas pelanggan & profil instansi tanpa duplikasi. | 5 | Console Command di `Modules/Integration` |
| **TS1-04** | Data Engine | Pembuatan ETL Migration Command `integration:migrate-sis-history` untuk memigrasi sertifikat aktif, data pabrik, dan riwayat permohonan lama dari `bbkkp_sis`. | 8 | Command Migration Historis di `Modules/Integration` |
| **TS1-05** | Backend | Penyiapan Eloquent Models (`FormSertifikasi`, `FormSertifikasiItem`, `FormSertifikasiPabrik`, `PelangganSertifikasi`) dengan relasi polymorphic dan validasi. | 5 | Models di `App\Models\Db2` |

* **Definition of Done (DoD) Sprint 1**:
  - Script migrasi berjalan tanpa error dan 100% data historis sertifikat aktif `bbkkp_sis` berhasil terimport ke DB `bbkkp_polimer`.
  - Skema database Polimer siap menampung permohonan multi-item sertifikasi dan profil pabrik.

---

### 📍 Milestone 2: Multi-Item Application Wizard, Factory Info & Marketing Inbox
* **Target Fokus**: Antarmuka pengajuan sertifikasi multi-item dan profil pabrik di React SPA (`/app`), serta inbox verifikasi dan penyesuaian tarif untuk Tim Marketing.
* **Alokasi Waktu**: **Sprint 2 (Minggu 3 - 4)**

#### 🎯 Sprint 2 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS2-01** | Frontend React | Pembuatan Form Wizard React SPA (`/app/sertifikasi`) untuk Pengajuan Sertifikasi Baru, Perpanjang, Perubahan Scope, & Surveilans. | 8 | Komponen React di `Modules/Eksternal/resources/assets` |
| **TS2-02** | Frontend React | Fitur Multi-Item Cart & Dynamic Factory Selector (Pelanggan dapat memilih/menambahkan data lokasi pabrik produksi). | 5 | Multi-item state & validator di React SPA |
| **TS2-03** | API Eksternal | Endpoint REST API `POST /api/eksternal/sertifikasi` untuk validasi & penyimpanan payload multi-item permohonan sertifikasi. | 5 | `SertifikasiController.php` di Modul `Eksternal` |
| **TS2-04** | Backend Admin | Pembuatan Dashboard Inbox Tim Marketing di Modul `Permohonan` (`/permohonan/marketing`) dengan filter status & detail permohonan. | 8 | Controller & Blade View di `Modules/Permohonan` |
| **TS2-05** | Backend Admin | Fitur Penyesuaian Rincian Tarif PNBP, Catatan Verifikasi, serta Aksi *Approve*, *Revisi*, dan *Reject* oleh Marketing. | 5 | Action handler di `PermohonanController.php` |

* **Definition of Done (DoD) Sprint 2**:
  - Pelanggan berhasil submit permohonan sertifikasi multi-item + profil pabrik dari React SPA.
  - Tim Marketing melihat permohonan di Inbox, bisa mengubah tarif, memberikan catatan revisi, atau melakukan *Approve*.

---

### 📍 Milestone 3: Repo Services Integration (TTE Invoice, BNI VA, & Kwitansi)
* **Target Fokus**: Otomatisasi penerbitan Invoice TTE, Virtual Account Bank BNI, handling webhook pembayaran secara idempoten, dan penerbitan Kwitansi TTE melalui **Repo Services**.
* **Alokasi Waktu**: **Sprint 3 (Minggu 5 - 6)**

#### 🎯 Sprint 3 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS3-01** | Service Client | Pembuatan Service Layer `App\Services\RepoServicesClient.php` sebagai REST API Client ke **Repo Services Container** (TTE, BNI VA, WA). | 5 | Service Client Class di `app/Services` |
| **TS3-02** | Async Queue | Pembuatan Background Job (`ProcessMarketingApprovalJob`) untuk memicu generasi Invoice TTE & BNI VA tanpa membebani respons UI. | 8 | Job Class di `app/Jobs` |
| **TS3-03** | Integration | Endpoint Callback Webhook BNI VA (`POST /api/integration/bni-callback`) dengan verifikasi signature & idempotency check. | 5 | Controller Webhook di `Modules/Integration` |
| **TS3-04** | Async Queue | Pembuatan Background Job (`GenerateKwitansiTteJob`) untuk mengenerate Kwitansi PDF ber-TTE setelah konfirmasi pelunasan. | 5 | Job Class di `app/Jobs` |
| **TS3-05** | Notification | Integrasi Notifikasi WhatsApp Gateway (via Repo Services) untuk pengiriman nomor BNI VA, tautan PDF Invoice, & PDF Kwitansi ke Pelanggan. | 3 | Notification Handler di Polimer |

* **Definition of Done (DoD) Sprint 3**:
  - Saat Marketing mengeklik *Approve*, Invoice TTE & Nomor VA BNI terbit secara otomatis dalam hitungan detik.
  - Simulasi callback BNI VA sukses mengubah status permohonan menjadi `LUNAS` dan otomatis menerbitkan Kwitansi TTE.

---

### 📍 Milestone 4: 2-Stage Audit, LKS Management, Committee, Certificate TTE & Cutover
* **Target Fokus**: Workflow teknis sertifikasi internal (Penjadwalan Auditor, Audit Tahap 1 Dokumen, Audit Tahap 2 Pabrik, Penanganan LKS Tindakan Koreksi, Rapat Komite), penerbitan Sertifikat ber-TTE, monitoring surveilans, UAT, dan penghentian redirect legacy `bbkkp-sis`.
* **Alokasi Waktu**: **Sprint 4 (Minggu 7 - 8)**

#### 🎯 Sprint 4 Summary Tasks:
| ID Task | Kategori | Deskripsi Pekerjaan / User Story | Estimasi (Point) | Deliverables |
| :-: | :--- | :--- | :-: | :--- |
| **TS4-01** | Backend & UI | Modul Penjadwalan Audit, Penunjukan Lead Auditor/Tim, & Penerbitan Surat Tugas (ST) untuk permohonan yang berstatus `LUNAS`. | 5 | Sub-modul Jadwal di `Modules/Permohonan` |
| **TS4-02** | Backend & UI | Form Evaluasi Audit Tahap 1 (Kecukupan Dokumen) & Audit Tahap 2 (Kesesuaian Pabrik / PPC). | 8 | Form Evaluasi Teknis Internal |
| **TS4-03** | Interactive Flow | Modul Manajemen LKS (Laporan Ketidaksesuaian): Input temuan auditor, upload bukti perbaikan pelanggan, dan approval verifikasi auditor. | 8 | Fitur LKS di Portal & Admin |
| **TS4-04** | Backend & TTE | Sub-modul Rapat Komite Sertifikasi & Issuer Engine Penerbitan Sertifikat Ber-TTE Kepala Balai via Repo Services. | 8 | Komite Review & TTE Sertifikat Engine |
| **TS4-05** | Lifecycle & Scheduler | Manajemen Masa Berlaku Sertifikat & Scheduled Notification untuk Siklus Surveilans Tahunan (Tahun 1 & 2) serta Resertifikasi. | 3 | Scheduler Command & Dashboard Lifecycle |
| **TS4-06** | Router & Cutover | Penghapusan URL Redirect ke `bbkkp-sis`, Final UAT, Security Review, dan Production Cutover. | 5 | Route Refactoring & System Cutover |

* **Definition of Done (DoD) Sprint 4**:
  - Seluruh alur sertifikasi dari pendaftaran, audit 2 tahap, perbaikan LKS, rapat komite, hingga penerbitan sertifikat TTE berjalan 100% di Polimer.
  - Redirect ke aplikasi legacy `bbkkp-sis` resmi dihentikan (*Decommissioned*).

---

## 3. Matriks Manajemen Risiko & Mitigasi

| Potensi Risiko | Tingkat Dampak | Rencana Mitigasi |
| :--- | :-: | :--- |
| **Kegagalan / Timeout Service TTE (BSrE)** | Tinggi | Terapkan *Asynchronous Job Queue* dengan mekanisme *Auto-Retry* (3 kali) & fallback alert ke Sentry/Admin. |
| **Ketidaksesuaian Data Historis `bbkkp_sis`** | Sedang | Lakukan *Data Sanitization*, uji coba migrasi di lingkungan *staging*, dan verifikasi cross-table count. |
| **Kendala Callback BNI Virtual Account** | Tinggi | Sediakan fitur *Re-Check Payment Status* manual di dashboard Bendahara untuk melakukan inquiry status VA ke BNI via Repo Services. |
| **Keterlambatan Penyelesaian LKS Pelanggan** | Sedang | Sistem otomatis mengirimkan WhatsApp reminder H-7 dan H-3 sebelum *due date* masa perbaikan LKS. |
| **Penyesuaian User Internal (Marketing & Auditor)** | Sedang | Adakan sesi pelatihan/sosialisasi UI Polimer baru bagi Tim Marketing, Koordinator, & Auditor pada akhir Sprint 3. |

---

## 4. Kriteria Kelayakan Rilis (Release Gate Criteria)

Sebelum rilis penuh (*Production Cutover*), sistem harus memenuhi kriteria berikut:
1. **Zero Critical/Blocker Bugs** pada alur end-to-end (Form Submission -> Approval Marketing -> VA BNI -> Pembayaran -> Audit 2 Tahap -> LKS -> Komite -> Sertifikat TTE).
2. **100% Data Historis** sertifikat aktif dan profil pabrik dari `bbkkp_sis` terverifikasi di database Polimer.
3. **Response Time API** untuk submit permohonan dan dashboard < 2 detik.
4. **Sign-Off UAT** disetujui oleh Tim Marketing, Koordinator Sertifikasi, Lead Auditor, Bendahara, dan Tim IT BBKKP.
