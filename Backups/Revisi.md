# 1 Inputs
di bagian input kendaraan, buat ui menjadi lebih minimalis dan tidak heboh. pastikan semuanya WAJIB terisi baru boleh simpan dan tambah kendaraan lain. untuk kategori dan jenis kendaraan itu WAJIB diisi dan bukan opsional

# 2 Laporan dashboard
Halaman Laporan Trip dirancang ulang agar tampilannya lebih intuitif, padat, dan mudah dipahami selayaknya _spreadsheets_ modern. Meskipun tata letak dan strukturnya diperbarui menjadi lebih rapi, fitur filter utama seperti Golongan dan Jenis Kendaraan tetap dipertahankan di bagian atas agar proses penyaringan data tidak dihilangkan.

# 3 Master Rute Wilayah Operasional
## 1. Badau
### Dermaga 1
- **Rute 1:** SJRE -> SBDZ
- **Rute 2:** SBDZ -> SJRE
### Dermaga 2
- **Rute 1:** AAAA -> BBBB
- **Rute 2:** BBBB -> AAAA
---
## 2. Belitung
### Dermaga 1
- **Rute 1:** CCCC -> DDDD
- **Rute 2:** DDDD -> CCCC
### Dermaga 2
- **Rute 1:** EEEE -> FFFF
- **Rute 2:** FFFF -> EEEE
---
## 3. Kelapa Kampit
### Dermaga 1
- **Rute 1:** GGGG -> HHHH
- **Rute 2:** HHHH -> GGGG
### Dermaga 2
- **Rute 1:** IIII -> JJJJ
- **Rute 2:** JJJJ -> IIII
## Pengaturan Admin
- Nama rute dapat diubah secara dinamis melalui dashboard admin pada halaman **Master Rute**.
---
# 4 Revisi alur login
pada saat login page, ubah dari login karyawan menjadi login region beserta password region, contoh : Login = BADAU password = badau123. lalu kemudian setelah berhasil login lewat akun region, baru muncul pilihan pekerjanya, contoh : di dalam akun region BADAU ada user petugas : Budi Santoso, Andi Pratama, Siti Rahayu. dan seterusnya. namun jika yang login adalah region BELITUNG, akun petugas yang tampil juga berbeda, karena belum ada akunnya, anda bisa buat akun contoh : Agung suntoso, ataupun nama yang lainnya, minimal 2. dan tiap petugas memiliki pin masing masing untuk verifikasi![[Pasted image 20260928101635.png|228]]
 ![[Pasted image 20260928101233.png|215]] 