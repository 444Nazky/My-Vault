## Cara Mengakses Localhost Ubuntu Server dari Arch Linux:

- **1. Pastikan Aplikasi _Binding_-nya Tepat (Jangan ke `127.0.0.1`)**
    
    Banyak aplikasi atau framework (seperti Node.js, Flask, dll) kalau dijalankan cuma nge-_bind_ ke `localhost` (`127.0.0.1`), yang artinya **cuma bisa diakses dari dalam server itu sendiri**. Kamu harus pastikan aplikasinya diatur buat nge-_bind_ ke semua _interface_ (biasanya pakai `0.0.0.0` atau IP LAN server `192.168.100.2`).
    
      
    - _Contoh di Node.js/Express:_ Ganti `app.listen(3000, '127.0.0.1')` jadi `app.listen(3000, '0.0.0.0')`.
        
          
        
- **2. Buka Akses Port di Firewall Ubuntu Server**
    
    Kalau _firewall_ (`ufw`) di Ubuntu server-mu nyala, port aplikasimu bakal otomatis ditolak. Buka dulu portnya lewat terminal server:
    
      
    
    Bash
    
    ```
    sudo ufw allow 3000/tcp
    ```
    
    _(Ganti `3000` dengan nomor port aplikasi yang mau kamu _debug_)._
    
      
    
- **3. Akses Lewat Browser/Curl di Arch Linux**
    
    Dari laptop Arch Linux kamu, buka browser atau terminal, lalu akses pakai IP statis server yang udah kita bikin tadi (atau IP Wi-Fi kalau lagi pakai Wi-Fi yang sama):
    
      
    
    Bash
    
    ```
    http://192.168.100.2:3000
    ```
    
