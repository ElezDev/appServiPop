import 'package:flutter/material.dart';
import 'package:servipopapp/views/favorites/favorites_view.dart';
import 'package:servipopapp/views/home/home_view.dart';
import 'package:servipopapp/views/profile/profile_view.dart';
import 'package:servipopapp/views/search/search_view.dart';
import 'package:servipopapp/localizations.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const SearchView(),
    FavoritesView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.colorScheme.surface,
            selectedItemColor: theme.primaryColor,
            unselectedItemColor: theme.unselectedWidgetColor,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: theme.textTheme.bodySmall?.fontSize,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: theme.textTheme.bodySmall?.fontSize,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home, color: theme.primaryColor),
                label: localizations.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search, color: theme.primaryColor),
                label: localizations.search,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_outline),
                activeIcon: Icon(Icons.favorite, color: theme.primaryColor),
                label: localizations.favorites,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person, color: theme.primaryColor),
                label: localizations.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}