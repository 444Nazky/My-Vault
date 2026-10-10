# Offline Sync — Mobile (Capacitor)

> **Status:** aktif & terverifikasi — 9 Okt 2026
> **Rujukan:** [[ionic/00-overview|00-overview]], [[database & api's/API Documentation Overview]]

## Prinsip

1. **Offline-first** — data trip & foto disimpan lokal (localStorage + IndexedDB) sebelum retry ke server.
2. **Antrean sync** — trip yang belum terkirim masuk ke queue; retry eksponensial.
3. **Ketika online, kirim lagi** — terutama trip yang belum terkirim.
4. **Persistence flag** — saat update OTA berhasil, state persist di-flag agar 후에도 cache diterjemahkan ulang (bukan murni bergantung pada WebView cache).

## Alur singkat

1. Petugas input trip → simpan lokal + queue.
2. Jika online → proses queue.
3. Jika gagal → tahan di queue + retry.
4. Admin/backend dapat melihat trip setelah berhasil sync.

## Catatan penting

- **Endpoint backend aktif**: cek latest base URL di `src/services/api.ts` atau konfigurasi proyek terkini.
- **Online/offline detector**: jangan andalkan `navigator.onLine` saja; ada probe aktif terhadap endpoint kesehatan.

## OTA update (relevansi offline)

- Versi aplikasi sekarang menggunakan format manusiawi (contoh: `1.0.1+abcde12`) bukan timestamp mentah.
- Setelah update OTA berhasil, **bundle lama otomatis dibuang** dari penyimpanan internal + Cache Storage, sehingga tidak menumpuk.
- Perangkat yang sudah pernah update tetap bisa recovery dari penyimpanan internal bila cache WebView kosong (mis. setelah clear data).
- Untuk debugging di perangkat, bisa dicek via log diagnostik yang dipublish dari layanan OTA pasca-apply (lokal vs versi terdeteksi vs versi terapan).

## Debugging

Lihat juga:
- [[01 - Fixes/offline-db TypeScript Audit]]
- [[01 - Fixes/2026-10-07 Trip History Data Sync]]
- [[01 - Fixes/2026-09-30 Sync Status Notification]]
