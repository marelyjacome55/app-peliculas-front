import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/pelicula.dart';

class PeliculaService {
  static const String baseUrl = 'https://app-peliculas-api.onrender.com';

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<List<Pelicula>> obtenerPeliculas() async {
    final response = await http.get(_buildUri('/api/peliculas'));
    _validarRespuesta(response);

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }

  Future<List<Pelicula>> buscarPorNombre(String nombre) async {
    final response = await http.get(
      _buildUri('/api/peliculas/buscar', {'nombre': nombre}),
    );
    _validarRespuesta(response);

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }

  Future<List<Pelicula>> filtrarPorVista(bool vista) async {
    final response = await http.get(
      _buildUri('/api/peliculas/filtrar', {'vista': vista}),
    );
    _validarRespuesta(response);

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }

  Future<Pelicula> crearPelicula({
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    required XFile imagen,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      _buildUri('/api/peliculas'),
    );

    request.fields['nombre'] = nombre;
    request.fields['genero'] = genero;
    request.fields['calificacion'] = calificacion.toString();
    request.fields['vista'] = vista.toString();
    request.files.add(await _crearMultipartFile('imagen', imagen));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    _validarRespuesta(response);

    return Pelicula.fromJson(jsonDecode(response.body));
  }

  Future<Pelicula> editarPelicula({
    required int id,
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    XFile? imagen,
  }) async {
    final request = http.MultipartRequest(
      'PUT',
      _buildUri('/api/peliculas/$id'),
    );

    request.fields['nombre'] = nombre;
    request.fields['genero'] = genero;
    request.fields['calificacion'] = calificacion.toString();
    request.fields['vista'] = vista.toString();

    if (imagen != null) {
      request.files.add(await _crearMultipartFile('imagen', imagen));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    _validarRespuesta(response);

    return Pelicula.fromJson(jsonDecode(response.body));
  }

  Future<void> eliminarPelicula(int id) async {
    final response = await http.delete(_buildUri('/api/peliculas/$id'));

    if (response.statusCode != 204) {
      _validarRespuesta(response);
    }
  }

  Future<Pelicula> cambiarEstadoVista(int id, bool vista) async {
    final response = await http.patch(
      _buildUri('/api/peliculas/$id/vista', {'vista': vista}),
    );

    _validarRespuesta(response);

    return Pelicula.fromJson(jsonDecode(response.body));
  }

  Future<http.MultipartFile> _crearMultipartFile(
    String fieldName,
    XFile file,
  ) async {
    final Uint8List bytes = await file.readAsBytes();
    return http.MultipartFile.fromBytes(
      fieldName,
      bytes,
      filename: file.name,
    );
  }

  void _validarRespuesta(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw Exception('Error ${response.statusCode}: ${response.body}');
  }
}