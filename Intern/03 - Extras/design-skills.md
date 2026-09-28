Spesifikasi Desain & Struktur Aplikasi:

1. Container & Layout Utama:
   - Outer Container: Background abu-abu terang (#e2e8f0 / slate-200) dengan tampilan centered card bergaya frame smartphone iOS / Android modern.
   - Top Switcher Bar: Floating pill bar di bagian atas tengah berisi pilihan "Mobile App" (Active) dan "Admin Dashboard".
   - Navigation Bottom Bar (Di dalam frame mobile): 3 Tab utama:
     * Beranda (Home Icon)
     * Riwayat (List / History Icon)
     * Profil (User Icon)

2. Halaman & Alur Layar (Screen Flow):

   A. Beranda (Home Screen):
      - Top Profile Card (Dark Theme #0f172a): Avatar "BS" (Budi Santoso - Petugas Lapangan), badge "Region Locked: BADAU", dan tombol "Ganti Petugas".
      - Hero Banner Action (Primary Blue #2563eb): Teks "Mulai Trip Baru Sekarang" dengan tombol pemicu "Mulai Trip".
      - Quick Stats Grid (3 Kolom Card):
        * "3" - Trip Hari Ini
        * "5" - Kendaraan Hari Ini
        * "730rb" - Pendapatan Hari Ini
      - Section "Trip Terbaru": List kartu perjalanan (asal-tujuan, status muatan/kosong, nominal nominal rupiah) dengan link "Lihat Semua".

   B. Alur Mulai Trip & Pilih Rute:
      - Layar Pilih Rute: Header "Pilih Rute - Tentukan asal dan tujuan perjalanan", info Wilayah Aktif ("BADAU"), dan list pilihan rute (contoh: SJRE -> SBDZ, SBDZ -> SJRE, SJRE -> BDAU, BDAU -> SJRE) lengkap dengan jarak (km) dan perkiraan waktu.
      - State Selection: Rute yang dipilih memiliki border biru terang dengan radio button aktif.
      - Bottom Action Button: Floating button "Pilih Rute Ini" di bagian bawah layar.

   C. Layar Verifikasi PIN & Ganti Petugas:
      - Verifikasi PIN: Tampilan Numpad 1-9 dengan 6-digit PIN indicator box, ikon gembok di header, instruksi "Masukkan 6-digit PIN Anda (Demo: 123456)", serta tombol "Konfirmasi".
      - Modal/Layar Ganti Petugas: Daftar petugas lapangan aktif di wilayah BADAU (Budi Santoso, Andi Pratama, Siti Rahayu) dengan badge status "Aktif" / "Non-aktif".

   D. Halaman Riwayat Trip:
      - Filter Tabs: "Semua", "Muatan", "Kosong".
      - Card List: Daftar historis trip mencakup ID Trip (contoh: TRP-2026-0091), tanggal/waktu, status ("Ada Muatan" / "Kosong"), serta nilai pendapatan (Rp 250.000, Rp 0, Rp 450.000, dll.).

   E. Halaman Profil Saya:
      - Profile Header (Dark Card): Avatar BS, Nama Budi Santoso, ID OFF-001, Status BADAU Aktif.
      - Summary Metrics: Total Trip (91), Total Revenue (Rp 12jt), Rating (4.8 ★).
      - Menu List Navigation: Riwayat Trip, Rute Aktif, Keamanan & PIN, Pengaturan.
      - Red Danger Button: "Ganti Petugas" di bagian paling bawah.

3. Ketentuan Lingkungan Proyek:
   - Framework: React 19 + Vite + Tailwind CSS v4 + Lucide React (untuk ikonografi).
   - Penempatan CSS: Atur kustomisasi styling pada `src/index.css` di bawah `@import 'tailwindcss';`.
   - Responsive & Interactive Mockup: Buat semua tab, tombol, dan alur navigasi (termasuk pemicu modal PIN dan pilih rute) dapat diklik secara interaktif di dalam frame smartphone.