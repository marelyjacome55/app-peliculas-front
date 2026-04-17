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

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      id: json['id'] as int?,
      nombre: (json['nombre'] ?? '').toString(),
      portada: (json['portada'] ?? '').toString(),
      genero: (json['genero'] ?? '').toString(),
      calificacion: (json['calificacion'] as num?)?.toDouble() ?? 0.0,
      vista: json['vista'] as bool? ?? false,
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