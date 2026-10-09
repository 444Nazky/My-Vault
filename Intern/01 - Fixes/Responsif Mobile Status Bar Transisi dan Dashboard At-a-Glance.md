# Fix — Responsif Mobile, Status Bar Dihapus, Transisi Bervariasi & Dashboard At-a-Glance

> **Tanggal:** 28 September 2026 (sesi sore) · **Status:** selesai & terverifikasi E2E (37/37 + 4 breakpoint)

## Lingkup

Revisi dua sisi: **aplikasi mobile** (target utama perangkat HP) dan **admin dashboard**.

---

## A. Aplikasi Mobile

### 1. Responsif — bingkai "ponsel" hanya untuk desktop

**Masalah:** seluruh layar dibungkus `w-[390px] h-[844px] rounded-[48px]` + padding `pt-16` —
di HP 360/412 px lebar bingkai meluber dan ada bayangan/border yang tidak perlu.

**Perbaikan (`src/index.css`, `App.tsx`, `MobileShell.tsx`, `MobileApp.tsx`):**

```css
.app-frame { width: 390px; height: 844px; max-height: calc(100dvh - 3rem); border-radius: 48px; … }
@media (max-width: 640px) {          /* HP / Capacitor WebView */
  .app-frame { width: 100%; height: 100dvh; max-height: none; border-radius: 0; border: 0; box-shadow: none; }
}
```

Pembungkus di `App.tsx` → `flex items-center justify-center min-h-screen p-0 sm:p-6`.

**Hasil uji (`/tmp/check-responsive.js`):**

| Breakpoint | Bingkai | Overflow X/Y |
|---|---|---|
| 360×740 (Android kecil) | full 360×740 | 0 / 0 |
| 412×915 (Pixel) | full 412×915 | 0 / 0 |
| 1024×700 (desktop pendek) | 390×652, center | 0 / 0 |
| 1440×900 (desktop lebar) | 390×844, center | 0 / 0 |

### 2. Status bar palsu dihapus

`src/pages/mobile/StatusBar.tsx` (jam + ikon Signal/Wifi/Battery) **dihapus total** —
dipakai sistem Android/iOS asli saat di-build jadi aplikasi native, jadi jangan dirender sendiri.
Berkas dihapus; impor dibersihkan dari `MobileShell` & `MobileApp`.

### 3. Opsi "Login Administrator" dihapus dari mobile

- `LoginPage.tsx`: state `adminMode`, form admin, `handleAdminLogin`, dan tombol toggle dihapus.
- `App.tsx`: build admin (`html[data-admin]`, yaitu `:8000`) **langsung menampilkan dashboard** —
  JWT admin diambil sendiri oleh dashboard via `POST /auth/admin-login`.
- `store.tsx`: sesi admin lama yang tertinggal di origin mobile (`trip.userType === 'admin'`)
  otomatis dibersihkan supaya tidak nyangkut di `:5173`.

### 4. Transisi halaman — fade diganti variasi kontekstual

Semua `animate-fade-in` di akar layar mobile dihapus (sisa: hanya pesan error).
`MobileApp.tsx` kini memelihara **stack navigasi** dan memilih animasi:

| Jenis | Kapan | Keyframe |
|---|---|---|
| `push` | maju ke layar baru | geser masuk dari kanan (0.26s) |
| `pop` | tombol kembali / layar sebelumnya | geser masuk dari kiri |
| `zoom` | detail (`camera`, `trip-summary`, `trip-complete`, `history-detail`) | scale 0.93 → 1 |
| `sheet` | form/modal (`trip-condition`, `vehicle-form`, `settings`, `pin-verify`) | naik dari bawah |
| `tab` | navigasi bottom nav (`goTab`) | turun + scale kecil |

Semua memakai `transform` + `opacity` (compositor) + `will-change` → tetap 60 FPS,
dan dimatikan pada `prefers-reduced-motion`.

**Umpan balik tombol global** (`:where()` sehingga spesifikasinya nol — kelas `active:scale`
bawaan Tailwind tetap menang):

```css
:where(button) { -webkit-tap-highlight-color: transparent; transition: transform .14s …; }
:where(button:not(:disabled):active) { transform: scale(0.96); }
```

Terverifikasi via `Input.dispatchMouseEvent`: admin `matrix(0.960185, …)` saat ditekan → `none`
saat dilepas; mobile tombol "Mulai Trip" `matrix(0.951566, …)` (memakai `active:scale-95` miliknya).

---

## B. Admin Dashboard

### 1. Halaman **Dashboard** → pusat informasi cepat (at-a-glance)

- Tabel mentah "Trip Terbaru dari Server" (10 baris) **dihapus**.
- **4 kartu metrik**: Trip Hari Ini · Pendapatan Hari Ini · Unit Hari Ini · Petugas Aktif
  (data dari `GET /reports/summary?startDate=today&endDate=today` + daftar petugas).
- **Tabel ringkas 5 trip terbaru** dengan badge `REAL-TIME`, refresh otomatis **tiap 15 detik**
  + tombol Refresh manual + chip status server + stempel "diperbarui HH:MM WIB".
- Data mentah dipindahkan ke tab **Laporan** (ada tombol "Buka Laporan →").

Contoh nilai nyata: Trip Hari Ini `2` · Pendapatan `Rp 555.000` · Unit `4` · Petugas Aktif `9/9`.

### 2. Halaman **Laporan** → data + analitik

- **Filter tanggal**: input *Dari* / *Sampai* (`type=date`) + preset `Hari Ini` · `7 Hari` · `30 Hari`,
  plus filter **Golongan** & **Jenis Kendaraan** yang tetap di atas.
  Backend hanya menerapkan filter bila `startDate` **dan** `endDate` ada — frontend otomatis
  melengkapi (`endDate` → hari ini, `startDate` → `1970-01-01`) supaya pilihan satu sisi tetap berlaku.
- **Grafik analitik di atas tabel** (ikut terfilter):
  1. **Trip per Hari** — bar chart maksimal 14 hari, label nilai + tooltip.
  2. **Komposisi Muatan** — donut `conic-gradient` (Ada Muatan vs Kosong) + persentase.
  3. **Trip per Wilayah** — bar horizontal sebaran trip per pos.
- Kartu ringkasan + tabel grid (sticky header, zebra, expand detail, tfoot total) tetap ada.
- **Ekspor Excel** kini ikut mencantumkan baris `Rentang Tanggal`.

### 3. Halaman **Petugas**

- `SBDZ` & `SJRE` disembunyikan dari seluruh bagian halaman (grup wilayah, form tambah/edit)
  — keduanya pos/dermaga lama, **bukan wilayah maupun dermaga petugas**.
  Grup "Lainnya" disediakan sebagai jaring pengaman bila ada petugas tanpa wilayah terlihat.
- Chip **Rute yang Tampil** memakai **nama rute** (mis. `Sijangkung → Sabadi`),
  bukan kode pos `SJRE → SBDZ`.
- Grup hasil uji: `BADAU (4) · BELITUNG (2) · ENTIKONG (1) · KELAPAKAMPIT (2)`.

### 4. Wilayah **Entikong** (seed backend `SPEC_WILAYAH`)

| Dermaga | Rute 1 | Rute 2 |
|---|---|---|
| Dermaga 1 | `A4A4 → B8B8` | `B8B8 → A4A4` |
| Dermaga 2 | `C3C3 → D6D6` | `D6D6 → C3C3` |

Dermaga 2 dibuat otomatis (sebelumnya Entikong hanya punya D1 + rute placeholder `A→B` yang
dibersihkan karena tidak dipakai trip mana pun). Terverifikasi: `POST /auth/region-login`
`ENTIKONG/entikong123` → Rizky Maulana (D1) → `GET /routes/mine` mengembalikan 2 rute tersebut.

### 5. Ubah nama rute

Sudah didukung sejak tab Master Rute (`input Nama Rute` → `PUT /routes/:id`); diverifikasi ulang:
form edit terbuka dengan nilai terisi (`Sabadi → Sijangkung`), tidak `disabled`, tombol `Update` ada.

---

## Verifikasi

`tsc` 0 error · `ng lint` pass · `ng build` sukses · `www/` → `admin-ci/` sinkron ·
E2E Chromium **37/37** (`/tmp/verify-mobile-admin.js`) · responsif **4/4 breakpoint**
(`/tmp/check-responsive.js`) · umpan balik tekan tombol (`/tmp/check-press.js`).

Screenshot: `/tmp/mobile-final.png`, `/tmp/admin-dashboard.png`, `/tmp/admin-petugas.png`,
`/tmp/admin-laporan.png`.

Terkait: [[Dev Server Masih Berjalan dari Folder Terhapus]] · [[Build admin-ci Tanpa File Bundle]]
