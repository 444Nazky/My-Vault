# Agents — Deployment

> Prompt siap pakai untuk Claude Code. Sumber rujukan: 5 file di folder ini
> ([[Deployment/Deployment-Guide|Deployment-Guide]], [[Deployment/Quick-Start|Quick-Start]],
> [[Deployment/Backend-Migration|Backend-Migration]], [[Deployment/Step-by-Step|Step-by-Step]]).

untuk endpoint/backend sudah berhasil di aplikasi-trip-production.up.railway.app


## Prompt Utama — Jalankan Deployment Trip Angkutan

```text
Kamu adalah agent deployment untuk proyek Trip Angkutan
(~/RPL/Intern/Aplikasi-Trip-Ionic, 3 komponen: backend Express+SQLite,
admin dashboard statis di admin-ci/, mobile React/Ionic).

Baca dulu: Aplikasi-Trip vault → Deployment/Step-by-Step.md sebagai panduan utama,
lalu Deployment-Guide.md untuk opsi alternatif.

Jalankan fase berurutan, jangan lompat:
1. PRA-KONDISI — verifikasi `git status` bersih, remote GitHub ada, dan
   ketiga komponen jalan lokal (:3000 api/health, :5173, :8000).
2. BACKEND → Railway — pastikan repo ter-push, lalu arahkan ke Railway
   (root directory `backend`, build `npm install`, start `npm start`).
   Verifikasi: GET /api/health harus {"status":"ok"}.
   Catatan penting: backend memakai sql.js (DB di memori menulis data/trip.db),
   jadi set Railway Volume untuk path data/ agar data tidak hilang saat restart.
3. ADMIN → Vercel — import repo, root directory `admin-ci`, output `.`,
   kosongkan build command. Setelah deploy, update API_BASE di config admin
   dari localhost:3000 ke URL Railway, commit → auto-redeploy.
4. MOBILE — ganti VITE_API_URL ke URL Railway (src/environments + .env),
   build, `npx cap sync android`, build APK debug.
5. UJI E2E — login petugas dari APK → buat trip → cek muncul di admin
   dashboard production. Test juga CORS: origin kapacitor://localhost
   dan domain admin harus diizinkan backend.

Setiap fase: laporkan hasil + URL yang didapat, dan berhenti minta konfirmasi
sebelum phase yang butuh akses akun (Railway/Vercel login).
Jangan ubah kode aplikasi kecuali diminta (config URL saja yang boleh).
```

## Prompt Ringkas — Cek Kesiapan Deploy (tanpa deploy)

```text
Audit kesiapan deployment Trip Angkutan tanpa mengubah apa pun:
- git remote & branch sudah sync dengan GitHub?
- ada hardcode localhost:3000 / localhost:8000 di src/ yang harus diganti produksi?
- CORS di backend/src/index.js sudah mengizinkan domain admin + capacitor://localhost?
- .env / environments punya nilai produksi?
- backend/data/trip.db sudah masuk .gitignore (jangan sampai ke-repo)?
Laporkan dalam tabel: item | status | yang perlu diubah.
```

## Prompt — Troubleshooting Setelah Deploy

```text
Gejala: <mis. "admin 404" / "mobile tidak bisa login" / "CORS error" / "backend 500">
Vault: baca Deployment/Deployment-Guide.md bagian Troubleshooting,
lalu Step-by-Step.md bagian Troubleshooting.
Diagnosa dari sisi client dulu (curl endpoint, cek log browser), lalu server
(log Railway/Vercel). Sebutkan akar penyebab sebelum menyarankan perubahan.
```

## Catatan Agent

- **Jangan** jalankan `fly launch` / `vercel --prod` / push ke production tanpa
  konfirmasi eksplisit user.
- Referensi URL placeholder dalam dokumen (`trip-api.up.railway.app`,
  `trip-admin.vercel.app`) — ganti dengan URL aktual hasil deploy.
- Biaya: semua opsi di doc = free tier, kecuali VPS ($4-6/bln).

---
*Terakhir diperbarui: 1 Oktober 2026*
