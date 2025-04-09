import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor:  Color(0xff00C535), 
  primarySwatch: createMaterialColor(Color(0xFF2E7D32)),
  colorScheme: ColorScheme.light(
    primary:  Color(0xff00C535),
    secondary: Color(0xFF81C784), 
    surface: Colors.white,
    background: Colors.grey[50]!,
    error: Color(0xFFD32F2F),
  ),
  
  appBarTheme: AppBarTheme(
    color:   Color(0xff00C535),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  
  // Textos
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.black87,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  
  // Botones
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor:  Color(0xff00C535), // Verde corporativo
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      elevation: 3,
    ),
  ),
  
  // Inputs/Formularios
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color:  Color(0xff00C535), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFFD32F2F)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    filled: true,
    fillColor: Colors.grey[50],
    labelStyle: TextStyle(color: Colors.grey[700]),
    errorStyle: TextStyle(color: Color(0xFFD32F2F)),
  ),
  
  // Card
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    margin: EdgeInsets.all(8),
  ),
  
  // Otros
  dividerTheme: DividerThemeData(
    color: Colors.grey[300],
    thickness: 1,
    space: 1,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor:  Color(0xff00C535),
    foregroundColor: Colors.white,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color:  Color(0xff00C535),
  ),
);

// Función para crear MaterialColor a partir de un Color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}