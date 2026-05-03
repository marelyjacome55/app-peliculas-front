import 'package:flutter/material.dart';

import '../../models/reaccion_pelicula.dart';

/// PATRÓN: Factory Method
/// Centraliza iconos y colores por reacción. Evita duplicación visual.
class ReaccionUiFactory {
  static IconData icono(TipoReaccion tipo) {
    switch (tipo) {
      case TipoReaccion.meGusta:
        return Icons.thumb_up_alt_outlined;
      case TipoReaccion.noMeGusta:
        return Icons.thumb_down_alt_outlined;
      case TipoReaccion.meEncanta:
        return Icons.favorite_border;
      case TipoReaccion.meAburrio:
        return Icons.sentiment_dissatisfied_outlined;
      case TipoReaccion.meHizoReir:
        return Icons.sentiment_very_satisfied_outlined;
      case TipoReaccion.meSorprendio:
        return Icons.bolt_outlined;
    }
  }

  static Color color(TipoReaccion tipo) {
    switch (tipo) {
      case TipoReaccion.meGusta:
        return Colors.blue;
      case TipoReaccion.noMeGusta:
        return Colors.red;
      case TipoReaccion.meEncanta:
        return Colors.pink;
      case TipoReaccion.meAburrio:
        return Colors.brown;
      case TipoReaccion.meHizoReir:
        return Colors.orange;
      case TipoReaccion.meSorprendio:
        return Colors.purple;
    }
  }
}