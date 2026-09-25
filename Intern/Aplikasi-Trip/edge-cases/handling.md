# Edge Cases & Error Handling

> **Status:** disesuaikan dengan implementasi aktual — 25 September 2026

## Offline Scenarios

### Scenario: User creates trip without internet
1. User creates trip -> Data saved to local storage (draft & trips)
2. UI shows "Terputus (Offline mode)"
3. Antrian sync (`src/services/sync.ts`) mengirim ulang: `Network offline - queuing trips locally`
4. When connection returns -> Auto-sync triggered → `POST /api/trips`
5. Trip ditandai `synced: true`

### Scenario: App crashes mid-sync
1. App starts syncing vehicle 3
2. App crashes
3. On restart, check sync queue
4. Vehicle 1, 2 are synced
5. Vehicle 3, 4, 5 are still pending
6. Resume sync from vehicle 3

### Scenario: Backend tidak terjangkau saat sinkron petugas
1. `GET /officers/my-region` gagal → daftar lokal dipertahankan (tidak dihapus)
2. Layar Ganti Petugas menyediakan tombol **“Sinkronkan daftar petugas”** untuk tarik ulang
3. Refresh token **offline** → token lama **dipertahankan** (tidak merusak sesi)

---

## Kasus Sinkron Petugas (admin ↔ mobile)

### Scenario: Admin menonaktifkan petugas yang sedang login
1. Mobile memanggil `POST /api/auth/refresh` → server balas **401** (`Officer not found or inactive`)
2. API membuang token → sesi petugas otomatis berakhir, kembali ke layar login
3. Daftar ganti petugas menampilkan status **Nonaktif** (tombol tidak bisa diketuk)
4. Login PIN juga ditolak 401

### Scenario: Admin memindahkan akses wilayah petugas
1. `PUT /officers/:id/regions` mengganti seluruh junction `officer_regions`
2. `GET /officers/my-region` langsung berubah — petugas lama hilang dari daftar rekan se-wilayah
3. Token diterbitkan ulang dengan klaim `regionId` baru → trip berikutnya tercatat di wilayah yang benar

### Scenario: Server menolak refresh (PIN khusus / akun bermasalah)
1. Token lama **tidak dibuang** sampai token baru terbit → sesi valid tidak rusak
2. Hanya respons **401** dari server yang mengakhiri sesi

---

## OCR & Plat Nomor

| Kasus | Penanganan |
|-------|-----------|
| Foto gagal dibaca | `Gagal membaca file gambar` / `Plat tidak terbaca — silakan ketik manual` |
| Unduhan data OCR gagal (offline) | `OCR gagal (unduhan data OCR butuh internet) — ketik manual` |
| Server cek plat tidak tersedia | `Server tidak tersedia — status plat tidak bisa dicek` |
| Plat tidak terdaftar | Pilih **region asal kendaraan** manual → status dihitung ulang (lokal/eksternal) |

---

## Validasi Alur Trip

| Kasus | Penanganan |
|-------|-----------|
| Trip **Kosong** memilih rute selain SJRE→SBDZ | Diblokir — rute difilter & dikunci, rute lama di-reset saat kondisi berubah |
| Submit tanpa foto kamera | Tombol “Simpan Data Kendaraan” / “Submit Trip” `disabled` → label “Ambil Foto Kamera Dulu” |
| Unggah galeri | Tidak tersedia — hanya `capture="environment"` (kamera) |
| Kategori/detail belum lengkap | Langkah 2 (detail tambahan) tidak muncul sampai langkah 1 selesai |

---

## Location Edge Cases (RENCANA — belum diimplementasikan)
> GPS/geofencing/device binding **tidak dipakai** dalam versi ini. Bagian di bawah hanya rancangan awal.

### GPS shows location outside region
1. Detect lat/lng outside bounds
2. Show warning: "Lokasi Anda di luar area kerja"
3. User can continue anyway (logged as anomaly)

---

## Error Messages (aktual)

| Error | Message |
|-------|---------|
| No internet (sync) | `Network offline - queuing trips locally` |
| Mode offline (UI) | `Terputus (Offline mode)` |
| Server plat tak terjangkau | `Server tidak tersedia — status plat tidak bisa dicek` |
| OCR gagal | `OCR gagal (unduhan data OCR butuh internet) — ketik manual` |
| Plat tak terbaca | `Plat tidak terbaca — silakan ketik manual` |
| Gagal baca file foto | `Gagal membaca file foto.` |
| Sesi backend hilang | `Tidak ada sesi backend` |
| PIN salah / akun Nonaktif | 401 dari `/auth/login` → login ditutup (tidak fallback demo) |
| Refresh ditolak (nonaktif) | 401 `/auth/refresh` → sesi berakhir |
| Admin aksi petugas gagal sync | Toast: `Gagal sync status ke server` / `Wilayah gagal sync ke server` |
| Dashboard admin API error | State offline + tombol “Tes Ulang Koneksi” |
