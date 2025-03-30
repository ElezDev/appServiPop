import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:servipopapp/core/dio_client.dart';
import 'dart:io';
import 'package:servipopapp/models/category_model.dart';
import 'package:servipopapp/models/service_model.dart';
import 'package:servipopapp/services/auth_service.dart';
import 'package:servipopapp/views/auth/providers/category_provider.dart';

class CreateServiceScreen extends StatefulWidget {
  @override
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isLoading = false;
  List<File> _portfolioImages = [];
  Category? _selectedCategory;
  final AuthService _authService = AuthService();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Cargar categorías al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  Future<void> _pickImage() async {
    if (_portfolioImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solo puedes subir hasta 3 imágenes')),
      );
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _portfolioImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _portfolioImages.removeAt(index);
    });
  }

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona una categoría')),
      );
      return;
    }

    if (_portfolioImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor sube al menos una imagen')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Preparamos el FormData para enviar todo en una sola solicitud
      final formData = FormData();

      // Agregamos los campos básicos
      formData.fields.addAll([
        MapEntry('title', _titleController.text),
        MapEntry('description', _descriptionController.text),
        MapEntry('price', _priceController.text),
        MapEntry('duration', _durationController.text),
        MapEntry('categories[]', _selectedCategory!.id.toString()),
      ]);

      // Agregamos las imágenes como archivos
      for (var image in _portfolioImages) {
        String fileName = image.path.split('/').last;
        formData.files.add(MapEntry(
          'portfolio_images[]',
          await MultipartFile.fromFile(image.path, filename: fileName),
        ));
      }

      final token = await _authService.getToken();

      final response = await DioClient.dio.post(
        'services', // Asegúrate que este es el endpoint correcto
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("Respuesta del servidor: ${response.data}");

      if (response.statusCode == 201) {
        final newService = Service.fromJson(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Servicio creado exitosamente')),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el servicio: Código ${response.statusCode}')),
        );
      }
    } on DioException catch (dioError) {
      print("Error de Dio: ${dioError.response?.data ?? dioError.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de red: ${dioError.response?.data ?? dioError.message}'),
        ),
      );
    } catch (e) {
      print("Error inesperado: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: ${e.toString()}'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  Future<String> _uploadImage(File image) async {
    String fileName = image.path.split('/').last;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path, filename: fileName),
    });

    final response = await DioClient.dio.post('services', data: formData);

    if (response.statusCode == 200) {
      return response.data['url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _durationController.clear();
    setState(() {
      _portfolioImages.clear();
      _selectedCategory = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Crear Nuevo Servicio'), elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título del servicio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Precio y Duración en fila
              Row(
                children: [
                  // Precio
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un precio';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Precio inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  // Duración
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _durationController,
                      decoration: InputDecoration(
                        labelText: 'Duración (min)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timer),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa la duración';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Duración inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Selector de Categoría
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Category>(
                    value: _selectedCategory,
                    isExpanded: true,
                    hint: Text('Selecciona una categoría'),
                    items:
                        categoryProvider.categories.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                    onChanged: (Category? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Subida de imágenes
              Text(
                'Imágenes del portafolio (Máx. 3)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Sube imágenes que muestren ejemplos de tu trabajo',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),

              // Preview de imágenes y botón para agregar
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._portfolioImages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final image = entry.value;
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () => _removeImage(index),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.all(4),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  if (_portfolioImages.length < 3)
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 30),
                            SizedBox(height: 5),
                            Text('Agregar', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 30),

              // Botón de enviar
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Text(
                          'Publicar Servicio',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
