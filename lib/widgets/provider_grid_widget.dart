import 'package:flutter/material.dart';
import 'package:servipopapp/views/provider/provider_profile_view.dart';

class ProviderGridWidget extends StatefulWidget {
  const ProviderGridWidget({super.key});

  @override
  _ProviderGridWidgetState createState() => _ProviderGridWidgetState();
}

class _ProviderGridWidgetState extends State<ProviderGridWidget> {
  bool _isLoading = true; 
  final List<Map<String, dynamic>> providers = [];

  @override
  void initState() {
    super.initState();
    _loadProviders(); 
  }

  void _loadProviders() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      providers.addAll([
        {
          'image': 'https://img.freepik.com/foto-gratis/hombre-joven-sonriente-uniforme-trabajo_23-2148209965.jpg?w=1380&t=st=1741994000~exp=1741994600~hmac=...',
          'name': 'Juan Pérez',
          'profession': 'Plomero',
          'rating': 4.5,
          'description': 'Experto en reparaciones de plomería y mantenimiento de tuberías.',
        },
        {
          'image': 'https://img.freepik.com/foto-gratis/electricista-trabajando_23-2147784745.jpg?w=1380&t=st=1741994100~exp=1741994700~hmac=...',
          'name': 'Carlos Gómez',
          'profession': 'Electricista',
          'rating': 4.7,
          'description': 'Instalaciones eléctricas y reparaciones en hogares y oficinas.',
        },
      ]);
      _isLoading = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _isLoading ? _buildSkeleton(theme) : _buildProviderGrid(theme);
  }

  // Construye el grid de proveedores
  Widget _buildProviderGrid(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        return GestureDetector(
          // onTap: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => ProviderProfileView(provider: provider),
          //     ),
          //   );
          // },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      provider['image'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: theme.primaryColor,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.cardColor,
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider['name'],
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        provider['profession'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            provider['rating'].toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Construye el skeleton loading
  Widget _buildSkeleton(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Container(
                    color: theme.dividerColor.withOpacity(0.3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      color: theme.dividerColor.withOpacity(0.3),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 80,
                      height: 14,
                      color: theme.dividerColor.withOpacity(0.3),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: theme.dividerColor.withOpacity(0.3),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 30,
                          height: 14,
                          color: theme.dividerColor.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}