import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../core/adapters/multipart_image_adapter.dart';
import '../core/network/api_client.dart';
import '../models/pelicula.dart';
import '../models/reaccion_pelicula.dart';
import '../models/resumen_reaccion.dart';

/// Servicio remoto para operaciones CRUD, filtros, comentarios y reacciones.
///
/// PATRÓN: Service Layer
/// Centraliza la comunicación con la API para que la interfaz no haga
/// peticiones HTTP directamente.
class PeliculaService {
  PeliculaService({
    ApiClient? apiClient,
    MultipartImageAdapter? imageAdapter,
  })  : _apiClient = apiClient ?? ApiClient(),
        _imageAdapter = imageAdapter ?? const MultipartImageAdapter();

  final ApiClient _apiClient;
  final MultipartImageAdapter _imageAdapter;

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    return _apiClient.buildUri(path, query);
  }

  Future<List<Pelicula>> obtenerPeliculas() async {
    final response = await _apiClient.get('/api/peliculas');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }

  Future<List<Pelicula>> buscarPorNombre(String nombre) async {
    final response = await _apiClient.get(
      '/api/peliculas/buscar',
      query: {'nombre': nombre},
    );
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }

  Future<List<Pelicula>> filtrarPorVista(bool vista) async {
    final response = await _apiClient.get(
      '/api/peliculas/filtrar',
      query: {'vista': vista},
    );
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

  Future<void> eliminarPelicula(int id) async {
    await _apiClient.delete('/api/peliculas/$id');
  }

  Future<Pelicula> cambiarEstadoVista(int id, bool vista) async {
    final response = await _apiClient.patch(
      '/api/peliculas/$id/vista',
      query: {'vista': vista},
      body: const {},
    );
    return Pelicula.fromJson(jsonDecode(response.body));
  }

  Future<Pelicula> actualizarComentarioPersonal({
    required int id,
    required String comentarioPersonal,
  }) async {
    final response = await _apiClient.patch(
      '/api/peliculas/$id/comentario',
      body: {
        'comentarioPersonal': comentarioPersonal,
      },
    );

    return Pelicula.fromJson(jsonDecode(response.body));
  }

  Future<List<ReaccionPelicula>> obtenerReaccionesDePelicula(int id) async {
    final response = await _apiClient.get('/api/peliculas/$id/reacciones');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReaccionPelicula.fromJson(e)).toList();
  }

  Future<List<ReaccionPelicula>> agregarReaccion({
    required int id,
    required TipoReaccion tipoReaccion,
  }) async {
    final response = await _apiClient.post(
      '/api/peliculas/$id/reacciones/${tipoReaccion.apiValue}',
    );

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReaccionPelicula.fromJson(e)).toList();
  }

  Future<List<ReaccionPelicula>> eliminarReaccion({
    required int id,
    required TipoReaccion tipoReaccion,
  }) async {
    final response = await _apiClient.delete(
      '/api/peliculas/$id/reacciones/${tipoReaccion.apiValue}',
    );

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ReaccionPelicula.fromJson(e)).toList();
  }

  Future<List<ResumenReaccion>> obtenerMisReacciones() async {
    final response = await _apiClient.get('/api/mis-reacciones');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ResumenReaccion.fromJson(e)).toList();
  }

  Future<List<Pelicula>> obtenerPeliculasPorReaccion(
    TipoReaccion tipoReaccion,
  ) async {
    final response = await _apiClient.get(
      '/api/mis-reacciones/${tipoReaccion.apiValue}',
    );

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Pelicula.fromJson(e)).toList();
  }
}