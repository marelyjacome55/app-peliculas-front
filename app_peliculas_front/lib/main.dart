import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const AppPeliculas());
}

class AppPeliculas extends StatelessWidget {
  const AppPeliculas({super.key});

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
      home: const LoginScreen(),
    );
  }
}
