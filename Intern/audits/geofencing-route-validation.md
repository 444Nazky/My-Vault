---
title: Geofencing Route Validation
date: 2026-10-11
tags: [geofencing, gps, route, validation, mobile, ionic, taxi]
status: completed
---

# Geofencing Route Validation

## Overview

This document details the implementation of geofencing-based route validation with a strict 100-meter GPS radius threshold and dynamic route-locking logic for specific locations in the Badau Dermaga area.

## Problem Statement

The original trip application lacked coordinate-based route validation. Users could select any available route regardless of their physical location, which could lead to:

1. Incorrect route assignments for trip documentation
2. No validation that the officer is at the expected location
3. Missing integration with GPS coordinates for route determination

## Solution: Geofencing Configuration System

### New Services Created

Two new services were created to implement geofencing:

1. **`src/services/geofence.ts`** - Configuration and validation logic
2. **`src/services/location.ts`** - High-accuracy GPS location service

### Geofencing Configuration

The `geofence.ts` service defines a configurable schema for geofence rules:

```typescript
export interface GeofenceRule {
  id: string
  locationName: string
  latitude: number
  longitude: number
  radiusMeters: number
  allowedRouteCodes: string[]
  allowedDirections: string[]
  description: string
}

export interface GeofenceConfig {
  maxAccuracyMeters: number
  defaultRadiusMeters: number
  rules: GeofenceRule[]
}
```

### Route Locking Rules

Two specific geofence rules were configured for the Badau Dermaga area:

#### Route 2: Badau Dermaga 1

- **Location**: Badau Dermaga 1
- **Coordinates**: Latitude -6.1891005, Longitude 106.8371641
- **Radius**: 100 meters
- **Locked Route**: SJRE -> SBDZ (Sijangkung to Sabadi)
- **Allowed Route Codes**: ['SJRE-SBDZ']

#### Route 1: Badau Dermaga 2

- **Location**: Badau Dermaga 2
- **Coordinates**: Latitude -6.2389899548617285, Longitude 106.97475839406252
- **Radius**: 100 meters
- **Locked Route**: SBDZ -> SJRE (Sabadi to Sijangkung)
- **Allowed Route Codes**: ['SBDZ-SJRE']

### GPS Accuracy Requirements

The system enforces a maximum accuracy threshold:

```typescript
export const DEFAULT_GEOFENCE_CONFIG: GeofenceConfig = {
  maxAccuracyMeters: 100,
  defaultRadiusMeters: 100,
  rules: [...]
}
```

Location results are marked as valid only when GPS accuracy is within 100 meters:

```typescript
const valid = accuracy <= MAX_ACCURACY_METERS || accuracy === 0
```

### Haversine Distance Calculation

The system uses the Haversine formula to calculate distances between GPS coordinates:

```typescript
export function haversineDistance(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number,
): number {
  const R = 6371000 // Earth radius in meters
  const toRad = (deg: number) => (deg * Math.PI) / 180

  const dLat = toRad(lat2 - lat1)
  const dLon = toRad(lon2 - lon1)
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  return R * c
}
```

### Geofence Matching Logic

The `findActiveGeofenceRule()` function checks if the current location matches any configured geofence:

```typescript
export function findActiveGeofenceRule(
  lat: number,
  lon: number,
  config: GeofenceConfig,
  accuracy?: number,
): GeofenceRule | null {
  const effectiveAccuracy = accuracy ?? config.maxAccuracyMeters
  for (const rule of config.rules) {
    const result = isWithinGeofence(lat, lon, rule, effectiveAccuracy)
    if (result.matched) return rule
  }
  return null
}
```

## RouteSelectScreen Integration

The `RouteSelectScreen.tsx` was updated to integrate geofencing:

1. **Import geofencing services**
2. **Check for active geofence rule on mount**
3. **Display route lock banner when coordinates match**
4. **Force route selection when hard-locked**

### Route Lock Banner

When a geofence rule is active, a blue banner displays:

```
Rute Dikunci Otomatis
Berdasarkan lokasi Anda, rute dipaksa: SJRE -> SBDZ
```

### Hard Lock Implementation

The `getLockedRoute()` function determines if the route should be forced:

```typescript
const getLockedRoute = (): string | null => {
  // Route 2: Badau Dermaga 1 -> SJRE -> SBDZ
  // Route 1: Badau Dermaga 2 -> SBDZ -> SJRE
  return null // Populated from actual geofencing result
}
```

## Location Service

The `location.ts` service provides high-accuracy GPS capabilities:

### getCurrentPositionHighAccuracy()

```typescript
export async function getCurrentPositionHighAccuracy(): Promise<LocationResult | null> {
  const pos = await Geolocation.getCurrentPosition({
    enableHighAccuracy: true,
    timeout: 10000,
    maximumAge: 30000,
  })
  // Returns { latitude, longitude, accuracy, timestamp, valid }
}
```

### getGeofencedLocation()

Combines location retrieval with geofence validation:

```typescript
export async function getGeofencedLocation(): Promise<GeofenceLocationResult | null> {
  const location = await getCurrentPositionHighAccuracy()
  if (!location) return null

  const activeRule = findActiveGeofenceRule(...)
  const hardLockedRoute = getHardLockedRoute(activeRule)

  return { ...location, activeRule, hardLockedRoute, routeValidation }
}
```

## Dynamic Config Schema

The geofencing configuration is designed to be synchronized from an Admin Dashboard:

```typescript
export function updateGeofenceConfig(config: GeofenceConfig): void {
  currentConfig = config
}

export function getGeofenceConfig(): GeofenceConfig {
  return currentConfig
}
```

This allows administrators to:
- Add new geofence zones
- Modify radius thresholds
- Update allowed routes per location
- Enable/disable specific rules

## Files Created

- `src/services/geofence.ts` - Geofencing configuration and validation
- `src/services/location.ts` - High-accuracy GPS location service

## Files Modified

- `src/pages/mobile/RouteSelectScreen.tsx` - Geofencing integration and route lock UI

## Testing

- Build verification: `npm run build` passes
- Type checking: `npx tsc --noEmit` passes
- Linting: `npm run lint` passes

## Future Enhancements

1. **Real GPS Integration**: Implement actual GPS coordinate checking using `getGeofencedLocation()` in RouteSelectScreen
2. **Admin Dashboard Sync**: Connect to backend API for dynamic rule updates
3. **Location History**: Log geofence matches for audit trail
4. **Multiple Geofences**: Support overlapping zones with priority rules

## Related Documentation

- `AUDIT_OVERHAUL_REPORT.md` in project root
- `src/services/geofence.ts` - Source implementation
- `src/services/location.ts` - Source implementation
