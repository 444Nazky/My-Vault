# Trip Angkutan — Dokumentasi

> Terakhir diperbarui: 28 September 2026

## Struktur

```
Aplikasi-Trip/
├── docs/               # panduan utama: setup, alur, deploy, akses, README
├── database & api's/   # skema DB & dokumentasi endpoint (sumber kebenaran teknis)
├── ionic/              # mobile app (ringkasan, layar, offline sync)
├── architecture/       # alur data end-to-end
├── Debugging/          # troubleshooting, edge cases, port guide
└── Extras/             # arsip arsitektur/rundown/skill
```

> Struktur lama (`requirements/`, `database/`, `edge-cases/`, `debugging/`) sudah
> digabung ke folder di atas. Catatan perbaikan & kesalahan ada di level `Intern/`:
> **`../01 - Fixes/`** dan **`../02 - Mistakes/`**.

## Mulai dari Sini

| Dokumen | Isi |
|---------|-----|
| [[docs/functional]] | Kebutuhan fungsional (sumber kebenaran implementasi) |
| [[database & api's/API Documentation Overview]] | Semua endpoint API |
| [[database & api's/Database Schema Overview]] | Skema DB aktual |
| [[ionic/00-overview]] | Struktur kode mobile & backend |
| [[ionic/screens]] | Daftar layar mobile |
| [[ionic/offline-sync]] | Alur sync offline |
| [[architecture/step-by-step-flow]] | Alur data end-to-end |
| [[docs/README]] | Overview proyek |

## Setup & Debugging

| Dokumen | Isi |
|---------|-----|
| [[docs/setup]] | Instalasi & menjalankan layanan |
| [[Debugging/handling]] | Edge cases & kasus bug (dermaga_id 500, regresi istilah, dll.) |
| [[Debugging/offline-sync]] | Bug sinkron offline |

## Catatan Penting

1. **Kode region:** `BADAU` (Badau), `BELITUNG`, `KELAPAKAMPIT` + region lama `SJRE`/`SBDZ`/`ENTIKONG` — jangan ubah seed tanpa menyesuaikan mobile
2. **Master Rute (Revisi #3):** 12 rute spec dikelola dari tab **Master Rute** admin → mobile ambil via `GET /routes/mine`
3. **Login 2 langkah (Revisi #4):** wilayah+password → pilih petugas → PIN. Lihat [[../accounts and regions]]
4. **Backend tidak hot-reload:** ubah kode backend → **wajib restart** `node src/index.js` (kalau tidak: 404 aneh)
5. **DB tracked git:** `data/trip.db` ikut commit — backup sebelum migrasi
6. **Stack nyata:** React+Tailwind (build Angular CLI) | Node+Express+sql.js | CodeIgniter `admin-ci/`
