# Firebase Authentication Integration

## Overview

Firebase Auth digunakan untuk autentikasi mobile app dengan metode PIN 6 digit.

## Setup

### Dependencies
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
```

## Authentication Flow

### Login dengan PIN

```dart
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login dengan custom token (dari backend)
  Future<UserCredential> signInWithCustomToken(String token) async {
    return await _auth.signInWithCustomToken(token);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
```

## Firestore Structure

```
/users/{uid}
  - nama: string
  - region_id: string
  - device_id: string
  - created_at: timestamp

/trips/{trip_id}
  - no_trip: string
  - user_id: string
  - region_id: string
  - vehicles: array

/tariffs/{tariff_id}
  - golongan: string
  - jenis_kendaraan: string
  - tarif_muatan: number
```

## Offline Persistence
```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```
