# Fix — Login Stuck "Memverifikasi..."

> **Tanggal:** 28 September 2026
> **Lokasi:** `localhost:5173` → login Petugas (`budi` / PIN demo)
> **File:** `src/services/api.ts`, `src/pages/LoginPage.tsx`

## Gejala

Tombol **Masuk** berhenti di spinner `Memverifikasi...` selamanya — tidak error,
tidak masuk, tidak ada pesan apa pun di console.

## Akar masalah

Dua kesalahan menumpuk di `src/services/api.ts` (masuk lewat commit `0514a59`
"auth ama login", 27 Sep 21:58):

1. **`isMobileDevice()` salah deteksi.** Fungsi itu mengecek
   `window.Capacitor !== undefined` sebagai tanda perangkat fisik. Padahal
   Capacitor **selalu** mendaftarkan `window.Capacitor` di build web
   (`getPlatform() === 'web'`, `isNativePlatform() === false`). Akibatnya
   browser desktop dianggap HP → base URL jatuh ke `environment.deviceApiBaseUrl`
   = `http://192.168.1.100:3000/api` (host mati) bukan `localhost:3000/api`.
2. **`fetch` tanpa timeout.** Request ke host yang tidak merespon menggantung
   tanpa batas → `setLoading(false)` (di blok `finally`) tak pernah tercapai.

Bukti di CDP: request setelah klik Masuk = `POST http://192.168.1.100:3000/api/auth/member-login`
(menggantung), sementara curl langsung ke `localhost:3000/api/auth/member-login`
balas **200 + token** — backend sehat, klien yang salah alamat.

## Perbaikan

### 1. `src/services/api.ts` — deteksi mobile yang benar

```ts
function isMobileDevice(): boolean {
  // UA mobile → browser di HP/tablet (perlu IP host, bukan localhost)
  if (/Android|iPhone|iPad|iPod/i.test(navigator.userAgent)) return true
  const cap = (window as any).Capacitor
  // Hanya native (Android/iOS) yang dianggap perangkat fisik
  if (cap && typeof cap.isNativePlatform === 'function' && cap.isNativePlatform()) return true
  if (cap && typeof cap.getPlatform === 'function') {
    const platform = cap.getPlatform()
    if (platform === 'android' || platform === 'ios') return true
  }
  return (window as any).cordova !== undefined
}
```

### 2. `src/services/api.ts` — timeout 12 detik

`fetch` dibungkus `AbortController` (12s, dibersihkan di `finally`),
`res.json()` diberi `.catch(() => ({}))`, dan pesan error khusus saat abort:

> `Server tidak merespon (12 detik timeout) — periksa API <baseUrl>`

### 3. `src/pages/LoginPage.tsx` — pesan error bedakan koneksi vs kredensial

State `error` berubah dari `boolean` ke `string | null` (via helper `showError`,
tampil 4 detik). Kegagalan jaringan/timeout kini menampilkan
**"Tidak bisa terhubung ke server. Pastikan backend berjalan."** — bukan lagi
"Username atau password salah" untuk semua kasus (yang dulu menyesatkan).

## Verifikasi (E2E Chromium lewat CDP)

| Skenario | Hasil |
|---|---|
| Login benar dari state kosong | ✅ request → `localhost:3000` · `POST /auth/member-login` **200** · token tersimpan · dashboard terender |
| Login salah (`budi`/`salah-salah`) | ✅ `POST` balas **401** · error box "Username atau password salah" muncul · **tidak stuck** |
| Host mati (simulasi `deviceApiBaseUrl`) | ✅ berhenti dalam 12 detik dengan pesan timeout, bukan loading selamanya |
| `npx tsc --noEmit` · `ng lint` · `ng build` | ✅ bersih |
| Sinkron `www/` → `admin-ci/` | ✅ `:8000` menyajikan bundle berisi perbaikan, `index.php` proteksi utuh |

## Catatan

- Deteksi mobile yang benar penting juga untuk **build produksi/APK**: HP asli
  tetap terdeteksi lewat UA (`Android|iPhone|...`) dan `isNativePlatform()`.
- URL API custom tetap bisa diatur manual via Settings
  (`localStorage trip.api.baseUrl.v1`) — itu prioritas tertinggi.
- Pelajaran kesalahannya ada di [[Mendeteksi Capacitor Sebagai Perangkat Mobile]].
