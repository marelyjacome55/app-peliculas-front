import 'package:flutter/material.dart';

import '../core/facades/movie_app_facade.dart';
import '../core/factories/reaccion_ui_factory.dart';
import '../models/pelicula.dart';
import '../models/reaccion_pelicula.dart';

/// PATRÓN: Facade + Factory Method
/// Usa MovieAppFacade para operaciones y ReaccionUiFactory para UI consistente.
class PeliculaCard extends StatefulWidget {
  final Pelicula pelicula;
  final MovieAppFacade facade;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  final VoidCallback onCambiarVista;

  const PeliculaCard({
    super.key,
    required this.pelicula,
    required this.facade,
    required this.onEditar,
    required this.onEliminar,
    required this.onCambiarVista,
  });

  @override
  State<PeliculaCard> createState() => _PeliculaCardState();
}

class _PeliculaCardState extends State<PeliculaCard> {
  final TextEditingController _comentarioController = TextEditingController();

  Set<TipoReaccion> _reaccionesSeleccionadas = {};
  bool _cargandoReacciones = true;
  bool _guardandoComentario = false;
  bool _actualizandoReaccion = false;

  @override
  void initState() {
    super.initState();
    _comentarioController.text = widget.pelicula.comentarioPersonal;
    _cargarReacciones();
  }

  @override
  void didUpdateWidget(covariant PeliculaCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pelicula.id != widget.pelicula.id) {
      _comentarioController.text = widget.pelicula.comentarioPersonal;
      _cargarReacciones();
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _cargarReacciones() async {
    final id = widget.pelicula.id;
    if (id == null) return;

    setState(() {
      _cargandoReacciones = true;
    });

    try {
      final reacciones = await widget.facade.obtenerReaccionesDePelicula(id);

      if (!mounted) return;

      setState(() {
        _reaccionesSeleccionadas =
            reacciones.map((reaccion) => reaccion.tipoReaccion).toSet();
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _reaccionesSeleccionadas = {};
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargandoReacciones = false;
        });
      }
    }
  }

  Future<void> _guardarComentario() async {
    final id = widget.pelicula.id;
    if (id == null) return;

    setState(() {
      _guardandoComentario = true;
    });

    try {
      await widget.facade.actualizarComentarioPersonal(
        id: id,
        comentarioPersonal: _comentarioController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentario personal guardado')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar comentario: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardandoComentario = false;
        });
      }
    }
  }

  Future<void> _alternarReaccion(TipoReaccion tipo) async {
    final id = widget.pelicula.id;
    if (id == null || _actualizandoReaccion) return;

    setState(() {
      _actualizandoReaccion = true;
    });

    try {
      final yaSeleccionada = _reaccionesSeleccionadas.contains(tipo);

      final nuevasReacciones = yaSeleccionada
          ? await widget.facade.eliminarReaccion(
              id: id,
              tipoReaccion: tipo,
            )
          : await widget.facade.agregarReaccion(
              id: id,
              tipoReaccion: tipo,
            );

      if (!mounted) return;

      setState(() {
        _reaccionesSeleccionadas =
            nuevasReacciones.map((reaccion) => reaccion.tipoReaccion).toSet();
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar reacción: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _actualizandoReaccion = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color estadoColor =
        widget.pelicula.vista ? Colors.green : Colors.orange;

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
                  child: widget.pelicula.portada.isNotEmpty
                      ? Image.network(
                          widget.pelicula.portada,
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
                        widget.pelicula.nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Género: ${widget.pelicula.genero}'),
                      const SizedBox(height: 6),
                      Text('Calificación: ${widget.pelicula.calificacion}'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: estadoColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          widget.pelicula.vista ? 'Vista' : 'Pendiente',
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
                    if (value == 'editar') widget.onEditar();
                    if (value == 'eliminar') widget.onEliminar();
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
            _buildComentarioPersonal(),
            const SizedBox(height: 14),
            _buildReacciones(),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: widget.onCambiarVista,
                icon: Icon(
                  widget.pelicula.vista
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                label: Text(
                  widget.pelicula.vista
                      ? 'Marcar pendiente'
                      : 'Marcar vista',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComentarioPersonal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Comentario personal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _comentarioController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Escribe tu opinión personal sobre esta película...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: _guardandoComentario ? null : _guardarComentario,
            icon: _guardandoComentario
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: const Text('Guardar comentario'),
          ),
        ),
      ],
    );
  }

  Widget _buildReacciones() {
    if (_cargandoReacciones) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis reacciones (${_reaccionesSeleccionadas.length})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TipoReaccion.values.map((tipo) {
            final seleccionada = _reaccionesSeleccionadas.contains(tipo);
            final color = ReaccionUiFactory.color(tipo);

            return FilterChip(
              selected: seleccionada,
              avatar: Icon(
                ReaccionUiFactory.icono(tipo),
                size: 18,
                color: seleccionada ? color : Colors.black54,
              ),
              label: Text(tipo.nombre),
              onSelected: (_) => _alternarReaccion(tipo),
              selectedColor: color.withValues(alpha: 0.18),
              checkmarkColor: color,
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Construye el placeholder cuando la portada no existe o falla.
  Widget _imagenFallback() {
    return Container(
      width: 105,
      height: 145,
      color: const Color(0xFFE9E0FF),
      child: const Icon(Icons.movie, size: 40),
    );
  }
}