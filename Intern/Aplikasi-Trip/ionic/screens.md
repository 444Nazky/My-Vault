# Ionic Screen Templates

> **Status:** daftar layar & alur di bawah sudah disesuaikan dengan implementasi React aktual — 9 Oktober 2026.
> (Template HTML `ion-*` di bagian bawah adalah **mockup awal** — aplikasi berjalan dengan React + Tailwind, bukan komponen Ionic Web Components.)

## Screen List (aktual — `src/pages/mobile/`)

1. **LoginPage** — login 2 langkah: Login Wilayah (kode + password) → Pilih Petugas (kartu per wilayah, Region Lock) → **Verifikasi PIN via keypad**; opsi Administrator sudah dihapus (dashboard admin hanya lewat build `:8000`)
2. **HomeScreen** — beranda petugas, tombol **Mulai Trip**
3. **TripConditionScreen** — **pilih status muatan dulu**: “Kosong / Tidak Ada Muatan” atau “Ada Angkutan”
4. **RouteSelectScreen** — pilih rute; **trip kosong → rute dikunci hanya SJRE → SBDZ**; ada muatan → bebas
5. **VehicleFormScreen** — 2 langkah: (1) No. Polisi + jenis kendaraan → (2) **Detail Informasi Tambahan** (kategori + foto wajib); kartu **“No. Polisi Sudah Diinput”** (ketuk → detail + foto dokumentasi + isi ulang form)
6. **CameraScreen** — **hanya capture kamera** (tanpa galeri); dipakai untuk foto kendaraan & bukti trip + swafoto penutup
7. **TripSummaryScreen** — ringkasan; **hanya 1 kartu foto dinamis**: berubah hijau + thumbnail setelah bukti trip/swafoto siap, lalu tombol utama aktif (`Kirim Saja` untuk muatan, `Langsung Selesaikan Trip Kosong` untuk kosong)
8. **TripCompleteScreen** — selesai; ringkasan minimal tanpa sisa elemen kartu foto double/redundan
9. **HistoryScreen / HistoryDetailScreen** — riwayat & detail (tanpa tampilan tarif)
10. **ProfileScreen / SettingsScreen** — profil & pengaturan
11. **OfficerSwitchScreen / PinVerifyScreen** — ganti petugas (sinkron real-time dengan admin: status aktif/nonaktif & akses wilayah)

## Alur Mulai Trip (revisi spesifikasi 9 Okt 2026)

```
Beranda
  └─ Mulai Trip
       └─ Status Muatan?
            ├─ Kosong / Tidak Ada Muatan ──> Rute DIKUNCI: hanya SJRE → SBDZ
            └─ Ada Angkutan ──────────────> Rute bebas
                 └─ Input Kendaraan (Langkah 1)
                      └─ Detail Informasi Tambahan (Langkah 2, muncul setelah langkah 1)
                           └─ Ambil Foto KAMERA (wajib)
                                └─ Ringkasan → 1 kartu foto dinamis
                                     ├─ Belum lengkap → kartu amber + tombol Ambil Foto / Ambil Swafoto / Lengkapi Foto
                                     └─ Lengkap → kartu hijau + thumbnail → tombol Kirim Saja aktif
                                          └─ Kirim Saja → Trip Selesai
```

Aturan kunci:
- **Seluruh tampilan tarif disembunyikan** di mobile (nilai hanya disimpan di objek trip untuk sinkron & laporan admin).
- **Wajib foto kamera** sebelum "Simpan Data Kendaraan" / "Submit Trip".
- Swafoto penutup adalah 1 slot foto wajib khusus petugas (trip bermuatan), disimpan terpisah dari foto kendaraan & foto bukti trip.
- **Hanya 1 kartu foto** di Ringkasan Trip; tidak ada kartu swafoto ganda/redundan.
- Setelah swafoto berhasil, kartu berubah hijau + thumbnail, dan tombol utama langsung "Kirim Saja" menuju halaman Trip Selesai.
- Daftar plat yang sudah diinput bisa **diklik** untuk melihat detail + foto dokumentasi.
- Layar Ganti Petugas menarik daftar **paksa** dari `GET /officers/my-region` (sinkron dengan admin).

---

## Login Page (mockup awal)

> ⚠️ **ARSIP** — mockup ini memakai input kolom PIN lama. Implementasi terkini memakai
> **keypad/numpad** (6 dot indicator + tombol angka + Konfirmasi) ala desain terbaru;
> login juga sudah 2 langkah (wilayah → petugas → PIN). Lihat [[docs/flow#1.1 Inisiasi Awal & Login]].

```html
<ion-page>
  <ion-content class="ion-padding">
    <div class="login-container">
      <h1>TRIP ANGKUTAN</h1>
      <p>Masukkan PIN 6 Digit</p>
      
      <ion-input
        type="password"
        maxlength="6"
        [(ngModel)]="pin"
        placeholder="------"
        class="pin-input">
      </ion-input>
      
      <ion-button expand="block" (click)="login()">
        MASUK
      </ion-button>
    </div>
  </ion-content>
</ion-page>
```

## Tab Navigation

```html
<ion-tabs>
  <ion-router-outlet></ion-router-outlet>
  <ion-tab-bar slot="bottom">
    <ion-tab-button tab="home">
      <ion-icon name="home"></ion-icon>
      <ion-label>Home</ion-label>
    </ion-tab-button>
    <ion-tab-button tab="history">
      <ion-icon name="list"></ion-icon>
      <ion-label>Riwayat</ion-label>
    </ion-tab-button>
    <ion-tab-button tab="profile">
      <ion-icon name="person"></ion-icon>
      <ion-label>Profil</ion-label>
    </ion-tab-button>
  </ion-tab-bar>
</ion-tabs>
```

## Home Page

```html
<ion-page>
  <ion-header>
    <ion-toolbar>
      <ion-title>Trip Angkutan</ion-title>
    </ion-toolbar>
  </ion-header>
  
  <ion-content class="ion-padding">
    <!-- Offline Banner -->
    <div *ngIf="!isOnline" class="offline-banner">
      Mode Offline
    </div>

    <h2>Selamat Datang, {{ userName }}</h2>
    <p>Region: {{ regionName }}</p>
    
    <ion-button expand="block" routerLink="/create-trip">
      BUAT TRIP BARU
    </ion-button>
    
    <ion-card>
      <ion-card-header>
        <ion-card-title>Ringkasan Hari Ini</ion-card-title>
      </ion-card-header>
      <ion-card-content>
        <ion-grid>
          <ion-row>
            <ion-col>{{ tripCount }} Trip</ion-col>
            <ion-col>{{ vehicleCount }} Angkutan</ion-col>
          </ion-row>
        </ion-grid>
      </ion-card-content>
    </ion-card>
  </ion-content>
</ion-page>
```

## Create Trip Page

```html
<ion-page>
  <ion-header>
    <ion-toolbar>
      <ion-buttons slot="start">
        <ion-back-button defaultHref="/tabs/home"></ion-back-button>
      </ion-buttons>
      <ion-title>Buat Trip</ion-title>
    </ion-toolbar>
  </ion-header>
  
  <ion-content class="ion-padding">
    <ion-item>
      <ion-label>Status Muatan</ion-label>
      <ion-select [(ngModel)]="statusMuatan">
        <ion-select-option value="Ada Muatan">Ada Muatan</ion-select-option>
        <ion-select-option value="Kosong">Kosong</ion-select-option>
      </ion-select>
    </ion-item>

    <!-- Jika Kosong -->
    <div *ngIf="statusMuatan === 'Kosong'">
      <ion-item>
        <ion-label position="floating">Keterangan</ion-label>
        <ion-input [(ngModel)]="keterangan"></ion-input>
      </ion-item>
      <ion-button expand="block" (click)="capturePhoto()">
        Ambil Foto Kondisi
      </ion-button>
    </div>

    <ion-button expand="block" color="success" (click)="submit()">
      MULAI INPUT KENDARAAN
    </ion-button>
  </ion-content>
</ion-page>
```

## Input Vehicle Page

```html
<ion-page>
  <ion-header>
    <ion-toolbar>
      <ion-title>Kendaraan ke-{{ vehicleCount }}</ion-title>
    </ion-toolbar>
  </ion-header>
  
  <ion-content class="ion-padding">
    <ion-item>
      <ion-label position="floating">Plat Nomor</ion-label>
      <ion-input [(ngModel)]="noPolisi" 
                  placeholder="B 1234 ABC">
      </ion-input>
    </ion-item>
    
    <ion-item>
      <ion-label>Golongan</ion-label>
      <ion-select [(ngModel)]="golongan">
        <ion-select-option value="Eksternal">Eksternal</ion-select-option>
        <ion-select-option value="Internal">Internal</ion-select-option>
      </ion-select>
    </ion-item>
    
    <ion-item>
      <ion-label>Jenis Kendaraan</ion-label>
      <ion-select [(ngModel)]="jenis">
        <ion-select-option value="Truk">Truk</ion-select-option>
        <ion-select-option value="Mobil">Mobil</ion-select-option>
        <ion-select-option value="Motor">Motor</ion-select-option>
      </ion-select>
    </ion-item>
    
    <ion-item>
      <ion-label>Status Muatan</ion-label>
      <ion-select [(ngModel)]="muatan">
        <ion-select-option value="Dengan Muatan">Dengan Muatan</ion-select-option>
        <ion-select-option value="Tanpa Muatan">Tanpa Muatan</ion-select-option>
      </ion-select>
    </ion-item>
    
    <ion-button expand="block" (click)="capturePhoto()">
      <ion-icon name="camera"></ion-icon>
      Ambil Foto Selfie
    </ion-button>
    
    <img *ngIf="fotoPath" [src]="fotoPath" class="photo-preview">
    
    <ion-button expand="block" color="success" 
                (click)="submit()" [disabled]="!isValid">
      SIMPAN DATA
    </ion-button>
  </ion-content>
</ion-page>
```

## History Page

```html
<ion-page>
  <ion-header>
    <ion-toolbar>
      <ion-title>Riwayat Trip</ion-title>
    </ion-toolbar>
  </ion-header>
  
  <ion-content>
    <ion-list>
      <ion-item *ngFor="let trip of trips" (click)="viewDetail(trip)">
        <ion-label>
          <h3>{{ trip.noTrip }}</h3>
          <p>{{ trip.rute }} | {{ trip.vehicleCount }} kendaraan</p>
          <p>{{ trip.date }}</p>
        </ion-label>
        <ion-note slot="end">{{ trip.total | currency }}</ion-note>
      </ion-item>
    </ion-list>
  </ion-content>
</ion-page>
```

## Profile Page

```html
<ion-page>
  <ion-header>
    <ion-toolbar>
      <ion-title>Profil</ion-title>
    </ion-toolbar>
  </ion-header>
  
  <ion-content class="ion-padding">
    <div class="profile-header">
      <ion-icon name="person-circle" class="avatar-icon"></ion-icon>
      <h2>{{ userName }}</h2>
      <p>{{ regionName }}</p>
    </div>
    
    <ion-card>
      <ion-card-content>
        <ion-item>
          <ion-label>Total Trip</ion-label>
          <ion-note>{{ totalTrips }}</ion-note>
        </ion-item>
        <ion-item>
          <ion-label>Pending Sync</ion-label>
          <ion-note [class.warning]="pendingSync > 0">
            {{ pendingSync }}
          </ion-note>
        </ion-item>
      </ion-card-content>
    </ion-card>
    
    <ion-button expand="block" color="danger" (click)="logout()">
      LOGOUT
    </ion-button>
  </ion-content>
</ion-page>
```

## Ringkasan Trip (mockup ringkas)

```html
<ion-page>
  <ion-header>
    <ion-toolbar>
      <ion-buttons slot="start">
        <ion-back-button defaultHref="/tabs/home"></ion-back-button>
      </ion-buttons>
      <ion-title>Ringkasan Trip</ion-title>
    </ion-toolbar>
  </ion-header>

  <ion-content class="ion-padding">
    <!-- Kartu detail trip -->
    <ion-card>
      <ion-card-content>
        <ion-list>
          <ion-item>
            <ion-label position="stacked">Rute</ion-label>
            <ion-text color="medium">SJRE → SBDZ</ion-text>
          </ion-item>
          <ion-item>
            <ion-label position="stacked">Kondisi</ion-label>
            <ion-text color="medium">Ada Muatan</ion-text>
          </ion-item>
        </ion-list>
      </ion-card-content>
    </ion-card>

    <!-- SATU KARTU FOTO DINAMIS -->
    <ion-card [class.ready]="docsReady">
      <ion-card-content>
        <div class="foto-row">
          <div class="ikon">
            <ion-icon [name]="docsReady ? 'checkmark-circle' : 'camera'"></ion-icon>
          </div>
          <div class="teks">
            <ion-text [color]="docsReady ? 'success' : 'warning'">
              <h3>{{ docsReady ? 'Foto kamera siap' : 'Foto belum lengkap' }}</h3>
            </ion-text>
            <ion-text color="medium">{{ docsReady ? 'Bukti trip tersimpan — siap dikirim' : 'Wajib diambil sebelum trip dikirim' }}</ion-text>
          </div>
          <ion-button *ngIf="!docsReady" expand="block" fill="outline">
            {{ fotoActionLabel }}
          </ion-button>
        </div>
        <img *ngIf="docsReady && tripPhotoUrl" class="thumbnail" [src]="tripPhotoUrl">
      </ion-card-content>
    </ion-card>

    <!-- Tombol utama -->
    <ion-button expand="block" color="primary" [disabled]="!docsReady">
      <ion-icon slot="start" name="play"></ion-icon>
      {{ mainButtonLabel }}
    </ion-button>
  </ion-content>
</ion-page>
```

Kartu foto hanya muncul sekali. Status:
- **Amber**: foto bukti trip belum diambil, atau swafoto penutup belum diambil (muatan), atau foto kendaraan belum lengkap.
- **Hijau + thumbnail**: semua dokumen lengkap; tombol utama langsung aktif.
- Tombol utama: `Kirim Saja` (muatan) atau `Langsung Selesaikan Trip Kosong` (kosong), lalu ke halaman Trip Selesai.

## Trip Selesai (mockup ringkas)

```html
<ion-page>
  <ion-content class="ion-padding">
    <div class="selesai-header">
      <ion-icon name="checkmark-circle" class="check-big"></ion-icon>
      <h2>Trip Selesai!</h2>
      <p>Trip {{ tripId }} berhasil dicatat dan disimpan</p>
    </div>

    <ion-card>
      <ion-card-content>
        <ion-grid>
          <ion-row>
            <ion-col>Rute</ion-col>
            <ion-col>{{ routeLabel }}</ion-col>
          </ion-row>
          <ion-row>
            <ion-col>Durasi</ion-col>
            <ion-col>{{ duration }}</ion-col>
          </ion-row>
          <ion-row>
            <ion-col>Kendaraan</ion-col>
            <ion-col>{{ unitCount > 0 ? unitCount + ' unit' : 'Kosong' }}</ion-col>
          </ion-row>
          <ion-row>
            <ion-col>Kondisi</ion-col>
            <ion-col>{{ load }}</ion-col>
          </ion-row>
        </ion-grid>
      </ion-card-content>
    </ion-card>

    <ion-card color="light">
      <ion-card-content>
        <ion-icon name="checkmark" color="success"></ion-icon>
        Tersimpan di Perangkat — sinkronisasi berjalan di background
      </ion-card-content>
    </ion-card>

    <div class="aksi">
      <ion-button expand="block" fill="outline" routerLink="/history-detail">
        Lihat Detail
      </ion-button>
      <ion-button expand="block" color="primary" routerLink="/tabs/home">
        Kembali ke Home
      </ion-button>
    </div>
  </ion-content>
</ion-page>
```

---

## Ionic Components Reference

| Component | Fungsi |
|-----------|--------|
| ion-page | Page container |
| ion-header/ion-toolbar/ion-title | Header bar |
| ion-content | Scrollable content |
| ion-footer | Footer bar |
| ion-item | List item |
| ion-input | Text input |
| ion-select/ion-select-option | Dropdown |
| ion-button | Button |
| ion-card | Card container |
| ion-grid/ion-row/ion-col | Grid layout |
| ion-tabs/ion-tab-bar/ion-tab-button | Tab navigation |
| ion-icon | Icon |
| ion-img | Image |
| ion-spinner | Loading spinner |
| ion-badge | Badge indicator |
| ion-alert | Alert dialog |
| ion-toast | Toast notification |
