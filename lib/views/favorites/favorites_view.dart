import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FavoritesView extends StatelessWidget {
  // Lista de favoritos de ejemplo
  final List<Map<String, dynamic>> favorites = [
    {
      'title': 'Servicio de Jardinería',
      'description': 'Mantenimiento de jardines y poda de árboles.',
      'image': 'assets/flags/reino.png',
      'rating': 4.5,
    },
    {
      'title': 'Limpieza del Hogar',
      'description': 'Limpieza profunda de casas y apartamentos.',
      'image': 'assets/flags/reino.png',
      'rating': 4.8,
    },
    {
      'title': 'Reparación de Electrodomésticos',
      'description': 'Reparación de neveras, lavadoras y más.',
      'image': 'assets/flags/reino.png',
      'rating': 4.7,
    },
  ];

   FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AnimationLimiter(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: favorites.map((favorite) {
                return _buildFavoriteCard(
                  title: favorite['title'],
                  description: favorite['description'],
                  image: favorite['image'],
                  rating: favorite['rating'],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard({
    required String title,
    required String description,
    required String image,
    required double rating,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Acción al tocar la tarjeta
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del servicio
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Detalles del servicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Botón de eliminar de favoritos
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // Acción para eliminar de favoritos
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}