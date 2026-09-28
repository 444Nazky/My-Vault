# Panduan Debugging ke Emulator Android (Pixel API 34)

Dokumen ini menjelaskan alur instalasi, sinkronisasi, kompilasi APK, dan debugging aplikasi Ionic **Trip Angkutan** ke emulator Android (Pixel_API_34).

---

## 1. Prasyarat Lingkungan

Pastikan variabel environment mengarah ke Android SDK dan Java 17:

```bash
export ANDROID_HOME=/home/nazky/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$JAVA_HOME/bin:$PATH
```

Cek device emulator yang terhubung:
```bash
adb devices
# Output yang diharapkan:
# emulator-5554   device
```

Jika emulator belum menyala:
```bash
emulator -avd Pixel_API_34 -netdelay none -netspeed full &
```

---

## 2. Sinkronisasi Web Assets ke Android (Capacitor)

Setiap ada perubahan kode sumber Angular/Ionic di `src/`:

```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic

# 1. Build bundle web (menghasilkan folder www/)
npm run build -- --configuration development

# 2. Sinkronkan asset & konfigurasi ke folder android/
npx cap sync android
```

---

## 3. Kompatibilitas Java 17 Toolchain

Capacitor v7 secara bawaan meminta Java 21 pada plugin Gradle. Karena lingkungan menggunakan Java 17, pastikan kesesuaian target JVM berikut telah diatur:

1. Di `android/app/build.gradle`:
   ```groovy
   android {
       compileOptions {
           sourceCompatibility JavaVersion.VERSION_17
           targetCompatibility JavaVersion.VERSION_17
       }
   }
   ```
2. Di `android/app/capacitor.build.gradle`:
   ```groovy
   compileOptions {
       sourceCompatibility JavaVersion.VERSION_17
       targetCompatibility JavaVersion.VERSION_17
   }
   ```
3. Di module plugin (`@capacitor/*/android/build.gradle`):
   - Ubah `JavaVersion.VERSION_21` -> `JavaVersion.VERSION_17`
   - Ubah `jvmToolchain(21)` -> `jvmToolchain(17)`

---

## 4. Kompilasi & Build APK Debug

Gunakan Gradle wrapper yang telah terpasang di folder `android/`:

```bash
cd /home/nazky/RPL/Intern/Aplikasi-Trip-Ionic/android

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export ANDROID_HOME=/home/nazky/android-sdk

./gradlew assembleDebug --console=plain
```

Output APK yang dihasilkan:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

---

## 5. Install & Jalankan ke Pixel Emulator

### A. Install APK
```bash
adb -s emulator-5554 install -r android/app/build/outputs/apk/debug/app-debug.apk
```

### B. Launch Aplikasi
```bash
adb -s emulator-5554 shell monkey -p com.plantation.tripangkut -c android.intent.category.LAUNCHER 1
```

---

## 6. Live Debugging WebView (Chrome DevTools)

Aplikasi Capacitor berjalan di atas WebView (`https://localhost`). Anda dapat menginspeksi console log, state storage, network call, dan DOM secara real-time via Chromium/Chrome:

1. Buat port-forward ke WebView devtools remote:
   ```bash
   # Cari socket WebView
   adb -s emulator-5554 shell cat /proc/net/unix | grep -i webview_devtools_remote
   
   # Forward port 9222 (contoh socket process id 7132)
   adb -s emulator-5554 forward tcp:9222 localabstract:webview_devtools_remote_7132
   ```

2. Buka Google Chrome atau Chromium pada host dan kunjungi:
   ```
   chrome://inspect/#devices
   ```
   atau periksa target inspeksi via terminal:
   ```bash
   curl -s http://127.0.0.1:9222/json
   ```

3. Klik tombol **Inspect** pada halaman target `https://localhost/login` untuk membuka panel Chrome DevTools lengkap (Console, Sources, Network, Application/IndexedDB).

---

## 7. Memantau Logcat Aplikasi

Untuk melihat log native Capacitor, Network, Camera, dan GPS secara langsung:

```bash
adb -s emulator-5554 logcat -s Capacitor,Capacitor/Console,chromium,AndroidRuntime
```

---

## 8. Mengaktifkan Live Reload / Auto Reload

Untuk mempercepat pengembangan tanpa perlu build APK ulang setiap kali mengubah kode, gunakan dev server Angular/Ionic yang tetap berjalan dan arahkan Capacitor ke server tersebut.

### Metode 1: Mengarahkan `server.url` ke IP Host Emulator (`10.0.2.2`)

1. Jalankan dev server dari folder proyek yang benar:

   ```bash
   cd "/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic"
   npx ionic serve --host 0.0.0.0 --port 8100
   ```

   Jangan menjalankan perintah dari folder lain. Server harus terikat pada `0.0.0.0` agar dapat dijangkau emulator.

2. Pastikan `capacitor.config.ts` mengarah ke server yang sama:

   ```typescript
   import { CapacitorConfig } from '@capacitor/cli';

   const config: CapacitorConfig = {
     appId: 'com.plantation.tripangkut',
     appName: 'Trip Angkutan',
     webDir: 'www',
     server: {
       androidScheme: 'https',
       url: 'http://10.0.2.2:8100',
       cleartext: true,
     },
   };

   export default config;
   ```

   `10.0.2.2` adalah alamat loopback komputer host dari dalam Android Emulator. Jangan mengganti nilai ini dengan IP LAN komputer.

3. Setelah mengubah konfigurasi Capacitor, sinkronkan dan jalankan ulang aplikasi:

   ```bash
   cd "/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic"
   npx cap sync android
   adb -s emulator-5554 shell monkey -p com.plantation.tripangkut -c android.intent.category.LAUNCHER 1
   ```

4. Verifikasi server dari komputer:

   ```bash
   curl -I http://127.0.0.1:8100
   ```

   Respons yang diharapkan adalah `HTTP/1.1 200 OK`. Vite HMR juga menyediakan endpoint WebSocket pada `/@vite/client`.

5. Verifikasi koneksi dari log emulator:

   ```bash
   adb -s emulator-5554 logcat -d | rg '\[vite\] (connecting|connected)|hot updated'
   ```

   Log `[vite] connected` menandakan client live reload sudah tersambung. Perubahan pada file di `src/` akan memicu hot update tanpa build APK ulang.

### Fix untuk `net::ERR_CONNECTION_REFUSED`

Error ini berarti WebView berhasil memulai permintaan ke `http://10.0.2.2:8100`, tetapi tidak ada proses yang mendengarkan port tersebut.

1. Pastikan server masih berjalan di terminal pertama:

   ```bash
   cd "/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic"
   npx ionic serve --host 0.0.0.0 --port 8100
   ```

2. Jika terminal server menampilkan error TypeScript atau build gagal, perbaiki error tersebut terlebih dahulu. Jalankan validasi:

   ```bash
   npm run build
   ```

3. Jika port sudah digunakan proses lain, cari PID-nya:

   ```bash
   ss -ltnp '( sport = :8100 )'
   ```

   Hentikan proses lama yang tidak diperlukan, lalu jalankan ulang `npx ionic serve`. Alternatifnya, gunakan port lain dan ubah `url` di `capacitor.config.ts` serta perintah server agar keduanya sama.

4. Pastikan tidak ada perbedaan port antara server, `capacitor.config.ts`, dan URL yang ditampilkan di log:

   ```text
   server:       0.0.0.0:8100
   Capacitor:    http://10.0.2.2:8100
   emulator log: http://10.0.2.2:8100
   ```

5. Jika konfigurasi baru saja diubah, jalankan `npx cap sync android` dan restart aplikasi. Pastikan juga `cleartext: true` tetap aktif karena server development menggunakan HTTP.

### Fix terverifikasi untuk "Webpage not available" di Pixel Emulator

Jika server merespons `200` dari komputer dan koneksi TCP dari emulator berhasil, tetapi WebView tetap menampilkan `chrome-error://chromewebdata/`, periksa konfigurasi native Android. Pada proyek ini, `cleartext: true` di `capacitor.config.ts` saja tidak cukup jika atribut manifest tidak diterapkan ke `android/app/src/main/AndroidManifest.xml`.

1. Tambahkan atribut berikut pada elemen `<application>` di `android/app/src/main/AndroidManifest.xml`:

   ```xml
   android:usesCleartextTraffic="true"
   android:networkSecurityConfig="@xml/network_security_config"
   ```

2. Buat atau perbarui `android/app/src/main/res/xml/network_security_config.xml`:

   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <network-security-config>
       <base-config cleartextTrafficPermitted="true" />
   </network-security-config>
   ```

3. Sinkronkan, build dengan Java 17, pasang ulang APK, lalu restart aplikasi:

   ```bash
   cd "/home/nazky/RPL/Intern/Aplikasi-Trip-Ionic"
   npx cap sync android
   JAVA_HOME=/usr/lib/jvm/java-17-openjdk ./gradlew assembleDebug --console=plain
   adb install -r android/app/build/outputs/apk/debug/app-debug.apk
   adb shell am force-stop com.plantation.tripangkut
   adb shell am start -W -n com.plantation.tripangkut/.MainActivity
   ```

4. Verifikasi bahwa log tidak lagi memunculkan `ERR_CONNECTION_REFUSED` atau `chrome-error`, dan Vite terhubung:

   ```bash
   adb logcat -d | rg 'Capacitor: Loading app|\[vite\] (connecting|connected)|ERR_CONNECTION_REFUSED|chrome-error'
   ```

   Hasil yang berhasil berisi `Loading app at http://10.0.2.2:8100` dan `[vite] connected`.

### Fix untuk server development yang gagal membangun `src/main.ts`

Jika `ionic serve` berhenti dengan error `TS6053: File '.../src/main.ts' not found`, periksa apakah proyek sudah bermigrasi ke React. Pada proyek ini entry point yang aktif adalah `src/main.tsx`, sedangkan `angular.json` dan `tsconfig.app.json` masih menunjuk ke `src/main.ts`.

Perbarui kedua konfigurasi berikut:

```json
// angular.json
"browser": "src/main.tsx"
```

```json
// tsconfig.app.json
"files": [
  "src/main.tsx"
]
```

Jangan membuat `src/main.ts` palsu jika aplikasi sudah menggunakan React. Setelah perubahan konfigurasi, restart `npx ionic serve` dan pastikan log menampilkan `Application bundle generation complete` serta `Development server running`.

> **Catatan:** `android/app/capacitor.build.gradle` dapat dibuat ulang oleh Capacitor dan mengatur source compatibility ke Java 21. Jika environment hanya memiliki Java 17, override di `android/app/build.gradle` setelah `apply from: 'capacitor.build.gradle'` diperlukan agar build tetap berjalan.

> **Catatan saat ingin build produksi / offline:** Hapus atau beri komentar pada `url` dan `cleartext` di `capacitor.config.ts`, lalu jalankan `npm run build && npx cap sync android`. Live reload tidak digunakan pada build produksi/offline.

