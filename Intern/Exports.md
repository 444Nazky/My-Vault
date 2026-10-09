# Export APK - Trip Angkutan

## Status

Berhasil dipastikan: proyek ini dapat menghasilkan APK Android debug dengan Java 21.

Tanggal verifikasi: 2026-10-05

Path APK hasil build:

- `/home/nazky/Documents/Obsidian Vault/Intern/Trip-Angkutan.apk` (salinan siap dipindahkan ke ponsel)
- `/home/nazky/RPL/Intern/mobile-trip Mobile Branch/android/app/build/outputs/apk/debug/Aplikasi Trip-debug.apk` (output asli Gradle)

## Prasyarat

- Node.js 22+
- npm
- Android SDK di `/home/nazky/android-sdk`
- JDK 21 (pakai Java 21, bukan Java 17/26)
- Android Studio / emulator optional untuk testing

## Setup yang berhasil dipakai

```bash
export JAVA_HOME=/home/nazky/.jdks/jbr-21.0.11
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME=/home/nazky/android-sdk
export ANDROID_SDK_ROOT=/home/nazky/android-sdk
```

## Build APK dari root project

```bash
cd "/home/nazky/RPL/Intern/mobile-trip Mobile Branch"
npm ci
npm run build
npx cap sync android
cd android
./gradlew assembleDebug
```

## Hasil build

APK akan dibuat di:

```bash
/home/nazky/RPL/Intern/mobile-trip Mobile Branch/android/app/build/outputs/apk/debug/Aplikasi Trip-debug.apk
```

## Install ke device

### Salin lewat kabel USB

1. Sambungkan ponsel Android ke komputer.
2. Pilih **File transfer** / **Transfer files** pada notifikasi USB di ponsel.
3. Salin `Trip-Angkutan.apk` dari folder `/home/nazky/Documents/Obsidian Vault/Intern/` ke folder `Downloads` di ponsel.
4. Buka file APK dari aplikasi Files/Downloads.
5. Jika diminta, izinkan aplikasi Files memasang aplikasi dari sumber ini, lalu pilih **Install**.

### Install langsung via USB debugging

```bash
adb install "/home/nazky/Documents/Obsidian Vault/Intern/Trip-Angkutan.apk"
```

### Ke emulator

```bash
adb devices
adb install "/home/nazky/Documents/Obsidian Vault/Intern/Trip-Angkutan.apk"
```

## Catatan penting

1. Proyek ini awalnya gagal karena Gradle memakai Java 26 / Java 17 yang tidak sesuai dengan build toolchain.
2. Build berhasil ketika memakai JDK 21.
3. Pengaturan development server `http://10.0.2.2:8100` sudah dihapus dari `capacitor.config.ts`, lalu APK dibuild ulang agar aplikasi memakai file web yang tertanam dan tidak bergantung pada server development.
4. APK yang ada di folder `Documents/Obsidian Vault/Intern/` adalah debug APK untuk pemasangan/testing langsung; distribusi resmi memerlukan release APK yang ditandatangani.

## Command cepat untuk build ulang

```bash
cd "/home/nazky/RPL/Intern/mobile-trip Mobile Branch"
export JAVA_HOME=/home/nazky/.jdks/jbr-21.0.11
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME=/home/nazky/android-sdk
export ANDROID_SDK_ROOT=/home/nazky/android-sdk
npm run build
npx cap sync android
cd android
./gradlew assembleDebug
```

## Link project

- Project root: `/home/nazky/RPL/Intern/mobile-trip Mobile Branch`
- Android project: `/home/nazky/RPL/Intern/mobile-trip Mobile Branch/android`
