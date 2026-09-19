import 'package:geolocator/geolocator.dart';
import '../constants/app_constants.dart';
import '../../data/models/region_model.dart';

class LocationService {
  // Minta permission lokasi
  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Layanan lokasi tidak aktif. Mohon aktifkan GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Izin lokasi ditolak. Aplikasi membutuhkan akses GPS.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
          'Izin lokasi ditolak permanen. Mohon aktifkan di pengaturan perangkat.');
    }

    return true;
  }

  // Dapatkan posisi saat ini
  Future<Position> getCurrentPosition() async {
    await requestPermission();

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: AppConstants.locationTimeout,
      );

      // Cek akurasi
      if (position.accuracy > AppConstants.locationAccuracyThreshold) {
        // Log warning tapi tetap return position
        print('Warning: GPS accuracy poor: ${position.accuracy}m');
      }

      return position;
    } catch (e) {
      throw LocationException('Gagal mendapatkan lokasi GPS: $e');
    }
  }

  // Stream posisi real-time
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update setiap 10 meter
      ),
    );
  }

  // Validasi lokasi dalam batas region (geofencing)
  LocationValidation validateLocation(double lat, double lng, RegionModel region) {
    // Cek apakah dalam batas region
    if (region.isWithinBounds(lat, lng)) {
      return LocationValidation(
        isValid: true,
        message: 'Lokasi valid dalam area kerja',
        distance: 0,
      );
    }

    // Hitung jarak dari pusat region
    final distance = region.distanceToCenter(lat, lng);
    return LocationValidation(
      isValid: false,
      message: 'Lokasi Anda di luar area kerja (${distance.toStringAsFixed(1)} km dari pusat)',
      distance: distance,
    );
  }

  // Hitung jarak antara dua titik (Haversine formula)
  static double distanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  // Cek apakah layanan lokasi aktif
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}

class LocationValidation {
  final bool isValid;
  final String message;
  final double distance;

  LocationValidation({
    required this.isValid,
    required this.message,
    required this.distance,
  });
}