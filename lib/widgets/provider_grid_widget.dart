import 'package:flutter/material.dart';
import 'package:servipopapp/views/provider/provider_profile_view.dart';

class ProviderGridWidget extends StatefulWidget {
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
    await Future.delayed(Duration(seconds: 2));
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
    return _isLoading ? _buildSkeleton() : _buildProviderGrid();
  }

  // Construye el grid de proveedores
  Widget _buildProviderGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProviderProfileView(provider: provider),
              ),
            );
          },
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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      provider['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        provider['profession'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 5),
                          Text(
                            provider['rating'].toString(),
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
  Widget _buildSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: 4, // Número de skeletons a mostrar
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Container(
                    color: Colors.grey[300], // Color de fondo del skeleton
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.grey[300], // Skeleton para el nombre
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 80,
                      height: 14,
                      color: Colors.grey[300], // Skeleton para la profesión
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: Colors.grey[300], // Skeleton para el ícono de estrella
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 30,
                          height: 14,
                          color: Colors.grey[300], // Skeleton para la calificación
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