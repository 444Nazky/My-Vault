# Mobile App Screens Overview

## Screen List

1. **Splash Screen** - Logo + loading
2. **Login Screen** - Input PIN 6 digit
3. **Home Screen** - Dashboard ringkas
4. **Create Trip Screen** - Form trip baru
5. **Input Vehicle Screen** - Form kendaraan
6. **Success Dialog** - Konfirmasi simpan
7. **Trip History Screen** - Daftar trip
8. **Trip Detail Screen** - Detail trip
9. **Profile Screen** - Info user

## Key Screens

### Login Screen
```
+---------------------------+
|      [LOGO APP]           |
|      TRIP ANGKUTAN        |
|                           |
|    [ ][ ][ ][ ][ ][ ]    |
|    [ 6 dots for PIN ]    |
|                           |
|    [ 1 ] [ 2 ] [ 3 ]    |
|    [ 4 ] [ 5 ] [ 6 ]    |
|    [ 7 ] [ 8 ] [ 9 ]    |
|    [   ] [ 0 ] [ < ]    |
+---------------------------+
```

### Home Screen
```
+---------------------------+
| Selamat Datang,           |
| Budi Santoso              |
| Region: Badau            |
+---------------------------+
|  [   BUAT TRIP BARU   ] |
+---------------------------+
|  Ringkasan Hari Ini       |
|  +---------+-----------+  |
|  | Trip    | Angkutan  |  |
|  |   5     |    12     |  |
|  +---------+-----------+  |
+---------------------------+
|  [Home] [History] [Profile]
+---------------------------+
```

### Input Vehicle Screen
```
+---------------------------+
|  TRP-120524-001 | Ada Muatan |
|                           |
|  Plat Nomor: [B 1234 ABC] |
|  Golongan: [Eksternal v] |
|  Jenis: [Truk v]         |
|  Status: [Dengan Muatan v]|
|                           |
|  Foto Selfie: [Ambil Foto]|
|  Lokasi: -1.2345, 110.98|
|                           |
|  [    SIMPAN DATA       ]|
+---------------------------+
```

## Component Specifications

### Button Styles
| Type | Color | Height | Use |
|------|-------|--------|-----|
| Primary | Green (#4CAF50) | 48dp | Main actions |
| Secondary | Blue (#1976D2) | 48dp | Secondary |
| Danger | Red (#F44336) | 48dp | Delete |

### Color Palette
| Name | Hex | Use |
|------|-----|-----|
| Primary | #1976D2 | App bar |
| Accent | #FF9800 | FAB |
| Success | #4CAF50 | Success |
| Error | #F44336 | Error |
| Background | #F5F5F5 | Screen bg |
