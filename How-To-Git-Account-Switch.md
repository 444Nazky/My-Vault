Markdown

````
# Panduan Gonta-Ganti Akun Git & Konfigurasi Repository

## 1. Cek Akun Git Saat Ini
Gunakan perintah ini di terminal untuk mengecek nama dan email yang sedang aktif:
```bash
git config user.name
git config user.email
````


- **Daftar Akun Git Tersedia
    ```
    git config user.name "4444Nazky"
    git config user.email "naruzky.naz@gmail.com"
    ```
    
    ```
    git config user.name "bebekkrenyes"
    git config user.email "nazkykaryamas@gmail.com"
    ```
    
    ```
    git config user.name "fufufafaselamatkanku"
    git config user.email "nazkynarutama@gmail.com"
    ```
    
    ```
    git config user.name "manusiasetengahpiscok"
    git config user.email "arpeggionazky@gmail.com"
    ```

    ```
    git config user.name "tahugorengkamis"
    git config user.email "narutamazril22@gmail.com"
    ```


## 3. Cara Mendapatkan Email Noreply GitHub

1. Buka halaman [GitHub Settings Emails](https://github.com/settings/emails?utm_source=gemini).
    
      
    
2. Periksa bagian _"Keep my email addresses private"_.
    
      
    
3. Salin email _noreply_ dengan format: `ID+username@users.noreply.github.com`.
    
      
    

## 4. Pengaturan Konfigurasi (Per Repo vs Global)

- **Lokal (Hanya untuk repository tertentu):**
    
      
    
    Bash
    
    ```
    git config --local user.name "nama-akun"
    git config --local user.email "email@noreply.github.com"
    ```
    
- **Global (Untuk semua repository di komputer):**
    
      
    
    Bash
    
    ```
    git config --global user.name "nama-akun"
    git config --global user.email "email@noreply.github.com"
    ```
    

## 5. Push ke Repository Orang Lain (Sebagai Collaborator)

Atur ulang URL _remote_ menggunakan personal access token:

Bash

```
git remote set-url origin [https://TOKEN@github.com/OWNER/REPO.git](https://TOKEN@github.com/OWNER/REPO.git)
```
