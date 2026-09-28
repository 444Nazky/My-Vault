# Trip Angkutan — Dokumentasi

## Struktur

```
Aplikasi-Trip/
├── requirements/     # Kebutuhan fungsional (sumber kebenaran)
├── database/         # Skema & API
├── ionic/            # Mobile app (layar, alur, offline)
├── architecture/     # Arsitektur & alur data
├── edge-cases/       # Error handling & kasus khusus
└── debugging/        # Bug fix & troubleshooting
```

## Mulai dari Sini

| Dokumen | Isi |
|---------|-----|
| [[functional]] | Kebutuhan fungsional (sumber kebenaran implementasi) |
| [[API Documentation Overview]] | Semua endpoint API |
| [[Intern/Aplikasi-Trip/database & api's/# Database Schema Overview]] | Skema DB aktual |
| [[ionic/screens]] | Daftar layar mobile |
| [[ionic/offline-sync]] | Alur sync offline |
| [[Edge Cases & Error Handling]] | Error handling & edge cases |
| [[architecture/step-by-step-flow]] | Alur data end-to-end |

## Setup & Debugging

| Dokumen | Isi |
|---------|-----|
| [[debugging/Port-Debug-Guide]] | Port services & restart |
| [[debugging/Sync-Connection]] | Bug: login stuck, API connection |

## Catatan Penting

1. **Kode region:** BADAU, SJRE, SBDZ, ENTIKONG (jangan ubah seedData() tanpa menyesuaikan mobile)
2. **DB tracked git:** data/trip.db ikut commit — backup terpisah
3. **After merge/restore:** `grep` for regressions (termuati 25 Sep)
4. **Stack nyata:** Ionic+React | Node+Express+sql.js | React build+CI admin

## Credentials

| Role | Username | Password | Akses |
|------|----------|----------|--------|
| Budi | budi | 123456 | BADAU - Dermaga 1 |
| Andi | andi | 123456 | BADAU - Dermaga 2 |
| Dewi | dewi | 123456 | BADAU - Dermaga 1 & 2 (dual) |
| Admin | admin | admin123 | Dashboard |
