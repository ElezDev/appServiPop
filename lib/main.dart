import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servipopapp/core/pusher.dart';
import 'package:servipopapp/core/theme_provider.dart';
import 'package:servipopapp/firebase_msg.dart';
import 'package:servipopapp/firebase_options.dart';
import 'package:servipopapp/services/service_provider_provider.dart';
import 'package:servipopapp/services/user_service.dart';
import 'package:servipopapp/views/auth/forgot_password_view.dart';
import 'package:servipopapp/views/auth/login_view.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/bookings_provider.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';
import 'package:servipopapp/views/auth/providers/language_provider.dart';
import 'package:servipopapp/views/auth/providers/notification_provider.dart';
import 'package:servipopapp/views/auth/providers/user_provider.dart';
import 'package:servipopapp/views/auth/register_view.dart';
import 'package:servipopapp/views/bookins/bookins_view.dart';
import 'package:servipopapp/views/califications/califications_view.dart';
import 'package:servipopapp/views/help/help_view.dart';
import 'package:servipopapp/views/home/navigation_view.dart';
import 'package:servipopapp/views/provider/location_provider.dart';
import 'package:servipopapp/views/services/create_service_view.dart';
import 'package:servipopapp/views/splash/splash_screen.dart';
import 'package:servipopapp/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/styles/app_theme.dart';

// ... otros imports ...

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    // await initPusher();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

await FirebaseMsg().initFCM();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProviderProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => BookingsProvider()),



        ChangeNotifierProvider(
          create: (_) => UserProvider(userService: UserService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Servicios Domésticos',
      theme: appTheme, 
      darkTheme: _buildDarkTheme(),
      themeMode: themeProvider.themeMode,
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginView(),
        '/home': (context) => const MainApp(),
        '/register': (context) => const RegisterView(),
        '/forgot-password': (context) => ForgotPasswordView(),
        '/help': (context) => const HelpView(),
        '/service-form': (context) => CreateServiceScreen(),
        '/rating': (context) => const CalificationsView(),
        '/bookinsProvider': (context) => const BookingsScreen(),
      },
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: const Color(0xFF81C784),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF81C784),
        secondary: Color(0xFF00C535),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.grey[900],
      ),
      cardTheme: CardTheme(
        color: Colors.grey[850],
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
      ),
    );
  }
  
}

