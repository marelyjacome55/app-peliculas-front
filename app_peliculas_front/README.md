# app_peliculas_front

Frontend Flutter para gestionar peliculas por ver, con autenticacion, listado, busqueda, filtros y operaciones CRUD.

## Documentacion de arquitectura por patrones

La documentacion enfocada en deteccion de patrones creacionales y estructurales del codigo actual esta en:

- `docs/patrones_creacionales_estructurales.md`

## Documentacion de patrones aplicados

Esta seccion resume las modificaciones de arquitectura solicitadas con patrones creacionales y estructurales.

## Patrones creacionales

### 1. Inyeccion por constructor (Factory Method simple)
- Se aplica creando dependencias por defecto dentro de constructores, pero permitiendo inyectarlas desde fuera para pruebas o configuraciones especiales.
- Se observa en `AuthService` y `PeliculaService` mediante parametros opcionales en constructor.
- Beneficio: bajo acoplamiento, facil testeo y reemplazo de implementaciones.

Implementaciones relacionadas:
- `AuthService({ApiClient? apiClient, SessionManager? sessionManager})`
- `PeliculaService({ApiClient? apiClient, MultipartImageAdapter? imageAdapter})`

## Patrones estructurales

### 1. Repository
- Se define una abstraccion `PeliculaRepository` para exponer operaciones de negocio sin acoplar la UI al detalle HTTP.
- `RemotePeliculaRepository` actua como implementacion concreta delegando en `PeliculaService`.
- Beneficio: separa capa de presentacion de capa de acceso a datos y facilita cambios futuros (por ejemplo, cache local).

Archivo clave:
- `lib/repositories/pelicula_repository.dart`

### 2. Adapter
- `MultipartImageAdapter` se usa (por diseno) para transformar `XFile` a `MultipartFile` en peticiones multipart.
- Beneficio: encapsula conversiones entre tipos incompatibles y evita duplicar logica en servicios.

Uso esperado en:
- `lib/services/pelicula_service.dart`

### 3. Facade
- `MovieAppFacade` se usa (por diseno) como punto unico para exponer operaciones de autenticacion y peliculas hacia las pantallas.
- Home y Login consumen la fachada para simplificar dependencias directas a multiples servicios/repositorios.
- Beneficio: API de alto nivel para UI y reduccion de complejidad en pantallas.

Usos esperados en:
- `lib/screens/home_screen.dart`
- `lib/screens/login_screen.dart`

## Estado actual del workspace

Al momento de esta documentacion, hay imports a componentes de `lib/core` (adapter, facade, cliente de red y sesion), pero esos archivos no estan presentes fisicamente en este estado del repositorio.

Esto implica que:
- El diseno por patrones esta reflejado en la capa de consumo (servicios/pantallas).
- Falta completar o restaurar los archivos de implementacion en `lib/core/*` para compilar correctamente.

## Beneficios esperados de estas modificaciones
- Mejor separacion de responsabilidades por capas.
- Menor acoplamiento entre UI y capa de infraestructura.
- Mayor mantenibilidad y escalabilidad para agregar nuevas fuentes de datos o reglas.
- Mejor testabilidad por uso de interfaces e inyeccion de dependencias.

## Proximo paso recomendado
- Restaurar o crear las implementaciones faltantes en `lib/core/adapters`, `lib/core/facades`, `lib/core/network` y `lib/core/security` para alinear la documentacion con el estado compilable del proyecto.
