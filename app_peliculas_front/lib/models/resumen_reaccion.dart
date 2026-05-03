import 'reaccion_pelicula.dart';

/// PATRÓN DTO / MODEL:
/// Este modelo representa el resumen estadístico de una reacción.
/// Se usará en la pantalla "Mis reacciones".
class ResumenReaccion {
  final TipoReaccion tipoReaccion;
  final String nombre;
  final int total;

  const ResumenReaccion({
    required this.tipoReaccion,
    required this.nombre,
    required this.total,
  });

  /// PATRÓN FACTORY METHOD:
  /// Centraliza la conversión desde JSON hacia un objeto de la app.
  factory ResumenReaccion.fromJson(Map<String, dynamic> json) {
    final tipoApi = (json['tipoReaccion'] ?? '').toString();

    return ResumenReaccion(
      tipoReaccion: TipoReaccionExtension.fromApiValue(tipoApi),
      nombre: (json['nombre'] ?? '').toString(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}