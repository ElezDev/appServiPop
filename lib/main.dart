import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servipopapp/services/user_service.dart';
import 'package:servipopapp/views/auth/forgot_password_view.dart';
import 'package:servipopapp/views/auth/login_view.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';
import 'package:servipopapp/views/auth/providers/language_provider.dart';
import 'package:servipopapp/views/auth/providers/user_provider.dart';
import 'package:servipopapp/views/auth/register_view.dart';
import 'package:servipopapp/views/help/help_view.dart';
import 'package:servipopapp/views/home/navigation_view.dart';
import 'package:servipopapp/views/provider/location_provider.dart';
import 'package:servipopapp/views/splash/splash_screen.dart';
import 'package:servipopapp/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/styles/app_theme.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            userService: UserService(), 
          ),
        ),
      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        Future.delayed( Duration(seconds: 2), () {
          FlutterNativeSplash.remove();
        });

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Servicios Domésticos',
          theme: appTheme,
          locale: languageProvider.locale,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales:  [
            Locale('en', ''), // English
            Locale('es', ''), // Spanish
          ],
          routes: {
            '/': (context) =>  SplashScreen(),
            '/login': (context) =>  LoginView(),
            '/home': (context) =>  MainApp(),
            '/register': (context) =>  RegisterView(),
            '/forgot-password': (context) =>  ForgotPasswordView(),
            '/help': (context) =>  HelpView(),
          },
        );
      },
    );
  }
}