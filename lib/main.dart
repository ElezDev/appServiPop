import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servipopapp/views/auth/forgot_password_view.dart';
import 'package:servipopapp/views/auth/login_view.dart';
import 'package:servipopapp/views/auth/onboarding/OnboardingManager.dart';
import 'package:servipopapp/views/auth/onboarding/onboarding_view.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';
import 'package:servipopapp/views/auth/providers/language_provider.dart';
import 'package:servipopapp/views/auth/register_view.dart';
import 'package:servipopapp/views/help/help_view.dart';
import 'package:servipopapp/views/home/navigation_view.dart';
import 'package:servipopapp/views/provider/location_provider.dart';
import 'package:servipopapp/views/splash/splash_screen.dart';
import 'package:servipopapp/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:servipopapp/core/styles/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isOnboardingCompleted = await OnboardingManager.isOnboardingCompleted();
  runApp(MyApp(isOnboardingCompleted: isOnboardingCompleted));
}

class MyApp extends StatelessWidget {
  final bool isOnboardingCompleted;

  const MyApp({Key? key, required this.isOnboardingCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()), 
      ],
      child: Builder(
        builder: (context) {
          final languageProvider = Provider.of<LanguageProvider>(context, listen: true);

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
            supportedLocales: const [
              Locale('en', ''), 
              Locale('es', ''), 
            ],
            routes: {
              '/': (context) => isOnboardingCompleted ? SplashScreen() : OnboardingPageView(),
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