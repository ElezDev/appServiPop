// lib/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:servipopapp/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  String? _loginError;

  bool get isAuthenticated => _isAuthenticated;
  String? get loginError => _loginError;

  Future<void> checkAuth() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

   Future<void> login(String email, String password) async {
    try {
      _loginError = null;
      notifyListeners();
      
      await _authService.login(email, password);
      _isAuthenticated = true;
      notifyListeners();
    } on LoginException catch (e) {
      _loginError = _translateError(e.message);
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _loginError = 'Ocurrió un error inesperado';
      _isAuthenticated = false;
      notifyListeners();
      throw LoginException('Ocurrió un error inesperado');
    }
  }
String _translateError(String error) {
    switch (error) {
      case 'invalid_credentials':
        return 'Correo o contraseña incorrectos';
      case 'account_disabled':
        return 'Tu cuenta ha sido desactivada';
      case 'email_not_verified':
        return 'Por favor verifica tu correo electrónico primero';
      default:
        return error;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}