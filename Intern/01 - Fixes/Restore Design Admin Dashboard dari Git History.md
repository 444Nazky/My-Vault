# Fix — Restore Design Admin Dashboard dari Git History (Bukan dari Pull)

> **Tanggal:** 1 Oktober 2026 · **Status:** selesai & terverifikasi E2E **13/13**
> **Gejala:** design admin dashboard terlihat "rollback" — Spreadsheet Live,
> Rekap Wilayah, galeri foto, dan navigasi tab hilang.

## Penyebab

Commit **`76b03c4 "angular"`** menimpa `src/pages/admin/AdminDashboard.tsx`
(shell split-tab **233 baris**) dengan versi **monolit 1326 baris** yang tidak
mengimpor `tabs/` — semua isi `src/pages/admin/tabs/*` jadi kode mati.
Detail & pelajaran: [[../02 - Mistakes/Commit Angular Menimpa AdminDashboard Split-Tab]]

> ⚠️ `git pull` **tidak bisa memulihkan** apa pun karena `origin/main` memang sudah
> berada di commit rusak tersebut (0 ahead / 0 behind).

## Perbaikan

### 1. Pulihkan **hanya file yang regression**

```bash
git show 3f8f9ec:src/pages/admin/AdminDashboard.tsx > src/pages/admin/AdminDashboard.tsx
git checkout -- admin-ci/index.php          # header Cache-Control no-store balik
```

`3f8f9ec` = `origin/main~1` — commit terakhir yang masih sehat.
**File lain tidak disentuh**, sehingga fitur baru di commit yang sama tetap utuh:

| Tetap dipertahankan | File |
|---|---|
| `@username` di tabel petugas | `tabs/OfficersTab.tsx` |
| Kartu **Rekap Wilayah** | `tabs/ReportsTab.tsx` |
| Prefetch petugas saat login | `src/pages/store.tsx` |
| `username` di type & API | `components/types.ts`, `services/officers.ts` |

### 2. Build & sinkron

```bash
npx tsc --noEmit        # 0 error
npx ng lint             # All files pass linting
npm run build:admin     # → www/ → admin-ci/ (10 bundle basi ter-prune)
                        # aktif: main-H7WLK3H6.js
```

## ✅ Verifikasi E2E (CDP, `http://localhost:8000`) — 13/13 PASS, 0 exception

| Uji | Hasil |
|---|---|
| Shell admin render (`data-admin`, nav 7 tab) | ✅ Dashboard · Master Tarif · Master Plat · Master Rute · Petugas · Laporan · Pengaturan |
| Tab **Overview** (kartu at-a-glance + trip terbaru) | ✅ |
| Tab **Petugas**: grup region + `@username` + kolom Dermaga/Rute | ✅ `BADAU (4 petugas)`, `@andipratama` |
| Tab **Laporan**: filter Golongan & Jenis Kendaraan | ✅ |
| Tab **Laporan**: **Rekap Wilayah** kembali | ✅ |
| Tab **Laporan**: ekspor **Spreadsheet** + foto dokumentasi | ✅ |
| **Spreadsheet Live** `#/sheet` (sinkron 15 detik) | ✅ |
| Master Tarif / Master Plat / Master Rute / Pengaturan | ✅ 4/4 render |
| Console exception | ✅ **tidak ada** |
| `:5173` · `:8000` · `/api/health` | 200 · 200 · `status:ok` |

Screenshot: `/tmp/admin-restored.png`

## 🛡️ Pencegahan berulang

1. **Commit terpisah** antara fitur baru dan refactor besar — jangan satu commit
   bawa perubahan lawan arah.
2. `scripts/admin-watch.mjs` sudah menjaga `admin-ci/index.php` (header no-cache +
   klien auto-refresh dipasang ulang tiap sinkron).
3. Bila editing berjalan paralel (agent/editor lain), cek `git diff` **sebelum commit**:
   pastikan `src/pages/admin/AdminDashboard.tsx` tetap < 300 baris.
4. Cek cepat kesehatan design:
   ```bash
   grep -c "ReportSheet" src/pages/admin/AdminDashboard.tsx   # harus > 0
   wc -l src/pages/admin/AdminDashboard.tsx                   # harus ~233
   ```

Terkait: [[tr]] · [[../Finished ✅]]
