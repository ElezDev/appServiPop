import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pagesData = [
    {
      'image': 'assets/images/omboarding1.png',
      'title': 'Bienvenido a ServiPop',
      'description': 'Conectamos hogares en Popayán con los mejores proveedores de servicios domésticos',
      'color': Color(0xFF6C5CE7),
    },
    {
      'image': 'assets/images/omboarding2.png',
      'title': 'Contrata con confianza',
      'description': 'Encuentra profesionales verificados para cada necesidad de tu hogar',
      'color': Color(0xFF00B894), 
    },
    {
      'image': 'assets/images/omboarding3.png',
      'title': 'Ofrece tus servicios',
      'description': 'Únete a nuestra comunidad y haz crecer tu negocio local',
      'color': Color(0xFFFD79A8), 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pagesData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (_, index) {
              return OnboardingPage(
                image: _pagesData[index]['image'] as String,
                title: _pagesData[index]['title'] as String,
                description: _pagesData[index]['description'] as String,
                color: _pagesData[index]['color'] as Color,
              );
            },
          ),
          
          // Indicadores de página
          Positioned(
            bottom: 120.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          
          // Botón de acción
          Positioned(
            bottom: 40.0,
            left: 40.0,
            right: 40.0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _currentPage == _pagesData.length - 1
                  ? ElevatedButton(
                      key: const ValueKey('start_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pagesData[_currentPage]['color'],
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _completeOnboarding,
                      child: const Text(
                        'Comenzar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : TextButton(
                      key: const ValueKey('next_button'),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        'Siguiente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _pagesData[_currentPage]['color'],
                        ),
                      ),
                    ),
            ),
          ),
          
          // Botón para saltar
          if (_currentPage != _pagesData.length - 1)
            Positioned(
              top: 60.0,
              right: 20.0,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'Saltar',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    return List<Widget>.generate(_pagesData.length, (int index) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _currentPage == index ? 24.0 : 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: _currentPage == index
              ? _pagesData[_currentPage]['color']
              : Colors.grey.withOpacity(0.4),
        ),
      );
    });
  }

  void _completeOnboarding() {
    Provider.of<AuthProvider>(context, listen: false).completeOnboarding();
    Navigator.pushReplacementNamed(context, '/login');
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Color color;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ilustración con sombra suave
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(
              image,
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40),
          // Título
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Descripción
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}