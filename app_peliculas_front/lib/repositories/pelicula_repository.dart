import 'package:image_picker/image_picker.dart';

import '../models/pelicula.dart';
import '../models/reaccion_pelicula.dart';
import '../models/resumen_reaccion.dart';
import '../services/pelicula_service.dart';

/// Contrato de acceso a datos para operaciones de peliculas.
///
/// PATRÓN REPOSITORY:
/// Esta abstraccion desacopla la UI de la fuente concreta de datos.
/// La interfaz no llama directamente a PeliculaService.
abstract class PeliculaRepository {
  Future<List<Pelicula>> obtenerPeliculas();

  Future<List<Pelicula>> buscarPorNombre(String nombre);

  Future<List<Pelicula>> filtrarPorVista(bool vista);

  Future<Pelicula> crearPelicula({
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    required XFile imagen,
  });

  Future<Pelicula> editarPelicula({
    required int id,
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    XFile? imagen,
  });

  Future<void> eliminarPelicula(int id);

  Future<Pelicula> cambiarEstadoVista(int id, bool vista);

  Future<Pelicula> actualizarComentarioPersonal({
    required int id,
    required String comentarioPersonal,
  });

  Future<List<ReaccionPelicula>> obtenerReaccionesDePelicula(int id);

  Future<List<ReaccionPelicula>> agregarReaccion({
    required int id,
    required TipoReaccion tipoReaccion,
  });

  Future<List<ReaccionPelicula>> eliminarReaccion({
    required int id,
    required TipoReaccion tipoReaccion,
  });

  Future<List<ResumenReaccion>> obtenerMisReacciones();

  Future<List<Pelicula>> obtenerPeliculasPorReaccion(
    TipoReaccion tipoReaccion,
  );
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

  @override
  Future<Pelicula> actualizarComentarioPersonal({
    required int id,
    required String comentarioPersonal,
  }) {
    return _service.actualizarComentarioPersonal(
      id: id,
      comentarioPersonal: comentarioPersonal,
    );
  }

  @override
  Future<List<ReaccionPelicula>> obtenerReaccionesDePelicula(int id) {
    return _service.obtenerReaccionesDePelicula(id);
  }

  @override
  Future<List<ReaccionPelicula>> agregarReaccion({
    required int id,
    required TipoReaccion tipoReaccion,
  }) {
    return _service.agregarReaccion(
      id: id,
      tipoReaccion: tipoReaccion,
    );
  }

  @override
  Future<List<ReaccionPelicula>> eliminarReaccion({
    required int id,
    required TipoReaccion tipoReaccion,
  }) {
    return _service.eliminarReaccion(
      id: id,
      tipoReaccion: tipoReaccion,
    );
  }

  @override
  Future<List<ResumenReaccion>> obtenerMisReacciones() {
    return _service.obtenerMisReacciones();
  }

  @override
  Future<List<Pelicula>> obtenerPeliculasPorReaccion(
    TipoReaccion tipoReaccion,
  ) {
    return _service.obtenerPeliculasPorReaccion(tipoReaccion);
  }
}