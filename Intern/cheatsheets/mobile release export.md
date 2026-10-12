# Mobile Release Export

Panduan untuk export/update release aplikasi mobile.

## Apa yang Dilakukan

Meng-commit perubahan konfigurasi release ke branch `mobile`, termasuk:
- Update file konfigurasi Android (Capacitor)
- Update konfigurasi Angular
- Hapus artefak release lama (archive, APK lama, license file)
- Fix dependency yang tidak kompatibel

## Cara Melakukan

### 1. Cek Status Perubahan

```bash
git status --short
```

Lihat file yang dimodifikasi (M), dihapus (D), atau baru (??).

### 2. Cek APK yang Ada

```bash
find . -name "*.apk" -type f
ls -lh android/app/build/outputs/apk/release/*.apk
```

Bandingkan tanggal APK dengan commit terakhir:
```bash
git log --oneline -5
```

### 3. Build APK Baru (Jika Perlu)

```bash
# Build web app
npm run build

# Sync ke Capacitor
npx cap sync android

# Build APK release
cd android && ./gradlew assembleRelease
```

### 4. Stage File yang Ingin Di-commit

```bash
git add <file1> <file2> ...
```

Contoh:
```bash
git add .gitignore android/app/capacitor.build.gradle android/capacitor.settings.gradle angular.json
```

Atau stage semua:
```bash
git add .
```

### 5. Commit dengan Pesan yang Jelas

```bash
git commit -m "fix: remove incompatible @capacitor/http, build new release APK"
```

Format commit message yang baik:
- `chore:` - perubahan maintenance
- `feat:` - fitur baru
- `fix:` - perbaikan bug
- `docs:` - dokumentasi
- `refactor:` - refactoring kode

### 6. (Opsional) Push ke Remote

```bash
git push origin mobile
```

## File yang Biasanya Berubah Saat Release

| File | Keterangan |
|------|------------|
| `android/app/capacitor.build.gradle` | Konfigurasi build Android |
| `android/capacitor.settings.gradle` | Pengaturan Capacitor Android |
| `angular.json` | Konfigurasi project Angular |
| `.gitignore` | Aturan file yang diabaikan |
| `src/` | Kode sumber aplikasi |
| `package.json` | Dependensi npm |

## Workflow Release

```
1. Buat branch baru atau checkout branch release
       │
       ▼
2. Develop/modify kode aplikasi
       │
       ▼
3. Build aplikasi: npm run build
       │
       ▼
4. Sync ke Capacitor: npx cap sync android
       │
       ▼
5. Build APK: cd android && ./gradlew assembleRelease
       │
       ▼
6. Commit perubahan (sesuai panduan ini)
       │
       ▼
7. Push ke remote
       │
       ▼
8. Tag release: git tag -a v1.x.x -m "Release v1.x.x"
       │
       ▼
9. Push tag: git push origin v1.x.x
```

## Troubleshooting

### Error: Namespace Not Specified (@capacitor/http)

Jika build gagal dengan error:
```
Namespace not specified. Specify a namespace in the module's build file
```

Solusi: Remove `@capacitor/http` yang tidak kompatibel dengan Capacitor 8:

```bash
npm uninstall @capacitor/http
npx cap sync android
cd android && ./gradlew assembleRelease
```

**Catatan:** Jika kode masih butuh `@capacitor/http`, cek alternatif:
- Gunakan `fetch()` native JavaScript
- Atau gunakan versi yang kompatibel

### Konflik Merge
```bash
git pull origin main
git merge main
# Resolve konflik secara manual
git add .
git commit -m "chore: resolve merge conflicts"
```

### Batalkan Commit Terakhir
```bash
git reset --soft HEAD~1  # soft - keep changes staged
git reset --hard HEAD~1   # hard - discard changes (PERHATIAN!)
```

### Lihat Commit History
```bash
git log --oneline -10
```

### Check Plugin Capacitor
```bash
npx cap sync android
# Lihat plugins yang terinstall
cat android/app/src/main/assets/capacitor.plugins.json
```

## Catatan Penting

- Selalu commit sebelum push ke remote
- Gunakan commit message yang deskriptif
- Jangan commit artefak besar (APK, node_modules) - sudah ada di .gitignore
- Test aplikasi sebelum release
- Pastikan semua dependency kompatibel sebelum build
- Check tanggal APK vs commit terakhir sebelum release
