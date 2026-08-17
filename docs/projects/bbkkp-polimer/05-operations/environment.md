# 🔑 Environment Variables Reference — BBKKP Polimer

Dokumen ini menjelaskan seluruh variabel lingkungan (*environment variables*) yang ada pada file `.env` aplikasi **BBKKP Polimer**.

---

## 1. Konfigurasi Aplikasi & Database

| Variabel | Contoh Nilai | Deskripsi |
| :--- | :--- | :--- |
| `APP_NAME` | `BBKKP Polimer` | Nama aplikasi yang muncul di email/UI. |
| `APP_ENV` | `local` / `production` | Lingkungan aplikasi. Gunakan `local` di komputer dev. |
| `APP_DEBUG` | `true` / `false` | Mode debug error stacktrace. Set `false` di produksi! |
| `APP_URL` | `http://127.0.0.1:8000` | Base URL aplikasi. |
| `DB_CONNECTION` | `mysql` | Driver database Eloquent. |
| `DB_HOST` | `127.0.0.1` | Host MySQL Server. |
| `DB_PORT` | `3306` | Port MySQL Server. |
| `DB_DATABASE` | `bbkkp_polimer` | Nama database utama aplikasi Polimer. |
| `DB_USERNAME` | `root` | Username MySQL. |
| `DB_PASSWORD` | `secret` | Password MySQL. |

---

## 2. Konfigurasi Database SIS (Koneksi Kedua untuk Migrasi)

Aplikasi Polimer terhubung ke database `bbkkp_sis` legacy untuk kepentingan migrasi dan verifikasi riwayat sertifikat:

| Variabel | Contoh Nilai | Deskripsi |
| :--- | :--- | :--- |
| `DB_SIS_HOST` | `127.0.0.1` | Host MySQL Server database SIS legacy. |
| `DB_SIS_PORT` | `3306` | Port MySQL Server database SIS. |
| `DB_SIS_DATABASE` | `bbkkp_sis` | Nama database SIS legacy. |
| `DB_SIS_USERNAME` | `root` | Username MySQL DB SIS. |
| `DB_SIS_PASSWORD` | `secret` | Password DB SIS. |

---

## 3. Konfigurasi Layanan Pihak Ke-3

### 3.1. BNI Virtual Account API
```ini
BNI_VA_CLIENT_ID=808
BNI_VA_SECRET_KEY=e83a4bf912903841a...
BNI_VA_PREFIX=9888
BNI_VA_IS_PRODUCTION=false
```

### 3.2. BSrE E-Sign TTE Service (BSSN)
```ini
BSRE_ESIGN_URL=https://esign-sandbox.bssn.go.id/api
BSRE_ESIGN_CLIENT_ID=bbkkp_user
BSRE_ESIGN_SECRET_KEY=938210391...
```

### 3.3. Queue & Redis Configuration
```ini
QUEUE_CONNECTION=redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```
