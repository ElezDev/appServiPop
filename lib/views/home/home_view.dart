import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:provider/provider.dart';
import 'package:servipopapp/localizations.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';
import 'package:servipopapp/views/auth/providers/language_provider.dart';
import 'package:servipopapp/views/provider/location_provider.dart';
import 'package:servipopapp/widgets/category_list_widget.dart';
import 'package:servipopapp/widgets/carousel_widget.dart';
import 'package:servipopapp/widgets/map_widget.dart' show MapWidget;
import 'package:servipopapp/widgets/provider_grid_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    Provider.of<LocationProvider>(
      context,
      listen: false,
    ).getCurrentLocation(); 
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(
      context,
    ); // Obtener LocationProvider
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Servicios Domésticos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.white),
            onPressed: () {
              // Actualizar la ubicación al presionar el botón
              locationProvider.getCurrentLocation();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.lightGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      'Menú',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.green),
                    title: Text('Ayuda'),
                    onTap: () {
                      Navigator.pushNamed(context, '/help');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.green),
                    title: Text('Cerrar sesión'),
                    onTap: () async {
                      await authProvider.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/flags/reino.png', 
                      width: 32,
                      height: 32,
                    ),
                    onPressed: () {
                      languageProvider.setLocale(const Locale('en', ''));
                      Navigator.pop(context); 
                    },
                    tooltip: 'Cambiar a inglés',
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/flags/espana.png', 
                      width: 32,
                      height: 32,
                    ),
                    onPressed: () {
                      languageProvider.setLocale(const Locale('es', ''));
                      Navigator.pop(context);
                    },
                    tooltip: 'Cambiar a español',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (locationProvider.currentCity != null &&
                locationProvider.currentDepartment != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Ubicación: ${locationProvider.currentCity} - ${locationProvider.currentDepartment}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Resto del contenido
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder:
                      (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                  children: [
                    CarouselWidget(),
                    CategoryListWidget(),
                    ProviderGridWidget(),
                  ],
                ),
              ),
            ),
            
            if (locationProvider.currentPosition != null)
              Padding(
                padding: EdgeInsets.all(16),
                child: MapWidget(
                  initialPosition: LatLng(
                    locationProvider.currentPosition!.latitude,
                    locationProvider.currentPosition!.longitude,
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
