import 'package:flutter/material.dart';
import 'package:servipopapp/models/service_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderProfileView extends StatelessWidget {
  final ServiceProvider provider;

  const ProviderProfileView({super.key, required this.provider});

  void _openPhoneDialer(String phoneNumber, BuildContext context) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No se encontró una aplicación para realizar llamadas'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 300),
          child: Text(
            provider.user.name,
            style: TextStyle(color: colorScheme.onPrimary),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero animation for the profile image
            Hero(
              tag: 'provider-image-${provider.user.id}',
              child: Stack(
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            provider.user.name,
                            key: ValueKey<String>(provider.user.name),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            provider.serviceType,
                            key: ValueKey<String>(provider.serviceType),
                            style: TextStyle(
                              fontSize: 18,
                              color: colorScheme.onPrimary.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating y ubicación with fade animation
                  FadeIn(
                    delay: 100,
                    child: SlideIn(
                      offset: const Offset(0, 20),
                      child: Row(
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
                          Icon(Icons.location_on, color: colorScheme.onSurface.withOpacity(0.6), size: 18),
                          const SizedBox(width: 5),
                          Text(
                            provider.address,
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Sección "Sobre mí" with animation
                  FadeIn(
                    delay: 200,
                    child: SlideIn(
                      offset: const Offset(0, 20),
                      child: Text(
                        'Sobre mí',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeIn(
                    delay: 250,
                    child: SlideIn(
                      offset: const Offset(0, 20),
                      child: Text(
                        provider.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sección de habilidades with staggered animation
                  FadeIn(
                    delay: 300,
                    child: SlideIn(
                      offset: const Offset(0, 20),
                      child: Text(
                        'Habilidades',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeIn(
                    delay: 350,
                    child: SlideIn(
                      offset: const Offset(0, 20),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSkillChip("Profesionalismo", theme),
                          _buildSkillChip("Puntualidad", theme),
                          _buildSkillChip("Calidad", theme),
                          _buildSkillChip("Atención al cliente", theme),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Botón de contacto with pulse animation
                  FadeIn(
                    delay: 400,
                    child: SlideIn(
                      offset: const Offset(0, 20),
                      child: PulseAnimation(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _openPhoneDialer(provider.user.phone, context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              shadowColor: theme.shadowColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, color: theme.colorScheme.onPrimary),
                                const SizedBox(width: 10),
                                Text(
                                  'Contactar ahora',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sección de reseñas with animation
                  FadeIn(
                    delay: 450,
                    child: SlideIn(
                      offset: const Offset(0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reseñas',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Ver todas',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._buildReviewsList(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Chip(
        label: Text(skill),
        backgroundColor: theme.primaryColor.withOpacity(0.1),
        labelStyle: TextStyle(color: theme.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: theme.primaryColor.withOpacity(0.3)),
        ),
      ),
    );
  }

  List<Widget> _buildReviewsList(ThemeData theme) {
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

    return reviews.asMap().entries.map((entry) {
      final index = entry.key;
      final review = entry.value;
      
      return FadeIn(
        delay: 500 + (index * 100),
        child: SlideIn(
          offset: const Offset(0, 20),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
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
                    Hero(
                      tag: 'reviewer-${review['user']}',
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(review['avatar']),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['user'],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            review['date'],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}


// Custom animation widgets
class FadeIn extends StatelessWidget {
  final Widget child;
  final int delay;
  
  const FadeIn({super.key, required this.child, this.delay = 0});
  
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeInOut,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class SlideIn extends StatelessWidget {
  final Widget child;
  final Offset offset;
  final int delay;
  
  const SlideIn({super.key, required this.child, this.offset = Offset.zero, this.delay = 0});
  
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: offset, end: Offset.zero),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutQuart,
      builder: (BuildContext context, Offset value, Widget? child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class PulseAnimation extends StatefulWidget {
  final Widget child;
  
  const PulseAnimation({super.key, required this.child});
  
  @override
  _PulseAnimationState createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}