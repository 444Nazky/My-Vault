# Mistake — Sinkronisasi `www/` → `admin-ci/` Tidak Lengkap (Halaman Admin Blank)

> **Tanggal:** 28 September 2026 · **Dampak:** `http://localhost:8000/` tampil **kosong total**
> (putih, `#root` berisi 0 byte) selama beberapa menit dan semua asersi uji admin gagal

## Kejadian

Setelah `ng build`, build disalin ke folder CodeIgniter dengan perintah yang **lupa menyalin
berkas bundle**:

```bash
# ❌ hanya html + assets — main-*.js & styles-*.css tertinggal
cp -r www/index.html www/assets www/3rdpartylicenses.txt www/prerendered-routes.json admin-ci/
```

Akibatnya `admin-ci/` berisi `index.html` yang menunjuk `main-XXXX.js`, tetapi file itu **tidak ada**.

## Gejala yang menipu

Diagnosa lewat CDP:

```
[LOG] error Failed to load module script: Expected a JavaScript-or-Wasm module script
      but the server responded with a MIME type of "text/html"
[EXC] ReferenceError: tailwind is not defined
nodes: 25   root innerHTML len: 0   body text: ""
```

Karena `php -S` **fallback ke `index.php`** untuk path yang tidak ditemukan, permintaan
`/main-XXXX.js` dijawab dengan halaman HTML (bukan 404). Browser menolak modul dengan MIME
salah → React tidak pernah mount → halaman kosong, **tanpa error JavaScript yang jelas**.

Tambahan kebingungan: `readlink /proc/<pid>/cwd` menunjuk folder Trash (proses `php -S` lama),
seolah server menyajikan folder yang salah. Ternyata **tidak** — diuji dengan file probe:

```
probe di admin-ci proyek  → 200 "proj-probe"     ✅ yang disajikan proyek
probe di folder Trash     → 200 HTML (fallback)  ✅ berarti bukan docroot
```

Jadi docroot PHP benar; yang rusak hanya isi folder-nya.

## Pelajaran

1. **Selalu bersihkan + salin seluruh keluaran build**, jangan hanya `index.html`:
   ```bash
   rm -f admin-ci/main-*.js admin-ci/main-*.css admin-ci/styles-*.css
   cp -r www/main-*.js www/main-*.css www/styles-*.css www/index.html \
        www/assets www/3rdpartylicenses.txt www/prerendered-routes.json admin-ci/
   ```
   (Membersihkan dulu juga mencegah **bundle lama tertinggal** — dua kali terjadi di sesi ini.)
2. **Verifikasi langsung setelah sync**, jangan hanya `ls`:
   ```bash
   curl -s http://localhost:8000/ | grep -o 'main-[A-Z0-9]*\.js'      # hash harus cocok
   curl -sI http://localhost:8000/main-XXXX.js | head -3               # harus application/javascript
   ```
3. **MIME `text/html` pada file `.js` = tidak ada file-nya**, bukan salah konfigurasi server.
   Cek keberadaan file dulu sebelum menduga routing/alias.
4. Halaman blank **bukan berarti** kode React rusak — `nodes` sedikit + tanpa exception
   menunjuk kegagalan *loading*, bukan kegagalan *runtime*.

Terkait: [[Dev Server Masih Berjalan dari Folder Terhapus]] ·
[[Responsif Mobile Status Bar Transisi dan Dashboard At-a-Glance]]
