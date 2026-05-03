/// Catálogo de reacciones disponibles para una película.
enum TipoReaccion {
  meGusta,
  noMeGusta,
  meEncanta,
  meAburrio,
  meHizoReir,
  meSorprendio,
}

/// Extensión para convertir entre valores de Flutter y valores de la API.
extension TipoReaccionExtension on TipoReaccion {
  String get apiValue {
    switch (this) {
      case TipoReaccion.meGusta:
        return 'ME_GUSTA';
      case TipoReaccion.noMeGusta:
        return 'NO_ME_GUSTA';
      case TipoReaccion.meEncanta:
        return 'ME_ENCANTA';
      case TipoReaccion.meAburrio:
        return 'ME_ABURRIO';
      case TipoReaccion.meHizoReir:
        return 'ME_HIZO_REIR';
      case TipoReaccion.meSorprendio:
        return 'ME_SORPRENDIO';
    }
  }

  String get nombre {
    switch (this) {
      case TipoReaccion.meGusta:
        return 'Me gusta';
      case TipoReaccion.noMeGusta:
        return 'No me gusta';
      case TipoReaccion.meEncanta:
        return 'Me encanta';
      case TipoReaccion.meAburrio:
        return 'Me aburrió';
      case TipoReaccion.meHizoReir:
        return 'Me hizo reír';
      case TipoReaccion.meSorprendio:
        return 'Me sorprendió';
    }
  }

  static TipoReaccion fromApiValue(String value) {
    switch (value) {
      case 'ME_GUSTA':
        return TipoReaccion.meGusta;
      case 'NO_ME_GUSTA':
        return TipoReaccion.noMeGusta;
      case 'ME_ENCANTA':
        return TipoReaccion.meEncanta;
      case 'ME_ABURRIO':
        return TipoReaccion.meAburrio;
      case 'ME_HIZO_REIR':
        return TipoReaccion.meHizoReir;
      case 'ME_SORPRENDIO':
        return TipoReaccion.meSorprendio;
      default:
        throw Exception('Tipo de reacción no válido: $value');
    }
  }
}

/// PATRÓN DTO / MODEL:
/// Este modelo representa una reacción recibida desde la API.
/// Evita usar mapas JSON directamente en la interfaz.
class ReaccionPelicula {
  final TipoReaccion tipoReaccion;
  final String nombre;

  const ReaccionPelicula({
    required this.tipoReaccion,
    required this.nombre,
  });

  /// PATRÓN FACTORY METHOD:
  /// Centraliza la creación de una reacción desde JSON.
  factory ReaccionPelicula.fromJson(Map<String, dynamic> json) {
    final tipoApi = (json['tipoReaccion'] ?? '').toString();

    return ReaccionPelicula(
      tipoReaccion: TipoReaccionExtension.fromApiValue(tipoApi),
      nombre: (json['nombre'] ?? '').toString(),
    );
  }
}