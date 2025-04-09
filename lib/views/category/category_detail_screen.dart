import 'package:flutter/material.dart';
import 'package:servipopapp/models/category_model.dart';
import 'package:servipopapp/models/service_model.dart';
import 'package:servipopapp/services/service_controller.dart';
import 'package:servipopapp/views/provider/provider_profile_view.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Category category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late Future<List<Service>> _servicesFuture;
  final ServiceController _serviceController = ServiceController();
  final Map<int, bool> _favorites = {};

  @override
  void initState() {
    super.initState();
    _servicesFuture = _serviceController.getServicesByCategory(
      widget.category.id,
    );
  }

  void _toggleFavorite(int serviceId) {
    setState(() {
      _favorites[serviceId] = !(_favorites[serviceId] ?? false);
      if (_favorites[serviceId]!) {
        _showFavoriteSnackbar('Añadido a favoritos');
      }
    });
  }

  void _showFavoriteSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _bookService(Service service) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Reservar servicio',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      service.portfolioImages.isNotEmpty
                          ? service.portfolioImages.first.imageUrl
                          : 'https://via.placeholder.com/150',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    service.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '\$${service.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildFormField(
                  icon: Icons.calendar_today,
                  label: 'Fecha',
                  hint: 'Selecciona una fecha',
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  icon: Icons.access_time,
                  label: 'Hora',
                  hint: 'Selecciona una hora',
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  icon: Icons.note,
                  label: 'Notas adicionales',
                  hint: 'Añade detalles adicionales',
                  maxLines: 3,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showConfirmationDialog(service);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'CONFIRMAR RESERVA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildFormField({
    required IconData icon,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[500]),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
          maxLines: maxLines,
        ),
      ],
    );
  }

  void _showConfirmationDialog(Service service) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '¡Reserva confirmada!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu reserva para ${service.title} ha sido confirmada.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'ENTENDIDO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: FutureBuilder<List<Service>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar servicios',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Por favor, inténtalo de nuevo más tarde',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _servicesFuture = _serviceController
                            .getServicesByCategory(widget.category.id);
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/emty.jpg',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No hay servicios disponibles',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Prueba con otra categoría',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final service = snapshot.data![index];
              return _buildServiceCard(service);
            },
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    final firstImage =
        service.portfolioImages.isNotEmpty
            ? service.portfolioImages.first.imageUrl
            : 'https://via.placeholder.com/150';

    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del servicio con overlay de favoritos
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Image.network(
                    firstImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      );
                    },
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: InkWell(
                  onTap: () => _toggleFavorite(service.id),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (_favorites[service.id] ?? false)
                              ? Colors.white
                              : Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _favorites[service.id] ?? false
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey<bool>(_favorites[service.id] ?? false),
                        color:
                            (_favorites[service.id] ?? false)
                                ? Colors.red
                                : Colors.grey[700],
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y precio
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${service.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Proveedor y rating
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProviderProfileView(
                                      provider: service.serviceProvider,
                                    ),
                              ),
                            );
                          },
                          splashColor: Colors.grey.withOpacity(0.3),
                          highlightColor: Colors.transparent,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                service.serviceProvider.user.avatar,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${service.serviceProvider.user.name} ${service.serviceProvider.user.lastname}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  service.serviceProvider.address
                                      .split(',')
                                      .first,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            service.serviceProvider.rating.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Descripción
                Text(
                  service.description.isNotEmpty
                      ? service.description
                      : 'Este servicio no tiene descripción detallada',
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Botón de reserva
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _bookService(service),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Reservar ahora',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
