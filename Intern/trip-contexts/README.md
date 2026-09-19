# Trip Angkutan Plantation - Documentation Index

## Core Documents

| File | Description |
|------|-------------|
| [01-penjelasan.md](01-penjelasan.md) | Penjelasan lengkap untuk mentor |
| [02-konsep.md](02-konsep.md) | Konsep dan arsitektur sistem |

## Architecture

| File | Description |
|------|-------------|
| [architecture/use-case.md](architecture/use-case.md) | Use Case Diagram |
| [architecture/dfd.md](architecture/dfd.md) | Data Flow Diagram |

## Database

| File | Description |
|------|-------------|
| [database/00-overview.md](database/00-overview.md) | ERD dan schema |

## Flutter Mobile

| File | Description |
|------|-------------|
| [flutter/00-overview.md](flutter/00-overview.md) | Struktur proyek dan implementasi |
| [flutter/offline-sync.md](flutter/offline-sync.md) | Strategi offline-first |

## API

| File | Description |
|------|-------------|
| [api/00-overview.md](api/00-overview.md) | Endpoint API documentation |

## Firebase

| File | Description |
|------|-------------|
| [firebase/auth.md](firebase/auth.md) | Firebase Authentication |

## UI/UX

| File | Description |
|------|-------------|
| [mockups/screens.md](mockups/screens.md) | Screen specifications |

## Requirements

| File | Description |
|------|-------------|
| [requirements/functional.md](requirements/functional.md) | Functional requirements |

## Methodology

| File | Description |
|------|-------------|
| [methodology/waterfall.md](methodology/waterfall.md) | Development process |

## Edge Cases

| File | Description |
|------|-------------|
| [edge-cases/handling.md](edge-cases/handling.md) | Error handling |

---

## Quick Summary

**Project:** Sistem Informasi Angkutan Plantation

**Tujuan:** Digitalisasi pencatatan Angkutan di perkebunan

**Komponen:**
1. Mobile App (Flutter) - Input data di lapangan
2. REST API (Laravel/Node.js) - Backend service
3. Web Dashboard (Vue.js) - Monitoring & laporan

**Fitur Utama:**
- Login dengan PIN 6 digit
- Input kendaraan dengan foto & GPS
- Offline-first dengan background sync
- Dashboard real-time
- Export laporan

**Teknologi:**
- Flutter, Laravel, Vue.js
- PostgreSQL, Firebase Auth
- Hive, Workmanager

**Durasi:** 14 minggu (Waterfall)
