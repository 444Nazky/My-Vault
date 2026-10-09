# 2026-10-07 — offline-db.ts TypeScript Audit & Fixes

## Ringkasan
Audit mendalam 13 bug TypeScript + 3+ error sintaks di `src/services/offline-db.ts`. Semua error TypeScript teratasi. File lain (`offline-sync.ts`) tidak disentuh.

## Masalah yang Diperbaiki

| # | Fungsi | Masalah | Perbaikan |
|----|---------|---------|-----------|
| 1 | `dbPut` | `_conn.run(...)` tidak di-`await` | Ditambahkan `await` |
| 2 | `dbGet` | Generic `T` di-cast langsung sebelum `JSON.parse` (data bisa berupa `string` | Ambil `.data` sebelum parse; tangani `null`/`undefined` |
| 3 | `dbAll` | `localStorage.key(i)` tanpa null-check + parse string sebagai `T` tanpa `JSON.parse` | Cek `key ?? ''`; parse JSON per item |
| 4 | `dbAll` | Trailing `}` duplikat di `for` loop | Dihapus |
| 5 | `dbDelete` | **Dua deklarasi fungsi identik** (trailing function copy-paste) | Satu deklarasi, satu body |
| 6 | `dbCount` | Generic `<T>` di `query()` → instantiation depth error | Dihapus generic; akses `rows[0]` langsung |
| 7 | `dbCount` | `req.onsuccess = () => res(req.result)` tanpa `as number` | Ditambahkan cast: `res(result as number)` |
| 8 | `findOfficer` | `dbAll('')` store kosong → scan seluruh storage | Ganti `''` → `'officers'` |
| 9 | `findOfficer` | Perbandingan `id` tanpa `.toLowerCase()` | Konsisten semua field → `.toLowerCase()` |
| 10 | `migrateLegacyData` | `trip?.id` tanpa kurung, `}` duplikat | Struktur ulang dengan type guard `typeof trip === 'object'` |
| 11 | `getPinHash` | Generic `query<T>` instantiation depth error | Dihapus generic; parsing manual `rows` |
| 12 | `requestPersistentStorage` | Trailing `}` duplikat | Dihapus |
| 13 | `migrateLegacyData` | `store` tidak di-cast sebagai `StoreName`, `store === 'triples'` salah ketik | `store.slice(0, -1)` sebagai `storeName` |

## Catatan: Semua fix TypeScript clean (`tsc --noEmit 0 error di `offline-db.ts`)
