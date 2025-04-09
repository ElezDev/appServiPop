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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  Future<void> _pickImage() async {
    if (_portfolioImages.length >= 3) {
      _showErrorSnackbar('Solo puedes subir hasta 3 imágenes');
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
      _showErrorSnackbar('Error al seleccionar imagen: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _portfolioImages.removeAt(index);
    });
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      _showErrorSnackbar('Por favor selecciona una categoría');
      return;
    }

    if (_portfolioImages.isEmpty) {
      _showErrorSnackbar('Por favor sube al menos una imagen');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formData = FormData.fromMap({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'duration': _durationController.text,
        'categories[]': _selectedCategory!.id.toString(),
      });

      for (var image in _portfolioImages) {
        formData.files.add(
          MapEntry(
            'portfolio_images[]',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }

      final token = await _authService.getToken();
      final response = await DioClient.dio.post(
        'services',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 201) {
        _showSuccessDialog();
        _clearForm();
      } else {
        _showErrorSnackbar(
          'Error al crear el servicio: ${response.statusCode}',
        );
      }
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data?['message'] ?? dioError.message;
      _showErrorSnackbar('Error: $errorMessage');
    } catch (e) {
      _showErrorSnackbar('Error inesperado: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              '¡Servicio creado!',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 20),
                Text(
                  'Tu servicio se ha publicado exitosamente',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _durationController.clear();
    setState(() {
      _portfolioImages.clear();
      _selectedCategory = null;
    });

    PrimaryScrollController.of(context)?.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
      appBar: AppBar(
        title: Text(
          'Crear Nuevo Servicio',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
            tooltip: 'Ayuda',
          ),
        ],
      ),
      body:
          _isLoading
              ? _buildLoadingIndicator()
              : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeaderSection(),
                              SizedBox(height: 24),
                              _buildTitleField(),
                              SizedBox(height: 16),
                              _buildDescriptionField(),
                              SizedBox(height: 16),
                              _buildPriceDurationRow(),
                              SizedBox(height: 16),
                              _buildCategoryDropdown(categoryProvider),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: _buildPortfolioImagesSection(),
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Publicando tu servicio...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Por favor no cierres la aplicación',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nuevo Servicio',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Completa todos los campos para publicar tu servicio',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Título del servicio',
        labelStyle: TextStyle(color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      ),
      style: TextStyle(fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa un título';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Descripción detallada',
        labelStyle: TextStyle(color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      maxLines: 5,
      minLines: 3,
      style: TextStyle(fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa una descripción';
        }
        if (value.length < 50) {
          return 'La descripción debe tener al menos 50 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildPriceDurationRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: 'Precio (S/)',
              labelStyle: TextStyle(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(Icons.attach_money, color: Colors.grey[600]),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 18,
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 16),
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
        SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _durationController,
            decoration: InputDecoration(
              labelText: 'Duración (min)',
              labelStyle: TextStyle(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(Icons.timer, color: Colors.grey[600]),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 18,
              ),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 16),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa la duración';
              }
              if (int.tryParse(value) == null) {
                return 'Duración inválida';
              }
              if (int.parse(value) < 15) {
                return 'Mínimo 15 minutos';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(CategoryProvider categoryProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoría del servicio',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<Category>(
          value: _selectedCategory,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          isExpanded: true,
          hint: Text(
            'Selecciona una categoría',
            style: TextStyle(color: Colors.grey[600]),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).primaryColor,
          ),
          dropdownColor: Colors.white,
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          items:
              categoryProvider.categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(
                    category.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                );
              }).toList(),
          onChanged: (Category? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Por favor selecciona una categoría';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPortfolioImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Portafolio (Máx. 3 imágenes)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sube imágenes de calidad que muestren ejemplos de tu trabajo',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        SizedBox(height: 12),
        _buildImageGrid(),
      ],
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount:
          _portfolioImages.length < 3
              ? _portfolioImages.length + 1
              : _portfolioImages.length,
      itemBuilder: (context, index) {
        if (index < _portfolioImages.length) {
          return _buildImageThumbnail(index);
        } else {
          return _buildAddImageButton();
        }
      },
    );
  }

  Widget _buildImageThumbnail(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _portfolioImages[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red[600],
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 4),
            Text(
              'Agregar',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      child:
          _isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : Text(
                'PUBLICAR SERVICIO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
      onPressed: _isLoading ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 3,
        shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Ayuda para publicar servicios',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHelpItem(
                    '1. Proporciona un título claro y descriptivo',
                  ),
                  _buildHelpItem('2. Describe detalladamente tu servicio'),
                  _buildHelpItem('3. Selecciona la categoría más adecuada'),
                  _buildHelpItem('4. Sube imágenes de calidad de tu trabajo'),
                  SizedBox(height: 10),
                  Text(
                    'Recomendaciones:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildHelpItem('- Usa fotos bien iluminadas'),
                  _buildHelpItem('- Muestra diferentes ángulos de tu trabajo'),
                  _buildHelpItem(
                    '- Incluye detalles que destaquen tu servicio',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Entendido',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
