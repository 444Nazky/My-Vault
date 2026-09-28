# Trip Angkutan Plantation — Documentation Index

> **Terakhir diperbarui:** 25 September 2026
> ⚠️ **Baca dulu:** dokumen di bawah dikelompokkan jadi **🟢 aktual** (ikuti ini) dan
> **⚪ arsip rancangan awal** (stack lama: Firebase/Flutter/PostgreSQL/Vue — hanya arsip desain).

---

## 🟢 Dokumen Aktual (ikuti ini)

### Inti

| File | Description |
|------|-------------|
| [requirements/functional.md](functional.md) | **Kebutuhan fungsional sesuai implementasi nyata** |
| [../summary/Summary.md](Dokumentasi.md) | Ringkasan sistem + daftar bug diperbaiki & masalah terbuka |
| [Additionals/Todo.md](Additionals/Todo.md) | Status tiap permintaan revisi + audit error |

### Teknis

| File | Description |
|------|-------------|
| [api/00-overview.md](API%20Documentation%20Overview.md) | Endpoint API + aturan akses |
| [database/00-overview.md](Intern/Aplikasi-Trip/database%20&%20api's/#%20Database%20Schema%20Overview.md) | Skema DB aktual (SQLite) |
| [ionic/00-overview.md](ionic/00-overview.md) | Struktur proyek mobile & perintah build |
| [ionic/screens.md](ionic/screens.md) | Daftar layar + alur navigasi |
| [ionic/offline-sync.md](ionic/offline-sync.md) | Strategi offline-first (konsep berlaku, implementasi localStorage) |
| [edge-cases/handling.md](Edge%20Cases%20&%20Error%20Handling.md) | Pesan error & penanganan kasus |
| [architecture/step-by-step-flow.md](architecture/step-by-step-flow.md) | Alur data mobile → backend → dashboard |

---

## ⚪ Arsip Rancangan Awal

> Dokumen ini ditulis **sebelum** stack final dipilih. Nilainya sebagai arsip desain/relasi magang.
> **Jangan jadikan acuan teknis** — lihat [requirements/functional.md](functional.md) untuk kenyataan.

| File | Description | Catatan |
|------|-------------|---------|
| [01-penjelasan.md](01-penjelasan.md) | Penjelasan lengkap untuk mentor | naratif awal |
| [02-konsep.md](02-konsep.md) | Konsep dan arsitektur sistem | naratif awal |
| [architecture/use-case.md](architecture/use-case.md) | Use Case Diagram | tetap valid secara fungsional |
| [architecture/dfd.md](architecture/dfd.md) | Data Flow Diagram | tetap valid secara fungsional |
| [architecture/database-linking.md](architecture/database-linking.md) | Database integration diagram | **PostgreSQL — belum dipakai** |
| [firebase/auth.md](auth.md) | Firebase Authentication | **tidak dipakai** (realita: JWT) |
| [methodology/waterfall.md](methodology/waterfall.md) | Development process (14 minggu) | metodologi |
| [mockups/screens.md](mockups/screens.md) | Wireframe screens | arsip visual |
| [design-skills.md](Intern/Aplikasi-Trip/Extras/design-skills.md) | Spesifikasi desain UI | label bisa tidak sinkron |
| [README.md](README.md) | Indeks ini | — |

---

## Quick Summary

**Project:** Sistem Informasi Angkutan Plantation
**Tujuan:** Digitalisasi pencatatan angkutan di perkebunan

### Komponen Sistem (REALITA — 25 Sep 2026)

| Komponen | Teknologi | Lokasi |
|----------|----------|---------|
| Mobile App | **Ionic + React + Tailwind** | `Aplikasi-Trip-Ionic/src/pages/mobile/` |
| Admin Dashboard | **React build → statis, disajikan CodeIgniter** | `Aplikasi-Trip-Ionic/admin-ci/` |
| Backend API | **Node.js + Express** | `Aplikasi-Trip-Ionic/backend/src/` |
| Database | **SQLite via sql.js** | `Aplikasi-Trip-Ionic/data/trip.db` |
| Autentikasi | **JWT (HS256, 24 jam)** — bukan Firebase Auth | `backend/src/middleware/auth.js` |

> **Arsip:** versi rancangan menyebut Vue.js / Laravel / PostgreSQL / Firebase Storage.
> Itu **tidak jadi** — lihat [requirements/functional.md](functional.md).

### Fitur Utama (sudah diimplementasikan)

- Login admin (username/password) & petugas (ID + PIN 6 digit)
- Alur trip: **pilih muatan dulu** → trip kosong **rute dikunci SJRE → SBDZ**
- Input kendaraan multi-unit + **foto kamera wajib** (galeri dimatikan)
- Cek status plat via OCR → Internal = 0 · Lokal = cadangan · Eksternal = tarif region
- Antrian sync offline → `POST /trips` + `/trips/:id/vehicles`
- Admin: master tarif, master plat, petugas (aktif/nonaktif + pindah region), laporan + **ekspor xlsx**, filter golongan & jenis kendaraan, tema (terang/gelap/font/aksen)

### Alur Data (aktual)

```
Mobile (React)                      Backend (Express)              SQLite
    │                                    │                            │
    │── login PIN / admin ─────────────>│── bcrypt + JWT ────────────>│ officers, regions
    │<── token + daftar petugas ────────│                            │
    │                                    │                            │
    │── pilih muatan → rute ───────────>│ (lokal di store)            │
    │── foto kamera + input kendaraan ─>│ (lokal, antrian sync)       │
    │                                    │                            │
    │── sync queue ────────────────────>│── INSERT trips ────────────>│ trips
    │                                    │── INSERT vehicles ─────────>│ vehicles
    │<── 201 / error ───────────────────│                            │
    │                                    │                            │
Admin (React di admin-ci)              │                            │
    │── GET /reports/trips ────────────>│── JOIN regions/officers ───>│
    │<── data + nama tempat + jam WIB ──│                            │
    │── ekspor .xlsx (client-side)      │                            │
```

### Database Linking (arsip — PostgreSQL & Firebase Storage **belum dipakai**)

Diagram asli ada di [architecture/database-linking.md](architecture/database-linking.md).
Realitanya: satu file SQLite, foto disimpan lokal sebagai data-URL di `localStorage`.

**Durasi:** 14 minggu (Waterfall)
