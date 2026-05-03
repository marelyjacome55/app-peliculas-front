/// PATRÓN: Singleton
/// Única instancia para persistir token JWT. Accesible desde cualquier capa.
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