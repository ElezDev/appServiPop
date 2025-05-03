// favorite_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'package:servipopapp/models/favorite_model.dart';
import 'package:servipopapp/services/auth_service.dart';

class FavoriteController {
  final Dio _dio = DioClient.dio;
  final AuthService _authService = AuthService();

  Future<List<Favorite>> getUserFavorites() async {
    try {
      final token = await _authService.getToken();

      final response = await _dio.get(
        'favorites',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      if (response.statusCode == 200) {
        // Verifica que la respuesta sea una lista
        if (response.data is List) {
          return (response.data as List).map((favJson) {
            return Favorite.fromJson(favJson as Map<String, dynamic>);
          }).toList();
        } 
        // Si es un solo objeto, lo convertimos a lista
        else if (response.data is Map<String, dynamic>) {
          return [Favorite.fromJson(response.data as Map<String, dynamic>)];
        }
        // Si no es ni lista ni mapa, retornamos lista vacía
        else {
          return [];
        }
      } else {
        throw Exception('Error al cargar favoritos: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getUserFavorites: $e');
      throw Exception('Error al obtener favoritos: ${e.toString()}');
    }
  }

  Future<bool> toggleFavorite(int favoriteId) async {
    try {
      final token = await _authService.getToken();
      
      final response = await _dio.put(
        'favorites/$favoriteId/toggle',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      return false;
    }
  }
}