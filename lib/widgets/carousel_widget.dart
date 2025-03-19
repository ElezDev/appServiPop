// lib/widgets/carousel_widget.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatefulWidget {
  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final List<String> carouselImages = [
    'https://img.freepik.com/foto-gratis/trabajadores-manuales-trabajadoras-encogiendose-hombros-expresiones-dudosas-saber-que-empezar-su-trabajo-joven-sosteniendo-maquina-perforacion-algunas-dudas-e-incertidumbre_273609-7944.jpg?t=st=1741993115~exp=1741996715~hmac=a9e32c9bd483038b2f885b5f605f835d4aa0353b2ef91e62fd85deaf0544bb70&w=1380',
    'https://img.freepik.com/foto-gratis/jardinero-weedwacker-cortando-cesped-jardin_329181-20539.jpg?t=st=1741992852~exp=1741996452~hmac=6fd018ab23ab9d0cf7590778df6d32cdc86737acdaf57a822e8b99258fd716a0&w=1060',
    'https://img.freepik.com/vector-gratis/limpiadores-productos-limpieza-servicio-limpieza_18591-52068.jpg?t=st=1741992799~exp=1741996399~hmac=539dca26c908916be167e878c243e3b0034654fd05d5cd473919bc2166703d92&w=740',
  ];

  int _currentIndex = 0;

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
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: carouselImages.map((imageUrl) {
            return Container(
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
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
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
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