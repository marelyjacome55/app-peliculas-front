# Patrones creacionales y estructurales detectados

Este documento resume los patrones detectados tras revisar todos los archivos fuente en `lib/` y `test/`.

## Alcance revisado

Archivos analizados:
- `lib/main.dart`
- `lib/models/pelicula.dart`
- `lib/repositories/pelicula_repository.dart`
- `lib/services/auth_service.dart`
- `lib/services/pelicula_service.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/login_screen.dart`
- `lib/screens/register_screen.dart`
- `lib/widgets/pelicula_card.dart`
- `lib/widgets/pelicula_form_sheet.dart`
- `test/widget_test.dart`

## Patrones estructurales

### 1) Repository (detectado e implementado)

Descripcion:
- Existe una abstraccion para acceso a datos (`PeliculaRepository`) y una implementacion concreta remota (`RemotePeliculaRepository`) que encapsula la comunicacion con el servicio.

Evidencia:
- Interface/contrato: `abstract class PeliculaRepository`
- Implementacion: `class RemotePeliculaRepository implements PeliculaRepository`
- Delegacion interna a servicio: campo privado `_service` y metodos que llaman a `_service.*`

Ubicacion:
- `lib/repositories/pelicula_repository.dart`

Beneficio en este proyecto:
- La UI no depende directamente de HTTP ni de detalles de serializacion.
- Permite sustituir la fuente remota por otra (cache local, mock o test double) sin romper la capa de presentacion.

### 2) Facade (detectado como intencion de diseno, implementacion faltante en workspace)

Descripcion:
- Las pantallas de login y home dependen de `MovieAppFacade` para consumir operaciones de autenticacion y peliculas mediante una API de alto nivel.

Evidencia:
- Import y dependencia de tipo `MovieAppFacade` en pantallas.

Ubicacion de consumo:
- `lib/screens/login_screen.dart`
- `lib/screens/home_screen.dart`

Estado actual:
- El archivo de implementacion de la fachada no esta presente en el arbol actual (`lib/core/facades/movie_app_facade.dart` no existe en este estado del workspace).

Impacto:
- El patron esta planteado en la capa de consumo, pero no completado en infraestructura.

### 3) Adapter (detectado como intencion de diseno, implementacion faltante en workspace)

Descripcion:
- `PeliculaService` depende de `MultipartImageAdapter` para convertir `XFile` a `MultipartFile` en peticiones multipart.

Evidencia:
- Inyeccion y uso de `_imageAdapter.toMultipartFile(...)`.

Ubicacion de consumo:
- `lib/services/pelicula_service.dart`

Estado actual:
- El archivo `lib/core/adapters/multipart_image_adapter.dart` no existe en este estado del workspace.

Impacto:
- El patron Adapter esta definido en contratos de uso, pero falta su implementacion concreta en el proyecto actual.

## Patrones creacionales

### 1) Inyeccion de dependencias por constructor (detectado e implementado)

Descripcion:
- Servicios admiten dependencias opcionales por constructor y, si no se inyectan, crean implementaciones por defecto.

Evidencia:
- `AuthService({ApiClient? apiClient, SessionManager? sessionManager})`
- `PeliculaService({ApiClient? apiClient, MultipartImageAdapter? imageAdapter})`
- Inicializacion con fallback: `apiClient ?? ApiClient()` y equivalentes.

Ubicacion:
- `lib/services/auth_service.dart`
- `lib/services/pelicula_service.dart`

Beneficio en este proyecto:
- Facilita pruebas unitarias y reemplazo de dependencias.
- Reduce acoplamiento con implementaciones concretas.

### 2) Factory Constructor en modelo (detectado e implementado)

Descripcion:
- La entidad de dominio usa constructor factoría para crear instancias desde JSON.

Evidencia:
- `factory Pelicula.fromJson(Map<String, dynamic> json)`

Ubicacion:
- `lib/models/pelicula.dart`

Beneficio en este proyecto:
- Centraliza reglas de mapeo/normalizacion y evita duplicar parseo en servicios/pantallas.

## Patrones no detectados en el codigo actual

No se encontraron implementaciones claras de estos patrones en el estado actual del repositorio:
- Structural: Decorator, Composite, Bridge, Flyweight, Proxy dedicado, Facade completa operativa.
- Creational: Singleton, Builder, Abstract Factory, Prototype.

Nota:
- Hay trazas de intencion para Facade y Adapter, pero sin archivos fuente presentes en `lib/core/*`.

## Observaciones de coherencia arquitectonica

1. Las capas de presentacion y servicios ya fueron adaptadas para trabajar con patrones (Repository/Facade/Adapter).
2. En este snapshot faltan clases de infraestructura referenciadas por imports en `lib/core`.
3. Para cerrar la arquitectura propuesta, se debe restaurar o crear:
- `lib/core/facades/movie_app_facade.dart`
- `lib/core/adapters/multipart_image_adapter.dart`
- `lib/core/network/api_client.dart`
- `lib/core/security/session_manager.dart`

## Conclusiones

Patrones confirmados y funcionales:
- Repository
- Inyeccion por constructor
- Factory constructor (`fromJson`)

Patrones confirmados como diseno pendiente de completar en este workspace:
- Facade
- Adapter
