# App Películas - Arquitectura

Breve: Proyecto Flutter con separación en capas (UI, services, repositories, core). Se usan patrones sencillos para organización, claridad y mantenibilidad en un contexto académico.

## Patrones usados

| Patrón | Archivo | Clase principal | Propósito | Por qué se usó |
|---|---|---|---|---|
| Factory Method | [lib/models/pelicula.dart](lib/models/pelicula.dart) | `Pelicula` | Centralizar la creación desde JSON (`fromJson`) | Evita repetir lógica de conversión en servicios/ UI |
| Factory Method (UI) | [lib/core/factories/reaccion_ui_factory.dart](lib/core/factories/reaccion_ui_factory.dart) | `ReaccionUiFactory` | Uniformizar iconos y colores por reacción | Mantener coherencia visual y evitar duplicación |
| Adapter | [lib/core/adapters/multipart_image_adapter.dart](lib/core/adapters/multipart_image_adapter.dart) | `MultipartImageAdapter` | Convertir `XFile` a `MultipartFile` para subida | Separar la transformación de datos del servicio HTTP |
| Facade (app) | [lib/core/facades/movie_app_facade.dart](lib/core/facades/movie_app_facade.dart) | `MovieAppFacade` | Entrada única para UI: auth, películas y reacciones | Desacopla la UI de servicios y repositorios |
| Facade (HTTP) | [lib/core/network/api_client.dart](lib/core/network/api_client.dart) | `ApiClient` | Cliente HTTP centralizado (URIs, headers, validación) | Evita duplicar lógica HTTP en servicios |
| Repository | [lib/repositories/pelicula_repository.dart](lib/repositories/pelicula_repository.dart) | `PeliculaRepository` / `RemotePeliculaRepository` | Abstracción de acceso a datos | Permite intercambiar la fuente de datos sin afectar UI |
| Strategy | [lib/core/strategies/movie_filter_strategy.dart](lib/core/strategies/movie_filter_strategy.dart) | `MovieFilterStrategy` + implementaciones | Encapsular criterios de filtrado | Evita condicionales complejos en la pantalla principal |
| Singleton | [lib/core/security/session_manager.dart](lib/core/security/session_manager.dart) | `SessionManager` | Mantener token JWT en memoria | Facilita acceso al token desde cualquier capa |
| DTO / Model | [lib/models/reaccion_pelicula.dart](lib/models/reaccion_pelicula.dart), [lib/models/resumen_reaccion.dart](lib/models/resumen_reaccion.dart) | `ReaccionPelicula`, `ResumenReaccion` | Representar datos de la API como objetos | Evita usar mapas JSON directamente en la UI |

> Nota: los enlaces apuntan a los archivos relevantes en el repo.

## Flujo de reacciones (breve)

1. La UI (por ejemplo `PeliculaCard`) solicita las reacciones a través de `MovieAppFacade`.
2. `MovieAppFacade` delega en `PeliculaRepository` que a su vez utiliza `PeliculaService` para realizar las llamadas HTTP.
3. `PeliculaService` usa `ApiClient` para construir y validar peticiones, y transforma JSON a objetos (`ReaccionPelicula`) mediante factories.
4. Para agregar/eliminar reacciones la UI invoca métodos del `Facade`, que actualizan el backend y retornan los DTOs actualizados.

## Por qué no se agregaron patrones adicionales

- El objetivo era mantener la lógica existente sin introducir dependencias ni cambiar la estructura.
- Patrones como Provider/GetIt, Cache o Decorator aportan beneficios pero requieren cambios en la construcción de dependencias o en la lógica de ejecución; por consiguiente se descartaron para mantener la compatibilidad y simplicidad del proyecto escolar.

## Conclusión

Se aplicaron patrones sólo donde aportan organización, separación de responsabilidades y facilidad de mantenimiento: `Factory`, `Adapter`, `Facade`, `Repository`, `Strategy` y `Singleton` en puntos concretos del código. Los comentarios en los archivos del código explican el rol de cada componente para facilitar el onboarding y las tareas académicas.

---

Modificaciones: Añadidos comentarios de patrón en las clases principales y este documento `ARCHITECTURE.md`.
