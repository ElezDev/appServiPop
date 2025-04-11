import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:provider/provider.dart';
import 'package:servipopapp/localizations.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';
import 'package:servipopapp/views/auth/providers/notification_provider.dart';
import 'package:servipopapp/views/auth/providers/user_provider.dart';
import 'package:servipopapp/views/home/user_drawer.dart';
import 'package:servipopapp/views/notifications/notifications_page.dart';
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
      Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<UserProvider>(context, listen: false).loadUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      // Actualiza tu AppBar en HomeView
appBar: AppBar(
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(width: 10),
      Text(
        'ServiPop',
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  centerTitle: true,
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          theme.primaryColor,
          theme.colorScheme.secondary,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  elevation: 4,
  actions: [
    IconButton(
      icon: Icon(Icons.location_on, color: Colors.white),
      onPressed: () {
        locationProvider.getCurrentLocation();
      },
    ),
    Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            );
          },
        ),
        if (Provider.of<NotificationProvider>(context).unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '${Provider.of<NotificationProvider>(context).unreadCount}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ),
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
              ? Icon(Icons.person, color: theme.primaryColor)
              : null,
        ),
      ),
    ),
  ],
),
      drawer: const UserDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (locationProvider.currentCity != null &&
                locationProvider.currentDepartment != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Ubicación: ${locationProvider.currentCity} - ${locationProvider.currentDepartment}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
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