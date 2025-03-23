import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String? _error;

  Position? get currentPosition => _currentPosition;
  String? get error => _error;

  Future<void> getCurrentLocation() async {
    try {
      // Verificar y solicitar permisos
      final status = await Permission.location.request();
      if (status.isGranted) {
        // Obtener la ubicación
        _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _error = null;
      } else {
        _error = "Permiso de ubicación denegado";
      }
    } catch (e) {
      _error = "Error al obtener la ubicación: $e";
    }
    notifyListeners();
  }
}