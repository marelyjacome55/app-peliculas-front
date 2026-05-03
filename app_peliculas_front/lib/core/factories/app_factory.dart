import '../../repositories/pelicula_repository.dart';
import '../../services/auth_service.dart';
import '../../services/pelicula_service.dart';
import '../adapters/multipart_image_adapter.dart';
import '../facades/movie_app_facade.dart';
import '../network/api_client.dart';
import '../security/session_manager.dart';

/// PATRÓN: Factory
/// Centraliza composición de dependencias (ApiClient, Services, Repository, Facade).
class AppFactory {
  static MovieAppFacade createMovieAppFacade() {
    final sessionManager = SessionManager();
    final apiClient = ApiClient(sessionManager: sessionManager);

    final authService = AuthService(
      apiClient: apiClient,
      sessionManager: sessionManager,
    );

    final peliculaService = PeliculaService(
      apiClient: apiClient,
      imageAdapter: const MultipartImageAdapter(),
    );

    final peliculaRepository = RemotePeliculaRepository(
      service: peliculaService,
    );

    return MovieAppFacade(
      authService: authService,
      peliculaRepository: peliculaRepository,
    );
  }
}