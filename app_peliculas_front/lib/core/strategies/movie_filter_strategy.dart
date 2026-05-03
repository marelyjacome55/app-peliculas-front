import '../../models/pelicula.dart';
import '../facades/movie_app_facade.dart';

/// Contrato para aplicar filtros de películas.
///
/// Patrón de comportamiento: Strategy.
/// Permite cambiar el criterio de consulta sin llenar la pantalla principal
/// con demasiados if/switch.
abstract class MovieFilterStrategy {
  Future<List<Pelicula>> obtenerPeliculas(MovieAppFacade facade);
}

/// Estrategia para obtener todas las películas.
class AllMoviesStrategy implements MovieFilterStrategy {
  @override
  Future<List<Pelicula>> obtenerPeliculas(MovieAppFacade facade) {
    return facade.obtenerPeliculas();
  }
}

/// Estrategia para obtener solo películas vistas.
class WatchedMoviesStrategy implements MovieFilterStrategy {
  @override
  Future<List<Pelicula>> obtenerPeliculas(MovieAppFacade facade) {
    return facade.filtrarPorVista(true);
  }
}

/// Estrategia para obtener solo películas pendientes.
class PendingMoviesStrategy implements MovieFilterStrategy {
  @override
  Future<List<Pelicula>> obtenerPeliculas(MovieAppFacade facade) {
    return facade.filtrarPorVista(false);
  }
}

/// Estrategia para buscar películas por nombre.
class SearchMoviesStrategy implements MovieFilterStrategy {
  SearchMoviesStrategy(this.nombre);

  final String nombre;

  @override
  Future<List<Pelicula>> obtenerPeliculas(MovieAppFacade facade) {
    return facade.buscarPorNombre(nombre);
  }
}