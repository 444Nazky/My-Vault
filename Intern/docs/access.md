# Master Dashboard

## 1 - Struktur Wilayah dan Rute
| Region | Dermaga | Rute Tersedia |
| :--- | :--- | :--- |
| Region 1 | Dermaga 1 | Rute 1 (A -> B \| B -> A), Rute 2 (C -> D \| D -> C) |
| Region 1 | Dermaga 2 | Rute 3 (E -> F \| F -> E), Rute 4 (G -> H \| H -> G) |

## 2 - User Mobile Access Rule
* Pegawai hanya dapat mengakses rute berdasarkan pengaturan region dan dermaga dari admin[cite: 2].
* Contoh: Budi diset di Region 1 Dermaga 1, maka otomatis hanya bisa mengakses Rute 1 (A -> B dan B -> A). Region, dermaga, dan rute lain disembunyikan (hide) atau tidak diberikan akses[cite: 2].

## 3 - Double Access
* User 2 kaki yang memiliki izin akses ke Region 1 dengan Dermaga 1 dan Dermaga 2 sekaligus memiliki fitur spesial[cite: 2].
* Karena user 2 kaki bisa akses rute 1 dan rute 2, tiap kali user 2 kaki login, sistem wajib menanyakan terlebih dahulu dermaga mana yang ingin dipilih untuk sesi aktif tersebut[cite: 2].

## 4 - Tahap Percobaan (Dummy Users)
| No | Nama Pegawai | Region & Dermaga | Akses Rute |
| :--- | :--- | :--- | :--- |
| 1 | Budi Santoso[cite: 2] | Region 1, Dermaga 1[cite: 2] | Rute 1 (A ⇄ B)[cite: 2] |
| 2 | Andi Pratama[cite: 2] | Region 1, Dermaga 2[cite: 2] | Rute 3 (E ⇄ F)[cite: 2] |
| 3 | Dewi Kusuma[cite: 2] | Region 1, Dermaga 1 & 2 (Dual Access)[cite: 2] | Rute 1, 2, 3, 4[cite: 2] |

## 5 - UI Mobile & Credentials
* Revisi tombol di halaman profil: Ubah dari tombol **Ganti Petugas** menjadi tombol **Logout** (sesuai ralat terbaru).
* Seluruh kredensial akun (user dan password) untuk Budi Santoso, Andi Pratama, dan Dewi Kusuma wajib dicatat pada direktori: `/home/nazky/Documents/Obsidian Vault/Intern/summary/Accounts.md`[cite: 2].