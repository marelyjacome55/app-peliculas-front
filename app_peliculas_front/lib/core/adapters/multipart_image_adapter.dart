import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// PATRÓN: Adapter
/// Convierte XFile (ImagePicker) a MultipartFile para subida HTTP.
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