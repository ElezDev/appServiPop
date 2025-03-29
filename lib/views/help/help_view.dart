import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:servipopapp/localizations.dart'; // Importa AppLocalizations


class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Obtén las traducciones

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.helpTitle, // Título traducido
          style: const TextStyle(
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
          child: Column(
            children: [
              Expanded(
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
                    children: [
                      _buildHelpCard(
                        icon: Icons.help_outline,
                        title: localizations.howToUse, // Título traducido
                        description: localizations.howToUseDescription, // Descripción traducida
                        onTap: () {
                          // Navegar a una vista detallada
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildHelpCard(
                        icon: Icons.payment,
                        title: localizations.paymentMethods, // Título traducido
                        description: localizations.paymentMethodsDescription, // Descripción traducida
                        onTap: () {
                          // Navegar a una vista detallada
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildHelpCard(
                        icon: Icons.security,
                        title: localizations.securityAndPrivacy, // Título traducido
                        description: localizations.securityAndPrivacyDescription, // Descripción traducida
                        onTap: () {
                          // Navegar a una vista detallada
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildHelpCard(
                        icon: Icons.contact_support,
                        title: localizations.contact, // Título traducido
                        description: localizations.contactDescription, // Descripción traducida
                        onTap: () {
                          // Navegar a una vista de contacto
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _buildFooter(localizations), // Footer con traducciones
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(width: 16),
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
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
              localizations.developedBy, // Texto traducido
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              localizations.copyright, // Texto traducido
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