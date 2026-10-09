# Bug Fix: Officers Tab — Semua Petugas Masuk Grup BADAU & Kolom Dermaga Kosong

Tanggal: 2026-09-29

## Gejala

Admin Dashboard → tab Petugas: semua 8 petugas masuk grup "BADAU" (padahal seharusnya tersebar di 4 wilayah: BADAU, BELITUNG, KELAPAKAMPIT, ENTIKONG). Kolom Dermaga dan Rute kosong `—` untuk semua petugas.

## Root Cause

Tiga bug terpisah yang saling terkait:

### Bug 1: OfficersTab render dari `officers` prop (store mobile)

`OfficersTab` menerima `officers` sebagai prop dari `AdminDashboard`, yang sumbernya `useApp().officers` (localStorage mobile store). Saat `isAdminBuild()` true, `refreshOfficers()` di skip, jadi store officers tidak pernah di-update dengan data backend yang punya `dermagaAccess` dan `regions` yang benar.

```tsx
// OfficersTab.tsx (sebelum fix)
const officerGroups = [
  ...regionCodes,  // [] karena regions state = [] (belum fetch)
  ...(officers.some(o => !officerRegionCodes(o).some(c => regionCodes.includes(c))) ? ['LAINNYA'] : []),
]
```

Semua petugas masuk "LAINNYA" karena `regionCodes = []` (empty array).

### Bug 2: `inRegionGroup` dan `officerGroups` pakai `officers` bukan `localOfficers`

即使 tab fetch `/officers` dan simpan ke `localOfficers`, grouping logic masih baca dari `officers` prop yang tidak pernah ter-update.

### Bug 3: `mergeBackendOfficers` tidak punya fallback D1 untuk `dermagaAccess` kosong

Saat backend petugas baru tanpa `dermagaAccess`, fallback-nya `old?.dermagaAccess ?? []` — array kosong. Kolom Dermaga tampil `—`.

## Fix

### Fix 1: OfficersTab fetch independen dengan admin JWT

```tsx
const [localOfficers, setLocalOfficers] = useState<Officer[]>([])

useEffect(() => {
  let alive = true
  setLoading(true)
  ensureAdminBackendSession().then(ok => {
    if (!ok || !alive) return
    Promise.all([
      fetchRegions(),
      fetchRoutes(),
      fetchDermagas(),
      api.get<BackendOfficerRow[]>('/officers'),
    ]).then(([regs, rts, dms, offs]) => {
      if (offs.ok && offs.data) {
        const merged = mergeBackendOfficers(offs.data, officers)
        setLocalOfficers(merged)  // state untuk display
        onSaveOfficers(merged)   // sync ke store mobile
      }
    })
  })
  return () => { alive = false }
}, [])
```

### Fix 2: Grouping pakai `localOfficers`, bukan `officers` prop

```tsx
// Sesudah fix
const localOfficers dari backend, bukan store prop
const officerGroups = [
  ...regionCodes,
  ...(localOfficers.some(o => !officerRegionCodes(o).some(c => regionCodes.includes(c))) ? ['LAINNYA'] : []),
]

// Render pakai localOfficers
{localOfficers.filter(o => inRegionGroup(o, region)).map(...)}
```

### Fix 3: Fallback D1 di `mergeBackendOfficers`

```tsx
const dermagaAccess = b.dermagas && b.dermagas.length > 0
  ? b.dermagas
  : old?.dermagaAccess && old.dermagaAccess.length > 0
    ? old.dermagaAccess
    : [{ id: '', name: 'Dermaga 1', code: 'D1' }]  // fallback D1
```

### Fix 4: Loading state dengan spinner

```tsx
if (loading) {
  return (
    <div className="flex items-center justify-center py-20">
      <div className="text-center">
        <div className="w-8 h-8 border-2 border-slate-300 border-t-blue-500 rounded-full animate-spin mx-auto mb-3" />
        <p className="text-slate-400 text-sm">Memuat data petugas...</p>
      </div>
    </div>
  )
}
```

## Files Diedit

| File | Perubahan |
|------|-----------|
| `src/pages/admin/tabs/OfficersTab.tsx` | Rewrite penuh — `localOfficers` state, fetch independen, grouping fix, loading state |

## Eksekusi

1. `npm run dev` (Vite HMR auto-refresh)
2. Reload browser
3. Tab Petugas sekarang 4 grup wilayah dengan data benar

## Todo

- [ ] Test: Officers tab dengan backend offline
- [ ] Test: Mutasi (add/edit/delete) petugas dengan admin
- [ ] Test: Sinkronisasi store mobile setelah mutasi admin
