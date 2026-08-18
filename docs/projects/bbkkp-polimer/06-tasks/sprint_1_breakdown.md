# Sprint 1 Breakdown — Design System, Tailwind Setup & Enterprise UI Kit
## Proyek Modernisasi Tech Stack BBKKP Polimer

> **Sprint**: 1 dari 5  
> **Durasi**: 2 Minggu  
> **Fokus Utama**: Fondasi Frontend Modern, Tailwind CSS, Design Tokens Kemenperin/BBKKP, dan Library Komponen Reusable  
> **Target Branch**: `feature/modern-design-system-foundation`

---

## 1. Sasaran Sprint (Sprint Goal)
Membangun fondasi arsitektur frontend modern berbasis **Tailwind CSS** dan **React 18 + TypeScript**, mendefinisikan sistem token desain enterprise (warna, tipografi, elevasi, radius), serta menyediakan pustaka komponen UI inti (*atoms, molecules, organisms*) yang siap pakai untuk modul pelanggan dan admin.

---

## 2. Rincian Task Breakdown

### 🔹 TS1-01: Instalasi & Konfigurasi Tailwind CSS & Tooling Modern
* **Deskripsi**: Menyiapkan Tailwind CSS versi 3.4+ ke dalam build system Vite di Polimer tanpa merusak asset build Laravel eksisting.
* **Langkah Teknis**:
  1. Install dependensi: `tailwindcss`, `postcss`, `autoprefixer`, `tailwind-merge`, `clsx`.
  2. Inisialisasi `tailwind.config.js` dan `postcss.config.js`.
  3. Konfigurasi `content` glob path untuk memindai seluruh file `.tsx`, `.ts`, dan `.blade.php`.
  4. Buat helper utility `cn()` (`clsx` + `twMerge`) di `utils/cn.ts` untuk penggabungan classname yang aman dan terprediksi.
* **Kriteria Penerimaan (Acceptance Criteria)**:
  - Utility class Tailwind dapat digunakan secara langsung di komponen React.
  - Hot Module Replacement (HMR) Vite berjalan instan tanpa lag.

---

### 🔹 TS1-02: Definisi Token Desain & Tema Korporat BBKKP
* **Deskripsi**: Menyusun palet warna resmi Kemenperin/BBKKP, tipografi modern, sistem spacing, dan tema visual yang profesional.
* **Spesifikasi Token**:
  * **Colors**:
    * `primary`: Navy Kemenperin (`50: #eff6ff` ... `600: #1e3a8a` ... `900: #0f172a`)
    * `accent / secondary`: Teal/Cyan (`#0d9488`, `#06b6d4`)
    * `success`: Emerald (`#10b981`)
    * `warning`: Amber (`#f59e0b`)
    * `danger`: Rose/Red (`#ef4444`)
    * `neutral`: Slate/Zinc gray scale
  * **Typography**:
    * Font Family: `Montserrat` (Heading & Brand), `Inter` (Data, Form & Body text).
  * **Border Radius & Shadows**:
    * Subtly rounded (`rounded-lg`, `rounded-xl`), soft modern enterprise elevation (`shadow-sm`, `shadow-md`).
* **Kriteria Penerimaan**:
  - Warna, font, dan spacing dapat diakses via semantic class Tailwind (contoh: `bg-primary-600`, `text-neutral-700`, `font-sans`).

---

### 🔹 TS1-03: Komponen Dasar (Atoms & Form Controls)
* **Deskripsi**: Membangun komponen UI dasar yang fleksibel, accessible, dan konsisten.
* **Daftar Komponen yang Dibuat**:
  1. `Button`: Varian `primary`, `secondary`, `outline`, `ghost`, `danger`, dengan icon support dan built-in loading spinner.
  2. `Input`: Text field dengan label, floating label opsional, helper text, error state, dan prefix/suffix icon.
  3. `Textarea`: Multi-line text area dengan auto-expand opsional dan counter karakter.
  4. `Select / Combobox`: Dropdown selection dengan fitur search filter terintegrasi.
  5. `Checkbox & Switch`: Toggle switch dan checkbox custom dengan animasi transisi halus.
  6. `Badge & StatusPill`: Indikator status (Pending, Lunas, Ditolak, Selesai) dengan palet warna kontekstual.
* **Kriteria Penerimaan**:
  - Semua form control mendukung integrasi langsung dengan `react-hook-form`.
  - Memiliki visual state lengkap: `default`, `hover`, `focus-visible`, `active`, `disabled`, `error`.

---

### 🔹 TS1-04: Komponen Kontainer & Data Presentation (Molecules)
* **Deskripsi**: Membangun komponen pengelompokan konten dan visualisasi data metrik.
* **Daftar Komponen yang Dibuat**:
  1. `Card`: Kontainer kartu modern dengan header, sub-header, action toolbar, body, dan footer.
  2. `StatsCard`: Kartu metrik ringkasan (Total Permohonan, Menunggu Pembayaran, Sertifikat Selesai) dilengkapi icon, tren persentase (+/-), dan subtitle.
  3. `Modal / Dialog`: Modal dialog berbasis overlay backdrop dengan animasi transisi masuk/keluar, keyboard `Escape` handler, dan focus lock.
  4. `Drawer / Offcanvas`: Panel geser dari sisi kanan untuk form ringkas atau filter mendalam.
  5. `Tabs`: Navigasi tab dengan garis aktif animasi halus.
  6. `SkeletonLoader`: Placeholder loading berkedip halus untuk tabel, kartu, dan teks saat data sedang di-fetch.
* **Kriteria Penerimaan**:
  - Modal dan Drawer responsif pada layar mobile maupun desktop tanpa clipping issue.

---

### 🔹 TS1-05: Enterprise DataTable Component (Organism)
* **Deskripsi**: Menggantikan ketergantungan jQuery DataTables lama dengan komponen DataTable React yang murni, cepat, dan kaya fitur.
* **Fitur Utama**:
  * Server-side & Client-side pagination.
  * Search bar global dengan debounce input.
  * Multi-column sorting (Asc/Desc).
  * Filter panel dinamis (berdasarkan tanggal, status, jenis layanan).
  * Selection checkbox baris (Bulk Action).
  * Loading skeleton saat request asynchronous.
  * Empty state yang informatif dengan CTA button.
* **Kriteria Penerimaan**:
  - DataTable dapat merender ribuan baris data dengan performa rendering 60 FPS tanpa freezing.

---

### 🔹 TS1-06: Layout Shell Modern (AppShell)
* **Deskripsi**: Membangun kerangka navigasi terpadu untuk portal yang dapat digunakan bersama oleh Pelanggan maupun Admin.
* **Fitur Utama**:
  * `Sidebar`: Desain ramping (*clean modern*), collapsible (expanded 260px vs collapsed 72px), multi-level submenu, dan indikator badge notifikasi.
  * `Navbar`: Header bar dengan tombol toggle sidebar, search bar cepat (Cmd/Ctrl + K), notification bell with unread badge popover, dan user avatar menu dengan role switch.
  * `PageHeader`: Judul halaman, subtitle penjelasan, breadcrumb otomatis, dan action button area.
* **Kriteria Penerimaan**:
  - Sidebar otomatis menjadi drawer overlay pada layar mobile (<768px).

---

## 3. Checklist Verifikasi & Testing Sprint 1
- [ ] Tailwind CSS terpasang tanpa bentrok CSS.
- [ ] Seluruh komponen di `components/ui/` memiliki TypeScript interface yang ketat (*Strict Props*).
- [ ] Pengujian aksesibilitas keyboard (Tab navigation, Escape on modal).
- [ ] Responsivitas diuji pada resolusi 375px (Mobile), 768px (Tablet), 1366px (Laptop), dan 1920px (Desktop).
