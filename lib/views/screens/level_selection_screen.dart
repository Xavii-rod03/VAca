import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/level_controller.dart';
import '../widgets/level_node.dart';
import '../../models/level_model.dart';
import 'activities/modulo_1_trazos/tracing_screen.dart';
import 'activities/modulo_2_silabas/syllables_screen.dart';
import 'activities/modulo_3_palabras/words_screen.dart';
import 'activities/modulo_4_textos/short_texts_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  final int moduleId;
  final String moduleTitle;
  final LevelController controller;

  const LevelSelectionScreen({
    super.key,
    required this.moduleId,
    required this.moduleTitle,
    required this.controller,
  });

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadLevels(widget.moduleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB), // Crema Suave del Design System
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF2C3E50), size: 32),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.moduleTitle,
          style: GoogleFonts.baloo2(
            color: const Color(0xFF4A90E2), // Azul Sereno
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, child) {
          if (widget.controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
              ),
            );
          }

          final levels = widget.controller.levels;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 40),
            // Invertimos la lista para que el nivel 1 esté abajo (metáfora de escalar)
            reverse: true,
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final level = levels[index];
              
              // Calculamos el desplazamiento en X para crear el efecto Zig-Zag
              // Usamos el índice para alternar izquierda (-1), centro (0), derecha (1)
              final zigzagIndex = index % 4;
              double alignX = 0;
              if (zigzagIndex == 1) alignX = 0.5;
              if (zigzagIndex == 2) alignX = 0.0;
              if (zigzagIndex == 3) alignX = -0.5;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Línea conectora (excepto para el último elemento visual / primer nivel real)
                    if (index > 0)
                      Positioned(
                        bottom: -30,
                        child: CustomPaint(
                          size: const Size(200, 100),
                          painter: _DashedLinePainter(),
                        ),
                      ),
                    
                    // Decoración (Animal o elemento visual) en el lado opuesto al nodo
                    Align(
                      alignment: Alignment(-alignX * 1.5, 0), // Lado opuesto
                      child: _buildMapDecoration(level.id),
                    ),

                    // Nodo del nivel posicionado en Zig-Zag
                    Align(
                      alignment: Alignment(alignX, 0),
                      child: LevelNode(
                        level: level,
                        onTap: () {
                          if (level.status == LevelStatus.current) {
                            Widget activityScreen;

                            // Selección dinámica de la actividad según el módulo
                            switch (widget.moduleId) {
                              case 1:
                                activityScreen = TracingScreen(
                                  level: level,
                                  controller: widget.controller,
                                );
                                break;
                              case 2:
                                activityScreen = SyllablesScreen(
                                  level: level,
                                  controller: widget.controller,
                                );
                                break;
                              case 3:
                                activityScreen = WordsScreen(
                                  level: level,
                                  controller: widget.controller,
                                );
                                break;
                              case 4:
                              default:
                                activityScreen = ShortTextsScreen(
                                  level: level,
                                  controller: widget.controller,
                                );
                                break;
                            }

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => activityScreen,
                              ),
                            );
                          } else {
                            // Si ya está completado, podríamos dar la opción de repetir
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Nivel completado. ¡Buen trabajo!', style: GoogleFonts.baloo2()),
                                backgroundColor: const Color(0xFF2ECC71),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Widget para insertar ilustraciones en el mapa
  Widget _buildMapDecoration(int levelId) {
    // Aquí puedes decidir en qué niveles poner decoraciones para no saturar.
    // Por ejemplo, pongamos una mascota en el nivel 1, 4, 7 y 10.
    if ([1, 4, 7, 10].contains(levelId)) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.transparent,
          // MODIFICAR AQUÍ: cuando tengas el SVG del animal, quita este BoxShape
          // y usa SvgPicture.asset(AppAssets.tuIlustracion)
        ),
        child: const Icon(
          Icons.pets, // Icono placeholder
          size: 50,
          color: Color(0xFFBDC3C7), // Gris claro para no distraer demasiado
        ),
      );
    }
    return const SizedBox.shrink(); // Espacio vacío para los demás niveles
  }
}

// CustomPainter para dibujar la línea de puntos (camino)
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const dashWidth = 10.0;
    const dashSpace = 10.0;
    double startY = 0;

    // Dibujamos una línea vertical punteada simple como placeholder
    // (En una versión más avanzada se puede curvar para seguir el zig-zag exacto)
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
