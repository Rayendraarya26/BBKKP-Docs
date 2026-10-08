---
title: "Index — Map of Content (Multi-Project SSOT)"
summary: "Peta navigasi utama seluruh dokumentasi sistem BBKKP terpusat. Single Source of Truth untuk semua proyek."
created: "2026-08-17"
updated: "2026-10-08"
tags:
  - moc
  - index
  - bbkkp
  - ssot
aliases:
  - "MOC"
  - "Peta Dokumen Multi Project"
---

# 🗺️ Index — Map of Content (Single Source of Truth BBKKP)

Peta navigasi utama seluruh dokumentasi ekosistem aplikasi BBKKP. Gunakan halaman ini untuk mengakses dokumen berdasarkan **Global Standards** atau **Project Specific**.

---

## 🌐 00 — Global Standards & Architecture (Lintas Project)

Dokumen standar teknis, aturan pengkodean, keamanan database/RBAC, dan SOP alur Git yang berlaku untuk **semua repositori**.

| Dokumen | Path | Deskripsi |
|---|---|---|
| Global Changelog (4 Hari Terakhir) | [changelog_global_4_hari_terakhir.md](docs/00-global/changelog_global_4_hari_terakhir.md) | Log agregasi menyeluruh ekosistem BBKKP (18 - 21 Agustus 2026) |
| Ecosystem Architecture Overview | [ecosystem_overview.md](docs/00-global/architecture/ecosystem_overview.md) | Gambaran umum arsitektur ekosistem BBKKP (Polimer, SIS, Redis, BNI VA, BSrE TTE) |
| Rules & Development Guidelines | [coding_guidelines.md](docs/00-global/standards/coding_guidelines.md) | Standar keamanan, RBAC, pencegahan IDOR, transaksi DB, dan zero-disruption |
| Security Guidelines | [security_guidelines.md](docs/00-global/standards/security_guidelines.md) | Standar keamanan API, validasi webhook signature, sanitasi input, & secret management |
| SOP Git Dual-Remote Workflow | [git_dual_remote_workflow.md](docs/00-global/standards/git_dual_remote_workflow.md) | Panduan lengkap alur kerja Git Dual-Remote (`origin` vs `upstream`) |
| Index Global | [_index.md](docs/00-global/_index.md) | Halaman utama standar global |

---

## 🚀 Projects Directory

### 🟢 1. Project: BBKKP Polimer (`bbkkp-polimer`)
*Repositori: `Rayendraarya26/private-polimer` / `bakulkapas/bbkkp-polimer`*

| Dokumen | Path | Deskripsi |
|---|---|---|
| Changelog Polimer | [changelog_polimer.md](docs/projects/bbkkp-polimer/changelog_polimer.md) | Log kronologis seluruh commit & fitur Polimer (18 Agustus - 08 Oktober 2026) |
| FRD Form Pengujian Laboratorium | [frd_form_pengujian_laboratorium.md](docs/projects/bbkkp-polimer/01-product/frd_form_pengujian_laboratorium.md) | Spesifikasi fungsional form pengujian mandiri sisi klien (4-step wizard) |
| System Overview Polimer | [system_overview.md](docs/projects/bbkkp-polimer/02-architecture/system_overview.md) | Arsitektur & modul aplikasi BBKKP Polimer |
| Multi-Sertifikasi Architecture | [multi_sertifikasi_architecture.md](docs/projects/bbkkp-polimer/02-architecture/multi_sertifikasi_architecture.md) | Arsitektur pengajuan multi-sertifikasi & 4-step wizard |
| Form Pengujian Architecture | [form_pengujian_laboratorium.md](docs/projects/bbkkp-polimer/02-architecture/form_pengujian_laboratorium.md) | Arsitektur pengajuan pengujian lab mandiri, multi-sample & BNI VA |
| Form Uji Profisiensi (PUP) Architecture | [pup_profisiensi_form_architecture.md](docs/projects/bbkkp-polimer/02-architecture/pup_profisiensi_form_architecture.md) | Arsitektur form pengajuan Uji Profisiensi (PUP) 4-step wizard & 28 katalog skema |
| Admin Helpdesk System | [admin_helpdesk_system.md](docs/projects/bbkkp-polimer/02-architecture/admin_helpdesk_system.md) | Sistem manajemen tiket helpdesk admin & notifikasi badge |
| BNI VA Payment Flow | [bni_va_payment_flow.md](docs/projects/bbkkp-polimer/02-architecture/bni_va_payment_flow.md) | Arsitektur pembayaran BNI e-Collection VA, webhook & queue |
| TTE Internal Service Integration | [tte_internal_service_integration.md](docs/projects/bbkkp-polimer/02-architecture/tte_internal_service_integration.md) | Integrasi TTE BSrE decoupled via mikroservis internal |
| Developer Guide Unified SPA | [developer_guide.md](docs/projects/bbkkp-polimer/02-architecture/developer_guide.md) | Panduan pengembang & standar arsitektur Unified React SPA |
| Analisis & Roadmap Polimer | [analisis_roadmap.md](docs/projects/bbkkp-polimer/02-architecture/analisis_roadmap.md) | Analisis kode eksisting Polimer & strategi refactoring |
| Setup & Onboarding Guide | [setup_guide.md](docs/projects/bbkkp-polimer/05-operations/setup_guide.md) | Panduan instalasi lokal (PHP, Composer, Node, Artisan, Redis) |
| Test Accounts & Login Info | [test_accounts.md](docs/projects/bbkkp-polimer/05-operations/test_accounts.md) | Daftar akun seeder (`UserSeeder`, `MarketingUserSeeder`, `DummyPolimerSeeder`) |
| Environment Reference | [environment.md](docs/projects/bbkkp-polimer/05-operations/environment.md) | Penjelasan rinci seluruh variabel `.env` Polimer |
| User Manual Portal Pelanggan | [user_manual_customer.md](docs/projects/bbkkp-polimer/05-operations/user_manual_customer.md) | Panduan lengkap penggunaan portal pelanggan publik |
| User Manual Portal Admin | [user_manual_admin.md](docs/projects/bbkkp-polimer/05-operations/user_manual_admin.md) | Panduan operasional verifikator, marketing & admin balai |
| Cutover & Deployment SOP | [cutover_and_deployment_sop.md](docs/projects/bbkkp-polimer/05-operations/cutover_and_deployment_sop.md) | SOP Zero-Downtime deployment & cutover production |
| Modernization Milestone Plan | [milestone.md](docs/projects/bbkkp-polimer/06-tasks/milestone.md) | Roadmap milestone & 5-sprint plan modernisasi Polimer |
| Sprint 1 Breakdown | [sprint_1_breakdown.md](docs/projects/bbkkp-polimer/06-tasks/sprint_1_breakdown.md) | Rincian tugas Sprint 1: Design System, Tailwind & UI Kit |
| Sprint 2 Breakdown | [sprint_2_breakdown.md](docs/projects/bbkkp-polimer/06-tasks/sprint_2_breakdown.md) | Rincian tugas Sprint 2: Modernisasi Total Portal Pelanggan |
| Sprint 3 Breakdown | [sprint_3_breakdown.md](docs/projects/bbkkp-polimer/06-tasks/sprint_3_breakdown.md) | Rincian tugas Sprint 3: TanStack Query v5, Zod & Standardisasi API |
| Sprint 4 Breakdown | [sprint_4_breakdown.md](docs/projects/bbkkp-polimer/06-tasks/sprint_4_breakdown.md) | Rincian tugas Sprint 4: Payment Gateway & TTE |
| Sprint 5 Breakdown | [sprint_5_breakdown.md](docs/projects/bbkkp-polimer/06-tasks/sprint_5_breakdown.md) | Rincian tugas Sprint 5: Dynamic RBAC Matrix, Testing, Optimasi & Cutover |
| Audit Sprint 1 s.d. 3 | [audit_sprint_1_to_3.md](docs/projects/bbkkp-polimer/06-tasks/audit_sprint_1_to_3.md) | Laporan audit teknis sprint 1 sampai dengan 3 |
| Audit Sprint 1 s.d. 5 Final | [audit_sprint_1_to_5.md](docs/projects/bbkkp-polimer/06-tasks/audit_sprint_1_to_5.md) | Laporan deep audit komprehensif seluruh milestone (Sprint 1 - 5) |
| Analisis Perbandingan Branch polimer_sis | [analisis_perbandingan_branch_polimer_sis.md](docs/projects/bbkkp-polimer/06-tasks/analisis_perbandingan_branch_polimer_sis.md) | Analisis perbedaan branch & acuan merging `polimer_sis` |
| Analisis Perbedaan v2.1 vs polimer_sis | [analisis_perbedaan_v2.1_internal_migration_vs_polimer_sis.md](docs/projects/bbkkp-polimer/06-tasks/analisis_perbedaan_v2.1_internal_migration_vs_polimer_sis.md) | Analisis variasi branch v2.1 internal migration vs `polimer_sis` |
| Dokumentasi Perubahan Permanaff | [dokumentasi_perubahan_permanaff_polimer_sis.md](docs/projects/bbkkp-polimer/06-tasks/dokumentasi_perubahan_permanaff_polimer_sis.md) | Dokumentasi detail commit & perubahan kontributor permanaff |
| Rekonsiliasi Merging Branch polimer_sis | [laporan_rekonsiliasi_merging_branch_polimer_sis.md](docs/projects/bbkkp-polimer/06-tasks/laporan_rekonsiliasi_merging_branch_polimer_sis.md) | Laporan mitigasi risiko & panduan penggabungan branch |
| Laporan Audit Alur 11 Layanan & Keamanan | [laporan_audit_alur_permohonan_11_layanan_dan_keamanan.md](docs/projects/bbkkp-polimer/07-audit/laporan_audit_alur_permohonan_11_layanan_dan_keamanan.md) | **Laporan Audit Komprehensif Alur 11 Layanan, Keamanan RBAC & Verifikasi Patch (08 Okt 2026)** |
| Rencana & Framework Audit Alur Polimer | [rencana_audit_alur_permohonan_dan_keamanan.md](docs/projects/bbkkp-polimer/07-audit/rencana_audit_alur_permohonan_dan_keamanan.md) | Framework & tahapan pelaksanaan audit alur layanan Polimer |
| Deep Audit Modernisasi Polimer | [deep_audit_modernisasi_polimer.md](docs/projects/bbkkp-polimer/07-audit/deep_audit_modernisasi_polimer.md) | Laporan deep audit teknis arsitektur modernisasi frontend & backend |
| Comprehensive 3-Day Audit | [comprehensive_3day_audit_report.md](docs/projects/bbkkp-polimer/07-audit/comprehensive_3day_audit_report.md) | Laporan audit teknis 3 hari pertama |
| Index Project Polimer | [_index.md](docs/projects/bbkkp-polimer/_index.md) | Halaman utama dokumentasi Polimer |

---

### 🔵 2. Project: BBKKP SIS (`bbkkp-sis`)
*Repositori: `Rayendraarya26/private-sis` / `bakulkapas/bbkkp-sis`*

| Dokumen | Path | Deskripsi |
|---|---|---|
| Changelog SIS | [changelog_sis.md](docs/projects/bbkkp-sis/changelog_sis.md) | Log perubahan repositori SIS (18 - 21 Agustus 2026) |
| Flow & Modul SIS | [flow_modul_sis.md](docs/projects/bbkkp-sis/02-architecture/flow_modul_sis.md) | Alur bisnis & struktur modul aplikasi SIS legacy |
| Setup & Onboarding Guide | [setup_guide.md](docs/projects/bbkkp-sis/05-operations/setup_guide.md) | Panduan instalasi & import database legacy SIS |
| Environment Reference | [environment.md](docs/projects/bbkkp-sis/05-operations/environment.md) | Penjelasan variabel `.env` & koneksi DB legacy SIS |
| Index Project SIS | [_index.md](docs/projects/bbkkp-sis/_index.md) | Halaman utama dokumentasi SIS |

---

### 🟣 3. Project: Integrasi SIS & Polimer (`integrasi-sis-polimer`)
*Proyek Cross-System Integrasi Data & Sertifikasi*

| Dokumen | Path | Deskripsi |
|---|---|---|
| Changelog Integrasi | [changelog_integrasi.md](docs/projects/integrasi-sis-polimer/changelog_integrasi.md) | Log aktivitas integrasi & bridging (termasuk update 01 September 2026) |
| Setup Lokal v2.1 (Docker) | [setup_local_v2.1.md](docs/projects/integrasi-sis-polimer/setup_local_v2.1.md) | Panduan setup lokal ekosistem terintegrasi Polimer & SIS v2.1 (Docker) |
| Setup Lokal v2.1 (Non-Docker) | [setup_local_v2.1_nondocker.md](docs/projects/integrasi-sis-polimer/setup_local_v2.1_nondocker.md) | Panduan setup lokal non-docker native PHP & MySQL |
| Panduan Alur Marketing & Invoicing | [panduan_alur_marketing_invoicing_tte_sis.md](docs/projects/integrasi-sis-polimer/01-product/panduan_alur_marketing_invoicing_tte_sis.md) | Panduan lengkap pengguna & pengembang: Verifikasi Marketing, TTE on-demand & SIS |
| FRD Integrasi SIS & Polimer | [frd_integrasi.md](docs/projects/integrasi-sis-polimer/01-product/frd_integrasi.md) | Spesifikasi fungsional integrasi data Polimer & SIS |
| Arsitektur Invoicing & TTE Bridging | [alur_invoicing_kuitansi_tte_bridging.md](docs/projects/integrasi-sis-polimer/02-architecture/alur_invoicing_kuitansi_tte_bridging.md) | Desain teknis alur invoicing otomatis, TTE on-demand BSrE, dan data bridging SIS |
| DB Schema & Migration Spec | [db_schema_migration.md](docs/projects/integrasi-sis-polimer/02-architecture/db_schema_migration.md) | Pemetaan skema DB SIS ke Polimer & spec artisan command idempoten |
| Target Milestone Integrasi | [milestone.md](docs/projects/integrasi-sis-polimer/06-tasks/milestone.md) | Timeline & target milestone sprint integrasi |
| Sprint 1 Breakdown | [sprint_1_breakdown.md](docs/projects/integrasi-sis-polimer/06-tasks/sprint_1_breakdown.md) | Rincian tugas Sprint 1: Integrasi Akun & Sertifikat SIS |
| Sprint 2 Breakdown | [sprint_2_breakdown.md](docs/projects/integrasi-sis-polimer/06-tasks/sprint_2_breakdown.md) | Rincian tugas Sprint 2 |
| Sprint 3 Breakdown | [sprint_3_breakdown.md](docs/projects/integrasi-sis-polimer/06-tasks/sprint_3_breakdown.md) | Rincian tugas Sprint 3 |
| Sprint 4 Breakdown | [sprint_4_breakdown.md](docs/projects/integrasi-sis-polimer/06-tasks/sprint_4_breakdown.md) | Rincian tugas Sprint 4 |
| Laporan Verifikasi Integrasi Lokal | [laporan_verifikasi_dan_pengujian_integrasi_lokal.md](docs/projects/integrasi-sis-polimer/06-tasks/laporan_verifikasi_dan_pengujian_integrasi_lokal.md) | Laporan verifikasi dan pengujian integrasi lokal Polimer & SIS |
| Deep Audit Integrasi SIS-Polimer | [deep_audit_integrasi_sis_polimer.md](docs/projects/integrasi-sis-polimer/07-audit/deep_audit_integrasi_sis_polimer.md) | Laporan audit teknis integrasi SIS & Polimer |
| Index Project Integrasi | [_index.md](docs/projects/integrasi-sis-polimer/_index.md) | Halaman utama dokumentasi Integrasi |

---

### 🟡 4. Project: BBKKP Internal Service (`bbkkp-internal-service`)
*Repositori: `bakulkapas/bbkkp-internal-service`*

| Dokumen | Path | Deskripsi |
|---|---|---|
| Changelog Internal Service | [changelog_internal_service.md](docs/projects/bbkkp-internal-service/changelog_internal_service.md) | Log operasional mikroservis TTE BSrE (18 - 21 Agustus 2026) |
| FRD Internal Service | [frd_internal_service.md](docs/projects/bbkkp-internal-service/01-product/frd_internal_service.md) | Spesifikasi fungsional shared microservices BBKKP |
| System Architecture & Specs | [system_architecture.md](docs/projects/bbkkp-internal-service/02-architecture/system_architecture.md) | Arsitektur container FrankenPHP Octane & DB |
| API Specifications | [api_specifications.md](docs/projects/bbkkp-internal-service/02-architecture/api_specifications.md) | Spesifikasi endpoint TTE BSrE, Verifikasi Dokumen & Hash MD5 |
| Deployment & Operations | [deployment_and_setup.md](docs/projects/bbkkp-internal-service/05-operations/deployment_and_setup.md) | Panduan setup Docker & FrankenPHP Octane |
| Index Project Internal Service | [_index.md](docs/projects/bbkkp-internal-service/_index.md) | Halaman utama dokumentasi Internal Service |
