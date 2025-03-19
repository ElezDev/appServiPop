import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servipopapp/views/auth/forgot_password_view.dart';
import 'package:servipopapp/views/auth/login_view.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';
import 'package:servipopapp/views/auth/providers/language_provider.dart';
import 'package:servipopapp/views/auth/register_view.dart';
import 'package:servipopapp/views/favorites/favorites_view.dart';
import 'package:servipopapp/views/help/help_view.dart';
import 'package:servipopapp/views/home/home_view.dart';
import 'package:servipopapp/views/profile/profile_view.dart';
import 'package:servipopapp/views/splash/splash_screen.dart';
import 'package:servipopapp/localizations.dart'; // Importa el archivo de localizaciones
import 'package:flutter_localizations/flutter_localizations.dart'; // Importa las localizaciones de Flutter
import 'core/styles/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Builder(
        builder: (context) {
          final languageProvider = Provider.of<LanguageProvider>(context, listen: true);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Servicios Domésticos',
            theme: appTheme,
            locale: languageProvider.locale,
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''), // Inglés
              const Locale('es', ''), // Español
            ],
            routes: {
              '/': (context) => SplashScreen(),
              '/login': (context) => LoginView(),
              '/home': (context) => MainApp(),
              '/register': (context) => RegisterView(),
              '/forgot-password': (context) => ForgotPasswordView(),
              '/help': (context) => HelpView(),
            },
          );
        },
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeView(),
    SearchView(),
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
    final localizations = AppLocalizations.of(context); // Obtén las traducciones

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: localizations.home, // Usa la traducción
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: localizations.search, // Usa la traducción
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: localizations.favorites, // Usa la traducción
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: localizations.profile, // Usa la traducción
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantallas adicionales (puedes moverlas a sus propios archivos)
class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Obtén las traducciones
    return Center(child: Text(localizations.search)); // Usa la traducción
  }
}

