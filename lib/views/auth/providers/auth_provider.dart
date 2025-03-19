// lib/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:servipopapp/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuth() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}