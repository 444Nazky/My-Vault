# Mistake — Menganggap `window.Capacitor` Ada = Perangkat Mobile

> **Tanggal:** 28 September 2026 · **Dampak:** login petugas macet total di browser
> **Muncul di:** commit `0514a59` "auth ama login" (27 Sep 21:58)

## Kesalahan 1: cek keberadaan global, bukan kondisi sebenarnya

```ts
// ❌ SALAH — selalu true di build web
(window as any).Capacitor !== undefined
```

Capacitor **selalu** mendaftarkan `window.Capacitor` di web build
(platform-nya `'web'`, `isNativePlatform() === false`). Akibatnya browser
desktop dianggap "perangkat fisik", lalu base URL API berganti ke
`deviceApiBaseUrl` (`192.168.1.100:3000`) yang tidak ada → semua request menggantung.

**Benar:**

```ts
// ✅ hanya native Android/iOS (atau UA mobile) yang dianggap perangkat fisik
if (cap?.isNativePlatform?.()) return true
if (['android', 'ios'].includes(cap?.getPlatform?.())) return true
```

**Pelajaran:** deteksi platform harus menanyakan *kondisi* (`isNativePlatform`,
`getPlatform`, UA), bukan *keberadaan* objek global. Kasus serupa: jangan pernah
`typeof window.X !== undefined` kalau library X memang selalu memasang global.

## Kesalahan 2: `fetch` tanpa timeout

Request ke host mati menggantung tanpa batas → state `loading` tak pernah
direset → UI "Memverifikasi..." selamanya **tanpa pesan error sama sekali**.

**Benar:** bungkus selalu `fetch` dengan `AbortController` + `setTimeout`
(di sini 12 detik), bersihkan di `finally`, dan ubah `AbortError` jadi pesan
yang bisa ditindaklanjuti user.

**Pelajaran:** setiap state loading wajib punya jalur kegagalan yang terlihat.
Loading tanpa timeout = bug yang menyembunyikan dirinya sendiri.

## Kesalahan 3: satu pesan error untuk semua kegagalan

Sebelumnya **semua** kegagalan login (termasuk backend mati) menampilkan
"Username atau password salah" → diagnosa jadi menyesatkan (dicurigai kredensial,
padahal jaringan).

**Benar:** bedakan pesan berdasarkan jenis error
(kredensial vs koneksi/timeout).

## Kesalahan 4 (saat pengujian): selector yang menipu

Uji otomatis awal menilai "error tidak muncul" karena selector `.bg-red-50`
juga menangkap **input** yang ikut kelas `bg-red-50` saat state error
(`innerText` kosong → dikira tidak ada). Padahal error box-nya muncul normal.

**Pelajaran:** saat cek keberadaan elemen, pilih selector yang spesifik ke
elemennya (mis. `div.bg-red-50` / teksnya), atau cek `tagName` — jangan simpulkan
"tidak ada" dari `innerText` elemen yang salah.

## Terkait

Fix lengkapnya: [[Login Stuck Memverifikasi]] · kasus dev server:
[[Dev Server Masih Berjalan dari Folder Terhapus]]
