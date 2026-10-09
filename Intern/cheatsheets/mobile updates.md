# Mobile Updates Cheatsheet

Cara kirim update ke aplikasi mobile Trip Angkutan (Ionic/React + Capacitor).
Verifikasi: 2026-10-08. Repo: `https://github.com/444Nazky/Aplikasi-Trip-Ionic`.

> Folder kerja aktual: `/home/nazky/RPL/Intern/mobile-trip Mobile Branch`
> (nama folder ada spasi — selalu pakai tanda kutip).

---

## 0. Tiga jalur update

| Cara                                             | Kapan                                 | Rebuild APK? |
| ------------------------------------------------ | ------------------------------------- | ------------ |
| **OTA (git)** — `npm run ota:publish`            | Update web assets saja (React/TS/CSS) | Tidak        |
| **OTA (API token)** — `npm run ota:publish:api`  | Sama, tapi pakai GitHub API token     | Tidak        |
| **APK penuh** — lihat [[../Exports\|Exports.md]] | Ubah native/Capacitor/plugin          | Ya           |

---

## 1. Build (WAJIB sebelum apa pun)

```bash
cd "/home/nazky/RPL/Intern/mobile-trip Mobile Branch"
npm run build          # = ng build && node scripts/organize-build.mjs
```

- `npm run build` memindahkan bundle ke `www/assets/js/` & `www/assets/css/` **dan
  memverifikasi** tiap referensi `index.html` + impor chunk. Gagal verifikasi → exit 1.
- Jangan pakai `ng build` mentah untuk deploy — strukturnya belum dirapikan
  (pakai `npm run build:raw` hanya untuk inspeksi cepat).

Cek lokal sebelum kirim:

```bash
npx tsc --noEmit -p tsconfig.json   # 0 error
npm run test:unit                   # vitest, harus lulus
```

---

## 2. OTA via Git (tanpa token) — cara utama

```bash
npm run build
npm run ota:publish
```

> **Auto (seperti Netlify) sejak 2026-10-08:** `.github/workflows/ota-publish.yml`
> menjalankan `tsc + npm run build + npm run ota:publish` otomatis setiap `git push`
> ke branch **`mobile`**. Jadi cukup push kode → aset OTA terbit sendiri.
> Commit bot OTA memakai `[skip ci]` agar tidak loop. Cek: GitHub → Actions →
> "OTA Publish (mobile)".

`scripts/publish-ota-git.mjs` melakukan:

1. `git fetch origin mobile` + worktree sementara ke `origin/mobile`
2. buang chunk lama di root & `assets/js` `assets/css` `ota`
3. salin `www/` → `ota/` **dan** ke root (kompatibilitas app lama)
4. tulis `version.json` (`version` = `Date.now()` sebagai string angka naik)
5. commit `chore(ota): bump version to <ts>` lalu `git push origin HEAD:mobile`

Butuh kredensial git lokal yang sudah tersimpan (credential helper). Tidak ada
perubahan aset → script skip push.

> **Guard anti-kosong (2026-10-08):** kedua script publish kini **abort dengan
> `exit 1`** bila `www/` tak memuat `index.html` — mencegah `version.json` naik
> dengan `assets: []` yang bikin perangkat tak tertarik sama sekali. `npm run build`
> WAJIB jalan dulu.

---

## 3. OTA via API token (opsional)

```bash
npm run build
GITHUB_TOKEN=ghs_xxx npm run ota:publish:api
# atau: node scripts/publish-ota-version.js --token=ghs_xxx
```

`scripts/publish-ota-version.js` meng-upsert `version.json` ke GitHub content API
(branch `mobile`). Pakai bila git push tidak tersedia.

---

## 4. Bagaimana aplikasi mengambil OTA

Diambil dari branch `mobile` via raw GitHub (lihat `src/services/ota.ts`):

```
Manifest : https://raw.githubusercontent.com/444Nazky/Aplikasi-Trip-Ionic/mobile/version.json
Assets   : https://raw.githubusercontent.com/444Nazky/Aplikasi-Trip-Ionic/mobile/ota/
```

- `version.json` berisi `{ version, assets: [...] }`.
- Perangkat menyimpan hasil unduhan + `sw.js` (Cache Storage `trip-ota-active`).
- Update diterapkan otomatis; notifikasi lewat `src/components/UpdateNotifier.tsx`.
- OTA menandai `trip.sync.forceRoster` → roster petugas ditarik paksa saat sync
  berikutnya (kredensial terbaru dari admin).

> `version-checker.ts` & `ota-downloader.ts` di root sudah **dihapus** (dead code dari sesi
> audit ponytail, 2026-10-08). Yang live hanya `src/services/ota.ts`.

---

## 5. Export APK (folder native berubah)

Lihat panduan lengkap di [[../Exports|Exports.md]]. Intinya:

```bash
cd "/home/nazky/RPL/Intern/mobile-trip Mobile Branch"
export JAVA_HOME=/home/nazky/.jdks/jbr-21.0.11
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME=/home/nazky/android-sdk
export ANDROID_SDK_ROOT=/home/nazky/android-sdk
npm run build
npx cap sync android
cd android && ./gradlew assembleDebug
# → app/build/outputs/apk/debug/Aplikasi Trip-debug.apk
```

Wajib rebuild APK bila mengubah plugin Capacitor, `capacitor.config.ts`, ikon,
atau kode native. Untuk perubahan web saja, cukup OTA.

---

## 6. Git workflow (branch `mobile`)

```bash
git checkout mobile
git add .
git commit -m "fix: ..."
git push origin mobile
```

- OTA = update aset web tanpa APK baru (langsung ke pengguna).
- `main` = jalur lain; branch OTA & publish = **`mobile`**.

---

## 7. Verifikasi cepat

| Cek | Perintah |
| --- | --- |
| Endpoint API hidup | `curl -s -o /dev/null -w "%{http_code}\n" https://aplikasi-trip-api-production.up.railway.app/api/health` → `200` |
| Manifest OTA terpasang | buka `.../mobile/version.json` (ada `version` + `assets`) |
| Typecheck | `npx tsc --noEmit -p tsconfig.json` |
| Unit test | `npm run test:unit` |
| Build rapi | `npm run build` (exit 0 + "Verifikasi lulus") |

---

## 8. Troubleshooting

| Gejala | Sebab / Solusi |
| --- | --- |
| Update tidak tertarik (paling sering!) | `version.json` terpublish dengan `assets: []` karena `ota:publish` jalan tanpa build, lalu app skip unduh. Jalankan `npm run build && npm run ota:publish` → asset re-terpublish |
| Update tidak terdeteksi | `version.json` tidak berubah / belum di-push ke `mobile`. Jalankan ulang `npm run ota:publish`. |
| White screen setelah update | Bundle rusak — cek `npm run build` lulus verifikasi sebelum publish. `organize-build.mjs` memindahkan chunk sekaligus agar impor relatif tetap valid. |
| `git push` OTA ditolak | Kredensial git lokal kadaluwarsa → login ulang, atau pakai `ota:publish:api` dengan token. |
| APK lama tetap jalan | Perubahan itu native → OTA tidak cukup, rebuild + install APK ([[../Exports\|Exports.md]]). |
| Login offline kehilangan petugas baru | Naikkan `SEED_VERSION` di `src/services/seedData.ts` ATAU pastikan perangkat online agar `forceRoster` menarik dari admin. |
| Cache basi di perangkat | Settings → "Bersihkan Cache" / `localStorage.clear()`. |

---

## 9. File penting

| File | Fungsi |
| --- | --- |
| `src/services/ota.ts` | Ambil manifest + unduh + terapkan OTA |
| `src/services/sync.ts` | Antrean kirim trip (postMultipart, backoff, watchdog) |
| `src/services/api.ts` | HTTP client, base URL |
| `src/services/seedData.ts` | Seed kredensial offline bawaan |
| `src/components/UpdateNotifier.tsx` | UI notifikasi update |
| `scripts/organize-build.mjs` | Rapikan + verifikasi struktur `www/` |
| `scripts/publish-ota-git.mjs` | Publish OTA via git (`ota:publish`) |
| `scripts/publish-ota-version.js` | Publish OTA via API token (`ota:publish:api`) |
| `version.json` | Manifest OTA (version + daftar aset) |

## 10. URL lingkungan

| Lingkungan | URL |
| --- | --- |
| Railway API | `https://aplikasi-trip-api-production.up.railway.app/api` |
| Repo GitHub | `https://github.com/444Nazky/Aplikasi-Trip-Ionic` |
| Manifest OTA | `https://raw.githubusercontent.com/444Nazky/Aplikasi-Trip-Ionic/mobile/version.json` |
