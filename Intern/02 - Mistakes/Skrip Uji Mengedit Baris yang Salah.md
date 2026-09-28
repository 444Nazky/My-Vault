# Mistake — Skrip Uji Mengedit Baris Salah karena Selector Ambigu

> **Tanggal:** 28 September 2026 · **Dampak:** nama rute di database berubah salah (data uji bocor ke data asli)

## Kejadian

Saat uji E2E **Master Rute**, skrip mencari baris yang mau diedit dengan selector longgar:

```js
rows.find(r => r.textContent.includes('SJRE') && r.textContent.includes('SBDZ'))
```

Kedua baris Badau D1 (`SJRE→SBDZ` **dan** `SBDZ→SJRE`) memuat kedua teks itu, jadi baris yang terklik bisa salah arah. Baris `SBDZ → SJRE` ikut ter-rename jadi "Sijangkung → Sabadi", lalu saat "kembalikan nama asli" juga salah target → data master tersimpan salah arah.

**Ini bukan bug aplikasi** — fitur edit-nya bekerja (toast ✅, persist setelah reload ✅, sinkron ke mobile ✅). Yang rusak justru data karena uji saya.

## Perbaikan Data

Dikembalikan lewat API:

```
PUT /api/routes/<id>  { "name": "Sabadi → Sijangkung", "route_from": "SBDZ", "route_to": "SJRE", ... }
```

## Pelajaran

1. **Selector baris harus unik** — pakai nilai kolom spesifik (mis. sel ke-2 = `SJRE` **dan** sel ke-3 = `SBDZ`), bukan `textContent.includes` gabungan.
2. **Uji yang mengubah data asli wajib punya langkah revert** yang selector-nya sama ketatnya dengan langkah edit.
3. Lebih aman: uji edit di data sengaja dibuat (nama uji unik `NAMA UJI ...`), lalu revert — jangan menyentuh data produksi yang labelnya mirip baris lain.

Terkait: [[Master Rute Wilayah dan Login Region]]
