import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService;
  final Dio _dio;

  AuthService(this._storageService)
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: AppConstants.loginTimeout,
          receiveTimeout: AppConstants.loginTimeout,
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
          },
        ));

  // Hash PIN dengan SHA-256
  static String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Login dengan PIN
  Future<LoginResult> login(String pin) async {
    try {
      // Validasi PIN format
      if (pin.length != 6 || !RegExp(r'^\d{6}$').hasMatch(pin)) {
        return LoginResult(
          success: false,
          error: 'PIN harus 6 digit angka',
        );
      }

      // Hash PIN
      final pinHash = hashPin(pin);

      // Dapatkan device ID
      String deviceId = _storageService.getDeviceId() ?? '';
      if (deviceId.isEmpty) {
        deviceId = const Uuid().v4();
        await _storageService.saveDeviceId(deviceId);
      }

      // Kirim ke backend
      final response = await _dio.post(
        ApiConstants.authLogin,
        data: {
          'pin': pinHash,
          'device_id': deviceId,
        },
      );

      // Parse response
      if (response.data[ApiConstants.keySuccess] == true) {
        final data = response.data[ApiConstants.keyData];
        final token = data[ApiConstants.keyToken];

        // Simpan token
        await _storageService.saveToken(token);
        await _storageService.setLoggedIn(true);

        return LoginResult(
          success: true,
          token: token,
          user: data[ApiConstants.keyUser],
        );
      } else {
        final error = response.data[ApiConstants.keyError];
        return LoginResult(
          success: false,
          error: error[ApiConstants.keyMessage] ?? 'Login gagal',
        );
      }
    } on DioException catch (e) {
      String errorMessage;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Koneksi timeout. Periksa jaringan Anda.';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Tidak ada koneksi internet.';
          break;
        case DioExceptionType.badResponse:
          errorMessage = _handleBadResponse(e.response?.statusCode);
          break;
        default:
          errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      }

      return LoginResult(
        success: false,
        error: errorMessage,
      );
    } catch (e) {
      return LoginResult(
        success: false,
        error: 'Terjadi kesalahan tidak terduga: $e',
      );
    }
  }

  // Refresh token
  Future<RefreshResult> refreshToken() async {
    try {
      final currentToken = _storageService.getToken();
      if (currentToken == null) {
        return RefreshResult(
          success: false,
          error: 'Tidak ada token',
        );
      }

      final response = await _dio.post(
        ApiConstants.authRefresh,
        options: Options(
          headers: {
            ApiConstants.authorization: '${ApiConstants.bearerPrefix}$currentToken',
          },
        ),
      );

      if (response.data[ApiConstants.keySuccess] == true) {
        final newToken = response.data[ApiConstants.keyData][ApiConstants.keyToken];
        await _storageService.saveToken(newToken);

        return RefreshResult(
          success: true,
          token: newToken,
        );
      } else {
        return RefreshResult(
          success: false,
          error: 'Gagal refresh token',
        );
      }
    } catch (e) {
      return RefreshResult(
        success: false,
        error: 'Gagal refresh token: $e',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    await _storageService.logout();
  }

  // Cek apakah user sudah login
  bool get isLoggedIn => _storageService.isLoggedIn();

  // Ambil token
  String? get token => _storageService.getToken();

  // Ambil user ID
  String? get userId => _storageService.getUserId();

  // Handle bad response
  String _handleBadResponse(int? statusCode) {
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
  }
}

class LoginResult {
  final bool success;
  final String? token;
  final dynamic user;
  final String? error;

  LoginResult({
    required this.success,
    this.token,
    this.user,
    this.error,
  });
}

class RefreshResult {
  final bool success;
  final String? token;
  final String? error;

  RefreshResult({
    required this.success,
    this.token,
    this.error,
  });
}