# 2026-10-08 — Edit Trip Terkirim: Upsert clientTripId & Merge updatedAt

## Masalah

Trip yang sudah terkirim, lalu diedit (ganti foto / plat nomor / jenis kendaraan),
tidak memperbarui data di dashboard admin. Status di aplikasi berubah jadi
"menunggu koneksi, tersimpan di lokal" dan tidak pernah pulih.

## Akar Masalah

| Lapis | Masalah |
| --- | --- |
| Backend `routes/trips.js` | `POST /trips/complete` hanya INSERT. Resend trip yang diedit → duplikat (sebelum guard) atau dibuang sebagai duplikat (sesudah guard). **Tidak ada jalur UPDATE.** |
| Mobile `pages/store.tsx` | `mergeTrips()` memprioritaskan `synced:true`; hasil edit (`synced:false`) ditimpa salinan lama saat rekonsiliasi localStorage ↔ IndexedDB. |

## Perbaikan

### Backend (`endpoint-trip`)

- `db.js`: migrasi kolom `trips.client_trip_id` (ALTER idempotent, aman untuk DB lama & baru).
- `routes/trips.js` `POST /trips/complete` → **upsert**:
  - `SELECT id, no_trip FROM trips WHERE client_trip_id = ?` sebelum menulis.
  - Ada → `UPDATE trips` (status muatan, rute, keterangan, foto, koordinat, waktu)
    + hapus `vehicles`/`trip_vehicles` lama lalu insert ulang dari payload →
    balas **200 `{ id, noTrip, updated: true }`**.
  - Tidak ada → INSERT baru → **201**.
- Helper `insertVehicle()` dipakai kedua jalur agar tarif master & foto konsisten.
- Verifikasi: `backend/scripts/check-client-trip-id.js` (`npm run check`) —
  boot DB sementara, pastikan kolom ada + edit memperbarui baris yang sama tanpa duplikat.

### Mobile

- `store.tsx`: tambah `Trip.updatedAt`; `patchTripPhoto` / `patchVehiclePhoto`
  menstempel `Date.now()`. `mergeTrips()` pilih `updatedAt` terbaru dulu;
  aturan `synced` hanya tie-breaker untuk data lama tanpa `updatedAt`.
- `HistoryDetailScreen.tsx`: editor inline per kendaraan (plat/jenis/golongan →
  "Simpan & Kirim") memanggil `patchVehiclePhoto` → re-queue → resend upsert.
- Test regresi: `pages/store.merge.test.ts` (3 kasus — edit dipertahankan,
  data lama tetap aman, tidak duplikat).

## Verifikasi

| Uji | Hasil |
| --- | --- |
| `npx tsc --noEmit -p tsconfig.json` | ✅ 0 error |
| `npm run test:unit` | ✅ 35 test lulus |
| `npm run build` | ✅ Sukses |
| `npm run check` (backend) | ✅ Upsert idempoten, tanpa duplikat |
| `curl /api/health` Railway | ✅ 200 |
| `POST /api/trips/complete` tanpa token | ✅ 401 (rute ada) |

## Catatan / Sisa

- `# ponytail:` upsert mengganti id kendaraan (bukan UPDATE per baris kendaraan).
  Aman untuk laporan berbasis `trip_id`; pertimbangkan UPDATE per kendaraan bila
  kelak ada referensi id kendaraan dari luar.
