# 🛡️ Pedoman Keamanan Sistem & API BBKKP
## Standar Keamanan Data, Autentikasi, Mitigasi IDOR, dan Validasi Webhook

> **Dokumen Standar Keamanan Teknis**  
> **Balai Besar Kulit, Karet, dan Plastik (BBKKP) - Kementerian Perindustrian RI**  
> **Status Dokumen**: Active / Mandatory Security Guidelines  
> **Tanggal Efektif**: 17 Agustus 2026

---

## 1. Prinsip Utama Keamanan Data

Aplikasi di lingkungan BBKKP mengelola data industri nasional, sertifikat legal, serta transaksi keuangan PNBP. Seluruh kode yang ditulis wajib mematuhi **5 Pilar Keamanan**:

1. **Pencegahan Akses Ilegal (Pencegahan IDOR)**.
2. **Perlindungan Kredensial & Secrets Management**.
3. **Validasi Signature Webhook & Callback Pihak Ke-3**.
4. **Sanitasi Input & Pencegahan SQLi / XSS**.
5. **Audit Logging Mutasi Data Kritis**.

---

## 2. Mitigasi IDOR (Insecure Direct Object References)

IDOR terjadi jika pengguna dapat mengakses atau mengubah data milik industri lain hanya dengan mengganti ID pada URL / payload API.

### Aturan Wajib:
* Setiap query mutasi atau pengambilan data **wajib memvalidasi kepemilikan data** (*data ownership check*).

```php
// ❌ SALAH (Rentan IDOR - Siapapun yang tahu ID bisa melihat permohonan industri lain)
public function show($id) {
    $permohonan = Permohonan::findOrFail($id);
    return view('permohonan.show', compact('permohonan'));
}

// ✅ BENAR (Aman IDOR - Hanya mengambil jika permohonan milik user yang sedang login)
public function show($id) {
    $permohonan = Permohonan::where('id', $id)
        ->where('created_by', auth()->id())
        ->firstOrFail();
        
    return view('permohonan.show', compact('permohonan'));
}
```

---

## 3. Keamanan Webhook & Callback Pihak Ke-3

### 3.1. Callback BNI Virtual Account (`/api/integration/bni-callback`)
1. **Validasi Signature**: Setiap payload callback BNI wajib didekripsi dan diverifikasi HMAC secret token-nya.
2. **Pencegahan Double Processing (Idempotency)**:
   * Bungkus pemrosesan transaksi dalam `DB::transaction()`.
   * Gunakan Redis Atomic Lock atau DB Lock berdasarkan `journal_number` / `va_number`.

```php
use Illuminate\Support\Facades\Cache;

$lock = Cache::lock('bni-payment-' . $journalNumber, 10);

if ($lock->get()) {
    try {
        // Proses update status lunas & kirim notifikasi
    } finally {
        $lock->release();
    }
} else {
    return response()->json(['message' => 'Duplicate transaction in progress'], 409);
}
```

---

## 4. Keamanan Kredensial & Secrets Management

1. **Dilarang Hardcode Token / Password**: API Key BNI, BSrE, DB Password, dan Secret Key **TIDAK BOLEH** ditulis di dalam source code `.php` atau `.js`.
2. **Gunakan `.env` & Config**:
   ```php
   // ✅ Read from config
   $apiKey = config('services.bsre.api_key');
   ```
3. **Penyimpanan Berkas Terproteksi**: Berkas PDF sertifikat sebelum TTE atau dokumen rahasia pabrik wajib disimpan di `storage/app/private` (bukan `public/`). Akses unduhan harus melewati controller berpenerima otoritas.

---

## 5. Audit Trail & Logging

Seluruh mutasi status kritis (perubahan tarif, approval permohonan, pembubuhan TTE, dan pembayaran lunas) **wajib mencatat log audit** di tabel `sys_audit_logs`:
* ID Pengguna & Role
* Aksi (Insert/Update/Delete)
* Payload sebelum (*old_values*) & sesudah (*new_values*)
* IP Address & User Agent
