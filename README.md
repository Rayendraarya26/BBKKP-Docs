# 📚 BBKKP Documentation — Single Source of Truth (SSOT)

Repositori ini berfungsi sebagai **Single Source of Truth (SSOT)** terpusat untuk seluruh ekosistem aplikasi **BBKKP (Balai Besar Kulit, Karet, dan Plastik - Kementerian Perindustrian RI)**, mencakup repositori `bbkkp-polimer`, `bbkkp-sis`, proyek integrasi, serta repositori/sistem BBKKP di masa mendatang.

---

## 🗺️ Panduan Navigasi Utama

Gunakan **[INDEX.md](INDEX.md)** sebagai peta navigasi utama (*Map of Content / MOC*) untuk menemukan dokumen yang Anda butuhkan baik berdasarkan **Project** maupun **Kategori Dokumen**.

### Taksonomi Direktori (`docs/`):

```text
Document/
├── README.md
├── INDEX.md
└── docs/
    ├── 00-global/                         # Standar, Aturan Security, & SOP Lintas Project
    │   ├── standards/
    │   │   ├── coding_guidelines.md       # Aturan Pengkodean, Transaction Safety & Security
    │   │   └── git_dual_remote_workflow.md# SOP Git Dual-Remote Workflow (origin vs upstream)
    │   └── architecture/                  # Overview Arsitektur Ekosistem BBKKP
    │
    └── projects/                          # Direktori Per Project / Repositori
        ├── bbkkp-polimer/                # Repository: Rayendraarya26/private-polimer
        ├── bbkkp-sis/                    # Repository: Rayendraarya26/private-sis
        └── integrasi-sis-polimer/        # Proyek Integrasi & Sprint 1-4
```

---

## 🚀 Repositori Terkait

| Nama Project | Kode Repositori | URL Repositori Utama (Upstream) | URL Repositori Private |
|---|---|---|---|
| BBKKP Polimer | `bbkkp-polimer` | `https://github.com/bakulkapas/bbkkp-polimer.git` | `https://github.com/Rayendraarya26/private-polimer.git` |
| BBKKP SIS | `bbkkp-sis` | `https://github.com/bakulkapas/bbkkp-sis.git` | `https://github.com/Rayendraarya26/private-sis.git` |
| BBKKP Docs | `BBKKP-Docs` | - | `https://github.com/Rayendraarya26/BBKKP-Docs.git` |

---

## 🛠️ Standar Pengelolaan Dokumen
Seluruh perubahan dokumentasi wajib mematuhi panduan di **[SOP Git Dual-Remote Workflow](docs/00-global/standards/git_dual_remote_workflow.md)**.
