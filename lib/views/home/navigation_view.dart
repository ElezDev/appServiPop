
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
    final localizations = AppLocalizations.of(context); 

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: localizations.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: localizations.search, 
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite),
                label: localizations.favorites,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: localizations.profile, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
