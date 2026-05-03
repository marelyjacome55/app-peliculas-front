/// Entidad de dominio que representa una pelicula registrada por el usuario.
class Pelicula {
  final int? id;
  final String nombre;
  final String portada;
  final String genero;
  final double calificacion;
  final bool vista;
  final String comentarioPersonal;

  const Pelicula({
    this.id,
    required this.nombre,
    required this.portada,
    required this.genero,
    required this.calificacion,
    required this.vista,
    this.comentarioPersonal = '',
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
      comentarioPersonal: (json['comentarioPersonal'] ?? '').toString(),
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
      'comentarioPersonal': comentarioPersonal,
    };
  }

  Pelicula copyWith({
    int? id,
    String? nombre,
    String? portada,
    String? genero,
    double? calificacion,
    bool? vista,
    String? comentarioPersonal,
  }) {
    return Pelicula(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      portada: portada ?? this.portada,
      genero: genero ?? this.genero,
      calificacion: calificacion ?? this.calificacion,
      vista: vista ?? this.vista,
      comentarioPersonal: comentarioPersonal ?? this.comentarioPersonal,
    );
  }
}