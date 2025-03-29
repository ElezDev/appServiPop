import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:servipopapp/services/service_provider_provider.dart';
import 'package:servipopapp/views/provider/location_provider.dart';

class BecomeProviderScreen extends StatefulWidget {
  const BecomeProviderScreen({Key? key}) : super(key: key);

  @override
  _BecomeProviderScreenState createState() => _BecomeProviderScreenState();
}

class _BecomeProviderScreenState extends State<BecomeProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _locationLoaded = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<LocationProvider>(
        context,
        listen: false,
      ).getCurrentLocation();
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );

      if (locationProvider.currentPosition != null) {
        _addressController.text =
            locationProvider.currentCity != null
                ? '${locationProvider.currentCity}, ${locationProvider.currentDepartment}'
                : 'Ubicación obtenida';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al obtener ubicación: $e')));
    } finally {
      setState(() {
        _isLoading = false;
        _locationLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convertirse en Proveedor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.green))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Animación Lottie
                      Center(
                        child: Image.asset(
                          'assets/images/default_profile.jpg', 
                          width: 200,
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Completa tu información como proveedor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Campo de Descripción
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción de tus servicios',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.work_outline),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor describe tus servicios';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Campo de Dirección
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Dirección de operación',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: _getCurrentLocation,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una dirección';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Términos y condiciones
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Términos y Condiciones',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Al convertirte en proveedor aceptas:\n\n'
                                '- Cumplir con los estándares de calidad\n'
                                '- Responder a solicitudes en tiempo razonable\n'
                                '- Mantener información actualizada\n'
                                '- Aceptar nuestras políticas de privacidad\n\n'
                                'Podrás desactivar tu cuenta de proveedor cuando lo desees.',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _acceptTerms,
                                    onChanged: (value) {
                                      setState(
                                        () => _acceptTerms = value ?? false,
                                      );
                                    },
                                  ),
                                  const Text(
                                    'Acepto los términos y condiciones',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Botón de envío
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          
                          style: ElevatedButton.styleFrom(
                            
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.green,
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            'ENVIAR SOLICITUD',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  // Actualiza el método _submitForm en BecomeProviderScreen
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
        ),
      );
      return;
    }

    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final serviceProvider = Provider.of<ServiceProviderProvider>(
      context,
      listen: false,
    );

    if (locationProvider.currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Necesitamos tu ubicación para continuar'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await serviceProvider.registerServiceProvider(
        description: _descriptionController.text,
        address: _addressController.text,
        latitude: locationProvider.currentPosition!.latitude,
        longitude: locationProvider.currentPosition!.longitude,
      );

      if (success) {
        await _showSuccessAnimation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              serviceProvider.errorMessage ?? 'Error al registrar proveedor',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showSuccessAnimation() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/animation.json',
                  width: 150,
                  height: 150,
                  repeat: false,
                ),
                const SizedBox(height: 20),
                const Text(
                  '¡Felicidades!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ahora eres un proveedor oficial de ServiPop',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: const Text('Continuar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
