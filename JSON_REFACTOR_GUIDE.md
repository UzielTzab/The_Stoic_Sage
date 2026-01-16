# Refactorización a JSON - Guía de Uso

## Cambios Realizados

Se ha refactorizado completamente el sistema de contenido del app, moviendo los textos de un archivo Dart hardcodeado a un archivo JSON profesional.

### Estructura Anterior
- **Archivo**: `lib/data/stoic_content_data.dart`
- **Tipo**: Constante con array de `StoicContent` en Dart puro
- **Problema**: Difícil de mantener, escalabilidad limitada

### Estructura Nueva
- **Archivo**: `assets/data/stoic_content.json`
- **Tipo**: JSON estructurado
- **Ventajas**:
  - ✅ Fácil de editar sin tocar código Dart
  - ✅ Escalable para miles de lecciones
  - ✅ Carga dinámica en tiempo de ejecución
  - ✅ Patrón profesional usado en apps grandes
  - ✅ Separación clara entre datos y lógica

## Archivos Modificados

### 1. `lib/data/stoic_content_data.dart`
- Ahora contiene solo la clase `StoicContentLoader`
- Función: `loadStoicContent()` - Carga desde JSON asincronamente
- Manejo de errores incluido

```dart
final lessons = await StoicContentLoader.loadStoicContent();
```

### 2. `lib/providers/stoic_content_provider.dart` (NUEVO)
- Provider que gestiona los contenidos
- Carga automáticamente al inicializarse
- Métodos útiles:
  - `lessons` - Obtiene todas las lecciones
  - `searchLessons(query)` - Busca por título
  - `getLessonsByCategory(category)` - Filtra por categoría
  - `getCategories()` - Obtiene todas las categorías

```dart
// En tu widget:
final contentProvider = context.watch<StoicContentProvider>();
final allLessons = contentProvider.lessons;
final searched = contentProvider.searchLessons("filosofía");
```

### 3. `lib/screens/home_screen.dart`
- Actualizado para usar el nuevo provider
- Reemplazó referencias a `stoicContentData` con `contentProvider`
- Código más limpio y mantenible

### 4. `lib/main.dart`
- Registrado el nuevo `StoicContentProvider` en MultiProvider
- Carga automáticamente al iniciar la app

### 5. `pubspec.yaml`
- Agregado asset: `assets/data/stoic_content.json`

### 6. `assets/data/stoic_content.json` (NUEVO)
- Contiene todas las 10 lecciones
- Estructura limpia y fácil de editar
- Compatible con markdown en el campo `content`

## Estructura del JSON

```json
{
  "lessons": [
    {
      "id": "origen-estoicismo",
      "title": "El origen del estoicismo",
      "description": "Controla tus reacciones.",
      "category": "Los inicios",
      "status": "completed",
      "content": "El contenido aquí...\n\n## Títulos\n\n- Listas\n- Soportadas"
    }
  ]
}
```

### Campos
- **id**: Identificador único (string)
- **title**: Título de la lección (string)
- **description**: Descripción corta (string)
- **category**: Categoría (string)
- **status**: Estado - `"completed"` o `"unread"` (string)
- **content**: Contenido en markdown (string)

## Ventajas de esta Estructura

### Para Desarrolladores
- Cargar/editar lecciones sin compilar
- Posibilidad de cargar desde API futura
- Testing más fácil
- Mejor separación de responsabilidades

### Para la App
- Carga asincrónica no bloquea UI
- Caché automático en memoria
- Búsqueda/filtrado eficiente
- Escalable a cientos de lecciones

## Cómo Agregar Nuevas Lecciones

1. Abre `assets/data/stoic_content.json`
2. Agrega un nuevo objeto en el array `lessons`:

```json
{
  "id": "mi-leccion",
  "title": "Mi Nueva Lección",
  "description": "Descripción breve",
  "category": "Mi Categoría",
  "status": "unread",
  "content": "# Título\n\nContenido aquí..."
}
```

3. ¡Listo! La app detectará automáticamente la nueva lección

## Cómo Editar una Lección Existente

1. Abre `assets/data/stoic_content.json`
2. Busca el id de la lección
3. Edita el campo que necesites
4. Guarda
5. Hot reload (Ctrl+S en Flutter)

## Flujo de Datos

```
App inicia
    ↓
main.dart registra StoicContentProvider
    ↓
StoicContentProvider.init()
    ↓
StoicContentLoader.loadStoicContent()
    ↓
Lee assets/data/stoic_content.json
    ↓
Parsea JSON → List<StoicContent>
    ↓
Almacena en memoria
    ↓
Los widgets usan context.watch<StoicContentProvider>()
```

## Performance

- ✅ Carga una sola vez al iniciar
- ✅ Búsqueda O(n) en memoria
- ✅ Sin llamadas a API (a menos que lo requieras después)
- ✅ Manejo de errores graceful

## Futuras Mejoras Posibles

1. **Cargar desde API**: Reemplazar `rootBundle.loadString()` con `http.get()`
2. **Caché Local**: Guardar en SQLite/Hive para offline
3. **Paginación**: Cargar lecciones bajo demanda
4. **Múltiples idiomas**: Mismo JSON con traducción dinámica
5. **Versionado**: Control de qué lecciones ha actualizado el usuario

---

**Creado**: 15 de enero de 2026
**Última actualización**: Refactorización completa a JSON
