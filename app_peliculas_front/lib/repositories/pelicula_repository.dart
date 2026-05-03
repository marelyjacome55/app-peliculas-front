import 'package:image_picker/image_picker.dart';

import '../models/pelicula.dart';
import '../services/pelicula_service.dart';

/// Contrato de acceso a datos para operaciones de peliculas.
///
/// Esta abstraccion desacopla la UI de la fuente concreta de datos.
abstract class PeliculaRepository {
  /// Obtiene el listado completo de peliculas.
  Future<List<Pelicula>> obtenerPeliculas();

  /// Busca peliculas por coincidencia de nombre.
  Future<List<Pelicula>> buscarPorNombre(String nombre);

  /// Filtra peliculas por su estado de visualizacion.
  Future<List<Pelicula>> filtrarPorVista(bool vista);

  /// Crea una nueva pelicula y devuelve el recurso persistido.
  Future<Pelicula> crearPelicula({
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    required XFile imagen,
  });

  /// Edita una pelicula existente y devuelve la version actualizada.
  Future<Pelicula> editarPelicula({
    required int id,
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    XFile? imagen,
  });

  /// Elimina una pelicula por identificador.
  Future<void> eliminarPelicula(int id);

  /// Cambia el estado vista/pendiente de una pelicula.
  Future<Pelicula> cambiarEstadoVista(int id, bool vista);
}

/// Implementacion remota del repositorio que delega en [PeliculaService].
class RemotePeliculaRepository implements PeliculaRepository {
  RemotePeliculaRepository({required PeliculaService service})
      : _service = service;

  final PeliculaService _service;

  @override
  Future<List<Pelicula>> obtenerPeliculas() {
    return _service.obtenerPeliculas();
  }

  @override
  Future<List<Pelicula>> buscarPorNombre(String nombre) {
    return _service.buscarPorNombre(nombre);
  }

  @override
  Future<List<Pelicula>> filtrarPorVista(bool vista) {
    return _service.filtrarPorVista(vista);
  }

  @override
  Future<Pelicula> crearPelicula({
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    required XFile imagen,
  }) {
    return _service.crearPelicula(
      nombre: nombre,
      genero: genero,
      calificacion: calificacion,
      vista: vista,
      imagen: imagen,
    );
  }

  @override
  Future<Pelicula> editarPelicula({
    required int id,
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    XFile? imagen,
  }) {
    return _service.editarPelicula(
      id: id,
      nombre: nombre,
      genero: genero,
      calificacion: calificacion,
      vista: vista,
      imagen: imagen,
    );
  }

  @override
  Future<void> eliminarPelicula(int id) {
    return _service.eliminarPelicula(id);
  }

  @override
  Future<Pelicula> cambiarEstadoVista(int id, bool vista) {
    return _service.cambiarEstadoVista(id, vista);
  }
}
