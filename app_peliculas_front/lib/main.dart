import 'package:flutter/material.dart';

import 'core/facades/movie_app_facade.dart';
import 'core/factories/app_factory.dart';
import 'screens/login_screen.dart';

/// Punto de entrada de la aplicacion Flutter.
void main() {
  final MovieAppFacade facade = AppFactory.createMovieAppFacade();
  runApp(AppPeliculas(facade: facade));
}

/// Widget raiz que configura tema, rutas iniciales y estilo global.
///
/// Patrón creacional usado: Factory.
/// La aplicación recibe una fachada creada por AppFactory, evitando
/// construir servicios directamente dentro de las pantallas.
class AppPeliculas extends StatelessWidget {
  const AppPeliculas({
    super.key,
    required this.facade,
  });

  final MovieAppFacade facade;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas por ver',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF6C63FF),
              width: 1.5,
            ),
          ),
        ),
      ),
      home: LoginScreen(facade: facade),
    );
  }
}