# Session — Audit & Security Fixes (2025-10-11)

## Scope
Full repo audit across:
- `Aplikasi-Trip-Main Branch/` — mobile app + backend
- `Trip-Dashboard Admin Branch/` — admin dashboard
- `endpoint-trip Endpoint Branch/` — Firebase functions

Load assumed: dozens of field officers + 1 admin dashboard.

---

## Must Fix (fixed)

### 1. JWT secret hardcoded in source
**Files:** `backend/src/middleware/auth.js`, `backend/src/routes/auth.js`

`JWT_SECRET = process.env.JWT_SECRET || 'trip-angkut-secret-key'` — silent fallback meant the app ran with a predictable secret anyone could forge tokens with.

**Fix:** Server now exits on boot if `JWT_SECRET` env var is absent.

**Deploy note:** Set `JWT_SECRET` in Railway environment variables (e.g. `openssl rand -hex 32`).

### 2. Admin default credentials `admin/admin123` in source
**File:** `backend/src/routes/auth.js`

**Fix:** `ADMIN_USERNAME` + `ADMIN_PASSWORD` env vars now required. No fallback defaults. Admin must set these on Railway.

### 3. Admin dashboard Overview tab always showed 0 active officers
**File:** `Trip-Dashboard Admin Branch/src/pages/store.tsx`

`useMemo` passed `tariffs: []` and `officers: []` instead of reading from state. Fixed the memo to read real values and fixed the dependency array.

### 4. Member login bypassed PIN verification
**File:** `backend/src/routes/auth.js`

`POST /auth/member-login` accepted `username` + shared password (`123456`), looked up officer by name map, and issued a JWT. Any officer could impersonate any other.

**Fix:** Now requires `username` + `pin` (not password). Verifies bcrypt hash from `officers.pin` column. Falls back to PIN-based login endpoint for devices using officerId + PIN.

### 5. PIN hashes shipped in mobile source code
**Files:** `src/services/seedData.ts`, `src/services/offlineDb.ts`

`pinHash: '$2a$10$...` fields in seed officers meant bcrypt hashes for default PINs were readable in the APK. A cracked GPU could recover `123456` from them in seconds.

**Fix:** Removed `pinHash` from `SeedOfficer` interface and all seed entries. `verifySeedPin()` always returns `false`. Officers must log in online once to get their hash cached, or rely on server sync.

### 6. Trip number used predictable `Math.random()`
**File:** `backend/src/routes/trips.js`

`Math.random()` is predictable in V8 — trip numbers were enumerable. Replaced with `crypto.randomBytes(3)` (Node.js built-in, no new dependency).

### 7. Firebase endpoint syntax errors
**File:** `endpoint-trip Endpoint Branch/functions/index.js`

Duplicate `});` on `apiHealth` and `apiInfo` exports made those endpoints unreachable. Removed the stray closing braces.

### 8. Vehicle tariff accepted client-sent amount as fallback
**File:** `backend/src/routes/trips.js`

When no master tariff matched the vehicle type, the server accepted `vehicle.tariffAmount` from the mobile payload. A tampered APK could inflate prices.

**Fix:** Amount now comes only from the server's master tariff, or `0` if unknown, with a warning log.

### 9. OTA update system failed to detect secondary updates
**File:** `src/services/ota.ts`

The old code only called `autoPurgeLegacyVersions` after deciding a new version existed. If version A was stuck downloading, version B was never detected.

**Fix:** Restructured `checkForUpdate()` into three clean phases:
1. Fetch manifest (always fresh)
2. Compare versions — if not newer, done immediately
3. If newer: `discardBundle()` + `resetOtaStorage()` → full clean slate → download everything → verify → mark ready

Removed `autoPurgeLegacyVersions`, `purgeStaleBundleVersions`, `clearStuckOtaState`, `listPersistedVersions` (no longer needed). Added `resetOtaStorage()` back as a minimal single-purpose wipe function.

### 10. `nextTripId` risked ID collisions across devices
**File:** `src/pages/store.tsx`

Generated sequential IDs from local state only — two devices could pick the same ID, causing upsert conflicts.

**Fix:** Primary ID is now `crypto.randomUUID()`. Falls back to sequential format for any legacy local trips.

### 11. Admin dashboard `localStorage` key collision with mobile app
**File:** `Trip-Dashboard Admin Branch/src/pages/store.tsx`

Both apps used `trip.trips.v1`, `trip.officers.v1`, etc. — an admin in the same browser as the mobile app would overwrite their own trip data.

**Fix:** Prefixed all admin keys: `trip.admin.trips.v1`, `trip.admin.tariffs.v1`, `trip.admin.officers.v1`, `trip.admin.session.v1`.

---

## Nice to Have (fixed)

### Unused packages removed
**File:** `package.json`

Removed `expo`, `railway` (not imported anywhere), and `sharp@0.32.6` / `@parcel/watcher` from `allowScripts`.

---

## Deployment checklist

Before pushing to Railway:

- [ ] Set `JWT_SECRET` environment variable (e.g. `openssl rand -hex 32`)
- [ ] Set `ADMIN_USERNAME` environment variable
- [ ] Set `ADMIN_PASSWORD` environment variable
- [ ] Verify no `trip-angkut-secret-key` appears in runtime logs

---

## OTA publish workflow

See [[OTA Update System]] for the full cheatsheet.
