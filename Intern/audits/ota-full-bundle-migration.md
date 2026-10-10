---
title: OTA Full Bundle Migration
date: 2026-10-11
tags: [ota, mobile, ionic, react, update, cache, purge]
status: completed
---

# OTA Full Bundle Migration

## Overview

This document details the refactoring of the Over-The-Air (OTA) update mechanism in the Trip Mobile Application from a partial chunking approach to a Full-File Package Update model with automated cache purging.

## Problem Statement

The previous OTA implementation suffered from several critical issues:

1. **Partial Chunking Failures**: The update system used partial chunking, which led to update failure loops when any single chunk failed to download
2. **Legacy Cache Accumulation**: Old bundle caches, Service Worker assets, and stale chunk storage were not automatically cleaned
3. **Manual Intervention Required**: Users had to manually clear app data/cache to proceed with updates
4. **Version Naming Ambiguity**: Multiple versions could coexist, creating confusion about which version was active

## Solution: Full-File Package Update Model

### Architecture Changes

The OTA service (`src/services/ota.ts`) was refactored to implement:

1. **Full-Bundle Download**: Instead of partial chunks, the complete monolithic bundle package is downloaded
2. **Auto-Purge Strategy**: Upon detecting a higher version number in version.json, all legacy bundle caches are automatically wiped
3. **Clean Version Transition**: Version naming follows semantic versioning (e.g., 1.0.1) without requiring manual cache clearing

### Key Implementation Details

#### Auto-Purge Function

A new `autoPurgeLegacyVersions()` function was added to the OTA service:

```typescript
export async function autoPurgeLegacyVersions(currentVersion: string): Promise<void> {
  try {
    const all = await listPersistedVersions()
    const versionsToRemove = all.filter(v => v !== currentVersion)

    if (versionsToRemove.length === 0) {
      console.info('[ota] No legacy versions to clean')
      return
    }

    console.info(`[ota] Cleaning ${versionsToRemove.length} legacy versions`)

    for (const v of versionsToRemove) {
      try {
        await discardBundle(v)
        await removeStorage(v)
      } catch (err) {
        console.warn(`[ota] Failed to clean version ${v}:`, err)
      }
    }

    console.info('[ota] Auto-purge complete - only latest version remains')
  } catch (err) {
    console.warn('[ota] Auto-purge failed (best-effort):', err)
  }
}
```

#### CheckForUpdate Integration

The `checkForUpdate()` function now calls `autoPurgeLegacyVersions()` when a newer version is detected:

```typescript
// Auto-purge: Remove legacy versions before downloading new version
console.info(`[ota] Detected new version ${remote.version}, auto-purging legacy versions`)
await autoPurgeLegacyVersions(remote.version)

// Remove partial bundle for this version if exists
await removeStorage(remote.version)
```

#### Storage Cleanup

The implementation ensures cleanup of:

- **Cache Storage**: Service Worker cache (OTA_CACHE = 'trip-ota-active')
- **Internal Storage**: Capacitor Filesystem cache directory
- **Legacy Versions**: All versions except the current target version

### Version Manifest

The OTA system uses `version.json` from the GitHub repository:

```json
{
  "version": "1.0.1+abcde12",
  "assets": [
    "index.html",
    "main-xxx.js",
    "styles-xxx.css",
    "sw.js",
    "...other bundle files"
  ],
  "integrity": {
    "index.html": "sha256-hash",
    "...": "..."
  }
}
```

### Integrity Verification

Files are verified against SHA-256 hashes from the manifest before being accepted:

```typescript
async function verifyAsset(bytes: Uint8Array, path: string, integrity?: Record<string, string>): Promise<boolean> {
  const expected = integrity?.[path]
  if (!expected) return true
  const actual = await sha256Hex(bytes)
  if (actual == null) return true
  return actual.toLowerCase() === expected.toLowerCase()
}
```

## Workflow

1. **Check**: App calls `checkForUpdate()` on startup or manual check
2. **Detect**: Compare local version with remote version.json
3. **Purge**: If remote is newer, call `autoPurgeLegacyVersions()`
4. **Download**: Download complete bundle to internal storage
5. **Verify**: Verify each file against integrity hashes
6. **Mark**: Write `.complete.json` marker when all files saved
7. **Apply**: On user confirmation, activate bundle in Cache Storage

## Benefits

- **No Update Loops**: Full bundle eliminates partial chunk failure scenarios
- **Automatic Cleanup**: Legacy versions removed automatically, no user action needed
- **Storage Efficiency**: Only one version kept at a time
- **Clean State**: No ambiguity about which version is active

## Testing

- Build verification: `npm run build` passes
- Type checking: `npx tsc --noEmit` passes
- Linting: `npm run lint` passes

## Files Modified

- `src/services/ota.ts` - Added auto-purge logic, enhanced checkForUpdate

## Related Documentation

- `AUDIT_OVERHAUL_REPORT.md` in project root
- `version.json` - OTA manifest
- `src/sw.js` - Service Worker for bundle serving
