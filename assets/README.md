# Guía de Recursos Gráficos (Assets)

Este directorio contiene todos los elementos visuales de la aplicación. Para cambiar el aspecto de la app, simplemente reemplaza los archivos indicados manteniendo el mismo nombre.

## Organización de Carpetas

| Carpeta | Uso |
| :--- | :--- |
| `images/logo/` | Logotipos de la app (Splash y General). |
| `images/icons/` | Iconos personalizados (no estándar de Flutter). |
| `images/backgrounds/` | Fondos de pantalla y decoraciones. |
| `images/illustrations/` | Dibujos o ilustraciones para lecciones y mensajes. |
| `images/general/` | Imágenes que no encajan en las otras categorías. |
| `fonts/` | Fuentes personalizadas (.ttf, .otf). |

## Recursos Clave para Reemplazar

| Recurso | Ubicación | Uso |
| :--- | :--- | :--- |
| **Logo Splash** | `assets/images/logo/logo_splash.png` | Se muestra al abrir la app. |
| **Logo Principal** | `assets/images/logo/logo.png` | Se usa en cabeceras o menús. |

## Instrucciones para agregar nuevas imágenes
1. Coloca el archivo en la carpeta correspondiente.
2. Si creas una subcarpeta nueva, regístrala en el archivo `pubspec.yaml`.
3. Agrega la ruta en `lib/core/app_assets.dart` para usarla en el código de forma limpia.
