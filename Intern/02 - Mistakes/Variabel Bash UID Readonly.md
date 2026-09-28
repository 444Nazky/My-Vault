# Mistake — Variabel Bash `UID` Readonly & Sesi Uji yang Tak Disiapkan

> **Tanggal:** 28 September 2026 · **Dampak:** data uji ("Uji Dermaga") tertinggal
> di database produksi sampai dibersihkan manual

## Kejadian 1 — `UID` readonly

Skrip pembersihan setelah uji E2E memakai variabel `UID`:

```bash
UID=$(curl ... | node -e "...")   # ❌
# bash: line 5: UID: readonly variable
```

`UID` adalah variabel bawaan bash (id user) yang **hanya-baca** — perintah `DELETE`
tidak jalan, petugas uji "Uji Dermaga" lolos dan masih ada di daftar petugas.

**Perbaikan:** pakai nama variabel lain (`OFFID`, `DST`, dst):
```bash
OFFID=$(curl ... )
[ -n "$OFFID" ] && curl -X DELETE .../officers/$OFFID
```

## Kejadian 2 — sesi browser tak disiapkan saat uji

Uji tab Petugas diarahkan ke `:5173`, tapi tab itu sedang **login sebagai petugas**
(localStorage berisi sesi member dari uji sebelumnya) → tombol nav admin tidak ada,
seluruh asersi gagal `NOT FOUND` padahal kodenya benar.

**Pelajaran:**
1. Sebelum uji admin, pastikan sesi benar — uji di `:8000` (sesi admin persist) atau
   `localStorage.clear()` + login ulang, dan deteksi halaman dari **tombol yang ada**
   (`Login Administrator`), bukan asumsi teks.
2. Selalu **bersihkan data uji** (petugas/rute uji) via API setelah uji —
   dan pastikan skrip pembersihannya benar-benar jalan (cek hasil `DELETE`),
   jangan hanya mengira sukses.

Terkait: [[01 - Fixes/Petugas Master Akses Dermaga dan Rute]] · [[02 - Mistakes/Skrip Uji Mengedit Baris yang Salah]]
