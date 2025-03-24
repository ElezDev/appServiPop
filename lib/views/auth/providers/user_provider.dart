// providers/user_provider.dart
import 'package:flutter/foundation.dart';
import 'package:servipopapp/models/user_model.dart';
import 'package:servipopapp/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService;
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  UserProvider({
    required UserService userService,
  }) : _userService = userService;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUser(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userService.getUserProfile(token);
      _error = null;
    } catch (e) {
      _user = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(String token, User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Aquí deberías llamar al servicio para actualizar el usuario
      // await _userService.updateUserProfile(token, updatedUser);
      
      _user = updatedUser;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    _error = null;
    notifyListeners();
  }
}