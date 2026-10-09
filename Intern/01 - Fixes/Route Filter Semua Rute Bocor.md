# Bug Fix: Route Filter — Semua Rute Bocor ke UI Mobile

Tanggal: 2026-09-29

## Gejala

Budi Santoso (Akses D1 Badau) melihat 4 rute di layar Pilih Rute mobile. Seharusnya hanya 2 rute (SJRE ⇄ SBDZ). Rute Dermaga 2 Badau (AAAA ⇄ BBBB) bocor ke UI.

Screenshot: Budi melihat `SJRE-SBDZ`, `SBDZ-SJRE`, `SJRE-BDAU`, `BDAU-SJRE` — seharusnya hanya 2 rute.

## Root Cause: Triple Bug Cascade

### Bug 1: `dermagaAccess` Hardcoded di Mobile Store

`toMobileOfficer()` di `src/services/officers.ts` hardcoded fallback:

```typescript
// Sebelum fix — fallback dummy yang salah
dermagaAccess: [{ id: 'd1', name: 'Dermaga 1' }],

// Sesudah fix — kosong, sync backend yang mengisi
dermagaAccess: bo.dermagas || [],
```

Officer Budi di localStorage punya `dermagaAccess: [{ id: 'd1' }]` (string biasa), padahal backend return UUID seperti `a1b2c3d4-...`. ID tidak cocok → filter bypass.

### Bug 2: `getStoredRoutes()` Return Empty, Fallback ke Static Routes

```typescript
// auth.ts — routes Map pakai UUID sebagai key
// Budi login → routes disave dengan key UUID, bukan 'd1'
// getStoredRoutes() filter UUID === 'd1' → tidak cocok → [] kosong

// Kondisi ini memenuhi stored.length === 0
// activeRoutes() fallback ke ROUTES static (4 rute)

// Sesudah fix — fallback single-access pakai routes dari satu-satunya key Map
if (Object.keys(map).length === 1) {
  const singleId = Object.keys(map)[0]
  routeGroups = [[singleId, map[singleId] || []]  // ✅ pakai UUID yang benar
}
```

### Bug 3: `activeDermagaId` Tidak Di-inisialisasi di RouteSelectScreen

```tsx
// RouteSelectScreen.tsx
const activeDermagaId = useApp().activeDermagaId
// Initial state = null

const dermagaFiltered = activeDermagaId
  ? routes.filter(r => r.dermagaId === activeDermagaId)
  : routes  // ❌ null → semua rute tampil
```

Fix: auto-init dari `getStoredDermaga()` atau `officer.dermagaAccess[0]`:

```tsx
useEffect(() => {
  if (activeDermagaId) return
  const stored = getStoredDermaga()
  if (stored?.id) setActiveDermaga(stored.id)
  else if (officer.dermagaAccess?.[0]?.id) setActiveDermaga(officer.dermagaAccess[0].id)
}, [activeDermagaId, officer.dermagaAccess, setActiveDermaga])

// Filter mutlak — tidak ada fallback ke semua rute
const dermagaFiltered = routes.filter(r => r.dermagaId === activeDermagaId)
```

## Files Diedit

| File | Perubahan |
|------|-----------|
| `src/pages/mobile/RouteSelectScreen.tsx` | Auto-init `activeDermagaId`, strict filter |
| `src/services/auth.ts` | `getStoredRoutes()` fallback single-access |
| `src/services/officers.ts` | `dermagaAccess` → `bo.dermagas \|\| []` |

## Test Plan

1. Login sebagai Budi Santoso (D1 Badau) — harus lihat 2 rute SJRE-SBDZ/SBDZ-SJRE
2. Login sebagai Andi Pratama (D2 Badau) — harus lihat 2 rute AAAA-BBBB/BBBB-AAAA
3. Login sebagai Dewi Kusuma (D1+D2 Badau) — harus lihat 4 rute
4. Backend `/routes/mine` harus filter benar

## Spesifikasi Akses Dermaga (dari access.md Revisi #3)

| Officer | Wilayah | Dermaga | Rute |
|---------|---------|---------|------|
| Budi Santoso | Badau | D1 | SJRE ⇄ SBDZ |
| Andi Pratama | Badau | D2 | AAAA ⇄ BBBB |
| Dewi Kusuma | Badau | D1+D2 | semua Badau |
| Siti Rahayu | Badau | D1 | SJRE ⇄ SBDZ |
| Agung Suntoso | Belitung | D1 | CCCC ⇄ DDDD |
| Rahmat Hidayat | Belitung | D2 | EEEE ⇄ FFFF |
| Hendra Gunawan | Kelapa Kampit | D1 | GGGG ⇄ HHHH |
| Maya Sari | Kelapa Kampit | D2 | IIII ⇄ JJJJ |
