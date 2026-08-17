# 🔑 Environment Variables Reference — BBKKP SIS

Dokumen ini menjelaskan variabel lingkungan pada file `.env` sistem legacy **BBKKP SIS**.

---

## Variabel Lingkungan Utama

| Variabel | Nilai Standar Dev | Deskripsi |
| :--- | :--- | :--- |
| `APP_NAME` | `BBKKP SIS Legacy` | Identifikasi nama sistem SIS. |
| `APP_URL` | `http://127.0.0.1:8001` | URL lokal dev server SIS (menggunakan port 8001 agar tidak bentrok dengan Polimer). |
| `DB_CONNECTION` | `mysql` | Driver database. |
| `DB_HOST` | `127.0.0.1` | Host MySQL Server. |
| `DB_PORT` | `3306` | Port MySQL Server. |
| `DB_DATABASE` | `bbkkp_sis` | Nama database SIS legacy. |
| `DB_USERNAME` | `root` | Username MySQL. |
| `DB_PASSWORD` | `secret` | Password MySQL. |
