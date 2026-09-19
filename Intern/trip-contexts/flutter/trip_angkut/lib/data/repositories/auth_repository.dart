import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';

class AuthRepository {
  final StorageService _storageService;
  final Dio _dio;

  AuthRepository(this._storageService)
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ));

  // Login
  Future<AuthResult> login(String pinHash, String deviceId) async {
    try {
      final response = await _dio.post(
        ApiConstants.authLogin,
        data: {
          'pin': pinHash,
          'device_id': deviceId,
        },
      );

      if (response.data[ApiConstants.keySuccess] == true) {
        final data = response.data[ApiConstants.keyData];
        final token = data[ApiConstants.keyToken];
        final userData = data[ApiConstants.keyUser];

        // Simpan token
        await _storageService.saveToken(token);
        await _storageService.setLoggedIn(true);

        // Parse user
        if (userData != null) {
          final user = UserModel.fromJson(userData);
          await _storageService.saveUser(user);
          await _storageService.saveUserId(user.id);
        }

        return AuthResult(
          success: true,
          token: token,
        );
      } else {
        final error = response.data[ApiConstants.keyError];
        return AuthResult(
          success: false,
          error: error[ApiConstants.keyMessage] ?? 'Login gagal',
        );
      }
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        error: _handleError(e),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'Terjadi kesalahan: $e',
      );
    }
  }

  // Get current user
  UserModel? getCurrentUser() {
    final userId = _storageService.getUserId();
    if (userId == null) return null;
    return _storageService.getUser(userId);
  }

  // Logout
  Future<void> logout() async {
    await _storageService.logout();
  }

  // Cek apakah sudah login
  bool get isLoggedIn => _storageService.isLoggedIn();

  // Get token
  String? get token => _storageService.getToken();

  // Handle Dio error
  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Periksa jaringan Anda.';
      case DioExceptionType.connectionError:
        return 'Tidak ada koneksi internet.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return 'Data tidak valid';
          case 401:
            return 'PIN salah atau tidak valid';
          case 403:
            return 'Akses ditolak. Perangkat tidak terdaftar.';
          case 404:
            return 'User tidak ditemukan';
          case 429:
            return 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
          case 500:
            return 'Server error. Silakan coba lagi nanti.';
          default:
            return 'Terjadi kesalahan ($statusCode)';
        }
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}

class AuthResult {
  final bool success;
  final String? token;
  final String? error;

  AuthResult({
    required this.success,
    this.token,
    this.error,
  });
}