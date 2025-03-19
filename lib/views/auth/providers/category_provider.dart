// lib/providers/category_provider.dart
import 'package:flutter/material.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'package:servipopapp/models/category_model.dart'; 

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await DioClient.dio.get('categories');
      if (response.statusCode == 200) {
        _categories = (response.data as List)
            .map((category) => Category.fromJson(category))
            .toList();
      }
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}