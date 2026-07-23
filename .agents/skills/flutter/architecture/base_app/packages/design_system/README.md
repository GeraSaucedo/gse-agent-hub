# GSE Design System

Paquete de Design System para Flutter con soporte light/dark, tipografia semantica
con extensiones encadenables, tokens de color, espaciado, radius y responsive adaptativo.

```dart
import 'package:gse_design_system/gse_design_system.dart';
```

---

## Indice

- [Setup inicial](#setup-inicial)
- [Reutilizar en otro proyecto](#reutilizar-en-otro-proyecto)
- [Controller](#controller-dscontroller)
- [Colores](#colores)
- [Tipografia](#tipografia)
- [Dimensiones responsive](#dimensiones-responsive)
- [Espaciado](#espaciado)
- [Border radius](#border-radius)
- [Estilos de componentes Material](#estilos-de-componentes-material)
- [Estructura del paquete](#estructura-del-paquete)
- [Referencia rapida](#referencia-rapida)

---

## Setup inicial

### 1. Dependencia

```yaml
# pubspec.yaml
dependencies:
  gse_design_system:
    path: packages/design_system
```

### 2. Envolver la app con `DSProvider`

Colocar **arriba** de `MaterialApp`. Usar `Builder` para leer el tema:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await DSController.preload();
  runApp(MainApp(dsController: controller));
}

// main_app.dart
return DSProvider(
  controller: widget.dsController,
  child: Builder(
    builder: (context) {
      final ds = DSProvider.of(context);
      return MaterialApp.router(
        theme:     ds.lightTheme,
        darkTheme: ds.darkTheme,
        themeMode: ds.themeMode,
        // ...
      );
    },
  ),
);
```

`DSController.preload()` carga la preferencia guardada **antes** de pintar,
evitando el flash de tema al abrir la app.

---

## Reutilizar en otro proyecto

Para adaptar el paquete a un proyecto diferente solo se modifican **3 archivos**:

### 1. Fuente — `src/config/ds_config.dart`

```dart
abstract class DSConfig {
  static const String fontPrimary = 'tu-fuente'; // ← cambiar aqui
}
```

> Asegurar que la fuente esta registrada en `pubspec.yaml → flutter.fonts`.

### 2. Colores — `src/colors/light_colors.dart` y `dark_colors.dart`

Cambiar los valores hex de los 24 tokens para la nueva paleta:

```dart
// light_colors.dart
static const AppColorScheme colors = AppColorScheme(
  primary: Color(0xFFTU_COLOR),
  // ...los demas tokens
);
```

### 3. Theme base (opcional) — `src/styles/app_theme.dart`

Ajustar el `ThemeData` si se necesitan cambios en forma de botones, elevacion, etc.

Todo lo demas (tipografia, spacing, radius, responsive) funciona sin cambios.

---

## Controller (`DSController`)

Maneja el modo de tema activo, lo persiste en `SharedPreferences` y notifica a listeners.

Acceso via extension: `context.ds`

### Propiedades

| Propiedad    | Tipo        | Descripcion                             |
|--------------|-------------|-----------------------------------------|
| `themeMode`  | `ThemeMode` | Modo activo (`light`, `dark`, `system`) |
| `isDark`     | `bool`      | `true` si el modo es `dark`             |
| `lightTheme` | `ThemeData` | Tema light (cacheado)                   |
| `darkTheme`  | `ThemeData` | Tema dark (cacheado)                    |

### Metodos

| Metodo                         | Descripcion                                       |
|--------------------------------|---------------------------------------------------|
| `setThemeMode(ThemeMode mode)` | Cambia el modo y lo persiste en SharedPreferences  |
| `toggleTheme()`               | Alterna entre `light` y `dark`                     |

### Ejemplo

```dart
// Toggle con switch
Switch(
  value: context.ds.isDark,
  onChanged: (_) => context.ds.toggleTheme(),
),

// Cambiar a modo sistema
context.ds.setThemeMode(ThemeMode.system);
```

Los cambios son reactivos: toda la app se actualiza sin reiniciar.

---

## Colores

Acceso: `context.colors`

**Regla: nunca usar `Color(0xFF...)` directamente en widgets.** Siempre usar tokens.

```dart
context.colors.primary
context.colors.surface
context.colors.textPrimary
context.colors.error
```

### Opacidad fluida

```dart
context.colors.primary.o10   // 10%
context.colors.primary.o20   // 20%
context.colors.primary.o50   // 50%
context.colors.primary.o80   // 80%
```

### Tokens Material-mapped

Estos se publican al `ColorScheme` nativo. Los widgets de Material 3 (`FilledButton`,
`TextField`, `NavigationBar`, etc.) los consumen **automaticamente**.

| Token                | Mapeado a                         | Uso                                        |
|----------------------|-----------------------------------|--------------------------------------------|
| `scaffoldBackground` | `ColorScheme.surface`             | Fondo base (Scaffold, AppBar)              |
| `surface`            | `ColorScheme.surfaceContainerLow` | Cards, bottom sheets, modales              |
| `onSurfaceLow`       | `ColorScheme.outlineVariant`      | Bordes sutiles, dividers, placeholder text |
| `onSurface`          | `ColorScheme.outline`             | Bordes estandar, iconos inactivos          |
| `textPrimary`        | `ColorScheme.onSurface`           | Titulos y texto principal                  |
| `textSecondary`      | `ColorScheme.onSurfaceVariant`    | Subtitulos, labels, texto de soporte       |
| `primary`            | `ColorScheme.primary`             | CTAs, FABs, estados activos                |
| `onPrimary`          | `ColorScheme.onPrimary`           | Texto/iconos sobre `primary`               |
| `secondary`          | `ColorScheme.secondary`           | Acciones secundarias, chips                |
| `onSecondary`        | `ColorScheme.onSecondary`         | Texto/iconos sobre `secondary`             |
| `accent`             | `ColorScheme.tertiary`            | CTAs especiales o uso promocional          |
| `onAccent`           | `ColorScheme.onTertiary`          | Texto/iconos sobre `accent`                |
| `error`              | `ColorScheme.error`               | Errores y validaciones criticas            |
| `onError`            | `ColorScheme.onError`             | Texto/iconos sobre `error`                 |

### Tokens Custom

Sin equivalente en `ColorScheme`. Usar **explicitamente** via `context.colors`.

| Token           | Uso                                          |
|-----------------|----------------------------------------------|
| `onSurfaceHigh` | Bordes de foco, hover, iconos activos        |
| `textDisabled`  | Texto para elementos deshabilitados          |
| `disabled`      | Fondo para componentes deshabilitados        |
| `onDisabled`    | Texto/iconos sobre fondo `disabled`          |
| `success`       | Confirmaciones y estados positivos           |
| `onSuccess`     | Texto/iconos sobre `success`                 |
| `warning`       | Advertencias y precauciones                  |
| `onWarning`     | Texto/iconos sobre `warning`                 |
| `info`          | Informacion neutral y anuncios               |
| `onInfo`        | Texto/iconos sobre `info`                    |

### Agregar un nuevo token de color

1. Declarar el campo en `AppColorScheme` (constructor, propiedad, `copyWith`, `lerp`)
2. Agregar el valor en `light_colors.dart` y `dark_colors.dart`
3. Si tiene equivalente Material 3, agregarlo en `toColorScheme()`
4. Usar con `context.colors.miToken`

---

## Tipografia

Acceso: `context.textStyles`

### Regla 90/10

El 90% de los usos necesitan solo el **token base**.
Las extensiones son para el 10% que necesita ajuste fino.

```dart
// 90% — token base
Text('Titulo', style: context.textStyles.titleMed)

// 10% — con extension
Text('Destacado', style: context.textStyles.titleMed.bold.italic)
```

### Tokens

Cada token incluye **tamano + peso canonico + line-height**.
Todos escalan automaticamente con `sp()` segun el ancho de pantalla.

| Token          | Tamano | Peso | Height | Uso                            |
|----------------|--------|------|--------|--------------------------------|
| `headLarge`    | 28sp   | w700 | 1.2    | Titulos principales            |
| `headMed`      | 24sp   | w700 | 1.2    | Titulos de seccion destacados  |
| `headSmall`    | 20sp   | w600 | 1.3    | Subtitulos de seccion          |
| `titleLarge`   | 18sp   | w600 | 1.3    | Titulos de card/dialogo        |
| `titleMed`     | 16sp   | w600 | 1.3    | Titulos de lista, AppBar       |
| `titleSmall`   | 14sp   | w600 | 1.4    | Titulos de subseccion          |
| `bodyLarge`    | 16sp   | w400 | 1.6    | Parrafos largos, descripciones |
| `bodyMed`      | 14sp   | w400 | 1.5    | Texto general de interfaz      |
| `bodySmall`    | 12sp   | w400 | 1.5    | Texto secundario, notas        |
| `labelLarge`   | 14sp   | w500 | 1.4    | Labels de formulario, botones  |
| `labelMed`     | 12sp   | w500 | 1.4    | Labels de chips, tabs          |
| `labelSmall`   | 11sp   | w500 | 1.3    | Labels auxiliares, badges      |
| `captionMed`   | 12sp   | w400 | 1.4    | Timestamps, metadata           |
| `captionSmall` | 10sp   | w400 | 1.3    | Textos legales, micro-notas    |

### Extensiones encadenables

Cada extension modifica **una sola propiedad**. Se encadenan libremente:

```dart
context.textStyles.bodyMed.bold.italic.c(context.colors.error)
```

#### Pesos semanticos

| Extension   | Peso |
|-------------|------|
| `.thin`     | w100 |
| `.light`    | w300 |
| `.regular`  | w400 |
| `.medium`   | w500 |
| `.semibold` | w600 |
| `.bold`     | w700 |
| `.heavy`    | w800 |
| `.black`    | w900 |

#### Pesos numericos

```dart
.w100  .w200  .w300  .w400  .w500  .w600  .w700  .w800  .w900
```

#### Estilos

| Extension        | Efecto                       |
|------------------|------------------------------|
| `.italic`        | `FontStyle.italic`           |
| `.underline`     | `TextDecoration.underline`   |
| `.strikethrough` | `TextDecoration.lineThrough` |

#### Color

```dart
.c(Color)   // Aplica color al texto
```

#### String extension

```dart
Text('estado activo'.upper)  // Renderiza: "ESTADO ACTIVO"
```

### Ejemplos combinados

```dart
// Titulo de pantalla
Text('Mi Pantalla', style: context.textStyles.headLarge)

// Subtitulo con color secundario
Text('Descripcion', style: context.textStyles.bodyMed.c(context.colors.textSecondary))

// Boton
Text('Guardar', style: context.textStyles.titleMed.semibold)

// Label en mayusculas
Text('estado'.upper, style: context.textStyles.labelMed.bold)

// Error italico
Text('Campo requerido', style: context.textStyles.bodySmall.italic.c(context.colors.error))
```

---

## Dimensiones responsive

Basado en un ancho de diseno de **375px** (Figma).

### `sp(size)` — Font scaling

Escala proporcional al ancho de pantalla **con clamp**:
- Minimo: 85% del valor base
- Maximo mobile: 115% del valor base
- Maximo tablet: 125% del valor base

```dart
context.sp(16)   // ~16px en 375w, escala proporcionalmente
```

> Los tokens de tipografia ya usan `sp()` internamente. No llamar `sp()` manualmente
> para texto — usar directamente `context.textStyles.bodyMed`.

### `w(perc)` y `h(perc)` — Porcentajes de pantalla

Porcentaje directo **sin clamp**.

```dart
context.w(50)    // 50% del ancho de pantalla
context.h(20)    // 20% del alto de pantalla
```

### `adaptive(size)` — Escalado tablet

Valor fijo en mobile, **x1.25** en tablet. Sin escalado progresivo.

```dart
context.adaptive(24)   // 24px en mobile, 30px en tablet
```

> Los tokens de spacing y radius usan `adaptive()` internamente.

### Device flags

```dart
context.isMobile     // shortestSide < 600
context.isTablet     // shortestSide >= 600 y < 1200
context.isDesktop    // shortestSide >= 1200 y < 1800
context.isTv         // shortestSide >= 1800
context.isPortrait
context.isLandscape
```

### Safe area

```dart
context.viewPadding   // notch, barra de navegacion
context.viewInsets    // teclado
```

---

## Espaciado

Acceso: `context.spacing`

Tokens adaptativos — escalan **x1.25** en tablet automaticamente.

| Token | Mobile | Tablet |
|-------|-------:|-------:|
| `xs`  |   4 px |   5 px |
| `sm`  |   8 px |  10 px |
| `md`  |  16 px |  20 px |
| `lg`  |  24 px |  30 px |
| `xl`  |  32 px |  40 px |
| `xxl` |  48 px |  60 px |

```dart
Padding(padding: EdgeInsets.all(context.spacing.md))
SizedBox(height: context.spacing.lg)
Column(spacing: context.spacing.sm, children: [...])
```

---

## Border radius

Acceso: `context.radius`

Tokens adaptativos — escalan **x1.25** en tablet.

| Token      | Mobile  | Tablet  |
|------------|--------:|--------:|
| `sm`       |    4 px |    5 px |
| `md`       |    8 px |   10 px |
| `lg`       |   12 px |   15 px |
| `xl`       |   16 px |   20 px |
| `circular` |  999 px |  999 px |

```dart
BorderRadius.circular(context.radius.lg)
BorderRadius.circular(context.radius.circular)  // pill / capsula
```

---

## Estilos de componentes Material

El paquete configura estilos base para widgets de Material 3 en `app_theme_styles.dart`.
Estos se aplican automaticamente al usar el tema:

| Componente      | Configuracion                                                |
|-----------------|--------------------------------------------------------------|
| `AppBar`        | Sin elevacion, fondo `scaffoldBackground`                    |
| `Card`          | Sin elevacion, borde `onSurfaceLow`, radius 16               |
| `FilledButton`  | Fondo `primary`, altura minima 52, radius 12                 |
| `OutlinedButton` | Borde `onSurface`, altura minima 52, radius 12              |
| `TextField`     | `filled`, borde `onSurface`, foco `primary`, radius 12       |
| `NavigationBar` | Fondo `scaffoldBackground`, indicador `primary` al 12%       |
| `Divider`       | Color `onSurfaceLow`, grosor 1px                             |
| `SnackBar`      | Floating, fondo `surface`, radius 8                          |

Para personalizar, modificar `src/styles/app_theme_styles.dart`.

---

## Estructura del paquete

```
packages/design_system/
├── pubspec.yaml
├── README.md
└── lib/
    ├── gse_design_system.dart              ← Barrel (un solo import)
    └── src/
        ├── colors/
        │   ├── app_color_scheme.dart       ← ThemeExtension con 24 tokens
        │   ├── light_colors.dart           ← Paleta light
        │   ├── dark_colors.dart            ← Paleta dark
        │   └── extensions/
        │       └── opacity_extension.dart  ← .o10 .o20 .o50 .o80
        ├── config/
        │   └── ds_config.dart              ← fontPrimary
        ├── controller/
        │   ├── ds_controller.dart          ← DSController (ValueNotifier)
        │   └── ds_provider.dart            ← InheritedNotifier + context.ds
        ├── sizes/
        │   ├── app_dimensions.dart         ← sp, w, h, adaptive, device flags
        │   ├── app_spacing.dart            ← context.spacing.*
        │   └── app_radius.dart             ← context.radius.*
        ├── styles/
        │   ├── app_theme.dart              ← AppTheme.light / .dark / .build()
        │   └── app_theme_styles.dart       ← Estilos de componentes Material
        └── texts/
            ├── app_texts_styles.dart       ← context.textStyles.*
            └── weight_extension.dart       ← .bold .italic .c(color) .upper
```

---

## Referencia rapida

```dart
// ── Controller ──
context.ds.toggleTheme();
context.ds.setThemeMode(ThemeMode.system);
context.ds.isDark;

// ── Colores (Material-mapped — automatico en widgets nativos) ──
context.colors.primary
context.colors.surface
context.colors.error
context.colors.primary.o50          // con opacidad

// ── Colores (Custom — usar explicitamente) ──
context.colors.textDisabled
context.colors.success
context.colors.warning
context.colors.info
context.colors.disabled

// ── Tipografia ──
context.textStyles.bodyMed                                    // base
context.textStyles.titleMed.semibold                          // + peso
context.textStyles.bodySmall.italic.c(context.colors.error)   // + estilo + color
'texto'.upper                                                 // TEXTO

// ── Espaciado y radius ──
context.spacing.md        // 16px (20px en tablet)
context.radius.lg         // 12px (15px en tablet)

// ── Dimensiones ──
context.sp(16)            // font scaling con clamp
context.w(100)            // % ancho
context.h(50)             // % alto
context.adaptive(24)      // x1.25 en tablet

// ── Device ──
context.isMobile
context.isTablet
context.isLandscape
```
