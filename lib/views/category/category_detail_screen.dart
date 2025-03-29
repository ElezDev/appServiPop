import 'package:flutter/material.dart';
import 'package:servipopapp/models/category_model.dart';
import 'package:servipopapp/models/service_model.dart';
import 'package:servipopapp/services/service_controller.dart';

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
    _servicesFuture = _serviceController.getServicesByCategory(widget.category.id);
  }

  void _toggleFavorite(int serviceId) {
    setState(() {
      _favorites[serviceId] = !(_favorites[serviceId] ?? false);
    });
  }

  void _bookService(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reservar servicio'),
        content: Text('¿Deseas reservar el servicio ${service.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Servicio ${service.title} reservado')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: FutureBuilder<List<Service>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay servicios disponibles'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
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
  final firstImage = service.portfolioImages.isNotEmpty 
      ? service.portfolioImages.first.imageUrl 
      : 'https://via.placeholder.com/150';

  return Card(
    elevation: 4,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen del servicio con overlay de favoritos
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                firstImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => _toggleFavorite(service.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Icon(
                    _favorites[service.id] ?? false 
                        ? Icons.favorite 
                        : Icons.favorite_border,
                    color: _favorites[service.id] ?? false 
                        ? Colors.red 
                        : Colors.grey[700],
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        Padding(
          padding: const EdgeInsets.all(16),
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
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$${service.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              
            const  SizedBox(height: 8),
              
              // Proveedor y rating
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        service.serviceProvider.user.avatar),
                    ),
                  ),
                const  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          '${service.serviceProvider.user.name} ${service.serviceProvider.user.lastname}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Row(
                          children: [
                           const Icon(Icons.location_on, 
                                size: 14, color: Colors.grey),
                           const SizedBox(width: 4),
                            Text(
                              service.serviceProvider.address.split(',').first,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      const  Icon(Icons.star, 
                            color: Colors.amber, size: 16),
                       const SizedBox(width: 4),
                        Text(
                          service.serviceProvider.rating.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Descripción
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  service.description.isNotEmpty 
                      ? service.description 
                      : 'Este servicio no tiene descripción detallada',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botón de reserva elaborado
              InkWell(
                onTap: () => _bookService(service),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'RESERVAR AHORA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                          fontFamily: 'Poppins',
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