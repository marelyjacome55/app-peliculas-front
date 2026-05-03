import 'reaccion_pelicula.dart';

/// PATRÓN: DTO / Factory Method
/// Resumen estadístico de reacción. fromJson convierte datos de API.
class ResumenReaccion {
  final TipoReaccion tipoReaccion;
  final String nombre;
  final int total;

  const ResumenReaccion({
    required this.tipoReaccion,
    required this.nombre,
    required this.total,
  });

  factory ResumenReaccion.fromJson(Map<String, dynamic> json) {
    final tipoApi = (json['tipoReaccion'] ?? '').toString();

    return ResumenReaccion(
      tipoReaccion: TipoReaccionExtension.fromApiValue(tipoApi),
      nombre: (json['nombre'] ?? '').toString(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}