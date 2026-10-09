# Bug Fix: TripConditionScreen — JSX Syntax Error & Emoji Replacement

Tanggal: 2026-09-29

## Bug 1: JSX Syntax Error di TripConditionScreen

### Gejala

Build error TypeScript:
```
src/pages/mobile/TripConditionScreen.tsx(71,15): error TS1005: '}' expected.
```

### Root Cause

Edit sebelumnya mengganti emoji dengan Lucide icons tapi typo di ternary JSX — ternary di dalam `className` belum ditutup `}` dengan benar.

Sebelum fix:
```tsx
<div className={`... ternary...? 'text-blue-600' : 'text-slate-400'} />  // ❌ } di tempat salah
```

### Fix

Rewrite penuh file TripConditionScreen.tsx dengan helper functions untuk className — tidak ada ternary di dalam template literal lagi:

```tsx
const bgForCondition = (key: string) => {
  if (condition !== key) return 'bg-slate-100'
  return key === 'muatan' ? 'bg-blue-100' : 'bg-slate-200'
}
const textColor = (key: string, selected: boolean) => {
  if (!selected) return 'text-slate-400'
  return key === 'muatan' ? 'text-blue-600' : 'text-slate-700'
}
const borderClass = (key: string) => { ... }
const dotColor = (key: string) => { ... }
```

Dua button terpisah (Kosong dan Muatan), tidak ada `.map()` dengan ternary object.

## Bug 2: Emoji di Mobile Screens

### Gejala

Spec Revv.md: "Seluruh emoji pada tombol/status diganti dengan ikon Lucide berbasis SVG."

### Root Cause

Beberapa emoji tersisa dari refactor sebelumnya:

| Lokasi | Emoji |
|---------|-------|
| `TripConditionScreen.tsx` | 🚛 📦 |
| `TripActiveScreen.tsx` | 🚛 |
| `TripSummaryScreen.tsx` | 🚛 |
| `HistoryDetailScreen.tsx` | 🚛 |
| `PinVerifyScreen.tsx` | ⌫ (backspace) |
| `ReportsTab.tsx` | ▶ (chevron) |

### Fix

| File | Fix |
|------|-----|
| `TripConditionScreen.tsx` | `<Truck>` dan `<Package>` dari lucide-react |
| `TripActiveScreen.tsx` | `<Truck>` |
| `TripSummaryScreen.tsx` | `<Truck>` |
| `HistoryDetailScreen.tsx` | `<Truck>` |
| `PinVerifyScreen.tsx` | `<Delete>` icon |
| `ReportsTab.tsx` | `<ChevronRight>` icon |

## Files Diedit

| File | Perubahan |
|------|-----------|
| `src/pages/mobile/TripConditionScreen.tsx` | Rewrite penuh — helper functions, tidak ada ternary di className |
| `src/pages/mobile/PinVerifyScreen.tsx` | Emoji ⌫ → `<Delete>` |
| `src/pages/mobile/TripActiveScreen.tsx` | Emoji 🚛 → `<Truck>` |
| `src/pages/mobile/TripSummaryScreen.tsx` | Emoji 🚛 → `<Truck>` |
| `src/pages/mobile/HistoryDetailScreen.tsx` | Emoji 🚛 → `<Truck>` |
| `src/pages/admin/tabs/ReportsTab.tsx` | Emoji ▶ → `<ChevronRight>` |

## Build Status

```
✓ 0 TypeScript errors
✓ vite build successful (455.78 kB JS, 39.70 kB CSS)
```
