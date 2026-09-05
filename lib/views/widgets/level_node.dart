import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/level_model.dart';

class LevelNode extends StatelessWidget {
  final Level level;
  final VoidCallback? onTap;

  const LevelNode({
    super.key,
    required this.level,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = level.status == LevelStatus.locked;
    final isCurrent = level.status == LevelStatus.current;
    final isCompleted = level.status == LevelStatus.completed;

    // Colores basados en el Design System
    final Color backgroundColor = isCompleted
        ? const Color(0xFF2ECC71) // Verde Menta
        : isCurrent
            ? const Color(0xFFF39C12) // Naranja Cálido
            : Colors.grey.shade300; // Gris para bloqueado

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador de estrellas (solo si está completado o es actual)
          if (isCompleted || isCurrent)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Icon(
                  Icons.star_rounded,
                  size: 24,
                  color: index < level.stars ? Colors.amber : Colors.grey.shade300,
                );
              }),
            )
          else
            const SizedBox(height: 24), // Espaciador para mantener alineación

          const SizedBox(height: 8),

          // Nodo circular
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                if (!isLocked)
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
              border: isCurrent ? Border.all(color: Colors.white, width: 4) : null,
            ),
            child: Center(
              child: isLocked
                  ? const Icon(Icons.lock_rounded, color: Colors.white, size: 32)
                  : Text(
                      '${level.id}',
                      style: GoogleFonts.baloo2(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Etiqueta opcional (ej. "¡Siguiente!")
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2), // Azul
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '¡A jugar!',
                style: GoogleFonts.baloo2(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            )
          else
             const SizedBox(height: 26),
        ],
      ),
    );
  }
}
