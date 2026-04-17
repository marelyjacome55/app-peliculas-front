import 'package:flutter/material.dart';

import '../models/pelicula.dart';
import '../repositories/pelicula_repository.dart';
import '../widgets/pelicula_card.dart';
import '../widgets/pelicula_form_sheet.dart';

enum FiltroVista { todas, vistas, pendientes }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PeliculaRepository _repository = PeliculaRepository();
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

  Future<void> _cargarPeliculas() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      List<Pelicula> peliculas;
      final textoBusqueda = _buscarController.text.trim();

      if (textoBusqueda.isNotEmpty) {
        peliculas = await _repository.buscarPorNombre(textoBusqueda);
      } else {
        switch (_filtro) {
          case FiltroVista.todas:
            peliculas = await _repository.obtenerPeliculas();
            break;
          case FiltroVista.vistas:
            peliculas = await _repository.filtrarPorVista(true);
            break;
          case FiltroVista.pendientes:
            peliculas = await _repository.filtrarPorVista(false);
            break;
        }
      }

      setState(() {
        _peliculas = peliculas;
      });
    } catch (e) {
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

  Future<void> _abrirFormulario([Pelicula? pelicula]) async {
    final bool? actualizado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PeliculaFormSheet(
        pelicula: pelicula,
        repository: _repository,
      ),
    );

    if (actualizado == true) {
      await _cargarPeliculas();
    }
  }

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
      await _repository.eliminarPelicula(pelicula.id!);
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

  Future<void> _cambiarVista(Pelicula pelicula) async {
    try {
      await _repository.cambiarEstadoVista(pelicula.id!, !pelicula.vista);
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