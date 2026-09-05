import 'package:flutter/material.dart';
import 'dart:ui'; // Para PointMode

class TracingCanvas extends StatefulWidget {
  final VoidCallback onDrawingStarted;

  const TracingCanvas({super.key, required this.onDrawingStarted});

  @override
  State<TracingCanvas> createState() => _TracingCanvasState();
}

class _TracingCanvasState extends State<TracingCanvas> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        widget.onDrawingStarted();
        setState(() {
          points.add(details.localPosition);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          points.add(details.localPosition);
        });
      },
      onPanEnd: (details) {
        setState(() {
          points.add(null); // Separador de trazos
        });
      },
      child: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CustomPaint(
            painter: _TracingPainter(points: points),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  final List<Offset?> points;

  _TracingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dibujar la "Guía" de fondo (Ejemplo: Una línea recta vertical)
    final guidePaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 60
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    canvas.drawLine(
      Offset(centerX, size.height * 0.2),
      Offset(centerX, size.height * 0.8),
      guidePaint,
    );
    
    // Punto de inicio de la guía
    final startPointPaint = Paint()..color = const Color(0xFFF39C12); // Naranja
    canvas.drawCircle(Offset(centerX, size.height * 0.2), 15, startPointPaint);

    // 2. Dibujar el trazo del usuario
    final userPaint = Paint()
      ..color = const Color(0xFF4A90E2) // Azul principal
      ..strokeWidth = 30
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, userPaint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!], userPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
