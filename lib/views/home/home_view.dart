import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:provider/provider.dart';
import 'package:servipopapp/localizations.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';
import 'package:servipopapp/views/auth/providers/language_provider.dart';
import 'package:servipopapp/views/auth/providers/user_provider.dart';
import 'package:servipopapp/views/provider/location_provider.dart';
import 'package:servipopapp/widgets/category_list_widget.dart';
import 'package:servipopapp/widgets/carousel_widget.dart';
import 'package:servipopapp/widgets/map_widget.dart' show MapWidget;
import 'package:servipopapp/widgets/provider_grid_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
      // Cargar datos del usuario si está logueado
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<UserProvider>(context, listen: false).loadUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
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
          // Botón de ubicación
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.white),
            onPressed: () {
              locationProvider.getCurrentLocation();
            },
          ),
          // Foto de perfil del usuario con GestureDetector para abrir el drawer
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: userProvider.user?.avatar != null
                    ? CachedNetworkImageProvider(userProvider.user!.avatar!)
                    : const AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
                child: userProvider.user?.avatar == null
                    ? const Icon(Icons.person, color: Colors.green)
                    : null,
              ),
            ),
          ),
        ],
      ),
      drawer: _buildUserDrawer(
          context, authProvider, userProvider, languageProvider),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Resto de tu contenido actual...
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
                    )
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

            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
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

  Widget _buildUserDrawer(BuildContext context, AuthProvider authProvider,
      UserProvider userProvider, LanguageProvider languageProvider) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userProvider.user?.name ?? 'Usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userProvider.user?.email ?? 'correo@ejemplo.com',
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: userProvider.user?.avatar != null
                  ? CachedNetworkImageProvider(userProvider.user!.avatar!)
                  : const AssetImage('assets/images/default_profile.jpg')
                      as ImageProvider,
              child: userProvider.user?.avatar == null
                  ? const Icon(Icons.person, size: 30, color: Colors.green)
                  : null,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.green),
                  title: Text('Perfil'),
                  onTap: () {
                    // Navegar a la vista de perfil
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.green),
                  title: Text('Configuración'),
                  onTap: () {
                    // Navegar a la vista de configuración
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline, color: Colors.green),
                  title: Text('Ayuda'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/help');
                  },
                ),
                Divider(),
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
    );
  }
}