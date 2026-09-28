# 🗂️ Intern — Peta Dokumen

> **Terakhir diperbarui:** 25 September 2026 (sore)
> Status tiap dokumen ditandai: 🟢 **aktual** · 🟡 **berlaku sebagian** · ⚪ **arsip/rancangan awal**

Proyek utama: **Trip Angkutan** — aplikasi mobile (Ionic/React) + admin dashboard (CodeIgniter) + backend (Node/Express/SQLite).

---

## 🟢 Mulai dari sini (dokumen terkini)

| Dokumen | Isi |
|---|---|
| [[Dokumentasi]] | **Ringkasan utama**: arsitektur, endpoint, daftar bug yang diperbaiki, masalah terbuka |
| [[Aplikasi-Trip/Additionals/Todo]] | **Status tiap permintaan** — tabel revisi spesifikasi + audit error |
| [[functional]] | Kebutuhan fungsional sesuai implementasi nyata |
| [[API Documentation Overview]] | Semua endpoint + aturan akses (admin/officer) |
| [[Intern/Aplikasi-Trip/database & api's/# Database Schema Overview]] | Skema DB aktual dari SQLite |
| [[Aplikasi-Trip/ionic/00-overview]] | Struktur proyek mobile & perintah build |

## 🟢 Referensi operasional

| Dokumen | Isi |
|---|---|
| [[summary/Setup]] | Setup dari awal |
| [[summary/Tutorial]] | Alur sync & penjelasan teknis |
| [[summary/Akses]] | Akses/akun pengujian |
| [[Port-Debug-Guide]] | Panduan cek port & debug |
| [[summary/Deploy-Admin-CodeIgniter]] | Deploy dashboard admin |
| [[Aplikasi-Trip/ionic/screens]] | Daftar layar + alur navigasi |
| [[Edge Cases & Error Handling]] | Pesan error & penanganan kasus |
| [[Aplikasi-Trip/architecture/step-by-step-flow]] | Alur data mobile → backend → dashboard |

## 🟡 Masih berlaku sebagian (ada catatan status)

| Dokumen | Catatan |
|---|---|
| [[Aplikasi-Trip/ionic/offline-sync]] | Konsep antrian sync berlaku; implementasi localStorage (bukan Ionic Storage) |
| [[summary/Summary 1]] | Catatan isu terbuka — sebagian sudah diselesaikan |
| [[Debugging-Session]] | Log debugging sesi 25 Sep |
| [[Aplikasi-Trip/Debugging]] | Catatan bug lama |
| [[Aplikasi-Trip/design-skills]] | Spesifikasi desain UI — label & screenshot bisa jadi tidak sinkron |

## ⚪ Arsip rancangan awal (stack lama: Firebase/Flutter/PostgreSQL/Vue)

> Dokumen ini adalah **desain sebelum implementasi**. Jangan dijadikan acuan teknis —
> stack nyata ada di [[functional]].

| Dokumen | Isi |
|---|---|
| [[Aplikasi-Trip/01-penjelasan]] | Penjelasan proyek untuk mentor |
| [[Aplikasi-Trip/02-konsep]] | Konsep sistem |
| [[Aplikasi-Trip/architecture/use-case]] | Use case diagram |
| [[Aplikasi-Trip/architecture/dfd]] | Data flow diagram |
| [[Aplikasi-Trip/architecture/database-linking]] | Arsitektur linking DB (PostgreSQL — belum dipakai) |
| [[auth]] | Firebase Auth — **tidak dipakai** (pakai JWT) |
| [[Aplikasi-Trip/methodology/waterfall]] | Metodologi 14 minggu |
| [[Aplikasi-Trip/mockups/screens]] | Wireframe awal |
| [[Aplikasi-Trip/README]] | Indeks lama — lihat peringatan di dalamnya |

## 📁 Lainnya

| Dokumen | Isi |
|---|---|
| [[LAPORAN_PEKERJAAN]] | Laporan pekerjaan (proyek terpisah) |
| [[TUTORIAL_LANGKAH_KERJA]] | Tutorial langkah kerja server |
| [[Network debugging]] | Catatan debug jaringan |
| [[Intern/Aplikasi-Trip/docs/rundown]] | Task list — **proyek magang lain**, bukan Trip Angkutan |
| [[CI & Ionic]] | Catatan CI & Ionic |

---

## ⚠️ Catatan penting soal menjaga dokumentasi tetap sinkron

1. **`data/trip.db` di-track git** → perubahan data ikut ter-commit dan bisa tertimpa proses lain.
2. **Ada proses otomatis yang meng-commit/merge** — perbaikan yang hanya di working tree bisa hilang.
   Setelah merge/restore: **audit ulang** dengan `grep` (lihat Bug 4 di [[Dokumentasi]]).
3. **`restart-all.sh` memakai `pkill`** → mematikan semua layanan, jangan dipakai untuk restart sebagian.
