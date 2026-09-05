import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/level_model.dart';
import '../../../../controllers/level_controller.dart';
import '../../../../core/level_data.dart';
import '../../../widgets/tracing_canvas.dart';
import '../activity_layout.dart';

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
  int _currentRound = 1; // 1 a 5 rondas por nivel
  final int _totalRounds = 5;

  void _checkResult() {
    setState(() {
      _feedbackState = _hasStartedDrawing ? FeedbackState.success : FeedbackState.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelData = LevelDataCatalog.getTracingData(widget.level.id);

    return ActivityLayout(
      progress: _currentRound / _totalRounds.toDouble(),
      totalStars: widget.level.stars,
      instructionText: '${levelData.instruction} ($_currentRound/$_totalRounds)',
      onAudioPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(levelData.instruction, style: GoogleFonts.baloo2()),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      onClose: () => Navigator.of(context).pop(),
      feedbackState: _feedbackState,
      onContinue: () async {
        if (_feedbackState == FeedbackState.success) {
          if (_currentRound < _totalRounds) {
            // Avanzar a la siguiente ronda dentro del nivel
            setState(() {
              _currentRound++;
              _hasStartedDrawing = false;
              _feedbackState = FeedbackState.none;
            });
          } else {
            // Se completaron las 5 rondas del nivel
            await widget.controller.completeLevel(widget.level, 3);
            if (mounted && context.mounted) {
              Navigator.of(context).pop();
            }
          }
        } else {
          setState(() {
            _feedbackState = FeedbackState.none;
          });
        }
      },
      child: Stack(
        key: ValueKey(_currentRound), // Fuerza a recrear el lienzo en cada ronda
        children: [
          TracingCanvas(
            shapeType: levelData.shapeType,
            onDrawingStarted: () {
              _hasStartedDrawing = true;
            },
          ),
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
