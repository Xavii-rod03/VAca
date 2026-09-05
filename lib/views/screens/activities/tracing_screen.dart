import 'package:flutter/material.dart';
import 'activity_layout.dart';
import '../../widgets/tracing_canvas.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/level_model.dart';
import '../../../controllers/level_controller.dart';

class TracingScreen extends StatefulWidget {
  final Level level;
  final LevelController controller;

  const TracingScreen({
    super.key, 
    required this.level,
    required this.controller,
  });

  @override
  State<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen> {
  FeedbackState _feedbackState = FeedbackState.none;
  bool _hasStartedDrawing = false;

  void _checkResult() {
    setState(() {
      _feedbackState = _hasStartedDrawing ? FeedbackState.success : FeedbackState.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActivityLayout(
      progress: 0.2,
      totalStars: widget.level.stars,
      instructionText: 'Sigue la línea hacia abajo',
      onAudioPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reproduciendo audio...', style: GoogleFonts.baloo2()),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      onClose: () => Navigator.of(context).pop(),
      feedbackState: _feedbackState,
      onContinue: () async {
        if (_feedbackState == FeedbackState.success) {
          // Guardar progreso: Marcar como completado con 3 estrellas
          await widget.controller.completeLevel(widget.level, 3);
          if (mounted && context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          setState(() {
            _feedbackState = FeedbackState.none;
          });
        }
      },
      child: Stack(
        children: [
          TracingCanvas(
            onDrawingStarted: () {
              _hasStartedDrawing = true;
            },
          ),
          
          // Botón flotante para "Comprobar"
          if (_feedbackState == FeedbackState.none)
            Positioned(
              bottom: 40,
              right: 40,
              child: FloatingActionButton.extended(
                onPressed: _checkResult,
                backgroundColor: const Color(0xFF4A90E2),
                icon: const Icon(Icons.check_rounded, color: Colors.white),
                label: Text(
                  '¡Listo!',
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
