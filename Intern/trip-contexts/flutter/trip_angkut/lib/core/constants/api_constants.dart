class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://api.tripangkut.com/v1';
  static const String devBaseUrl = 'http://10.0.2.2:8000/v1'; // For emulator

  // Endpoints
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';

  static const String trips = '/trips';
  static String tripDetail(String id) => '/trips/$id';
  static String tripComplete(String id) => '/trips/$id/complete';
  static String tripVehicles(String id) => '/trips/$id/vehicles';
  static String tripVehicleDetail(String tripId, String vehicleId) =>
      '/trips/$tripId/vehicles/$vehicleId';

  static const String reportsSummary = '/reports/summary';
  static const String reportsDaily = '/reports/daily';
  static const String reportsExport = '/reports/export';

  static const String adminUsers = '/admin/users';
  static const String adminTariffs = '/admin/tariffs';
  static const String adminRegions = '/admin/regions';

  // Headers
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String applicationJson = 'application/json';

  // Query Parameters
  static const String queryPage = 'page';
  static const String queryLimit = 'limit';
  static const String queryStartDate = 'start_date';
  static const String queryEndDate = 'end_date';
  static const String queryRegionId = 'region_id';
  static const String queryStatus = 'status';

  // Response Keys
  static const String keySuccess = 'success';
  static const String keyData = 'data';
  static const String keyError = 'error';
  static const String keyCode = 'code';
  static const String keyMessage = 'message';
  static const String keyToken = 'token';
  static const String keyUser = 'user';
  static const String keyTrips = 'trips';
  static const String keyVehicles = 'vehicles';
  static const String keyTariffs = 'tariffs';
  static const String keyRegions = 'regions';
}