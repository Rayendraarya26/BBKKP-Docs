# 🟢 Project: BBKKP Polimer (`bbkkp-polimer`)

Folder ini berisi seluruh dokumentasi spesifik untuk aplikasi **BBKKP Polimer**.

* **Repositori Utama (Upstream)**: `https://github.com/bakulkapas/bbkkp-polimer.git`
* **Repositori Private**: `https://github.com/Rayendraarya26/private-polimer.git`

## Dokumen Project:
* **Changelog & Log Perubahan**:
  * [`changelog_polimer.md`](changelog_polimer.md) — Log kronologis perubahan commit & fitur (18 - 21 Agustus 2026).
* **`02-architecture/`**:
  * [`system_overview.md`](02-architecture/system_overview.md) — Arsitektur & modul aplikasi Polimer.
  * [`multi_sertifikasi_architecture.md`](02-architecture/multi_sertifikasi_architecture.md) — Arsitektur pengajuan multi-sertifikasi & 4-step wizard.
  * [`admin_helpdesk_system.md`](02-architecture/admin_helpdesk_system.md) — Sistem manajemen tiket helpdesk admin & notifikasi.
  * [`bni_va_payment_flow.md`](02-architecture/bni_va_payment_flow.md) — Arsitektur pembayaran BNI e-Collection VA & webhook.
  * [`tte_internal_service_integration.md`](02-architecture/tte_internal_service_integration.md) — Integrasi TTE BSrE decoupled via internal service.
  * [`developer_guide.md`](02-architecture/developer_guide.md) — Panduan Pengembang & Standar Arsitektur Unified React SPA.
  * [`analisis_roadmap.md`](02-architecture/analisis_roadmap.md) — Analisis kode & strategi refactoring Polimer.
* **`05-operations/`**:
  * [`setup_guide.md`](05-operations/setup_guide.md) — Panduan instalasi dan lingkungan lokal.
  * [`test_accounts.md`](05-operations/test_accounts.md) — Daftar akun pengujian, database seeder (`UserSeeder`, `MarketingUserSeeder`, `DummyPolimerSeeder`).
  * [`environment.md`](05-operations/environment.md) — Konfigurasi environment variabel `.env`.
  * [`user_manual_customer.md`](05-operations/user_manual_customer.md) — Panduan Pengguna Portal Pelanggan.
  * [`user_manual_admin.md`](05-operations/user_manual_admin.md) — Panduan Pengguna Portal Admin & Petugas Balai.
  * [`cutover_and_deployment_sop.md`](05-operations/cutover_and_deployment_sop.md) — Standar Operasional Prosedur (SOP) Zero-Downtime Production Cutover.
* **`06-tasks/`**:
  * [`milestone.md`](06-tasks/milestone.md) — Roadmap milestone & 5-sprint plan modernisasi Polimer.
  * [`sprint_1_breakdown.md`](06-tasks/sprint_1_breakdown.md) — Rincian tugas Sprint 1: Design System, Tailwind & UI Kit.
  * [`sprint_2_breakdown.md`](06-tasks/sprint_2_breakdown.md) — Rincian tugas Sprint 2: Modernisasi Total Portal Pelanggan.
  * [`sprint_3_breakdown.md`](06-tasks/sprint_3_breakdown.md) — Rincian tugas Sprint 3: TanStack Query v5, Zod & Standardisasi API.
  * [`sprint_4_breakdown.md`](06-tasks/sprint_4_breakdown.md) — Rincian tugas Sprint 4: Migrasi Total Modul Admin ke Unified React SPA.
  * [`sprint_5_breakdown.md`](06-tasks/sprint_5_breakdown.md) — Rincian tugas Sprint 5: Dynamic RBAC Matrix, Testing, Optimasi & Cutover.
  * [`audit_sprint_1_to_3.md`](06-tasks/audit_sprint_1_to_3.md) — Laporan Audit Teknis Sprint 1 s.d. 3.
  * [`audit_sprint_1_to_5.md`](06-tasks/audit_sprint_1_to_5.md) — **Laporan Deep Audit Komprehensif Seluruh Milestone (Sprint 1 - 5 Final)**.
  * [`analisis_perbandingan_branch_polimer_sis.md`](06-tasks/analisis_perbandingan_branch_polimer_sis.md) — Analisis Perbedaan Branch & Acuan Merging `polimer_sis`.
* **`07-audit/`**:
  * [`deep_audit_modernisasi_polimer.md`](07-audit/deep_audit_modernisasi_polimer.md) — Laporan audit arsitektur modernisasi Polimer.
  * [`comprehensive_3day_audit_report.md`](07-audit/comprehensive_3day_audit_report.md) — Laporan audit komprehensif 3 hari terakhir.
