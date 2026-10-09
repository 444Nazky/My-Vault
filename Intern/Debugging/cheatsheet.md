# Page Refresh — Cara Memaksa Perubahan Tampil di Browser

> ⚠️ Ini bukan cheatheet debugging jaringan atau build. Ini hanya menjelaskan mekanisme refresh browser.

---

## Masalah: Edit Sudah Benar Tapi UI Lama Tetap Tampil

Setiap kali ada perubahan kode (CSS/JS/HTML/gambar) tapi browser menampilkan UI lama. Penyebabnya hampir selalu **browser cache asset statik**.

---

## Prosedur Standar (Semua Browser)

### 1. Hard Refresh — Langkah Pertama

```
Ctrl + Shift + R          # Linux / Windows
Cmd  + Shift + R          # macOS
```

Ini kirim permintaan ulang ke server dengan `Cache-Control: no-cache` pada resource CSS/JS/image. Cocok untuk perubahan CSS, React/Vite HMR, template HTML statik.

### 2. DevTools Cache Disable — Lebih Akurat Lagi

Ini langkah DevOps/Devtools tunggal yang mengatasi semua cache di tingkat browser:

1. `F12` buka DevTools
2. **Network** tab
3. TICK ☑️ **Disable cache** ← berlaku SELAMA DevTools terbuka
4. Refresh halaman (`F5` biasa cukup, tidak perlu hard refresh)

Sekarang DevTools terbuka, browser tidak cache resource, setiap `F5` ambil ulang.

### 3. Periksa Tab Application → Storage

Jika perubahan storage (localStorage, sessionStorage) tidak berefek:

1. `F12` → **Application** tab
2. **Storage** di sidebar
3. Clear site data untuk origin ini

Atau dari Console:

```javascript
localStorage.clear()     // hapus spesifik storage
sessionStorage.clear()   // session saja
location.reload()        // reload halaman
```

---

## Per-Browser Engine

### Chromium / Chrome / Edge

| Sumber Cache | Cara Bersihkan |
|---|---|
| HTTP cache | Network tab ☑️ Disable cache + refresh |
| Service Worker | Application → Service Workers → Unregister |
| localStorage / IndexedDB | Application → Storage → Clear site data |
| Memory cache (RAM) | DevTools terbuka ☑️ Disable cache + F5 |
| Preload / Speculation Rules |chrome://preloads di address bar |

### Firefox

| Sumber Cache | Cara Bersihkan |
|---|---|
| HTTP cache | Network tab ☑️ Disable HTTP cache (permanen) |
| localStorage | DevTools Storage → Clear Storage |
| Ini browser: `about:preferences#privacy` | Cache permanen dari toolbar |

### Safari

1. **Develop → Empty Caches** ← reset memory + HTTP cache
2. DevTools Storage inspector untuk localStorage

---

## Per-Tipe Perubahan

### JavaScript / TypeScript (.tsx / .ts)

| Kondisi | Harus Diperbaiki | Cara Benar |
|---|---|---|
| ng serve (dev 5173) | Vite HMR otomatis | Refresh biasa (HMR push) |
| Build Angular | Bundel baru (hash beda) | DevTools Network ☑️ Disable cache + F5 |
| PHP serve (admin 8000) | Bundel lama di-cache | ☑️ Disable cache + F5 |

### CSS / Tailwind

DevTools open + ☑️ Disable cache. Atau purge. Hot refresh dari DevTools Style editor (perubahan live di Elements panel). Tidak perlu reload halaman penuh.

### Gambar / Asset Statik

Sumber cache berbeda dari bundle. DevTools open + Network ☑️ Disable cache + F5. Cache-control header tidak bisa diabaikan.

---

## Perbedaan Port / Layanan

| Port | Server | Watch/Reload Otomatis? |
|---|---|---|
| 5173 | Vite (`ng serve`) | ✅ Hot Module Replacement otomatis, tanpa reload |
| 8000 | PHP built-in server | ❌ Tidak watch, tidak push |
| 3000 | Node.js Express | ❌ Tidak watch, tidak push |

---

## Indikator Cache Stale

Kalau ragu apakah yang tampil sudah versi terbaru:

```
DevTools terbuka + ☑️ Disable cache + F5         # cara universal
```

Kalau ingin verifikasi teknis: lihat `Content-Length` atau `ETag` di Network tab, bandingkan dengan file di disk/server.

---

## Checklist Proses Debug Cache Penuh

1. `DevTools` terbuka — ☑️ Disable cache aktif
2. `localStorage.clear()` dari Console jika cache aplikasi salah
3. `location.reload()` dari Console (bukan F5)
4. `Ctrl + Shift + R` jika masih ada asset lama
5. DevTools Application → Clear storage jika perubahan storage tidak berefek
