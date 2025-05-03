import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../models/auth_response.dart';

class AuthService {
  final Dio _dio = Dio();
  final StorageService _storageService = StorageService();

  AuthService() {
    _dio.options.baseUrl = 'http://192.168.101.74:8000/api/';

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              final newAuthResponse = await refreshToken();
              error.requestOptions.headers['Authorization'] =
                  'Bearer ${newAuthResponse.token}';
              final response = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
              );
              return handler.resolve(response);
            } catch (e) {
              await logout();
              return handler.reject(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Future<AuthResponse> login(String email, String password) async {
  //   try {
  //     final response = await _dio.post('login', data: {
  //       'email': email,
  //       'password': password,
  //     });

  //     final authResponse = AuthResponse.fromJson(response.data);

  //     await _storageService.saveToken(authResponse.token);
  //     await _storageService.saveRefreshToken(authResponse.refreshToken);
  //         if (authResponse.user.role != null) {
  //       await _storageService.saveUserRole(authResponse.user.role!);
  //     }

  //     return authResponse;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  // auth_service.dart
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'login',
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);

      await _storageService.saveToken(authResponse.token);
      await _storageService.saveRefreshToken(authResponse.refreshToken);
      if (authResponse.user.role != null) {
        await _storageService.saveUserRole(authResponse.user.role!);
      }

      return authResponse;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        if (errorData.containsKey('error')) {
          throw LoginException(errorData['error'].toString());
        } else if (errorData.containsKey('message')) {
          throw LoginException(errorData['message'].toString());
        }
      }
      throw LoginException('Error de conexión. Por favor intenta nuevamente.');
    } catch (e) {
      throw LoginException('Ocurrió un error inesperado');
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }
      final response = await _dio.post(
        'refresh-token',
        data: {'refresh_token': refreshToken},
      );

      final authResponse = AuthResponse.fromJson(response.data);

      await _storageService.saveToken(authResponse.token);
      await _storageService.saveRefreshToken(authResponse.refreshToken);

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storageService.clearTokens();
  }

  Future<String?> getToken() async {
    return await _storageService.getToken();
  }

  Future<String?> getRefreshToken() async {
    return await _storageService.getRefreshToken();
  }
}

class LoginException implements Exception {
  final String message;
  LoginException(this.message);

  @override
  String toString() => message;
}
