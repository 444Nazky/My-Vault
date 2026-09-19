import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AuthService _authService;

  AuthProvider(this._authRepository, this._authService);

  // State
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;
  UserModel? _user;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;
  UserModel? get user => _user;

  // Initialize - check if already logged in
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = _authRepository.isLoggedIn;
      if (_isLoggedIn) {
        _user = _authRepository.getCurrentUser();
      }
    } catch (e) {
      _isLoggedIn = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login dengan PIN
  Future<bool> login(String pin) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Hash PIN
      final pinHash = AuthService.hashPin(pin);

      // Dapatkan device ID
      String deviceId = _authService._storageService.getDeviceId() ?? '';
      if (deviceId.isEmpty) {
        // Generate device ID baru
        deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      }

      // Login
      final result = await _authRepository.login(pinHash, deviceId);

      if (result.success) {
        _isLoggedIn = true;
        _user = _authRepository.getCurrentUser();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.logout();
      _isLoggedIn = false;
      _user = null;
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get user name
  String get userName => _user?.nama ?? 'User';

  // Get user region ID
  String? get regionId => _user?.regionId;
}