import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final LatLng initialPosition; // Posición inicial del mapa

  const MapWidget({super.key, required this.initialPosition});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;
  String _mapStyle = ''; // Variable para almacenar el estilo del mapa

  @override
  void initState() {
    super.initState();
    // Cargar el estilo del mapa desde un archivo JSON
    DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json')
        .then((style) {
      _mapStyle = style;
    });
  }

  // Función para centrar el mapa en la ubicación actual
  void _goToMyLocation() {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(widget.initialPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                // Aplicar el estilo del mapa
                _mapController.setMapStyle(_mapStyle);
              },
              initialCameraPosition: CameraPosition(
                target: widget.initialPosition,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("current_location"),
                  position: widget.initialPosition,
                  infoWindow: const InfoWindow(title: "Tu ubicación"),
                ),
              },
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
            ),
          ),
        ),

        // Botón flotante para ir a la ubicación actual
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _goToMyLocation,
            backgroundColor: Colors.green,
            mini: true,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ),
      ],
    );
  }
}