# Android (Capacitor) — Setup & Build APK

> **Status:** aktif & terverifikasi — 2 Okt 2026
> **Hasil:** `android/app/build/outputs/apk/debug/app-debug.apk` (8.9 MB) ✔
> Rujukan: [[ionic/00-overview|00-overview]], [[tr|tr.md]] (debug #17–#19)

## Kondisi Proyek

Dependensi native **sudah terpasang sejak awal** — tidak perlu `ionic capacitor add android` lagi:

| Komponen | Nilai |
|---|---|
| `@capacitor/core` / `cli` | 8.5.2 |
| Plugin | app, camera, geolocation, haptics, keyboard, network, preferences, status-bar (**8**) |
| `capacitor.config.ts` | `appId: com.plantation.tripangkut` · `appName: Trip Angkutan` · `webDir: www` |
| Platform | folder `android/` sudah ada & terdaftar di `android/capacitor.settings.gradle` |
| Android Studio | `/opt/android-studio` (bukan path default `/usr/local/...`) |
| SDK | `~/Android/Sdk` — platform android-37, build-tools 36.0.0 |

## Alur Build (urutan benar)

```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic

# 1. Build web → www/
npm run build

# 2. Sinkronkan aset web + plugin ke proyek Android
npx cap sync android

# 3a. Build APK debug (CLI) — WAJIB pakai JDK 21, lihat "Fix JDK 21" di bawah
JAVA_HOME=~/.gradle/jdks/eclipse_adoptium-21-amd64-linux.2 \
  ./android/gradlew -p android assembleDebug

# 3b. ATAU buka di Android Studio (Build → Build APK)
CAPACITOR_ANDROID_STUDIO_PATH=/opt/android-studio/bin/studio.sh npx cap open android

# Hasil APK:
# android/app/build/outputs/apk/debug/app-debug.apk
```

Verifikasi ikon di dalam APK:
```bash
unzip -p android/app/build/outputs/apk/debug/app-debug.apk assets/public/index.html \
  | grep -o '<link rel="icon"[^>]*>'
# → <link rel="icon" type="image/svg+xml" href="assets/karyamasv.svg">
```

## Favicon Brand `karyamasv.svg`

Aset ada di `src/assets/karyamasv.svg` (13.5 KB, 640×640). Referensi:

| Lokasi | Perubahan |
|---|---|
| `src/index.html` | `assets/icon/favicon.png` → `assets/karyamasv.svg` (`type="image/svg+xml"`) |
| `admin-ci/index.php` **&** `archive/admin-ci/index.php` | injeksi ikon `data:,` (kosong) → `assets/karyamasv.svg` — **keduanya** harus diubah karena `start-all.sh` menyalin versi archive menimpa admin-ci |
| `www/`, `admin-ci/`, APK | ikut ter-update lewat build + `npm run sync:admin` |

> ⚠️ `archive/admin-ci/index.php` jangan dilupakan — kalau cuma `admin-ci/` yang
> diedit, `start-all.sh` akan menimpa perubahan dengan versi archive.

## 🐛 Fix Wajib (3 masalah saat setup)

### 1. `server.url` dev → APK tidak mandiri
`capacitor.config.ts` masih punya sisa live-reload:
```ts
server: { url: 'http://10.0.2.2:8100', cleartext: true }  // ❌ APK nyari dev server!
```
**Dikomentari** — APK sekarang memuat konten dari bundel (`assets/public/`) dan
jalan mandiri tanpa `ng serve`. Kalau butuh live-reload lagi, uncomment saja.

### 2. Fix JDK 21 (toolchain plugin Capacitor)
**Gejala build pertama:**
```
Cannot find a Java installation ... matching: {languageVersion=21}   ← plugin minta JDK 21
# sesudah toolchain auto-download:
error: invalid source release: 21   ← compiler JVM Gradle (17) < source (21)
```

**Fakta mesin:** JDK terpasang cuma 8/11/17/26, JBR Android Studio = 25 — **tidak ada 21**.

**Solusi (2 langkah, sudah diterapkan):**
1. `android/settings.gradle` — tambahkan **foojay-resolver** di baris paling atas
   (blok `plugins` harus statement pertama):
   ```groovy
   plugins {
       id 'org.gradle.toolchains.foojay-resolver-convention' version '1.0.0'
   }
   ```
   → Gradle **otomatis unduh JDK 21** ke `~/.gradle/jdks/` saat build pertama (tanpa sudo).
2. Build CLI dengan JAVA_HOME menunjuk JDK 21 hasil unduhan:
   ```bash
   JAVA_HOME=~/.gradle/jdks/eclipse_adoptium-21-amd64-linux.2 ./gradlew assembleDebug
   ```
   (Penting: **daemon JVM harus ≥ 21** — cukup toolchain 21 tidak cukup, modul
   `capacitor-android` meng-compile dengan compiler JVM Gradle-nya.)

**Di Android Studio tidak perlu setting apa pun** — JBR bawaan (25) ≥ 21, foojay
sudah terpasang.

### 3. `npx cap open android` salah path
```
[error] Unable to launch Android Studio ... /usr/local/android-studio/bin/studio.sh
```
**Solusi:** env var ini **sudah disimpan permanen di `~/.bashrc`** (2 Okt 2026),
sehingga cukup jalankan biasa:
```bash
npx cap open android
# Manual (kalau shell belum reload .bashrc):
CAPACITOR_ANDROID_STUDIO_PATH=/opt/android-studio/bin/studio.sh npx cap open android
```

## Perintah Cepat

```bash
# Full pipeline: build web → sync → APK
npm run build && npx cap sync android \
  && JAVA_HOME=~/.gradle/jdks/eclipse_adoptium-21-amd64-linux.2 ./android/gradlew -p android assembleDebug

# Buka Android Studio
CAPACITOR_ANDROID_STUDIO_PATH=/opt/android-studio/bin/studio.sh npx cap open android

# Cek plugin terdaftar
npx cap sync android   # → "Found 8 Capacitor plugins"
```

## Troubleshooting Lain

| Gejala | Penyebab / solusi |
|---|---|
| Build minta `languageVersion=21` lagi (jdks terhapus) | foojay re-download otomatis — hanya pastikan JAVA_HOME ke `~/.gradle/jdks/*21*` |
| APK gagal instal "inconsistent certificates" | build debug vs release beda signing — uninstall dulu atau pakai signing sama |
| Aset web di APK basi | lupa `npm run build` sebelum `npx cap sync android` |
| `compileSdk 36` belum ada di SDK | AGP auto-download karena `~/Android/Sdk/licenses` sudah ada |
