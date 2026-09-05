# Plan de Reparación del Entorno de Ejecución

El proyecto está experimentando fallos críticos de compilación debido al uso de versiones experimentales de Gradle (9.3.1) y el Plugin de Android (9.1.0), las cuales no son compatibles con el servicio de localización de Android en tu entorno actual. Además, el emulador presenta signos de bloqueo (ANR).

## Cambios Propuestos

### Infraestructura Android (Gradle)

Bajar las versiones a versiones estables y compatibles entre sí.

#### [MODIFY] [settings.gradle.kts](file:///C:/Users/javii/AndroidStudioProjects/PT/android/settings.gradle.kts)
- Cambiar el plugin de Android de `9.1.0` a `8.7.0`.
- Cambiar el plugin de Kotlin de `2.4.0` a `2.0.21`.

#### [MODIFY] [gradle-wrapper.properties](file:///C:/Users/javii/AndroidStudioProjects/PT/android/gradle/wrapper/gradle-wrapper.properties)
- Cambiar la distribución de Gradle de `9.3.1` a `8.10.2`.

## Plan de Verificación

### Pruebas Automatizadas
1. Ejecutar `flutter clean` para eliminar archivos temporales corruptos.
2. Ejecutar `flutter pub get` para refrescar dependencias.
3. Ejecutar `flutter build apk --debug` para confirmar que la compilación de Gradle ahora es exitosa.

### Verificación Manual
1. Iniciar el emulador mediante un "Cold Boot" (Reinicio en frío) desde el Device Manager de Android Studio para solucionar el error de "System UI not responding".
2. Ejecutar la aplicación desde el IDE.
