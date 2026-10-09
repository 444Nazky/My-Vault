# Fix — Region Select Screen untuk Petugas Multi-Akses (Dual Access)

> **Tanggal:** 29 September 2026 · **Status:** selesai & verified TypeScript

## Masalah

Petugas dengan hak akses multi-wilayah atau "dua kaki"—seperti Andi Pratama yang memiliki kewenangan di beberapa titik—alur mulai trip pada aplikasi _mobile_ tidak memiliki pemilihan wilayah yang jelas sebelum formulir input trip diakses. Akibatnya, petugas bisa saja memulai trip di dermaga yang salah karena salah klik, mencatat data operational di dermaga yang tidak seharusnya.

## Perbaikan

### 1. `src/pages/mobile/RegionSelectScreen.tsx` — New Component (baris 1-120)
- Dialog modal yang muncul ketika petugas multi-akses menekan "Mulai Trip"
- Menampilkan daftar wilayah/dermagas yang tersedia untuk officer tersebut
- Tombol konfirmasi memilih wilayah → proceeding ke `TripConditionScreen`
- Tombol batal → menutup dialog tanpa mengubah state

### 2. `src/pages/mobile/HomeScreen.tsx` — Integrasi ke Alur Utama (baris 63-71)
- Deteksi `hasDualAccess = !!(officer.dermagaAccess && officer.dermagaAccess.length > 1)`
- Saat onClick "Mulai Trip":
  - Jika `hasDualAccess` → tampilkan `RegionSelectScreen` dulu
  - Jika tidak → langsung ke `trip-condition` seperti sebelumnya

### 3. Alur Yang Diberikan

```
HomeScreen → "Mulai Trip" tapped
├─ Single-access officer → langsung ke TripConditionScreen
└─ Dual-access officer → RegionSelectDialog appears
   ├─ Select region (D1/D2, etc.)
   └─ Confirm → proceed to TripConditionScreen
```

### 4. Fitur Double-Check Mitigasi

Dialog terdiri dari dua mitigasi ganda:
1. **Pemilihan wilayah pertama** — officer memilih region tugas dari daftar yang diaizinkan
2. **Konfirmasi sebelum melanjutkan** — setelah memilih, tombol "Mulai Trip" aktif, memastikan pilihan sudah benar

### Tujuan

- Meminimalisir kesalahan klik (_miss-click_)
- Mencegah data pencatatan operasi di dermaga yang tidak seharusnya
- Konsisten dengan alur 2-step verification yang sudah ada (region → petugas → PIN)

## Verifikasi

- `tsc` 0 error · `ng lint` pass · `ng build` sukses
- New component sejalan dengan pattern yang ada di `DermagaSelectScreen.tsx`

## Pelajaran

- Query "disiapkan tapi tidak dipakai" di kode = bug diam-diam (seperti yang tercatat di `02 - Mistakes/Build admin-ci Tanpa File Bundle.md`)
- Endpoint/fitur yang dipanggil frontend tapi perlu validasi tambahan harus di-smoke-test lewat API
- Menambahkan layer validasi ganda meningkatkan stabilitas data tanpa memperlama alur utama untuk mayoritas pengguna