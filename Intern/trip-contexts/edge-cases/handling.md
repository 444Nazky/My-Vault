# Edge Cases & Error Handling

## Offline Scenarios

### Scenario: User creates trip without internet
1. User creates trip -> Data saved to local storage
2. UI shows "Offline Mode" indicator
3. When connection returns -> Auto-sync triggered
4. User receives notification "Data berhasil disinkronkan"

### Scenario: App crashes mid-sync
1. App starts syncing vehicle 3
2. App crashes
3. On restart, check sync queue
4. Vehicle 1, 2 are synced
5. Vehicle 3, 4, 5 are still pending
6. Resume sync from vehicle 3

## Location Edge Cases

### GPS shows location outside region
1. Detect lat/lng outside bounds
2. Show warning: "Lokasi Anda di luar area kerja"
3. User can continue anyway (logged as anomaly)

### GPS accuracy is poor
1. Location accuracy > 50m
2. Show warning to user
3. Allow continue but flag in data

## Error Messages

| Error | Message |
|-------|---------|
| No internet | "Tidak ada koneksi internet. Data akan disimpan dan disinkronkan nanti." |
| GPS disabled | "Layanan lokasi tidak aktif. Mohon aktifkan GPS." |
| Upload failed | "Gagal mengunggah foto. Silakan coba lagi." |
| Session expired | "Sesi berakhir. Mohon login kembali." |
