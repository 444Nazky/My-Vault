# Trip Angkutan — Cheatsheet Hot Reload, Server & Debugging

> **Terakhir diperbarui:** 30 September 2026
> Proyek: `/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic`

## 🗂️ Peta Layanan

| Layanan | Port | Proses | Peran |
|---|---|---|---|
| Backend API | **3000** | `node src/index.js` | REST + SQLite (`backend/data/trip.db`) |
| Mobile (dev) | **5173** | `ng serve` | React app + **hot reload / live-reload** |
| Admin Dashboard | **8000** | `php -S localhost:8000` | Menyajikan build statis dari `admin-ci/` |

> [!important] Satu source, dua tampilan
> Mobile (:5173) dan Admin (:8000) memakai **kode sumber yang sama** (`src/`).
> Admin dibedakan lewat atribut `html[data-admin]` yang disuntik `admin-ci/index.php`.

---

## ⚡ Hot Reload yang Sudah Dikonfigurasi

### 1. Mobile — `ng serve` (Vite-based)
`angular.json → architect.serve.options`:

```json
"options": {
  "port": 5173,
  "host": "localhost",
  "poll": 1000,        // polling file watcher 1 detik (Linux sensitif)
  "hmr": true,         // hot module replacement
  "liveReload": true,  // refresh otomatis bila HMR tidak bisa dipakai
  "watch": true
}
```

- `poll: 1000` diteruskan Angular ke watcher build → perubahan file tetap
  terdeteksi walau inotify telat (bind-mount, filesystem jaringan, editor tertentu).
- Port/host pindah ke `angular.json`, jadi `npm start` / `npm run dev` cukup `ng serve`.

### 2. Admin — watch build → sinkron otomatis ke `admin-ci/`
Admin adalah build statis, jadi hot reload-nya memakai script:

```bash
npm run dev:admin      # ng build --watch + sinkron otomatis (jalankan saat develop)
npm run build:admin    # build sekali + sinkron lalu keluar
npm run sync:admin     # hanya salin www/ → admin-ci/ (tanpa build)
```

Alur `scripts/admin-watch.mjs`:

1. `ng build --watch` menulis ke `www/` setiap file disimpan.
2. Manifest `www/` dipolling tiap 800 ms → bila berubah, file disalin ke `admin-ci/`.
3. **Bundle basi dibersihkan otomatis** (`main-*`, `styles-*`, `chunk-*` lama),
   hanya `index.php` + `admin.log` yang dijaga.
4. `admin-ci/index.php` mengirim `Cache-Control: no-store`, jadi **refresh browser
   selalu memuat bundle terbaru** (nama file ber-hash unik tiap build).
   > [!note] Pengaman otomatis
   > Header itu sempat hilang 2× karena buffer editor lama menimpa `index.php`.
   > Kini tiap sinkron `admin-watch` mengecek dan **memasangnya kembali** bila
   > hilang (log: `header no-cache index.php dipulihkan`).

> [!tip] Cara pakai
> Biarkan `npm run dev:admin` berjalan di terminal terpisah, lalu kerja di `src/`.
> Simpan file → tunggu `Output location: …/www` di log → **refresh :8000**.

### 3. `vite.config.ts`
`ng serve` **tidak** membaca file ini (Angular menyusun konfigurasi Vite sendiri);
file itu hanya untuk tool yang menjalankan Vite langsung. Opsi `usePolling` di dalamnya
dipertahankan agar konsisten dengan `poll` di `angular.json`.

---

## 🔄 Auto-Refresh Tiap Update Kode (tanpa Ctrl+R)

| Layanan | Cara kerja | Target |
|---|---|---|
| **Mobile `:5173`** | Klien bawaan `/@vite/client` + live-reload Angular. Server kirim frame `full-reload` lewat WebSocket begitu build selesai. | **± 2–4 detik** setelah simpan file |
| **Admin `:8000`** | Klien kecil `__ADMIN_LIVE_RELOAD__` disuntik `admin-watch` ke `admin-ci/index.html`: polling `GET /` tiap **2 detik**, dibandingkan dengan bundle `main-*.js` yang sedang tampil → bila beda, `location.reload()`. | **± 2–5 detik** setelah build + sinkron |

**Syarat:** `ng serve` (mobile) dan `npm run dev:admin` (admin) harus berjalan.
Lihat `admin-watch.log` — baris `Output location: …/www` = build selesai, sesaat
kemudian halaman admin menyegarkan dirinya sendiri.

> [!tip] Ramah form
> Bila Anda sedang mengetik di kolom input, refresh tidak dipaksa — muncul tombol
> pengingat **“Build baru — klik untuk refresh”** di kanan bawah.

**Menonaktifkan:** hapus tag `<script id="__ADMIN_LIVE_RELOAD__">…</script>` dari
`admin-ci/index.html`, atau salin `www/index.html` tanpa blok itu (`npm run sync:admin`
akan memasangnya lagi — sengaja begitu agar mode develop selalu auto-refresh).
Klien ini hanya ditambahkan saat sinkron develop, bukan bagian dari source aplikasi.

---

## 🚀 Perintah Cepat

| Aksi | Perintah |
|---|---|
| Nyalakan semua layanan | `./restart-all.sh` |
| Cek status port & PID | `npm run status` |
| Mobile dev (hot reload) | `npm run dev` |
| Admin watch + sinkron | `npm run dev:admin` |
| Sinkron admin sekali jalan | `npm run sync:admin` |
| Log mobile | `tail -f mobile.log` |
| Log admin watch | `tail -f admin-watch.log` |
| Log admin PHP | `tail -f admin-ci/admin.log` |
| Log backend | `tail -f backend/backend.log` |
| Typecheck | `npx tsc --noEmit` |
| Lint | `npx ng lint` |
| Build produksi | `npm run build` |
| Bersihkan cache build Angular | `npm run cache:clean` |

---

## 🧹 Manajemen Server Lokal (Linux)

### Hentikan server dev
```bash
pkill -f '[n]g serve'      # mobile dev server
pkill -f 'admin-watch'     # watch build admin
pkill -f 'php -S'          # server PHP :8000
pkill -f 'src/index.js'    # backend :3000
```

> [!warning] Hati-hati `pkill -f`
> `pkill -f` mencocokkan **command line lengkap**, termasuk command Anda sendiri.
> Selalu pakai pola berbentuk **regex** `[n]g serve` (bukan `ng serve`) dan
> **jangan menulis kata kunci pola itu sendiri** di perintah yang sama.
> Contoh jebakan yang membunuh shell sendiri:
> ```bash
> pkill -f 'vite' && echo "vite dibunuh"   # ❌ shell ikut mati (ada kata "vite" di echo)
> ```

### Nyalakan ulang
```bash
./restart-all.sh          # backend + mobile + sync admin + PHP
# atau satu per satu:
npm run dev               # :5173
npm run dev:admin         # watch admin (opsional)
(cd backend && npm start) # :3000
(cd admin-ci && php -S localhost:8000)  # :8000
```

### Cek port
```bash
ss -ltnp | grep -E ':3000|:5173|:8000'
npm run status
```

---

## 🗑️ Pembersihan Cache (Modul & Build)

```bash
# 1. Cache build Angular (paling sering menyelesaikan build aneh)
npm run cache:clean            # = ng cache clean
rm -rf .angular/cache

# 2. Output build lama
rm -rf www dist out-tsc
npm run sync:admin             # sinkronkan lagi www → admin-ci

# 3. Cache modul Node (bila dependensi aneh / native module gagal)
rm -rf node_modules/.cache
# rm -rf node_modules && npm ci   # reinstall total (jarang perlu)

# 4. Cache browser
# DevTools (F12) → Network → ✓ Disable cache → refresh
# atau Ctrl+Shift+R (hard reload)
# atau DevTools → Application → Storage → Clear site data
```

> [!note] `www/` itu gitignored
> Folder `www/` adalah hasil build dan tidak ikut git — menghapusnya aman,
> tinggal jalankan `npm run build` / `npm run dev:admin` lagi.

---

## 🐛 Debugging — Gejala → Penyebab → Solusi

### 1. Perubahan kode tidak muncul di :5173
1. Lihat log: `tail -30 mobile.log` — ada `✘ [ERROR]`?
2. Kalau tidak ada error tapi tidak rebuild: cek proses `ss -ltnp | grep 5173`.
3. Hard refresh browser (`Ctrl+Shift+R`) / disable cache.
4. Restart: `pkill -f '[n]g serve'` lalu `npm run dev`.
5. Cache build nakal: `npm run cache:clean`.

### 2. Halaman :8000 kosong / modul JS ditolak
Penyebab klasik: **`admin-ci/` tidak punya file bundle** yang dirujuk `index.html`
(bisa terjadi kalau build disalin sebagian).
```bash
npm run sync:admin                       # salin www → admin-ci
grep -o 'main-[A-Z0-9]*\.js' admin-ci/index.html   # rujukan ada?
ls admin-ci/main-*.js                                # file-nya ada?
curl -sI http://localhost:8000/main-XXXX.js | head -1   # 200?
```

### 3. :8000 menampilkan tampilan lama
`Cache-Control: no-store` sudah dikirim `index.php`; bila masih basi:
- pastikan `npm run dev:admin` berjalan (atau `npm run build:admin`),
- hard refresh (`Ctrl+Shift+R`),
- cek ada **satu** saja `main-*.js` di `admin-ci/` (bundle basi otomatis dibersihkan
  oleh `admin-watch`; bila menumpuk: `npm run sync:admin`).

### 4. Port sudah terpakai
```bash
ss -ltnp | grep -E ':5173|:8000|:3000'
pkill -f '[n]g serve'; pkill -f 'php -S'
```
Biasanya sisa proses dev lama (sering setelah editor/shell ditutup paksa).

### 5. Build gagal: JSX / TypeScript error
```
✘ [ERROR] TS17002: Expected corresponding JSX closing tag
```
→ Ada tag pembuka tanpa pasangan (kasus nyata: `</CurrencyProvider>` hilang di
`AdminDashboard.tsx`). Perbaiki tag-nya, save → watcher auto-rebuild.
Cek cepat: `npx tsc --noEmit`.

### 6. Server jalan dari folder yang salah / hasil edit tidak pernah berubah
```bash
readlink /proc/$(pgrep -f 'ng serve' | head -1)/cwd   # harus folder proyek
```
Kalau ternyata menjalankan build dari folder lama/terhapus (mis. karena proses
tidak pernah mati setelah pindah folder), matikan lalu start ulang dari
`/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic`.

### 7. `.log` menumpuk / penuh
Log (`*.log`) sudah masuk `.gitignore`. Aman dihapus kapan saja:
`rm -f mobile.log admin-watch.log backend/backend.log admin-ci/admin.log`

### 8. Foto dokumentasi tidak muncul (thumbnail rusak / "Tidak ada foto")
```bash
# a) Foto ada di DB tapi 404 → cek folder upload vs static server
ls backend/uploads | wc -l          # yang disajikan (harus berisi)
ls backend/src/uploads 2>/dev/null  # kalau ini yang berisi = path belum sinkron
curl -sI http://localhost:3000/uploads/<file>.jpg | head -1   # harus 200

# b) Foto belum terkirim dari mobile
#    cek kolom foto: trips.foto_kosong_path / vehicles.foto_path
/home/nazky/android-sdk/platform-tools/sqlite3 data/trip.db \
  "SELECT COUNT(*) FROM vehicles WHERE foto_path!='';"
```
Semua path kini dipegang satu konstanta: **`backend/src/uploads-dir.js`** (`UPLOADS_DIR`).

### 9. Dashboard `:8000` blank (putih) padahal JS 200 OK
```bash
# Lihat exception di console (CDP):
# TypeError: Cannot read properties of undefined (reading 'VITE_API_URL')
```
→ Penyebab: `import.meta.env` / `VITE_API_URL` dipakai di `src/` — idiom Vite yang
**tidak ada** di build Angular (esbuild), sehingga modul gagal eval dan React
tidak mount. Solusi: pakai `getApiBaseUrl()` (`src/services/api.ts`) dan
`resolvePhotoUrl()` (`admin/components/PhotoViewer.tsx`).

### 10. Riwayat trip tiba-tiba kosong
Bukan crash — kemungkinan `./clear-trip-history.sh` dijalankan (dia membuat backup
dulu, **dan** merestart backend supaya hasil hapus tidak tertimpa memori sql.js).
Pulihkan:
```bash
ls -t data/backups/*.db | head -1
cp data/backups/trip_backup_20260930_095018.db data/trip.db   # contoh
./restart-all.sh
```
Cheatsheet lengkap (server + localStorage mobile + snippet perangkat fisik):
**[[Debugging/clear-trip-history]]**

---

### 11. Login gagal: `no such column: username` / "Tidak bisa terhubung ke server"
**Gejala:** halaman login mobile minta ulang terus — padahal `/api/health` 200.
**Penyebab:** kolom baru ditambahkan ke file `data/trip.db` **sementara backend
masih jalan**. Backend (sql.js) memuat DB ke **memori** saat boot lalu
menulis ulang file itu di tiap perubahan — jadi salinan lama (tanpa kolom baru)
masih dipakai, dan `SELECT username` melempar error.
**Solusi:**
1. Restart backend **setelah** ubah skema: `pkill -f 'node src/[i]ndex.js'` lalu
   `setsid nohup npm start > backend.log 2>&1 < /dev/null &` (pakai `setsid`
   agar proses tidak ikut terbunuh saat shell sesi command keluar).
2. `backend/src/db.js → migrate()` kini **idempoten**: ALTER `username` di
   `officers`/`dermagas`/`routes` (nullable) + backfill dari `name` tiap boot,
   sehingga skema selalu sinkron walau file diedit manual.
3. Schema segar (`initialize()`) juga sudah nullable — sebelumnya
   `username TEXT NOT NULL` tanpa diisi INSERT → `NOT NULL constraint failed`
   pada DB baru.
**Tanda sembuh:** `POST /api/auth/member-login` balik `token`, log backend 0 error.

### 12. Design admin dashboard "kembali seperti dulu" (rollback)
**Gejala:** Spreadsheet Live, Rekap Wilayah, galeri foto, dan navigasi tab hilang;
user minta "pull versi lama dari GitHub".
**Penyebab:** commit `76b03c4 "angular"` menimpa `src/pages/admin/AdminDashboard.tsx`
(shell split-tab 233 baris) dengan monolit 1326 baris yang tidak mengimpor `tabs/*`
→ seluruh isi `src/pages/admin/tabs/` jadi kode mati. `admin-ci/index.php` juga
kehilangan header `Cache-Control: no-store`.
**Catatan penting:** `git pull` **percuma** — `origin/main` (0 ahead/0 behind) memang
sudah berada di commit rusak itu; versi sehat hanya ada di **history** (`origin/main~1`).
**Solusi:**
```bash
git show 3f8f9ec:src/pages/admin/AdminDashboard.tsx > src/pages/admin/AdminDashboard.tsx
git checkout -- admin-ci/index.php      # header no-cache balik
npx tsc --noEmit && npx ng lint && npm run build:admin
```
Jangan revert/reset seluruh commit — di commit yang sama ada fitur baru
(`@username`, Rekap Wilayah, prefetch petugas) yang harus bertahan.
**Tanda sembuh:** nav 7 tab tampil, `#/sheet` terbuka, kartu Rekap Wilayah ada,
E2E **13/13 PASS, 0 exception**, bundle `main-H7WLK3H6.js`.

## 🧪 Verifikasi Hot Reload (30 Sep 2026)

| Uji | Hasil |
|---|---|
| `touch src/.../HomeScreen.tsx` → log rebuild | ✅ rebuild < 5 detik |
| Ubah konten teks → modul di `:5173` berubah | ✅ `Baru Sekarang-PROBE` terbaca |
| Ubah konten → `www/` rebuild → `admin-ci/` sinkron | ✅ `main-DWTWQRS5.js` → index.html ikut |
| Revert kode → bundle kembali & lama dibersihkan | ✅ `main-IEJYEV5X.js`, 1 bundle basi dihapus |
| File dummy `www/` → tersalin ke `admin-ci/` | ✅ ≤ 4 detik |
| Header `Cache-Control: no-store` di `:8000` | ✅ |
| `npx tsc --noEmit` · `npx ng lint` | ✅ 0 error · all files pass |
| `:3000` / `:5173` / `:8000` | 200 / 200 / 200 |

---

## 🧹 Pembersihan Kode Sisa (30 Sep 2026)

| File | Alasan dihapus |
|---|---|
| `index.html` (root) | Sisa proyek Vite lama — duplikat `src/index.html`, sering salah diedit |
| `global.scss` (root) | Bukan SCSS — file PostScript hasil ekspor ImageMagick (1,5 MB) |
| `dist/` | Output build Vite lama, sudah gitignored, tidak dipakai Angular |
| `admin-ci/styles-*.css`, `main-*.css`, `main-*.js` basi | 8+ bundle lama menumpuk, dibersihkan oleh `sync:admin` |

> [!warning] Anti-rollback
> Cek cepat sebelum commit: `wc -l src/pages/admin/AdminDashboard.tsx` harus **±233**
> (bukan 1300+) dan `grep -c ReportSheet src/pages/admin/AdminDashboard.tsx` **> 0**.
> Detail: [[01 - Fixes/Restore Design Admin Dashboard dari Git History]] ·
> [[02 - Mistakes/Commit Angular Menimpa AdminDashboard Split-Tab]]

> [!tip] Struktur yang dipakai
> - HTML aplikasi: **`src/index.html`** (bukan root)
> - Gaya global: **`src/global.scss`**
> - Hasil build: **`www/`** → disalin ke **`admin-ci/`**
> - Entry admin: **`admin-ci/index.php`**

---

## 🔌 MCP (Model Context Protocol) — Cek & Debug

### Kesehatan server (1 Okt 2026 — semua ✔)

```bash
claude mcp list          # health check semua server
claude mcp get <nama>    # detail satu server
claude mcp login figma   # OAuth figma (butuh terminal interaktif + browser)
```

| Server | Tipe | Jumlah tool | Catatan |
|---|---|---|---|
| railway | stdio `railway mcp` | 68 | **satu-satunya** definisi (duplikat sudah dihapus) |
| vercel | HTTP | 244 | OAuth aktif |
| supabase | HTTP | 29 | dari `.mcp.json` (project) |
| figma | HTTP | 40 | OAuth diaktifkan 1 Okt 2026 ✅ |
| graphify | HTTP | 24 | |
| netlify | HTTP | 9 | |
| memory | stdio npx | 9 | |
| obsidian | stdio npx | 2 | **perlu patch** lihat #14 |
| pdf | stdio | 9 | |
| sequential-thinking | stdio npx | 1 | |

> Framer **bukan server MCP** — hanya CLI + skill (`npx @framer/agent setup`
> sudah dijalankan, 2 skill terpasang). Entri MCP framer yang rusak sudah dihapus.

### 13. Error `No such tool available: mcp__railway__get-project`

**Gejala:** Claude Code memanggil tool railway yang tidak ada.
**Penyebab:** model **mengarang nama tool** — terpicu deskripsi tool Netlify
(`get-project, get-project...`) di prompt yang sama. Tool railway yang benar:
`list-projects`, `describe-service`, `get-status` (68 tool, tidak ada `get-project`).
**Solusi:** arahkan ke `mcp__railway__list-projects`; kalau model mengulang,
restart sesi (`/exit` lalu `claude -c`).
**Pencegahan:** jangan menyebut nama tool di prompt yang tidak diverifikasi dulu
(`claude mcp get <server>` untuk daftar resmi).

### 14. MCP tidak muncul di sesi / terlambat connect

**Gejala:** `claude mcp list` ✔ Connected, tapi di sesi model bilang
tool tidak tersedia (atau event `init` berisi 0 tool server itu).
**Penyebab:** server connect **async** — `init` terkirim sebelum selesai spawn.
**Solusi:**
- Sesi `-p` (headless): izinkan tool `WaitForMcpServers`, suruh model memanggilnya dulu
- Sesi interaktif: tunggu indikator MCP selesai / cek `/mcp`
- Verifikasi tool resmi: `claude mcp get <nama>`

### 15. Obsidian MCP: `ENOENT ... /documents/obsidian vault`

**Gejala:** semua path vault lowercase di log (`/home/nazky/documents/obsidian vault`)
di Linux yang case-sensitive → ENOENT.
**Penyebab:** bug paket `mcp-obsidian@1.0.0` — `normalizePath()` memanggil
`.toLowerCase()` pada seluruh path (`dist/index.js` baris 19-21).
**Solusi (2 lapis, sudah diterapkan):**
1. Patch cache npx: hilangkan `.toLowerCase()` di
   `~/.npm/_npx/*/node_modules/mcp-obsidian/dist/index.js`
2. Symlink pengaman (kalau cache ter-wipe paket original tetap jalan):
   `ln -s "/home/nazky/Documents/Obsidian Vault" "/home/nazky/documents/obsidian vault"`
**Verifikasi:** `search_notes query 'deployment'` → mengembalikan file vault ✅

### 16. Konfigurasi MCP duplikat (konflik OAuth)

**Gejala:** warning `[Conflicting scopes]` saat `claude mcp list`.
**Penyebab:** satu server didefinisikan di banyak scope dengan endpoint berbeda
(OAuth disimpan per-endpoint → token tidak saling berlaku).
**Solusi:** `claude mcp remove <nama> -s <scope>` untuk duplikatnya,
pertahankan satu. Cek semua lokasi: top-level `~/.claude.json`, 
`projects[<path>].mcpServers`, `~/.claude/settings.json`, `<project>/.mcp.json`.
**Catatan:** top-level `~/.claude.json` (legacy, deprecated v2.0.8 — issue #16728)
masih terbaca di v2.1.286, tapi kalau suatu hari server hilang tanpa sebab:
`claude mcp add <nama> -- <command>` ulangi di scope baru.

## 🤖 Android / Capacitor — Build & Debug (2 Okt 2026)

Detail lengkap: [[Aplikasi-Trip/ionic/android-capacitor|android-capacitor]]

### 17. Gradle: `Cannot find ... languageVersion=21` lalu `invalid source release: 21`

**Gejala:** `./gradlew assembleDebug` gagal dua kali berturut-turut saat setup APK.
**Penyebab:** plugin Capacitor (capacitor-camera & capacitor-android) butuh **JDK 21**,
sedangkan mesin cuma punya JDK 8/11/17/26 (JBR Android Studio = 25). Error pertama:
toolchain 21 tidak ditemukan. Error kedua (sesudah toolchain ada): compiler JVM Gradle
(JDK 17) meng-compile source 21 → `invalid source release`.
**Solusi:**
1. `android/settings.gradle` → tambah foojay-resolver di baris paling atas
   (`plugins { id 'org.gradle.toolchains.foojay-resolver-convention' version '1.0.0' }`)
   → JDK 21 otomatis terunduh ke `~/.gradle/jdks/` tanpa sudo.
2. Build CLI dengan JAVA_HOME ke JDK 21 tsb:
   `JAVA_HOME=~/.gradle/jdks/eclipse_adoptium-21-amd64-linux.2 ./gradlew assembleDebug`
**Verifikasi:** `BUILD SUCCESSFUL` → `android/app/build/outputs/apk/debug/app-debug.apk` ✅

### 18. APK tidak mandiri karena `server.url` live-reload

**Gejala:** tidak terlihat langsung — APK hanya bisa jalan kalau `ng serve` (:8100) hidup.
**Penyebab:** `capacitor.config.ts` masih berisi sisa dev:
`server: { url: 'http://10.0.2.2:8100', cleartext: true }` → WebView memuat konten
dari dev server, bukan dari bundel `assets/public/`.
**Solusi:** `url` & `cleartext` dikomentari (hanya `androidScheme: 'https'` aktif).
Uncomment lagi hanya saat butuh live-reload.

### 19. `npx cap open android` → "Unable to launch Android Studio"

**Gejala:** `[error] Unable to launch Android Studio ... /usr/local/android-studio/bin/studio.sh`.
**Penyebab:** Capacitor mencari Studio di path default; instalasi aslinya di `/opt/android-studio`.
**Solusi:** `CAPACITOR_ANDROID_STUDIO_PATH=/opt/android-studio/bin/studio.sh npx cap open android`.
(Sudah disimpan permanen di `~/.bashrc` — 2 Okt 2026 — jadi cukup `npx cap open android`.)

**Perintah cepat build APK:**
```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic
npm run build && npx cap sync android
JAVA_HOME=~/.gradle/jdks/eclipse_adoptium-21-amd64-linux.2 ./android/gradlew -p android assembleDebug
```
