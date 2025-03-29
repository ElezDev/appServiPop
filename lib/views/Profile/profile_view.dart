// lib/views/profile/profile_view.dart
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header del Perfil con gradiente
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Avatar con sombra
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // Reemplaza con la foto del usuario
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Juan Pérez',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'juan.perez@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Información del Usuario
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.phone,
                    title: 'Teléfono',
                    subtitle: '+51 987 654 321',
                  ),
                  Divider(height: 20, color: Colors.grey[300]),
                  _buildInfoTile(
                    icon: Icons.location_on,
                    title: 'Dirección',
                    subtitle: 'Calle Falsa 123, Lima, Perú',
                  ),
                ],
              ),
            ),

            // Acciones del Usuario
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Editar Perfil',
                    onPressed: () {
                      // Navegar a la pantalla de editar perfil
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildActionButton(
                    icon: Icons.lock,
                    label: 'Cambiar Contraseña',
                    isOutlined: true,
                    onPressed: () {
                      // Navegar a la pantalla de cambiar contraseña
                    },
                  ),
                ],
              ),
            ),

            // Sección de Servicios con scroll horizontal
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Servicios que ofreces',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Lista de servicios con scroll horizontal
                  SizedBox(
                    height: 180, // Altura fija para el contenedor de tarjetas
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _buildServiceCards(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir un tile de información
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
    );
  }

  // Método para construir un botón de acción
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isOutlined = false,
    required VoidCallback onPressed,
  }) {
    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          );
  }

  // Método para construir las tarjetas de servicios
  List<Widget> _buildServiceCards() {
    final services = [
      {
        'icon': Icons.cleaning_services,
        'title': 'Limpieza del Hogar',
        'description': 'Servicio de limpieza profunda para tu hogar.',
      },
      {
        'icon': Icons.plumbing,
        'title': 'Plomería',
        'description': 'Reparación e instalación de tuberías y grifería.',
      },
      {
        'icon': Icons.electrical_services,
        'title': 'Electricidad',
        'description': 'Instalación y reparación de sistemas eléctricos.',
      },
      {
        'icon': Icons.carpenter,
        'title': 'Carpintería',
        'description': 'Trabajos de carpintería y muebles a medida.',
      },
    ];

    return services.map((service) {
      return Container(
        width: 160, // Ancho fijo para cada tarjeta
        margin: const EdgeInsets.only(right: 10),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(service['icon'] as IconData, color: Colors.green, size: 30),
                const SizedBox(height: 10),
                Text(
                  service['title'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  service['description'] as String,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}