import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String? _currentCity; 
  String? _currentDepartment; 
  String? _error;

  Position? get currentPosition => _currentPosition;
  String? get currentCity => _currentCity;
  String? get currentDepartment => _currentDepartment;
  String? get error => _error;

  Future<void> getCurrentLocation() async {
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          _currentCity = placemark.locality; 
          _currentDepartment = placemark.administrativeArea; 
        }

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