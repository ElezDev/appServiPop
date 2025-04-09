// lib/core/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.101.3:8000/api/',
      
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30), 
    ));

    _dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      error: true,
    ));
  }

  static Dio get dio => _instance._dio;
}