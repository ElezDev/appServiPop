import 'package:flutter/material.dart';
import 'package:servipopapp/models/service_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderProfileView extends StatelessWidget {
  // final Map<String, dynamic> provider;
    final ServiceProvider provider;

  const ProviderProfileView({super.key, required this.provider});

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
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(provider.user.name, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(provider.user.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.user.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        provider.serviceType,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating y ubicación
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              provider.rating.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on, color: Colors.grey, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        provider.address, // Puedes agregar este campo a tu provider
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Sección "Sobre mí"
                  const Text(
                    'Sobre mí',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    provider.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sección de habilidades (opcional)
                  const Text(
                    'Habilidades',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSkillChip("Profesionalismo"),
                      _buildSkillChip("Puntualidad"),
                      _buildSkillChip("Calidad"),
                      _buildSkillChip("Atención al cliente"),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Botón de contacto
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openPhoneDialer(provider.user.phone, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: Colors.green.withOpacity(0.4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Contactar ahora',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sección de reseñas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reseñas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Ver todas',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._buildReviewsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill),
      backgroundColor: Colors.green[50],
      labelStyle: TextStyle(color: Colors.green[800]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.green[100]!),
      ),
    );
  }

  List<Widget> _buildReviewsList() {
    final List<Map<String, dynamic>> reviews = [
      {
        'user': 'Juan Pérez',
        'comment': 'Excelente servicio, muy profesional y puntual. Recomiendo ampliamente sus servicios.',
        'rating': 5.0,
        'date': 'Hace 2 semanas',
        'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
      },
      {
        'user': 'María Gómez',
        'comment': 'Muy satisfecha con el trabajo realizado. Cumplió con todas mis expectativas.',
        'rating': 4.5,
        'date': 'Hace 1 mes',
        'avatar': 'https://randomuser.me/api/portraits/women/1.jpg',
      },
      {
        'user': 'Carlos López',
        'comment': 'Buen servicio, pero un poco caro. Aunque la calidad justifica el precio.',
        'rating': 3.8,
        'date': 'Hace 3 meses',
        'avatar': 'https://randomuser.me/api/portraits/men/2.jpg',
      },
    ];

    return reviews.map((review) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(review['avatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['user'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        review['date'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        review['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review['comment'],
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}