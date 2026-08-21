# 📜 Changelog Proyek: BBKKP SIS (`bbkkp-sis`)

> **Repositori**: `Rayendraarya26/private-sis` / `bakulkapas/bbkkp-sis`  
> **Periode Log**: 18 Agustus 2026 s/d 21 Agustus 2026 (4 Hari Terakhir)  
> **Teknologi Utama**: PHP 7.4/8.1, Laravel Legacy, MySQL Legacy DB (`bbkkp_sis`)

---

## 📑 Ringkasan Log Komit

```
9e1e4f57 (2026-08-18 06:18) feat: Create public tables migration
```

---

## 🔍 Detail Perubahan & Integrasi

### 📅 18 Agustus 2026

#### 1. Public Tables Migration (`9e1e4f57`)
* **Tujuan**:
  * Menyelaraskan struktur tabel publik pada database legacy `bbkkp_sis` agar kompatibel dengan akun terpadu dan aliran data permohonan dari portal modern **BBKKP Polimer**.
* **Cakupan Perubahan**:
  * Menambahkan tabel / kolom publik untuk mapping ID pengguna (`user_id`, `id_permohonan_polimer`).
  * Memastikan integritas referensial dan foreign key tabel sertifikasi legacy tetap dapat dibaca oleh perintah migrator di Polimer (`php artisan sis:migrate-sertifikasi`).

---

## 🔗 Kaitan dengan Ekosistem

* **Status Co-Existence**: Database SIS tetap aktif beroperasi sebagai penyimpanan riwayat data sertifikasi lama dan melayani proses internal existing.
* **Sinkronisasi 2 Arah**: Seluruh pembaruan status sertifikasi dan penerbitan TTE dari Polimer terhubung via `SisSyncBridgingService`.
