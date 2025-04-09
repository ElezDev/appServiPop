import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:provider/provider.dart';
import 'package:servipopapp/localizations.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';
import 'package:servipopapp/views/auth/providers/user_provider.dart';
import 'package:servipopapp/views/home/user_drawer.dart';
import 'package:servipopapp/views/provider/location_provider.dart';
import 'package:servipopapp/widgets/category_list_widget.dart';
import 'package:servipopapp/widgets/carousel_widget.dart';
import 'package:servipopapp/widgets/map_widget.dart';
import 'package:servipopapp/widgets/provider_grid_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  @override
   bool get wantKeepAlive => true; 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<LocationProvider>(
        context,
        listen: false,
      ).getCurrentLocation();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<UserProvider>(context, listen: false).loadUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     super.build(context);
    final userProvider = Provider.of<UserProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset(
            //   'assets/flags/reino.png', // Tu logo
            //   height: 30,
            // ),
            SizedBox(width: 10),
            Text(
              'ServiPop',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
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
            icon: const Icon(Icons.location_on, color: Colors.white),
            onPressed: () {
              locationProvider.getCurrentLocation();
            },
          ),
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage:
                    userProvider.user?.avatar != null
                        ? CachedNetworkImageProvider(userProvider.user!.avatar!)
                        : const AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                child:
                    userProvider.user?.avatar == null
                        ? const Icon(Icons.person, color: Colors.green)
                        : null,
              ),
            ),
          ),
        ],
      ),
      drawer: const UserDrawer(), // Usa el nuevo componente de drawer
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
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 10),
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
                  childAnimationBuilder:
                      (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                  children: [
                    const CarouselWidget(),
                    const CategoryListWidget(),
                    const ProviderGridWidget(),
                  ],
                ),
              ),
            ),
            if (locationProvider.currentPosition != null)
              Padding(
                padding: const EdgeInsets.all(16),
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
