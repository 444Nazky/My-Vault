# Trip Angkutan — Dokumentasi

> Terakhir diperbarui: 8 Oktober 2026

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
| [[ionic/android-capacitor]] | Build APK Android (Capacitor) + fix JDK 21 |
| [[architecture/step-by-step-flow]] | Alur data end-to-end |
| [[docs/README]] | Overview proyek |

## Setup & Debugging

| Dokumen | Isi |
|---------|-----|
| [[docs/setup]] | Instalasi & menjalankan layanan |
| [[Intern/Debugging/handling]] | Edge cases & kasus bug (dermaga_id 500, regresi istilah, dll.) |
| [[Intern/Debugging/offline-sync]] | Bug sinkron offline |

## Catatan Penting

1. **Kode region:** `BADAU` (Badau), `BELITUNG`, `KELAPAKAMPIT` + region lama `SJRE`/`SBDZ`/`ENTIKONG` — jangan ubah seed tanpa menyesuaikan mobile
2. **Master Rute (Revisi #3):** 12 rute spec dikelola dari tab **Master Rute** admin → mobile ambil via `GET /routes/mine`
3. **Login Mobile (Revisi #13):** Form username + password. Gunakan `npx ng build --configuration=development` untuk dev bundle. [[Intern/Finished ✅|#13 Revisi Total Login]]
4. **Switch Account Filter (Revisi #13):** Region SAMA + dermaga irisan wajib. Budi (D1) → hanya Andi (D1+D2) & Dewi (D1); Siti (D2) difilter.
5. **Backend tidak hot-reload:** ubah kode backend → **wajib restart** `node src/index.js` (kalau tidak: 404 aneh)
6. **DB tracked git:** `data/trip.db` ikut commit — backup sebelum migrasi
7. **Stack nyata:** React+Tailwind (build Angular CLI) | Node+Express+sql.js | CodeIgniter `admin-ci/`
8. **`clientTripId` (2026-10-08):** `POST /trips/complete` kini **upsert** — trip dengan `client_trip_id` sama di-UPDATE (edit pasca-kirim ikut terkirim), bukan diduplikat. Lihat [[../01 - Fixes/Edit Trip Terkirim Upsert clientTripId|Fixes: Edit Trip Terkirim]].
