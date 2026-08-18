# Sprint 3 Breakdown — Standardisasi Backend API, State Management & Validasi
## Proyek Modernisasi Tech Stack BBKKP Polimer

> **Sprint**: 3 dari 5  
> **Durasi**: 2 Minggu  
> **Fokus Utama**: Integrasi TanStack Query v5, Validasi Schema Zod + React Hook Form, dan Standardisasi REST API Laravel  
> **Target Branch**: `feature/standardized-api-and-state-management`

---

## 1. Sasaran Sprint (Sprint Goal)
1. **Frontend State & Caching Modern**: Menggantikan fetching manual dan boilerplate Redux lama dengan **TanStack Query (React Query v5)** untuk smart caching, background revalidation, auto retry, dan query invalidation.
2. **Type-Safe Validation**: Menggantikan validasi ad-hoc dan Yup dengan **Zod Schemas** yang terintegrasi dengan **React Hook Form**.
3. **Backend API Standardisasi**: Menstandarisasi response JSON Resource (`success`, `data`, `meta`, `errors`) serta menyediakan endpoint API terstruktur untuk verifikasi, master data, dan operasional admin.

---

## 2. Rincian Task Breakdown

### 🔹 TS3-01: Instalasi & Setup TanStack Query v5
* **Deskripsi**:
  1. Instalasi `@tanstack/react-query` dan `zod`.
  2. Setup `QueryClientProvider` global di root aplikasi (`app.tsx`).
  3. Konfigurasi default options (caching `staleTime: 5 menit`, `gcTime: 10 menit`, `refetchOnWindowFocus: false`).
* **Deliverables**: `src/lib/queryClient.ts`, `app.tsx`, `package.json`.

---

### 🔹 TS3-02: Implementasi Custom Query Hooks untuk Portal Layanan
* **Deskripsi**:
  Membangun custom query & mutation hooks terstandarisasi:
  - `useProfileQuery`: Fetching profil akun + pre-caching.
  - `usePermohonanQuery` & `usePermohonanDetailQuery`: Fetching daftar & detail permohonan dengan caching pintar.
  - `useLspSkemaQuery` & `usePelatihanSkemaQuery`: Fetching data skema master dengan invalidasi otomatis.
  - `useNotificationsQuery`: Real-time polling latar belakang setiap 30 detik untuk badge notifikasi.
  - `useFeedbacksQuery` & `useQuestionsQuery`: Infinite/paginated query untuk tiket dan survey.
* **Deliverables**: Direktori `hooks/queries/` dan `services/api/`.

---

### 🔹 TS3-03: Standardisasi Skema Validasi Zod (Type-Safe Forms)
* **Deskripsi**:
  Membuat Zod schema terpadu untuk setiap modul input:
  1. `profileSchema.ts`: Validasi form perorangan, instansi, dan perusahaan.
  2. `securitySchema.ts`: Validasi nama akun dan kata sandi baru (min 8 karakter kombinasi huruf & angka).
  3. `lspSchema.ts`: Validasi NIK 16 digit, kode pos 5 digit, email, no whatsapp internasional, dan dokumen portofolio.
  4. `pelatihanSchema.ts`: Validasi kebutuhan kurikulum bimtek dan dokumen peserta.
* **Deliverables**: Direktori `schemas/` (misal: `schemas/profile.schema.ts`, `schemas/lsp.schema.ts`, dll.).

---

### 🔹 TS3-04: Standardisasi Response JSON Resource Backend Laravel
* **Deskripsi**:
  Menyelaraskan format response JSON API Laravel pada seluruh modul:
  - Format Sukses: `{ success: true, message: string, data: any, meta?: any }`
  - Format Gagal: `{ success: false, message: string, errors?: Record<string, string[]> }`
  - Global API Exception Handler di `app/Exceptions/Handler.php`.
* **Deliverables**: `app/Http/Resources/ApiResource.php`, `app/Exceptions/Handler.php`.

---

### 🔹 TS3-05: Backend Admin API Preparation
* **Deskripsi**:
  Menyediakan endpoint REST API terstruktur untuk modul operasional internal:
  - `GET/POST /api/v1/admin/permohonan`: Manajemen antrean & disposisi permohonan.
  - `GET/PUT /api/v1/admin/verifikasi/{id}`: Verifikasi berkas & approval bertingkat.
  - `GET /api/v1/admin/master-data`: API skema, parameter uji, komoditi SNI, dan wilayah.
* **Deliverables**: `Modules/Admin/Http/Controllers/Api/`.

---

## 3. Matriks Kriteria Penerimaan (Definition of Done)
1. Seluruh data fetching di portal pelanggan menggunakan TanStack Query tanpa flickering / refetch berulang.
2. Form validasi 100% type-safe menggunakan Zod + React Hook Form dengan pesan kesalahan yang jelas dan ramah pengguna.
3. Seluruh endpoint backend menghasilkan struktur JSON seragam dan lolos linting serta build Vite.
