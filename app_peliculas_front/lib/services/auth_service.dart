import 'dart:convert';

import '../core/network/api_client.dart';
import '../core/security/session_manager.dart';

/// PATRÓN: Service Layer
/// Gestiona autenticación. Persiste el token en `SessionManager`.
class AuthService {
  AuthService({ApiClient? apiClient, SessionManager? sessionManager})
      : _apiClient = apiClient ?? ApiClient(),
        _sessionManager = sessionManager ?? SessionManager();

  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  /// Token actual en memoria de sesion.
  String? get token => _sessionManager.token;

  /// Indica si existe una sesion autenticada activa.
  bool get estaAutenticado => _sessionManager.isAuthenticated;

  /// Inicia sesion contra la API y persiste el access token.
  Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/auth/signin',
      withAuth: false,
      body: {
        'username': username,
        'password': password,
      },
    );

    final data = jsonDecode(response.body);
    _sessionManager.saveToken((data['accessToken'] ?? '').toString());
  }

  /// Registra un nuevo usuario en el backend.
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await _apiClient.post(
      '/api/auth/signup',
      withAuth: false,
      body: {
        'username': username,
        'email': email,
        'password': password,
        'role': ['user'],
      },
    );
  }

  /// Cierra sesion y limpia credenciales locales.
  void logout() {
    _sessionManager.clearSession();
  }
}