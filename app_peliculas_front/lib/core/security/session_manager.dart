/// Administra la sesión del usuario autenticado.
///
/// Patrón de diseño: Singleton.
/// Se usa una sola instancia compartida para guardar el token JWT
/// y permitir que los servicios lo consulten desde cualquier parte del frontend.
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  String? _token;

  String? get token => _token;

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  void saveToken(String token) {
    _token = token;
  }

  void clearSession() {
    _token = null;
  }
}