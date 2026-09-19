class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Trip Angkut';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Sistem Informasi Angkutan Plantation';

  // Storage Keys
  static const String boxName = 'trip_angkut_box';
  static const String userBox = 'users';
  static const String tripBox = 'trips';
  static const String vehicleBox = 'vehicles';
  static const String tariffBox = 'tariffs';
  static const String regionBox = 'regions';
  static const String syncQueueBox = 'sync_queue';

  // Auth Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String deviceIdKey = 'device_id';
  static const String isLoggedInKey = 'is_logged_in';

  // Trip Status
  static const String tripStatusActive = 'active';
  static const String tripStatusCompleted = 'completed';
  static const String tripStatusFailed = 'failed';

  // Vehicle Golongan
  static const String golonganInternal = 'internal';
  static const String golonganEksternal = 'eksternal';

  // Vehicle Jenis
  static const String jenisTruk = 'truk';
  static const String jenisMobil = 'mobil';
  static const String jenisMotor = 'motor';

  // Muatan
  static const String muatanAda = 'dengan_muatan';
  static const String muatanKosong = 'tanpa_muatan';

  // Status Muatan Trip
  static const String statusMuatanAda = 'ada_muatan';
  static const String statusMuatanKosong = 'kosong';

  // Sync
  static const int syncIntervalMinutes = 15;
  static const int maxRetryCount = 5;
  static const int maxPendingItems = 100;

  // Location
  static const double defaultLatitude = 0.0;
  static const double defaultLongitude = 0.0;
  static const double locationAccuracyThreshold = 50.0; // meters
  static const Duration locationTimeout = Duration(seconds: 10);

  // Image
  static const int imageMaxWidth = 1920;
  static const int imageMaxHeight = 1080;
  static const int imageQuality = 80;
  static const int imageCompressionQuality = 70;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration loginTimeout = Duration(seconds: 15);

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;

  // Color Codes
  static const int primaryColor = 0xFF1976D2;
  static const int accentColor = 0xFFFF9800;
  static const int successColor = 0xFF4CAF50;
  static const int errorColor = 0xFFF44336;
  static const int warningColor = 0xFFFFEB3B;
  static const int backgroundColor = 0xFFF5F5F5;
  static const int cardColor = 0xFFFFFFFF;
}