import 'package:flutter/material.dart';
import 'package:servipopapp/models/category_model.dart'; 

class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  CategoryDetailScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              category.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              category.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Descripción de la categoría...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}