import 'package:flutter/material.dart';

import '../core/facades/movie_app_facade.dart';
import '../core/strategies/movie_filter_strategy.dart';
import '../models/pelicula.dart';
import '../widgets/pelicula_card.dart';
import '../widgets/pelicula_form_sheet.dart';
import 'mis_reacciones_screen.dart';

/// Filtro de estado usado por la pantalla principal.
enum FiltroVista { todas, vistas, pendientes }

/// PATRÓN: Strategy + Facade
/// Delega filtrado a estrategia; operaciones a Facade.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.facade});

  final MovieAppFacade facade;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _buscarController = TextEditingController();

  List<Pelicula> _peliculas = [];
  bool _cargando = true;
  String? _error;
  FiltroVista _filtro = FiltroVista.todas;

  @override
  void initState() {
    super.initState();
    _cargarPeliculas();
  }

  /// Carga peliculas aplicando el patrón Strategy.
  /// La pantalla no decide directamente cómo consultar; delega el criterio
  /// a una estrategia concreta.
  Future<void> _cargarPeliculas() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final textoBusqueda = _buscarController.text.trim();

      late final MovieFilterStrategy estrategia;

      if (textoBusqueda.isNotEmpty) {
        estrategia = SearchMoviesStrategy(textoBusqueda);
      } else {
        switch (_filtro) {
          case FiltroVista.todas:
            estrategia = AllMoviesStrategy();
            break;
          case FiltroVista.vistas:
            estrategia = WatchedMoviesStrategy();
            break;
          case FiltroVista.pendientes:
            estrategia = PendingMoviesStrategy();
            break;
        }
      }

      final peliculas = await estrategia.obtenerPeliculas(widget.facade);

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

  /// Abre el formulario para crear o editar y recarga si hubo cambios.
  Future<void> _abrirFormulario([Pelicula? pelicula]) async {
    final bool? actualizado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PeliculaFormSheet(
        pelicula: pelicula,
        facade: widget.facade,
      ),
    );

    if (actualizado == true) {
      await _cargarPeliculas();
    }
  }

  /// Solicita confirmacion y elimina la pelicula seleccionada.
  Future<void> _eliminarPelicula(Pelicula pelicula) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar película'),
        content: Text('¿Deseas eliminar "${pelicula.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await widget.facade.eliminarPelicula(pelicula.id!);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada')),
      );

      await _cargarPeliculas();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  /// Cambia entre estado vista/pendiente para una pelicula.
  Future<void> _cambiarVista(Pelicula pelicula) async {
    try {
      await widget.facade.cambiarEstadoVista(pelicula.id!, !pelicula.vista);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            pelicula.vista ? 'Marcada como pendiente' : 'Marcada como vista',
          ),
        ),
      );

      await _cargarPeliculas();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar estado: $e')),
      );
    }
  }

  void _abrirMisReacciones() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MisReaccionesScreen(
          facade: widget.facade,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _cargarPeliculas,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Películas por ver',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Versión web y APK con una interfaz bonita',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _buscarController,
                        onSubmitted: (_) => _cargarPeliculas(),
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _buscarController.clear();
                              _cargarPeliculas();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ChoiceChip(
                            label: const Text('Todas'),
                            selected: _filtro == FiltroVista.todas,
                            onSelected: (_) {
                              setState(() => _filtro = FiltroVista.todas);
                              _cargarPeliculas();
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Vistas'),
                            selected: _filtro == FiltroVista.vistas,
                            onSelected: (_) {
                              setState(() => _filtro = FiltroVista.vistas);
                              _cargarPeliculas();
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Pendientes'),
                            selected: _filtro == FiltroVista.pendientes,
                            onSelected: (_) {
                              setState(() => _filtro = FiltroVista.pendientes);
                              _cargarPeliculas();
                            },
                          ),
                          OutlinedButton.icon(
                            onPressed: _cargarPeliculas,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Actualizar'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _abrirMisReacciones,
                            icon: const Icon(
                              Icons.collections_bookmark_outlined,
                            ),
                            label: const Text('Mis reacciones'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_cargando)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else if (_peliculas.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text('No hay películas registradas'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList.separated(
                    itemCount: _peliculas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, index) {
                      final pelicula = _peliculas[index];

                      return PeliculaCard(
                        pelicula: pelicula,
                        facade: widget.facade,
                        onEditar: () => _abrirFormulario(pelicula),
                        onEliminar: () => _eliminarPelicula(pelicula),
                        onCambiarVista: () => _cambiarVista(pelicula),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}