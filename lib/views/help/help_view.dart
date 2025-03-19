import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HelpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ayuda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: AnimationConfiguration.toStaggeredList(
                    duration: Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      _buildHelpCard(
                        icon: Icons.help_outline,
                        title: '¿Cómo usar la aplicación?',
                        description:
                            'Explora nuestra guía paso a paso para aprender a utilizar todas las funciones de la aplicación.',
                        onTap: () {
                          // Navegar a una vista detallada
                        },
                      ),
                      SizedBox(height: 16),
                      _buildHelpCard(
                        icon: Icons.payment,
                        title: 'Métodos de pago',
                        description:
                            'Consulta los métodos de pago disponibles y cómo realizar transacciones seguras.',
                        onTap: () {
                          // Navegar a una vista detallada
                        },
                      ),
                      SizedBox(height: 16),
                      _buildHelpCard(
                        icon: Icons.security,
                        title: 'Seguridad y privacidad',
                        description:
                            'Conoce cómo protegemos tus datos y garantizamos tu privacidad.',
                        onTap: () {
                          // Navegar a una vista detallada
                        },
                      ),
                      SizedBox(height: 16),
                      _buildHelpCard(
                        icon: Icons.contact_support,
                        title: 'Contacto',
                        description:
                            '¿Necesitas ayuda adicional? Contáctanos directamente desde aquí.',
                        onTap: () {
                          // Navegar a una vista de contacto
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _buildFooter(), // Footer agregado aquí
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.green),
              SizedBox(width: 16),
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
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        border: Border(
          top: BorderSide(color: Colors.green.withOpacity(0.2)),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Desarrollado por ElezDevTech',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '© 2025 - Todos los derechos reservados',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}