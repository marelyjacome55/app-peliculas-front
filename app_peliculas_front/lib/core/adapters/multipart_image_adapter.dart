import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// Adapta una imagen seleccionada con ImagePicker al formato MultipartFile.
///
/// Patrón estructural: Adapter.
/// Convierte el objeto XFile de Flutter al formato que necesita http.MultipartRequest.
class MultipartImageAdapter {
  const MultipartImageAdapter();

  Future<http.MultipartFile> toMultipartFile({
    required String fieldName,
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();

    return http.MultipartFile.fromBytes(
      fieldName,
      bytes,
      filename: image.name,
    );
  }
}