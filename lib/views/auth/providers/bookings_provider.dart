// lib/features/bookings/providers/bookings_provider.dart
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'package:servipopapp/services/auth_service.dart';

class BookingsProvider extends ChangeNotifier {
  List<dynamic> _bookings = [];
  bool _isLoading = false;
  String _errorMessage = '';
    final AuthService _authService = AuthService();



  List<dynamic> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchBookings() async {
    try {
      _setLoading(true);
      _setErrorMessage('');

      final token = await _authService.getToken();
      final response = await DioClient.dio.get(
        'bookings_by_provider',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        _setBookings(response.data);
      } else {
        _setErrorMessage('Failed to load bookings');
      }
    } on DioException catch (e) {
      _setErrorMessage(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      _setErrorMessage('An unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  void _setBookings(List<dynamic> bookings) {
    _bookings = bookings;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> refreshBookings() async {
    await fetchBookings();
  }
}