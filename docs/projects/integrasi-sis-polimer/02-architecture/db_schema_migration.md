# 🗄️ Spesifikasi Migrasi Skema DB SIS ➡️ Polimer
## Pemetaan Tabel Legacy, Transformasi Data, dan Desain Command Artisan Idempoten

> **Proyek**: Integrasi & Migrasi Data BBKKP SIS ke BBKKP Polimer  
> **Status Dokumen**: Active / Technical Specification Baseline  
> **Tanggal Efektif**: 17 Agustus 2026

---

## 1. Tujuan Spesifikasi Migrasi

Dokumen ini mendefinisikan pemetaan data (*database schema mapping*) dari database legacy `bbkkp_sis` ke database modern `bbkkp_polimer`.

Sasaran utama migrasi:
1. Memindahkan data sertifikat aktif (`status = on_going`) dari SIS ke tabel `pelanggan_sertifikasi` di Polimer.
2. Memindahkan data profil pabrik pelanggan lama dari SIS ke tabel `pelanggan_pabrik` di Polimer.
3. Memastikan pemindahan data dapat dijalankan secara **idempoten** (aman dijalankan berulang kali tanpa menciptakan duplikasi record).

---

## 2. Pemetaan Skema Tabel (Database Schema Mapping)

### 2.1. Tabel Sertifikat: `sis_sertifikat` ➡️ `pelanggan_sertifikasi`

| Kolom Asal (`bbkkp_sis.sis_sertifikat`) | Tipe Data Asal | Kolom Tujuan (`bbkkp_polimer.pelanggan_sertifikasi`) | Tipe Data Tujuan | Catatan Transformasi |
| :--- | :--- | :--- | :--- | :--- |
| `id_sertifikat` | INT (PK) | `sis_sertifikat_id` | BIGINT (Nullable) | Dipakai sebagai *unique key constraint* untuk pengecekan idempotensi. |
| `nomor_sertifikat` | VARCHAR(100) | `nomor_sertifikat` | VARCHAR(150) | Trim whitespace & normalisasi format string. |
| `id_perusahaan` | INT (FK) | `pelanggan_pabrik_id` | BIGINT (FK) | Dihubungkan dengan ID pabrik hasil migrasi di `pelanggan_pabrik`. |
| `tgl_terbit` | DATE | `tanggal_terbit` | DATE | Format YYYY-MM-DD. |
| `tgl_kadaluarsa` | DATE | `tanggal_kadaluarsa` | DATE | Format YYYY-MM-DD. |
| `status_sertifikat` | VARCHAR(50) | `status` | ENUM('on_going','expired','suspended') | `on_going` jika `tgl_kadaluarsa >= NOW()`. |
| `file_pdf_path` | VARCHAR(255) | `url_pdf_sertifikat_lama` | TEXT | URL / relative path ke berkas PDF sertifikat lama di storage SIS. |

---

### 2.2. Tabel Perusahaan: `sis_perusahaan` ➡️ `pelanggan_pabrik`

| Kolom Asal (`bbkkp_sis.sis_perusahaan`) | Kolom Tujuan (`bbkkp_polimer.pelanggan_pabrik`) | Aturan Transformasi |
| :--- | :--- | :--- |
| `id_perusahaan` | `sis_perusahaan_id` | Unique identifier legacy. |
| `nama_perusahaan` | `nama_pabrik` | Trim & Uppercase. |
| `alamat_pabrik` | `alamat_pabrik` | Sanitasi HTML XSS. |
| `npwp` | `npwp_pabrik` | Bersihkan karakter titik & strip (`123456...`). |
| `email` | `email_pabrik` | Lowercase & validasi format email. |

---

## 3. Spesifikasi Command Artisan Idempoten

### Nama Command:
```bash
php artisan integration:migrate-sis-history
```

### Parameter & Flag:
* `--dry-run`: Mensimulasikan migrasi tanpa menyimpan ke database.
* `--chunk=100`: Menentukan ukuran batch pembacaan data (default: 100 record per iterasi).
* `--force`: Memaksa update record jika sudah ada di Polimer.

---

## 4. Logika Idempotensi (Upsert Pattern)

Untuk menjamin idempotensi, tabel `pelanggan_sertifikasi` di Polimer dilengkapi dengan **Unique Constraint** pada kolom `sis_sertifikat_id`:

```php
namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use App\Models\PelangganSertifikasi;

class MigrateSisHistory extends Command
{
    protected $signature = 'integration:migrate-sis-history {--dry-run} {--chunk=100}';
    protected $description = 'Migrasi riwayat sertifikat aktif dari BBKKP SIS ke Polimer secara idempoten';

    public function handle()
    {
        $this->info('Memulai proses migrasi data sertifikat SIS...');
        
        $sisSertifikat = DB::connection('mysql_sis')
            ->table('sis_sertifikat')
            ->where('status_sertifikat', 'on_going')
            ->orderBy('id_sertifikat');

        $migratedCount = 0;
        
        $sisSertifikat->chunk($this->option('chunk'), function ($rows) use (&$migratedCount) {
            foreach ($rows as $row) {
                if ($this->option('dry-run')) {
                    $this->line("Dry-run: Memproses sertifikat #{$row->nomor_sertifikat}");
                    continue;
                }

                // UPSERT (Update or Insert) berdasarkan sis_sertifikat_id
                PelangganSertifikasi::updateOrCreate(
                    ['sis_sertifikat_id' => $row->id_sertifikat], // Key penanda idempotensi
                    [
                        'nomor_sertifikat' => trim($row->nomor_sertifikat),
                        'tanggal_terbit' => $row->tgl_terbit,
                        'tanggal_kadaluarsa' => $row->tgl_kadaluarsa,
                        'status' => ($row->tgl_kadaluarsa >= now()) ? 'on_going' : 'expired',
                        'url_pdf_sertifikat_lama' => $row->file_pdf_path,
                    ]
                );
                
                $migratedCount++;
            }
        });

        $this->info("Migrasi selesai! Total {$migratedCount} record sertifikat diproses.");
    }
}
```

---

## 5. Strategi Pengujian & Verifikasi
1. **Dry-Run Test**:
   ```bash
   php artisan integration:migrate-sis-history --dry-run
   ```
2. **Re-run Test (Uji Idempotensi)**:
   Jalankan command migrasi 2x berturut-turut. Hasil `COUNT(*)` pada tabel `pelanggan_sertifikasi` harus tetap sama tanpa duplikasi ID.
