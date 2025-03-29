// service_controller.dart
import 'package:dio/dio.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'package:servipopapp/models/service_model.dart';

class ServiceController {
   final Dio _dio = DioClient.dio;


  Future<List<Service>> getServicesByCategory(int categoryId) async {
    try {
      final response = await _dio.get(
        'services-category/$categoryId',
      );

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
}