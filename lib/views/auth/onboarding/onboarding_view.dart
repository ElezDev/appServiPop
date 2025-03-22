import 'package:flutter/material.dart';
import 'package:servipopapp/widgets/onboarding_widget.dart';

class OnboardingPageView extends StatefulWidget {
  @override
  _OnboardingPageViewState createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingScreen> _onboardingScreens = [
    const OnboardingScreen(
      title: 'Bienvenido a Servicios Domésticos',
      description: 'Encuentra los mejores servicios domésticos en tu área.',
      imagePath: 'assets/images/onbo1.png',
      backgroundColor: Colors.blueAccent,
    ),
    const OnboardingScreen(
      title: 'Fácil de usar',
      description: 'Navega fácilmente y encuentra lo que necesitas.',
      imagePath: 'assets/images/onbo2.png',
      backgroundColor: Colors.greenAccent,
    ),
    const OnboardingScreen(
      title: 'Comienza ahora',
      description: 'Regístrate y comienza a disfrutar de nuestros servicios.',
      imagePath: 'assets/images/onbo3.png',
      backgroundColor: Colors.orangeAccent,
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _skipOnboarding() {
    _navigateToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _onboardingScreens.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _onboardingScreens[index].backgroundColor,
                      _onboardingScreens[index].backgroundColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _onboardingScreens[index].imagePath,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _onboardingScreens[index].title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _onboardingScreens[index].description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _skipOnboarding,
              child: const Text(
                'Saltar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Indicador de progreso personalizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _onboardingScreens.length,
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón de siguiente o finalizar con degradado
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho de la pantalla
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _onboardingScreens[_currentPage].backgroundColor,
                          _onboardingScreens[_currentPage].backgroundColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: _onboardingScreens[_currentPage].backgroundColor.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _currentPage == _onboardingScreens.length - 1
                          ? _navigateToLogin
                          : () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Fondo transparente para que se vea el degradado
                        shadowColor: Colors.transparent, // Sin sombra adicional
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        _currentPage == _onboardingScreens.length - 1
                            ? 'Comenzar'
                            : 'Siguiente',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Texto en blanco para contrastar con el degradado
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}