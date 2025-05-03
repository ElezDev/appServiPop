import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:servipopapp/core/dio_client.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  XFile? _avatarFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro', style: TextStyle(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface.withOpacity(0.2),
              colorScheme.background,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAvatarPicker(colorScheme, textTheme),
                const SizedBox(height: 24),
                _buildNameField(colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildLastnameField(colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildEmailField(colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildPhoneField(colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildAddressField(colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildPasswordField(colorScheme, textTheme),
                const SizedBox(height: 24),
                _buildRegisterButton(colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildLoginLink(colorScheme, textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ WIDGETS DEL FORMULARIO ============

  Widget _buildAvatarPicker(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.surfaceVariant,
            backgroundImage: _avatarFile != null ? FileImage(File(_avatarFile!.path)) : null,
            child: _avatarFile == null
                ? Icon(Icons.camera_alt, size: 30, color: colorScheme.onSurfaceVariant)
                : null,
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _showImageSourceDialog,
          icon: Icon(Icons.edit, size: 16, color: colorScheme.primary),
          label: Text(
            'Cambiar foto de perfil',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: _nameController,
      decoration: _inputDecoration('Nombre', Icons.person, colorScheme, textTheme),
      validator: (value) => value!.isEmpty ? 'Ingresa tu nombre' : null,
    );
  }

  Widget _buildLastnameField(ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: _lastnameController,
      decoration: _inputDecoration('Apellido', Icons.person_outline, colorScheme, textTheme),
      validator: (value) => value!.isEmpty ? 'Ingresa tu apellido' : null,
    );
  }

  Widget _buildEmailField(ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Correo electrónico', Icons.email, colorScheme, textTheme),
      validator: (value) {
        if (value!.isEmpty) return 'Ingresa tu correo';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Correo inválido';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField(ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration('Teléfono', Icons.phone, colorScheme, textTheme),
      validator: (value) => value!.isEmpty ? 'Ingresa tu teléfono' : null,
    );
  }

  Widget _buildAddressField(ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: _addressController,
      decoration: _inputDecoration('Dirección', Icons.home, colorScheme, textTheme),
      validator: (value) => value!.isEmpty ? 'Ingresa tu dirección' : null,
    );
  }

  Widget _buildPasswordField(ColorScheme colorScheme, TextTheme textTheme) {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: _inputDecoration('Contraseña', Icons.lock, colorScheme, textTheme),
      validator: (value) {
        if (value!.isEmpty) return 'Ingresa tu contraseña';
        if (value.length < 6) return 'Mínimo 6 caracteres';
        return null;
      },
    );
  }

  Widget _buildRegisterButton(ColorScheme colorScheme, TextTheme textTheme) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: _isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onPrimary,
              ),
            )
          : Text(
              'REGISTRARSE',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
    );
  }

  Widget _buildLoginLink(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text.rich(
          TextSpan(
            text: '¿Ya tienes cuenta? ',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            children: [
              TextSpan(
                text: 'Inicia sesión',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ FUNCIONALIDAD ============

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface.withOpacity(0.7),
      ),
      prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 1.5,
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    final colorScheme = Theme.of(context).colorScheme;
    
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Seleccionar imagen',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: colorScheme.primary),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: colorScheme.primary),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const Divider(height: 1, thickness: 0.5),
            ListTile(
              leading: Icon(Icons.close, color: colorScheme.error),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      PermissionStatus status;
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        status = await Permission.photos.request();
      }

      if (!status.isGranted) {
        _showPermissionDeniedMessage(
          source == ImageSource.camera ? 'la cámara' : 'la galería',
        );
        return;
      }

      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _avatarFile = pickedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showPermissionDeniedMessage(String feature) {
    final colorScheme = Theme.of(context).colorScheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Permiso denegado para $feature'),
        backgroundColor: colorScheme.error,
        action: SnackBarAction(
          label: 'Ajustes',
          textColor: colorScheme.onError,
          onPressed: openAppSettings,
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      FormData formData = FormData.fromMap({
        'name': _nameController.text,
        'lastname': _lastnameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
      });

      if (_avatarFile != null) {
        formData.files.add(
          MapEntry(
            'avatar',
            await MultipartFile.fromFile(
              _avatarFile!.path,
              filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await DioClient.dio.post('register', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog();
      }
    } on DioException catch (e) {
      String errorMessage = 'Error en el registro';
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 64,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                '¡Registro exitoso!',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tu cuenta ha sido creada correctamente.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el diálogo
                    Navigator.pop(context); // Regresa al login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}