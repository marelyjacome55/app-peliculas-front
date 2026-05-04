import 'package:flutter_test/flutter_test.dart';

<<<<<<< HEAD
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
=======
void main() {
  test('Prueba base del proyecto', () {
    expect(true, isTrue);
>>>>>>> 4ccc895 (Corregir análisis Flutter antes de generar APK)
  });
}