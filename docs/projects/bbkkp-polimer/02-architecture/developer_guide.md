# Panduan Pengembang & Arsitektur Sistem (Developer Guide)
## Proyek Modernisasi Tech Stack BBKKP Polimer

---

## 1. Ikhtisar Arsitektur Modern

Sistem BBKKP Polimer modern mengadopsi pola arsitektur **Decoupled Client-Server**:
- **Frontend SPA**: React 18 + TypeScript + Vite + Tailwind CSS + TanStack Query v5 + React Hook Form + Zod.
- **Backend API**: Laravel 10/11 REST API terstandarisasi + PostgreSQL/MySQL + Redis Cache + Object Storage S3/MinIO.
- **Security & Authorization**: Dynamic RBAC Matrix (`sys_group_permission`, `sys_menu_action`), Laravel Passport / Sanctum OAuth SSO, TTE BSrE Digital Signature.

```
┌────────────────────────────────────────────────────────┐
│                   Unified React 18 SPA                 │
│  [Customer Portal] ── [Shared UI Kit] ── [Admin Shell] │
└───────────────────────────┬────────────────────────────┘
                            │ JSON API (Axios / TanStack Query)
                            ▼
┌────────────────────────────────────────────────────────┐
│                Laravel REST API Core                   │
│   [ApiResource] ── [RBAC Middleware] ── [Sentry/Log]  │
└───────────────────────────┬────────────────────────────┘
                            │ Database / S3
                            ▼
┌────────────────────────────────────────────────────────┐
│  [PostgreSQL / MySQL] ── [Redis] ── [S3 MinIO Storage] │
└────────────────────────────────────────────────────────┘
```

---

## 2. Struktur Direktori Frontend

Direktori kode frontend berada pada: `Modules/Eksternal/resources/assets/js/`

```
Modules/Eksternal/resources/assets/js/
├── components/           # Komponen UI Terpadu
│   ├── admin/            # Komponen khusus admin (Approval modal, summary cards)
│   ├── common/           # Shared components (AppLauncher, Navbar, Footer, Gate)
│   ├── layouts/          # Layout Shell (AdminShell, AppShell, PrivateLayout)
│   └── ui/               # Reusable atomic UI (Button, Modal, Badge, Card, Table)
├── context/              # Global React Contexts (PermissionContext, AuthContext)
├── guards/               # Route Security Guards (PermissionGuard)
├── hooks/                # Custom React & TanStack Query Hooks
│   ├── queries/          # useProfileQuery, usePermohonanQuery, useMasterQuery
│   └── usePermission.ts  # RBAC hook helper (useCan, useHasRole)
├── pages/                # Halaman Rute Aplikasi
│   ├── admin/            # Modul Operasional Internal (Dashboard, Permohonan, Finance, Master, System)
│   ├── dashboard/        # Customer Dashboard
│   ├── profile/          # Customer Profile & Password
│   └── service-requests/ # Wizard Permohonan Layanan
├── schemas/              # Zod Validation Schemas (Type-safe forms)
├── services/             # Axios REST API Service layers
├── styles/               # Tailwind CSS & Global stylesheets
├── types/                # TypeScript Interfaces & Enums (rbac.ts, profile.ts, etc.)
├── utils/                # Helper utilities (api.ts, cn.ts, avatar.ts, date.ts)
├── routes.tsx            # Central Route Registry
└── app.tsx               # Root Application Entrypoint
```

---

## 3. Pola & Standar Pengembangan

### A. State Management & Data Fetching (TanStack Query v5)
Gunakan TanStack Query untuk seluruh pengambilan data server. Hindari penggunaan `useEffect` manual untuk fetching.

```tsx
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import api from '@/utils/api';

export const usePermohonanListQuery = (filters: PermohonanFilterState) => {
  return useQuery({
    queryKey: ['adminPermohonanList', filters],
    queryFn: async () => {
      const response = await api.get('/admin/permohonan', { params: filters });
      return response.data?.data;
    },
    staleTime: 1000 * 60 * 3, // 3 menit cache segar
  });
};
```

---

### B. Form Validation (React Hook Form + Zod)
Seluruh formulir wajib divalidasi menggunakan skema Zod type-safe:

```tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { profilePerusahaanSchema, ProfilePerusahaanSchemaType } from '@/schemas/profile.schema';

export const FormPerusahaanComponent = () => {
  const { register, handleSubmit, formState: { errors } } = useForm<ProfilePerusahaanSchemaType>({
    resolver: zodResolver(profilePerusahaanSchema),
  });

  const onSubmit = (data: ProfilePerusahaanSchemaType) => {
    // data is 100% type-safe
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('nama')} />
      {errors.nama && <span className="text-rose-500">{errors.nama.message}</span>}
    </form>
  );
};
```

---

### C. Otorisasi RBAC di Komponen UI
Gunakan komponen `PermissionGate` atau hook `useCan` / `useHasRole` untuk menyembunyikan atau menampilkan aksi berdasarkan izin:

```tsx
import { PermissionGate } from '@/components/common/PermissionGate';
import { useCan, useHasRole } from '@/hooks/usePermission';

// Pendekatan 1: Deklaratif Gate
<PermissionGate action="approve" module="permohonan">
  <button onClick={handleApprove}>Setujui Permohonan</button>
</PermissionGate>

// Pendekatan 2: Hook Logic
const canExport = useCan('export', 'finance');
const isSuperAdmin = useHasRole('SUPER_ADMIN');
```

---

### D. Menambahkan Halaman Baru di Admin Shell
1. Buat halaman baru pada folder `pages/admin/{modul}/{NamaHalaman}Page.tsx`.
2. Daftarkan item navigasi di `components/layouts/AdminShell.tsx` pada variabel `allModules`.
3. Daftarkan rute di `routes.tsx` dengan pembungkus `PermissionGuard` sesuai izin yang diperlukan:
   ```tsx
   <Route
     path="modul/baru"
     element={
       <PermissionGuard requiredRoles={['SUPER_ADMIN', 'VERIFIKATOR']}>
         <ModulBaruPage />
       </PermissionGuard>
     }
   />
   ```

---

## 4. Perintah Pengembangan & Pengujian

| Perintah | Deskripsi |
| :--- | :--- |
| `npm run dev` | Menjalankan Vite Development Server dengan Hot Module Replacement (HMR). |
| `npm run build` | Melakukan kompilasi bundle production dengan chunk splitting teroptimasi. |
| `npm run type-check` | Menjalankan pemeriksaan tipe TypeScript statis (`tsc`). |
| `php artisan serve` | Menjalankan local server backend Laravel. |
| `php artisan test` | Menjalankan test suite backend PHPUnit. |
