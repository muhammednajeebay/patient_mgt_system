import 'package:flutter/material.dart';
import '../data/models/login_response.dart';
import '../data/repositories/auth_repository.dart';
import '../core/services/storage_service.dart';
import '../core/utils/app_logger.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final StorageService _storageService = StorageService();

  bool _isLoading = false;
  String? _error;
  UserDetails? _currentUser;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UserDetails? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.login(username, password);

      if (response.status == true && response.token != null) {
        await _storageService.saveToken(response.token!);
        _currentUser = response.userDetails;
        _isAuthenticated = true;
        AppLogger.success('Login successful for: $username');
        return true;
      } else {
        _error = response.message;
        _isAuthenticated = false;
        AppLogger.warning('Login failed: ${response.message}');
        return false;
      }
    } catch (e) {
      _error = 'An error occurred during login';
      _isAuthenticated = false;
      AppLogger.error('Login Exception: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Check initial auth state
  Future<void> checkInitialAuth() async {
    final hasToken = await _storageService.hasToken();
    if (hasToken) {
      _isAuthenticated = true;
      // You might want to fetch user details here if there's an endpoint for it
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }
}
