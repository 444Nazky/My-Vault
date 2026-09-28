# Bug Report: Mobile Sync Gagal Terhubung ke Backend API

**Tanggal:** 27 September 2026
**Status:** Terselesaikan
**Prioritas:** Tinggi

---

## Ringkasan Masalah

Aplikasi mobile tidak dapat menyinkronkan data trip ke backend API dan terjebak pada status "menunggu sinkronisasi". Dashboard admin dapat terhubung dengan baik, menunjukkan bahwa backend server beroperasi normal.

---

## Gejala

1. Aplikasi mobile stuck pada status "Menunggu sinkronisasi" setelah submit trip
2. Request API gagal dengan error "Network Error" atau timeout
3. Dashboard admin berfungsi normal dan dapat menerima data
4. Backend API di `localhost:3000` tidak terjangkau dari perangkat mobile

---

## Akar Penyebab

### Masalah 1: Localhost Tidak Valid untuk Perangkat Mobile

`localhost:3000` hanya merujuk ke perangkat itu sendiri. Ketika aplikasi berjalan di:
- **Perangkat fisik (Android/iOS):** localhost merujuk ke perangkat mobile, bukan komputer host
- **Emulator:** localhost merujuk ke emulator, bukan host (kecuali adb reverse dikonfigurasi)

```
Mobile App (localhost:3000) --> Device localhost:3000 [TIDAK ADA SERVER]
vs
Web Browser (localhost:3000) --> Host localhost:3000 [SERVER ADA]
```

### Masalah 2: Payload Sinkronisasi

Transformasi data trip perlu diverifikasi agar sesuai dengan format yang diharapkan backend:
- `statusMuatan`: harus `muatan` atau `kosong` (bukan "Ada Muatan")
- `routeFrom`/`routeTo`: kode region (SJRE, SBDZ, BDAU)
- `vehicles`: array kendaraan dengan field yang benar

---

## Solusi yang Diterapkan

### 1. Konfigurasi Multi-Environment

File: `src/environments/environment.ts`

```typescript
export const environment = {
  production: false,
  apiBaseUrl: 'http://localhost:3000/api',           // Browser/Emulator
  deviceApiBaseUrl: 'http://192.168.1.100:3000/api', // Physical Device
};
```

### 2. Deteksi Otomatis Tipe Perangkat

File: `src/services/api.ts`

- Mendeteksi apakah berjalan di mobile device (Capacitor/Cordova)
- Menggunakan `deviceApiBaseUrl` untuk perangkat fisik
- Menggunakan `apiBaseUrl` untuk browser/emulator

### 3. Konfigurasi URL Manual

File: `src/pages/mobile/SettingsScreen.tsx`

- Menu pengaturan新增 "Konfigurasi Server"
- Pengguna dapat mengatur URL API secara manual
- URL tersimpan di localStorage

---

## Panduan Konfigurasi untuk Perangkat Mobile

### Opsi 1: Adb Reverse (Emulator)

```bash
# Jalankan di terminal komputer host
adb reverse tcp:3000 tcp:3000
```

### Opsi 2: IP Host Statis (Perangkat Fisik)

```bash
# 1. Cari IP komputer host
hostname -I | awk '{print $1}'
# Contoh output: 192.168.1.100

# 2. Update environment.ts
deviceApiBaseUrl: 'http://192.168.1.100:3000/api'

# 3. Pastikan firewall mengizinkan koneksi ke port 3000
```

### Opsi 3: Konfigurasi Lewat Aplikasi

1. Buka menu "Pengaturan" di aplikasi mobile
2. Pilih "Konfigurasi Server"
3. Masukkan URL API: `http://192.168.1.100:3000/api`
4. Tekan "Simpan URL"

---

## Payload Sinkronisasi Trip

Format request yang benar:

```json
POST /api/trips
{
  "statusMuatan": "muatan",
  "routeFrom": "SJRE",
  "routeTo": "SBDZ",
  "keterangan": "Internal",
  "fotoKosongPath": null,
  "vehicles": [
    {
      "noPolisi": "B 1234 XYZ",
      "vehicleType": "Motor",
      "golongan": "Internal",
      "hasLoad": true,
      "tariffAmount": 15000
    }
  ]
}
```

---

## Verifikasi

| Check | Hasil |
|-------|-------|
| Backend API `:3000` | Berjalan |
| Curl test dari host | 200 OK |
| Mobile app config URL | IP host valid |
| Firewall port 3000 | Dibuka |
| Sync queue process | Berjalan |

---

## Langkah untuk Testing

1. **Browser Dev:**
   ```bash
   npm start  # Port 5173
   curl http://localhost:3000/api/health
   ```

2. **Emulator:**
   ```bash
   adb reverse tcp:3000 tcp:3000
   ```

3. **Perangkat Fisik:**
   - Pastikan HP dan komputer di jaringan yang sama
   - Atur URL API ke IP komputer host
   - Test koneksi: `curl http://192.168.1.x:3000/api/health`

---

## Catatan Tambahan

- Offline-first architecture menyimpan data di localStorage terlebih dahulu
- Sync queue retry otomatis hingga 3 kali dengan jeda 5 detik
- Token JWT valid 24 jam, auto-refresh saat diperlukan
