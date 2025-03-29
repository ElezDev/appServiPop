// lib/providers/service_provider_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'package:servipopapp/services/auth_service.dart';

class ServiceProviderProvider with ChangeNotifier {
  final Dio _dio = DioClient.dio;

  ServiceProviderProvider();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> registerServiceProvider({
    required String description,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _authService.getToken();

      final response = await _dio.post(
        'service-providers',
        data: {
          "description": description,
          "address": address,
          "latitude": latitude,
          "longitude": longitude,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _isLoading = false;
      notifyListeners();
      return response.statusCode == 201;
    } on DioException catch (e) {
      _isLoading = false;
      _errorMessage =
          e.response?.data['message'] ??
          'Error al registrar proveedor. Intente nuevamente.';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error inesperado: $e';
      notifyListeners();
      return false;
    }
  }
}
