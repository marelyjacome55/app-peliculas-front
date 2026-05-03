import 'package:image_picker/image_picker.dart';

import '../../models/pelicula.dart';
import '../../models/reaccion_pelicula.dart';
import '../../models/resumen_reaccion.dart';
import '../../repositories/pelicula_repository.dart';
import '../../services/auth_service.dart';

/// PATRÓN: Facade
/// Entrada única para autenticación, películas y reacciones. Desacopla UI de servicios.
class MovieAppFacade {
  MovieAppFacade({
    required AuthService authService,
    required PeliculaRepository peliculaRepository,
  })  : _authService = authService,
        _peliculaRepository = peliculaRepository;

  final AuthService _authService;
  final PeliculaRepository _peliculaRepository;

  bool get estaAutenticado => _authService.estaAutenticado;

  String? get token => _authService.token;

  Future<void> iniciarSesion({
    required String username,
    required String password,
  }) {
    return _authService.login(
      username: username,
      password: password,
    );
  }

  Future<void> registrarUsuario({
    required String username,
    required String email,
    required String password,
  }) {
    return _authService.register(
      username: username,
      email: email,
      password: password,
    );
  }

  void cerrarSesion() {
    _authService.logout();
  }

  Future<List<Pelicula>> obtenerPeliculas() {
    return _peliculaRepository.obtenerPeliculas();
  }

  Future<List<Pelicula>> buscarPorNombre(String nombre) {
    return _peliculaRepository.buscarPorNombre(nombre);
  }

  Future<List<Pelicula>> filtrarPorVista(bool vista) {
    return _peliculaRepository.filtrarPorVista(vista);
  }

  Future<Pelicula> crearPelicula({
    required String nombre,
    required String genero,
    required double calificacion,
    required bool vista,
    required XFile imagen,
  }) {
    return _peliculaRepository.crearPelicula(
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
    return _peliculaRepository.editarPelicula(
      id: id,
      nombre: nombre,
      genero: genero,
      calificacion: calificacion,
      vista: vista,
      imagen: imagen,
    );
  }

  Future<void> eliminarPelicula(int id) {
    return _peliculaRepository.eliminarPelicula(id);
  }

  Future<Pelicula> cambiarEstadoVista(int id, bool vista) {
    return _peliculaRepository.cambiarEstadoVista(id, vista);
  }

  Future<Pelicula> actualizarComentarioPersonal({
    required int id,
    required String comentarioPersonal,
  }) {
    return _peliculaRepository.actualizarComentarioPersonal(
      id: id,
      comentarioPersonal: comentarioPersonal,
    );
  }

  Future<List<ReaccionPelicula>> obtenerReaccionesDePelicula(int id) {
    return _peliculaRepository.obtenerReaccionesDePelicula(id);
  }

  Future<List<ReaccionPelicula>> agregarReaccion({
    required int id,
    required TipoReaccion tipoReaccion,
  }) {
    return _peliculaRepository.agregarReaccion(
      id: id,
      tipoReaccion: tipoReaccion,
    );
  }

  Future<List<ReaccionPelicula>> eliminarReaccion({
    required int id,
    required TipoReaccion tipoReaccion,
  }) {
    return _peliculaRepository.eliminarReaccion(
      id: id,
      tipoReaccion: tipoReaccion,
    );
  }

  Future<List<ResumenReaccion>> obtenerMisReacciones() {
    return _peliculaRepository.obtenerMisReacciones();
  }

  Future<List<Pelicula>> obtenerPeliculasPorReaccion(
    TipoReaccion tipoReaccion,
  ) {
    return _peliculaRepository.obtenerPeliculasPorReaccion(tipoReaccion);
  }
}