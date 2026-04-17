import 'package:flutter/material.dart';

import '../models/pelicula.dart';

class PeliculaCard extends StatelessWidget {
  final Pelicula pelicula;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  final VoidCallback onCambiarVista;

  const PeliculaCard({
    super.key,
    required this.pelicula,
    required this.onEditar,
    required this.onEliminar,
    required this.onCambiarVista,
  });

  @override
  Widget build(BuildContext context) {
    final Color estadoColor = pelicula.vista ? Colors.green : Colors.orange;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: pelicula.portada.isNotEmpty
                      ? Image.network(
                          pelicula.portada,
                          width: 105,
                          height: 145,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imagenFallback(),
                        )
                      : _imagenFallback(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pelicula.nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Género: ${pelicula.genero}'),
                      const SizedBox(height: 6),
                      Text('Calificación: ${pelicula.calificacion}'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: estadoColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          pelicula.vista ? 'Vista' : 'Pendiente',
                          style: TextStyle(
                            color: estadoColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'editar') onEditar();
                    if (value == 'eliminar') onEliminar();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'editar',
                      child: Text('Editar'),
                    ),
                    PopupMenuItem(
                      value: 'eliminar',
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCambiarVista,
                icon: Icon(
                  pelicula.vista
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                label: Text(
                  pelicula.vista ? 'Marcar pendiente' : 'Marcar vista',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagenFallback() {
    return Container(
      width: 105,
      height: 145,
      color: const Color(0xFFE9E0FF),
      child: const Icon(Icons.movie, size: 40),
    );
  }
}