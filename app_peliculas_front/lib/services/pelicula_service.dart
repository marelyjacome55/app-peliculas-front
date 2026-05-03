import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../core/adapters/multipart_image_adapter.dart';
import '../core/network/api_client.dart';
import '../models/pelicula.dart';

/// Servicio remoto para operaciones CRUD y filtros de peliculas.
class PeliculaService {
  PeliculaService({
    ApiClient? apiClient,
    MultipartImageAdapter? imageAdapter,
  })  : _apiClient = apiClient ?? ApiClient(),
        _imageAdapter = imageAdapter ?? const MultipartImageAdapter();

  final ApiClient _apiClient;
  final MultipartImageAdapter _imageAdapter;

  /// Construye URIs completas a partir de rutas relativas de API.
  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    return _apiClient.buildUri(path, query);
  }

  /// Obtiene todas las peliculas del usuario autenticado.
  Future<List<Pelicula>> obtenerPeliculas() async {
    final response = await _apiClient.get('/api/peliculas');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }

  /// Busca peliculas por nombre usando endpoint de busqueda.
  Future<List<Pelicula>> buscarPorNombre(String nombre) async {
    final response = await _apiClient.get(
      '/api/peliculas/buscar',
      query: {'nombre': nombre},
    );
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }

  /// Filtra peliculas por estado de visualizacion.
  Future<List<Pelicula>> filtrarPorVista(bool vista) async {
    final response = await _apiClient.get(
      '/api/peliculas/filtrar',
      query: {'vista': vista},
    );
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }

  /// Crea una nueva pelicula con subida de imagen en multipart/form-data.
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

    request.headers.addAll(_apiClient.authHeaders());
    request.fields['nombre'] = nombre;
    request.fields['genero'] = genero;
    request.fields['calificacion'] = calificacion.toString();
    request.fields['vista'] = vista.toString();
    request.files.add(
      await _imageAdapter.toMultipartFile(fieldName: 'imagen', image: imagen),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    _apiClient.validate(response);
    return Pelicula.fromJson(jsonDecode(response.body));
  }

  /// Actualiza campos de una pelicula y opcionalmente su imagen.
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

    request.headers.addAll(_apiClient.authHeaders());
    request.fields['nombre'] = nombre;
    request.fields['genero'] = genero;
    request.fields['calificacion'] = calificacion.toString();
    request.fields['vista'] = vista.toString();

    if (imagen != null) {
      request.files.add(
        await _imageAdapter.toMultipartFile(
          fieldName: 'imagen',
          image: imagen,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    _apiClient.validate(response);
    return Pelicula.fromJson(jsonDecode(response.body));
  }

  /// Elimina una pelicula por id.
  Future<void> eliminarPelicula(int id) async {
    await _apiClient.delete('/api/peliculas/$id');
  }

  /// Alterna el estado de vista de una pelicula.
  Future<Pelicula> cambiarEstadoVista(int id, bool vista) async {
    final response = await _apiClient.patch(
      '/api/peliculas/$id/vista',
      query: {'vista': vista},
      body: const {},
    );
    return Pelicula.fromJson(jsonDecode(response.body));
  }
}