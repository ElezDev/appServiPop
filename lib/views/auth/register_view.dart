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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  XFile? _avatarFile;
  bool _isLoading = false;
  final Dio _dio = Dio();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // _buildHeader(),
              // SizedBox(height: 20),
              _buildAvatarPicker(),
              const SizedBox(height: 20),
              _buildNameField(),
              const SizedBox(height: 15),
              _buildLastnameField(),
              const SizedBox(height: 15),
              _buildEmailField(),
              const SizedBox(height: 15),
              _buildPhoneField(),
              const SizedBox(height: 15),
              _buildAddressField(),
              const SizedBox(height: 15),
              _buildPasswordField(),
              const SizedBox(height: 25),
              _buildRegisterButton(),
              const SizedBox(height: 15),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  // ============ WIDGETS DEL FORMULARIO ============

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 15),
        Text(
          'Crea tu cuenta',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Completa tus datos para comenzar',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAvatarPicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                _avatarFile != null ? FileImage(File(_avatarFile!.path)) : null,
            child:
                _avatarFile == null
                    ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                    : null,
          ),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: _showImageSourceDialog,
          icon: Icon(Icons.edit, size: 16, color: Colors.green[700]),
          label: Text(
            'Cambiar foto de perfil',
            style: TextStyle(color: Colors.green[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: _inputDecoration('Nombre', Icons.person),
      validator: (value) => value!.isEmpty ? 'Ingresa tu nombre' : null,
    );
  }

  Widget _buildLastnameField() {
    return TextFormField(
      controller: _lastnameController,
      decoration: _inputDecoration('Apellido', Icons.person_outline),
      validator: (value) => value!.isEmpty ? 'Ingresa tu apellido' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Correo electrónico', Icons.email),
      validator: (value) {
        if (value!.isEmpty) return 'Ingresa tu correo';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Correo inválido';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration('Teléfono', Icons.phone),
      validator: (value) => value!.isEmpty ? 'Ingresa tu teléfono' : null,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: _inputDecoration('Dirección', Icons.home),
      validator: (value) => value!.isEmpty ? 'Ingresa tu dirección' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: _inputDecoration('Contraseña', Icons.lock),
      validator: (value) {
        if (value!.isEmpty) return 'Ingresa tu contraseña';
        if (value.length < 6) return 'Mínimo 6 caracteres';
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[800],
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child:
          _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('REGISTRARSE', style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text.rich(
          TextSpan(
            text: '¿Ya tienes cuenta? ',
            style: TextStyle(color: Colors.grey[600]),
            children: [
              TextSpan(
                text: 'Inicia sesión',
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ FUNCIONALIDAD ============

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green[800]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.green[800]!, width: 2),
      ),
    );
  }

 Future<void> _showImageSourceDialog() async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent, // Para que se vean los bordes redondeados
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Indicador de deslizamiento ---
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // --- Título opcional ---
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'Seleccionar imagen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          // --- Opciones ---
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.greenAccent[700]),
            title: const Text('Tomar foto'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: Colors.greenAccent[700]),
            title: const Text('Elegir de galería'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          // --- Divisor y Cancelar ---
          const Divider(height: 1, thickness: 0.5),
          ListTile(
            leading: Icon(Icons.close, color: Colors.red[400]),
            title: const Text('Cancelar'),
            onTap: () => Navigator.pop(context),
          ),
          // --- Espacio para evitar el notch ---
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPermissionDeniedMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Permiso denegado para $feature'),
        action: const SnackBarAction(
          label: 'Ajustes',
          textColor: Colors.white,
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
        print(response.data);
      }
    } on DioException catch (e) {
      String errorMessage = 'Error en el registro';
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(
              '¡Registro exitoso!',
              style: TextStyle(color: Colors.green[800]),
            ),
            content: const Text('Tu cuenta ha sido creada correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                  Navigator.pop(context); // Regresa al login
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
            ],
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
