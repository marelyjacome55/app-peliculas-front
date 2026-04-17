import 'package:image_picker/image_picker.dart';

import '../models/pelicula.dart';
import '../services/pelicula_service.dart';

class PeliculaRepository {
  final PeliculaService _service = PeliculaService();

  Future<List<Pelicula>> obtenerPeliculas() {
    return _service.obtenerPeliculas();
  }

  Future<List<Pelicula>> buscarPorNombre(String nombre) {
    return _service.buscarPorNombre(nombre);
  }

  Future<List<Pelicula>> filtrarPorVista(bool vista) {
    return _service.filtrarPorVista(vista);
  }

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

  Future<void> eliminarPelicula(int id) {
    return _service.eliminarPelicula(id);
  }

  Future<Pelicula> cambiarEstadoVista(int id, bool vista) {
    return _service.cambiarEstadoVista(id, vista);
  }
}