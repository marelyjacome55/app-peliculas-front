import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/pelicula.dart';
import '../repositories/pelicula_repository.dart';

class PeliculaFormSheet extends StatefulWidget {
  final Pelicula? pelicula;
  final PeliculaRepository repository;

  const PeliculaFormSheet({
    super.key,
    this.pelicula,
    required this.repository,
  });

  @override
  State<PeliculaFormSheet> createState() => _PeliculaFormSheetState();
}

class _PeliculaFormSheetState extends State<PeliculaFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _generoController = TextEditingController();
  final _calificacionController = TextEditingController();

  bool _vista = false;
  bool _guardando = false;
  XFile? _imagenSeleccionada;

  bool get _esEdicion => widget.pelicula != null;

  @override
  void initState() {
    super.initState();
    if (_esEdicion) {
      _nombreController.text = widget.pelicula!.nombre;
      _generoController.text = widget.pelicula!.genero;
      _calificacionController.text = widget.pelicula!.calificacion.toString();
      _vista = widget.pelicula!.vista;
    }
  }

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = imagen;
      });
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_esEdicion && _imagenSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una imagen'),
        ),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      final nombre = _nombreController.text.trim();
      final genero = _generoController.text.trim();
      final calificacion = double.parse(_calificacionController.text.trim());

      if (_esEdicion) {
        await widget.repository.editarPelicula(
          id: widget.pelicula!.id!,
          nombre: nombre,
          genero: genero,
          calificacion: calificacion,
          vista: _vista,
          imagen: _imagenSeleccionada,
        );
      } else {
        await widget.repository.crearPelicula(
          nombre: nombre,
          genero: genero,
          calificacion: calificacion,
          vista: _vista,
          imagen: _imagenSeleccionada!,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 55,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _esEdicion ? 'Editar película' : 'Nueva película',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.movie_creation_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _generoController,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el género';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _calificacionController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Calificación',
                  prefixIcon: Icon(Icons.star_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la calificación';
                  }
                  final numero = double.tryParse(value.trim());
                  if (numero == null) {
                    return 'Ingresa un número válido';
                  }
                  if (numero < 0 || numero > 10) {
                    return 'Debe estar entre 0 y 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                value: _vista,
                onChanged: (value) {
                  setState(() {
                    _vista = value;
                  });
                },
                title: const Text('¿Ya la viste?'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _seleccionarImagen,
                icon: const Icon(Icons.image_outlined),
                label: Text(
                  _imagenSeleccionada == null
                      ? (_esEdicion ? 'Cambiar imagen (opcional)' : 'Seleccionar imagen')
                      : _imagenSeleccionada!.name,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(_esEdicion ? Icons.save_outlined : Icons.add),
                  label: Text(_guardando
                      ? 'Guardando...'
                      : (_esEdicion ? 'Guardar cambios' : 'Crear película')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}