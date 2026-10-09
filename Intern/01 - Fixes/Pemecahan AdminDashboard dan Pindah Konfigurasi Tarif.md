# Fix — Pemecahan AdminDashboard & Safe-Area Hero Mobile

> **Tanggal:** 28 September 2026 · **Status:** selesai & terverifikasi E2E

## Masalah

1. `src/pages/admin/AdminDashboard.tsx` sudah **>3.000 baris** dalam satu file — semua tab
   (Overview, Laporan, Petugas, Master Plat, Master Rute, Master Tarif, Pengaturan) tercampur,
   sulit dibaca & diedit developer.
2. **Konfigurasi Tarif Terpusat** (Internal/Lokal/Eksternal) berada di halaman **Master Plat** —
   tidak nyambung secara UI.
3. Hero biru di beranda mobile bisa **menabrak notch/status bar** asli saat di-build native
   (atau malah menyisakan jidat jenong kalau paddingnya kebesaran).

## Perbaikan

### 1. AdminDashboard dipecah jadi modul (`src/pages/admin/`)

```
AdminDashboard.tsx          216 baris  ← kini cuma shell: header, nav tab, state global, toast
tabs/
  OverviewTab.tsx           188        ← dashboard at-a-glance
  ReportsTab.tsx            434        ← laporan + grafik + ekspor
  OfficersTab.tsx           301        ← petugas (wilayah + dermaga)
  TariffTab.tsx             241        ← tarif region + KONFIGURASI TARIF TERPUSAT
  RoutesTab.tsx             183        ← master rute
  PlatesTab.tsx             152        ← master plat
  SettingsTab.tsx           154        ← pengaturan
components/
  types.ts, Toast.tsx, CurrencyDisplay.tsx, PhotoViewer.tsx
```

**Tidak ada file yang >1.000 baris** — terpanjang `ReportsTab.tsx` (434).

### 2. Konfigurasi Tarif Terpusat → tab **Master Tarif**

- Dipotong dari `PlatesTab`, ditempatkan di atas daftar tarif region di `TariffTab`
  supaya satu halaman = satu topik (tarif).
- Master Plat kini murni soal plat (internal/lokal/eksternal).

### 3. Safe-area hero mobile

Di `src/index.css`:

```css
.screen-scroll {
  padding-top: calc(var(--ion-safe-area-top, 0px)
                  + env(safe-area-inset-top, 0px) + 12px);
}
```

- `--ion-safe-area-top` (Ionic/Capacitor) + `env(safe-area-inset-top)` (browser/PWA)
  menyesuaikan tinggi notch otomatis saat native.
- Fallback desktop: `env = 0` → `12px + padding bawaan` ≈ **16 px** (rentang aman 12–16 px).
- `MobileShell.tsx` / `MobileApp.tsx` memakai kelas `screen-scroll` pada pembungkus layar.

## Verifikasi

| Uji | Hasil |
| --- | --- |
| `wc -l` semua file admin | maks 434 baris, total 1.989 baris (dulu 1 file 3.000+) |
| Dashboard: kartu Trip Hari Ini / Pendapatan / Petugas Aktif / 5 trip REAL-TIME | ✅ |
| Laporan: filter Golongan+Jenis, ekspor Excel, 3 grafik (Trip per Hari, Komposisi Muatan, Trip per Wilayah) | ✅ |
| Master Tarif memuat **Konfigurasi Tarif** + Internal/Lokal/Eksternal | ✅ |
| Master Plat **tidak lagi** memuat Konfigurasi Tarif | ✅ |
| Hitungan `heroTop` = 16 px, rule CSS safe-area terpasang, overflowX 0 | ✅ |
| `tsc` 0 error · `ng lint` pass · `ng build` sukses · `www/` → `admin-ci/` sinkron | ✅ |

## Pelajaran

- Setelah pindah file, **audit regresi yang tak terlihat**: gradien grafik laporan sempat
  hilang karena komponennya tak ikut terbawa saat saham kode disalin antar file.
- Teks ber-`uppercase` (kartu metrik, badge) bikin assertion skrip uji gagal palsu —
  tes pakai regex case-insensitive (`/trip hari ini/i`), jangan bandingkan string mentah.
- Grafik laporan **bukan recharts** (bar CSS + `conic-gradient`) — jangan tes dengan
  selector `.recharts-wrapper`; tes judul `h4`-nya.
