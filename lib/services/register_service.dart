// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';

// class RegisterService {
//   final Dio _dio = Dio();

//   Future<Response> registerUser({
//     required String name,
//     required String lastname,
//     required String email,
//     required String password,
//     required String phone,
//     required String address,
//     XFile? avatar,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         'name': name,
//         'lastname': lastname,
//         'email': email,
//         'password': password,
//         'phone': phone,
//         'address': address,
//       });

//       // Si hay avatar, agregarlo al FormData
//       if (avatar != null) {
//         formData.files.add(MapEntry(
//           'avatar',
//           await MultipartFile.fromFile(
//             avatar.path,
//             filename: avatar.name.split('/').last,
//             contentType: MediaType('image', 'jpeg'), // Ajusta según el tipo
//           ),
//         ));
//       }

//       final response = await _dio.post(
//         'https://tu-api.com/api/register',
//         data: formData,
//         options: Options(
//           headers: {'Content-Type': 'multipart/form-data'},
//         ),
//       );
//       return response;
//     } on DioException catch (e) {
//       throw e;
//     }
//   }
// }