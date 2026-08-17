---
title: "Index — Map of Content (Multi-Project SSOT)"
summary: "Peta navigasi utama seluruh dokumentasi sistem BBKKP terpusat. Single Source of Truth untuk semua proyek."
created: "2026-08-17"
updated: "2026-08-17"
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

## 🌐 00 — Global Standards & SOP (Lintas Project)

Dokumen standar teknis, aturan pengkodean, keamanan database/RBAC, dan SOP alur Git yang berlaku untuk **semua repositori**.

| Dokumen | Path | Deskripsi |
|---|---|---|
| Rules & Development Guidelines | [coding_guidelines.md](docs/00-global/standards/coding_guidelines.md) | Standar keamanan, RBAC, pencegahan IDOR, transaksi DB, dan zero-disruption |
| SOP Git Dual-Remote Workflow | [git_dual_remote_workflow.md](docs/00-global/standards/git_dual_remote_workflow.md) | Panduan lengkap alur kerja Git Dual-Remote (`origin` vs `upstream`) |

---

## 🚀 Projects Directory

### 🟢 1. Project: BBKKP Polimer (`bbkkp-polimer`)
*Repositori: `Rayendraarya26/private-polimer` / `bakulkapas/bbkkp-polimer`*

| Dokumen | Path | Deskripsi |
|---|---|---|
| System Overview Polimer | [system_overview.md](docs/projects/bbkkp-polimer/02-architecture/system_overview.md) | Arsitektur & modul aplikasi BBKKP Polimer |
| Analisis & Roadmap Polimer | [analisis_roadmap.md](docs/projects/bbkkp-polimer/02-architecture/analisis_roadmap.md) | Analisis kode eksisting Polimer & strategi refactoring |
| Index Project Polimer | [_index.md](docs/projects/bbkkp-polimer/_index.md) | Halaman utama dokumentasi Polimer |

---

### 🔵 2. Project: BBKKP SIS (`bbkkp-sis`)
*Repositori: `Rayendraarya26/private-sis` / `bakulkapas/bbkkp-sis`*

| Dokumen | Path | Deskripsi |
|---|---|---|
| Flow & Modul SIS | [flow_modul_sis.md](docs/projects/bbkkp-sis/02-architecture/flow_modul_sis.md) | Alur bisnis & struktur modul aplikasi BBKKP SIS |
| Index Project SIS | [_index.md](docs/projects/bbkkp-sis/_index.md) | Halaman utama dokumentasi SIS |

---

### 🟣 3. Project: Integrasi SIS & Polimer (`integrasi-sis-polimer`)
*Proyek Cross-System Integrasi Data & Sertifikasi*

| Dokumen | Path | Deskripsi |
|---|---|---|
| FRD Integrasi SIS & Polimer | [frd_integrasi.md](docs/projects/integrasi-sis-polimer/01-product/frd_integrasi.md) | Spesifikasi fungsional integrasi data Polimer & SIS |
| Target Milestone Integrasi | [milestone.md](docs/projects/integrasi-sis-polimer/06-tasks/milestone.md) | Timeline & target milestone sprint integrasi |
| Sprint 1 Breakdown | [sprint_1_breakdown.md](docs/projects/integrasi-sis-polimer/06-tasks/sprint_1_breakdown.md) | Rincian tugas Sprint 1: Integrasi Akun & Sertifikat SIS |
| Sprint 2 Breakdown | [sprint_2_breakdown.md](docs/projects/integrasi-sis-polimer/06-tasks/sprint_2_breakdown.md) | Rincian tugas Sprint 2 |
| Sprint 3 Breakdown | [sprint_3_breakdown.md](docs/projects/integrasi-sis-polimer/06-tasks/sprint_3_breakdown.md) | Rincian tugas Sprint 3 |
| Sprint 4 Breakdown | [sprint_4_breakdown.md](docs/projects/integrasi-sis-polimer/06-tasks/sprint_4_breakdown.md) | Rincian tugas Sprint 4 |
| Index Project Integrasi | [_index.md](docs/projects/integrasi-sis-polimer/_index.md) | Halaman utama dokumentasi Integrasi |
