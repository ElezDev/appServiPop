// services/user_service.dart
import 'package:dio/dio.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'package:servipopapp/models/user_model.dart';

class UserService {
  final Dio _dio = DioClient.dio;

  Future<User> getUserProfile(String token) async {
    try {
      final response = await _dio.get(
        'user', 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error ${e.response?.statusCode}: ${e.response?.data}');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    }
  }
}