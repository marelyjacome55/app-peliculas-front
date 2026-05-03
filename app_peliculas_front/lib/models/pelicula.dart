/// Entidad de dominio que representa una pelicula registrada por el usuario.
class Pelicula {
  final int? id;
  final String nombre;
  final String portada;
  final String genero;
  final double calificacion;
  final bool vista;

  const Pelicula({
    this.id,
    required this.nombre,
    required this.portada,
    required this.genero,
    required this.calificacion,
    required this.vista,
  });

  /// Patrón creacional: Factory Method.
  /// Centraliza la creación de objetos Pelicula desde JSON.
  /// Así la conversión de datos no se repite en servicios o pantallas.
  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse((json['id'] ?? '').toString()),
      nombre: (json['nombre'] ?? '').toString(),
      portada: (json['portada'] ?? '').toString(),
      genero: (json['genero'] ?? '').toString(),
      calificacion: (json['calificacion'] as num?)?.toDouble() ?? 0.0,
      vista: json['vista'] as bool? ?? json['visto'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'portada': portada,
      'genero': genero,
      'calificacion': calificacion,
      'vista': vista,
    };
  }
}