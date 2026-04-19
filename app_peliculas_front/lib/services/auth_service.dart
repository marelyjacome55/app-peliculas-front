import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://app-peliculas-api.onrender.com';

  static String? _token;

  String? get token => _token;

  bool get estaAutenticado => _token != null && _token!.isNotEmpty;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/signin'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body);
    _token = data['accessToken'];
  }

  void logout() {
    _token = null;
  }
}