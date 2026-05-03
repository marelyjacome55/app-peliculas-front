import 'package:flutter_test/flutter_test.dart';

import 'package:app_peliculas_front/main.dart';
import 'package:app_peliculas_front/core/factories/app_factory.dart';

void main() {
  testWidgets('Carga pantalla de login', (WidgetTester tester) async {
    final facade = AppFactory.createMovieAppFacade();

    await tester.pumpWidget(
      AppPeliculas(facade: facade),
    );

    expect(find.text('App Películas por ver'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });
}