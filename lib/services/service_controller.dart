// service_controller.dart
import 'package:dio/dio.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'package:servipopapp/models/service_model.dart';
import 'package:servipopapp/services/auth_service.dart';

class ServiceController {
  final Dio _dio = DioClient.dio;
  final AuthService _authService = AuthService();

  Future<List<Service>> getServicesByCategory(int categoryId) async {
    try {
      final response = await _dio.get('services-category/$categoryId');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((serviceJson) => Service.fromJson(serviceJson))
            .toList();
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

 Future<Map<String, dynamic>> bookService({
  required int serviceId,
  required DateTime scheduledAt,
  required String address,
  String? notes,
}) async {
  try {
    final token = await _authService.getToken();
    final response = await DioClient.dio.post(
      'booking',
      data: {
        "service_id": serviceId,
        "scheduled_at": scheduledAt.toIso8601String(),
        "address": address,
        "notes": notes,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return {
      'success': true,
      'data': response.data,
    };
  } on DioException catch (e) {
    if (e.response != null) {
      if (e.response?.statusCode == 422) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Error en los datos proporcionados',
          'errors': e.response?.data['errors'] ?? {},
          'statusCode': e.response?.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Error al realizar la reserva',
          'statusCode': e.response?.statusCode,
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.message}',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error inesperado: ${e.toString()}',
    };
  }
}
}
