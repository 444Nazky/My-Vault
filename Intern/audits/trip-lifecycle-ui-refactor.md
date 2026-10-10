---
title: Trip Lifecycle UI Refactor
date: 2026-10-11
tags: [trip, lifecycle, ui, refactor, empty-trip, selfie, mobile, ionic]
status: completed
---

# Trip Lifecycle UI Refactor

## Overview

This document details the refactoring of the trip lifecycle management, including fixes for empty trip states, removal of redundant placeholders, and elimination of selfie duplication bugs in the Trip Mobile Application.

## Problem Statement

The original trip lifecycle had several issues:

1. **Empty Trip Workflow**: Unclear requirements for empty trip documentation, leading to inconsistent state
2. **Redundant Placeholders**: Unnecessary duration tracking and vehicle detail forms for empty trips
3. **Selfie Duplication**: Closing selfies (swafoto penutup) could be duplicated in trip summary screen and final payload
4. **Photo State Confusion**: Mixed state logic between trip photos, vehicle photos, and selfies

## Solution: Trip Lifecycle Overhaul

### Empty Trip State Fix

#### Requirements

For empty trips (Trip Kosong), the following rules were enforced:

1. **Single Photo Requirement**: Exactly 1 proof photo required before submission
2. **No Duration Tracking**: Duration field stripped from empty trip payload
3. **No Vehicle Form**: Vehicle detail forms removed for empty trips
4. **Clean Empty State**: No placeholder images or -1 indicators

#### Implementation

**TripConditionScreen.tsx** was updated to properly initialize empty trip state:

```typescript
onClick={() => {
  setCondition('kosong')
  patchDraft({
    condition: 'kosong',
    vehicles: [],
    vehicleForm: { plate: '', type: '', category: '' },
    photo: false,
    photoUrl: undefined,
    photoCapturedAt: undefined,
    photoLatitude: undefined,
    photoLongitude: undefined,
    // Vehicle photo NOT required for empty trips
    vPhoto: false,
    vPhotoUrl: undefined,
    vPhotoCapturedAt: undefined,
    vPhotoLatitude: undefined,
    vPhotoLongitude: undefined,
    retakeTarget: undefined,
    cameraMode: 'photo',
    // Clear selfie state for empty trips
    selfieMode: undefined,
    selfieUrl: undefined,
    selfieCapturedAt: undefined,
  })
}}
```

**TripSummaryScreen.tsx** submit handler validates photo before submission:

```typescript
const handleSubmit = () => {
  if (draft.condition === 'kosong') {
    if (!draft.photoUrl) {
      patchDraft({ cameraFrom: 'trip-summary', cameraMode: 'photo' })
      go('camera')
      return
    }
    startTrip()
    finishEmptyTrip()
    go('trip-complete')
  }
  // ... muatan handling
}
```

### Loaded Trip State Fix

#### Requirements

For loaded trips (Trip Muatan/Ada Muatan):

1. **Route Validation**: Route must be selected and validated
2. **Vehicle Input**: Vehicle details required (plate, type, category)
3. **Dynamic Image Capture**: Photos captured in loop per vehicle
4. **Closing Selfie**: Exactly ONE closing selfie required (swafoto penutup)

#### Implementation

**TripConditionScreen.tsx** initializes muatan trip state:

```typescript
onClick={() => {
  setCondition('muatan')
  patchDraft({
    condition: 'muatan',
    photo: false,
    photoUrl: undefined,
    // Vehicle and photos handled in vehicle form screen
    vehicles: [],
    vehicleForm: { plate: '', type: '', category: '' },
    vPhoto: false,
    // Closing selfie required at end of trip
    selfieMode: undefined,
    selfieUrl: undefined,
    selfieCapturedAt: undefined,
    retakeTarget: undefined,
    cameraMode: 'photo',
  })
}}
```

### Selfie Duplication Bug Fix

#### Problem

The closing selfie (swafoto penutup) for muatan trips was potentially being:
1. Stored multiple times in IndexedDB
2. Displayed in duplicate in trip summary screen
3. Included multiple times in final payload

#### Solution

**Single Storage Location**: Selfie is stored once in:
- `draft.selfieUrl` during capture
- `trip.selfieUrl` in trip record upon completion

**Separation from Gallery**: Selfie is NOT included in the documentation gallery.

**HistoryDetailScreen.tsx** - Dedicated selfie section:

```typescript
// Selfie separated from documentation gallery
const selfieUrl = t.selfieUrl
const selfieCapturedAt = t.selfieCapturedAt

// Photos array excludes selfie
const photos: DocPhoto[] = [
  ...(t.photoUrl ? [{ url: t.photoUrl, label: 'Foto Bukti Trip', kind: 'trip' as const }] : []),
  ...vehicles.map((v, i) => ({
    url: v.photoUrl ?? '',
    label: unitLabel(vehicles, i),
    kind: 'vehicle' as const,
    index: i,
  })).filter(p => !!p.url),
]
```

**Dedicated Selfie Display**:

```typescript
{selfieUrl && (
  <div className="bg-white rounded-2xl p-4 shadow-sm border border-slate-100 mb-3">
    <div className="flex items-center justify-between mb-3">
      <p className="text-[11px] font-bold text-slate-500 uppercase tracking-wide">
        Swafoto Penutup
      </p>
    </div>
    <div className="rounded-xl overflow-hidden border border-slate-200 bg-slate-100">
      <img src={selfieUrl} alt="Swafoto Penutup" className="w-full h-32 object-cover" />
      <div className="bg-slate-800 px-3 py-2 text-center">
        <p className="text-white text-[10px] font-black">SWAFOTO PENUTUP</p>
        <p className="text-slate-400 text-[9px] mt-0.5">
          {selfieCapturedAt ? new Date(selfieCapturedAt).toLocaleString('id-ID') : ''}
        </p>
      </div>
    </div>
  </div>
)}
```

**TripSummaryScreen.tsx** - No selfie in summary:

```typescript
// Selfie not displayed in summary - only in history detail
const showSelfiePlaceholder = false
```

### Photo State Management

The draft state now has clearly separated photo slots:

| Slot | Purpose | Required For |
|------|---------|--------------|
| `draft.photo` / `draft.photoUrl` | Trip proof photo | Both empty and muatan |
| `draft.vPhoto` / `draft.vPhotoUrl` | Vehicle document photo | Muatan (per vehicle) |
| `draft.selfieUrl` | Closing selfie | Muatan only |

### Finish Functions

**finishEmptyTrip()** - No duration, no vehicles:

```typescript
const trip: Trip = {
  id,
  route: routeLabel,
  routeCode,
  routeFrom,
  routeTo,
  status: 'Selesai',
  time: fmtClock(now),
  date: fmtDate(now),
  load: 'Kosong',
  vehicle: '-',
  type: '-',
  category: '-',
  revenue: '-',
  revenueNum: 0,
  officer: officer.name,
  officerId: String(officer.id),
  duration: '-',  // No duration for empty trips
  photo: !!draft.photoUrl,
  photoUrl: draft.photoUrl,
  photoCapturedAt: draft.photoCapturedAt,
  photoLatitude: draft.photoLatitude ?? null,
  photoLongitude: draft.photoLongitude ?? null,
  startedAt: draft.startedAt ? new Date(draft.startedAt).toISOString() : now.toISOString(),
  completedAt: now.toISOString(),
  vehicles: [],
  synced: false,
}
```

**finishMuatanTrip()** - Includes selfie, vehicles, duration:

```typescript
const trip: Trip = {
  // ... other fields
  vehicles,
  synced: false,
  selfieUrl: draft.selfieUrl,        // Selfie included once
  selfieCapturedAt: draft.selfieCapturedAt,
}
```

## Files Modified

| File | Changes |
|------|---------|
| `src/pages/mobile/TripConditionScreen.tsx` | Empty trip initialization, muatan trip initialization |
| `src/pages/mobile/TripSummaryScreen.tsx` | Submit validation, photo requirement check |
| `src/pages/mobile/HistoryDetailScreen.tsx` | Selfie separation from gallery, dedicated selfie section |
| `src/pages/store.tsx` | finishEmptyTrip, finishMuatanTrip (reviewed, no changes needed) |

## Testing

- Build verification: `npm run build` passes
- Type checking: `npx tsc --noEmit` passes
- Linting: `npm run lint` passes

## UX Improvements

1. **Clear Photo Requirements**: Users see exactly what photos are needed
2. **No Confusing Placeholders**: Empty states are clean, no -1 or phantom images
3. **Selfie Once**: Closing selfie stored and displayed exactly once
4. **Proper Navigation**: Back buttons and forward progression work correctly

## Related Documentation

- `AUDIT_OVERHAUL_REPORT.md` in project root
- `src/pages/mobile/TripConditionScreen.tsx` - Source implementation
- `src/pages/mobile/TripSummaryScreen.tsx` - Source implementation
- `src/pages/mobile/HistoryDetailScreen.tsx` - Source implementation
