import 'package:flutter/material.dart';

import '../core/facades/movie_app_facade.dart';
import '../core/factories/reaccion_ui_factory.dart';
import '../models/pelicula.dart';
import '../models/reaccion_pelicula.dart';
import '../models/resumen_reaccion.dart';

/// Pantalla de estadísticas y colecciones de reacciones.
///
/// PATRÓN FACADE:
/// Esta pantalla no llama directamente al servicio ni al repositorio.
/// Usa MovieAppFacade para obtener el resumen y las películas por reacción.
class MisReaccionesScreen extends StatefulWidget {
  const MisReaccionesScreen({
    super.key,
    required this.facade,
  });

  final MovieAppFacade facade;

  @override
  State<MisReaccionesScreen> createState() => _MisReaccionesScreenState();
}

class _MisReaccionesScreenState extends State<MisReaccionesScreen> {
  List<ResumenReaccion> _resumen = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarResumen();
  }

  Future<void> _cargarResumen() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final resumen = await widget.facade.obtenerMisReacciones();

      if (!mounted) return;

      setState(() {
        _resumen = resumen;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudieron cargar tus reacciones.\n$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  void _abrirColeccion(ResumenReaccion resumen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PeliculasPorReaccionScreen(
          facade: widget.facade,
          resumen: resumen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalGeneral = _resumen.fold<int>(
      0,
      (total, reaccion) => total + reaccion.total,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reacciones'),
      ),
      body: RefreshIndicator(
        onRefresh: _cargarResumen,
        child: _buildContenido(totalGeneral),
      ),
    );
  }

  Widget _buildContenido(int totalGeneral) {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            _error!,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        Text(
          'Resumen personal',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Aquí se agrupan tus películas según las reacciones que seleccionaste.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Total de reacciones registradas'),
            trailing: Text(
              '$totalGeneral',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._resumen.map(_buildTarjetaReaccion),
      ],
    );
  }

  Widget _buildTarjetaReaccion(ResumenReaccion resumen) {
    final color = ReaccionUiFactory.color(resumen.tipoReaccion);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: () => _abrirColeccion(resumen),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(
            ReaccionUiFactory.icono(resumen.tipoReaccion),
            color: color,
          ),
        ),
        title: Text(
          resumen.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text('Ver películas de esta colección'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${resumen.total}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

/// Pantalla de detalle de una colección de reacción.
///
/// Muestra las películas que pertenecen a una reacción específica.
class PeliculasPorReaccionScreen extends StatefulWidget {
  const PeliculasPorReaccionScreen({
    super.key,
    required this.facade,
    required this.resumen,
  });

  final MovieAppFacade facade;
  final ResumenReaccion resumen;

  @override
  State<PeliculasPorReaccionScreen> createState() =>
      _PeliculasPorReaccionScreenState();
}

class _PeliculasPorReaccionScreenState
    extends State<PeliculasPorReaccionScreen> {
  List<Pelicula> _peliculas = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarPeliculas();
  }

  Future<void> _cargarPeliculas() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final peliculas = await widget.facade.obtenerPeliculasPorReaccion(
        widget.resumen.tipoReaccion,
      );

      if (!mounted) return;

      setState(() {
        _peliculas = peliculas;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudieron cargar las películas.\n$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = ReaccionUiFactory.color(widget.resumen.tipoReaccion);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resumen.nombre),
      ),
      body: RefreshIndicator(
        onRefresh: _cargarPeliculas,
        child: _buildContenido(color, widget.resumen.tipoReaccion),
      ),
    );
  }

  Widget _buildContenido(Color color, TipoReaccion tipoReaccion) {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            _error!,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (_peliculas.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            ReaccionUiFactory.icono(tipoReaccion),
            size: 56,
            color: color,
          ),
          const SizedBox(height: 14),
          Text(
            'Aún no tienes películas en esta reacción.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: _peliculas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final pelicula = _peliculas[index];
        return _buildPeliculaCard(pelicula, color, tipoReaccion);
      },
    );
  }

  Widget _buildPeliculaCard(
    Pelicula pelicula,
    Color color,
    TipoReaccion tipoReaccion,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: pelicula.portada.isNotEmpty
                  ? Image.network(
                      pelicula.portada,
                      width: 78,
                      height: 105,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagenFallback(),
                    )
                  : _imagenFallback(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pelicula.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Género: ${pelicula.genero}'),
                  const SizedBox(height: 4),
                  Text('Calificación: ${pelicula.calificacion}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        ReaccionUiFactory.icono(tipoReaccion),
                        color: color,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tipoReaccion.nombre,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (pelicula.comentarioPersonal.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Comentario: ${pelicula.comentarioPersonal}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagenFallback() {
    return Container(
      width: 78,
      height: 105,
      color: const Color(0xFFE9E0FF),
      child: const Icon(Icons.movie, size: 34),
    );
  }
}