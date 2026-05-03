import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../security/session_manager.dart';

/// PATRÓN: Facade (Cliente HTTP)
/// Centraliza URIs, headers (auth) y validación de respuestas HTTP.
class ApiClient {
  ApiClient({
    SessionManager? sessionManager,
    String? baseUrl,
  })  : _sessionManager = sessionManager ?? SessionManager(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final SessionManager _sessionManager;
  final String _baseUrl;

  Uri buildUri(String path, [Map<String, dynamic>? query]) {
    final uri = Uri.parse('$_baseUrl$path');

    if (query == null || query.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: query.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Map<String, String> headers({bool withAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (withAuth && _sessionManager.token != null) {
      headers['Authorization'] = 'Bearer ${_sessionManager.token}';
    }

    return headers;
  }

  Map<String, String> authHeaders() {
    final headers = <String, String>{};

    if (_sessionManager.token != null) {
      headers['Authorization'] = 'Bearer ${_sessionManager.token}';
    }

    return headers;
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    bool withAuth = true,
  }) async {
    final response = await http.get(
      buildUri(path, query),
      headers: headers(withAuth: withAuth),
    );

    validate(response);
    return response;
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final response = await http.post(
      buildUri(path, query),
      headers: headers(withAuth: withAuth),
      body: jsonEncode(body ?? {}),
    );

    validate(response);
    return response;
  }

  Future<http.Response> patch(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final response = await http.patch(
      buildUri(path, query),
      headers: headers(withAuth: withAuth),
      body: jsonEncode(body ?? {}),
    );

    validate(response);
    return response;
  }

  Future<http.Response> delete(
    String path, {
    Map<String, dynamic>? query,
    bool withAuth = true,
  }) async {
    final response = await http.delete(
      buildUri(path, query),
      headers: headers(withAuth: withAuth),
    );

    validate(response);
    return response;
  }

  void validate(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw Exception(
      'Error ${response.statusCode}: ${response.body}',
    );
  }
}