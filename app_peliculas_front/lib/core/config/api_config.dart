/// Configuración general de la API.
///
/// Patrón relacionado: Singleton/Configuración centralizada.
/// Esta clase evita repetir la URL base en varios archivos.
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://app-peliculas-api.onrender.com',
  );
}