import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final List<String> carouselImages = [
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
    'assets/images/bn1.jpg',
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var imagePath in carouselImages) {
        precacheImage(AssetImage(imagePath), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: carouselImages.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                      // Añade esto para manejar errores de carga
                      onError: (exception, stackTrace) {
                        debugPrint('Error loading image: $imageUrl');
                      },
                    ),
                  ),
                  child: Center(
                    // Widget de respaldo si la imagen no carga
                    child: Image.asset(imageUrl, errorBuilder:
                        (context, error, stackTrace) {
                      return const Text('Imagen no encontrada',
                          style: TextStyle(color: Colors.white));
                    }),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselImages.map((url) {
            int index = carouselImages.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.green
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}