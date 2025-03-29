import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir la aplicación de teléfono

class ProviderProfileView extends StatelessWidget {
  final Map<String, dynamic> provider;

  const ProviderProfileView({super.key, required this.provider});

  // Método para abrir el marcador telefónico con el número prellenado

   void _openPhoneDialer(String phoneNumber, BuildContext context) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró una aplicación para realizar llamadas')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(provider['name']),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                provider['image'],
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),

            // Nombre y calificación en la misma fila
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Alinea los elementos a los extremos
              children: [
                // Nombre del proveedor
                Text(
                  provider['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                // Calificación
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      provider['rating'].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Profesión
            Text(
              provider['profession'],
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 20),

            // Sección de descripción
            Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              provider['description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),

            // Botón de contacto con número quemado
            // Botón de contacto con número quemado
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _openPhoneDialer('3126285281', context);
                },
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text(
                  'Contactar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Color de fondo
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bordes redondeados
                  ),
                  elevation: 5, // Sombra del botón
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Sección de reseñas
            Text(
              'Reseñas:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
            const SizedBox(height: 10),
            ..._buildReviewsList(), // Lista de reseñas
          ],
        ),
      ),
    );
  }

  // Método para construir la lista de reseñas (diseño minimalista)
  List<Widget> _buildReviewsList() {
    // Datos de ejemplo para las reseñas
    final List<Map<String, dynamic>> reviews = [
      {
        'user': 'Juan Pérez',
        'comment': 'Excelente servicio, muy profesional y puntual.',
        'rating': 5.0,
      },
      {
        'user': 'María Gómez',
        'comment': 'Muy satisfecha con el trabajo realizado.',
        'rating': 4.5,
      },
      {
        'user': 'Carlos López',
        'comment': 'Buen servicio, pero un poco caro.',
        'rating': 3.8,
      },
    ];

    return reviews.map((review) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del usuario y calificación (alineados a los extremos)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review['user'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      review['rating'].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Comentario
            Text(
              review['comment'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),

            // Línea divisoria (opcional)
            Divider(height: 30, color: Colors.grey[300]),
          ],
        ),
      );
    }).toList();
  }
}
