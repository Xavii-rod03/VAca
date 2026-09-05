import 'package:flutter/material.dart';
import 'dart:ui';

class TracingCanvas extends StatefulWidget {
  final VoidCallback onDrawingStarted;
  final String shapeType; // 'line_v', 'line_h', 'A', 'E', 'I', 'O', 'U', 'M', 'P', 'S'

  const TracingCanvas({
    super.key,
    required this.onDrawingStarted,
    this.shapeType = 'line_v',
  });

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
          points.add(null);
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
            painter: _TracingPainter(points: points, shapeType: widget.shapeType),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  final List<Offset?> points;
  final String shapeType;

  _TracingPainter({required this.points, required this.shapeType});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 1. Dibujar Guía según shapeType
    final guidePaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 40
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final startPointPaint = Paint()..color = const Color(0xFFF39C12);

    if (shapeType == 'line_h') {
      canvas.drawLine(Offset(size.width * 0.2, centerY), Offset(size.width * 0.8, centerY), guidePaint);
      canvas.drawCircle(Offset(size.width * 0.2, centerY), 15, startPointPaint);
    } else if (shapeType == 'line_v') {
      canvas.drawLine(Offset(centerX, size.height * 0.2), Offset(centerX, size.height * 0.8), guidePaint);
      canvas.drawCircle(Offset(centerX, size.height * 0.2), 15, startPointPaint);
    } else {
      // Dibuja la letra como plantilla de texto guía
      final textPainter = TextPainter(
        text: TextSpan(
          text: shapeType,
          style: TextStyle(
            fontSize: 180,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade300,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
      );
    }

    // 2. Dibujar el trazo libre del usuario
    final userPaint = Paint()
      ..color = const Color(0xFF4A90E2)
      ..strokeWidth = 25
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
    return oldDelegate.points != points || oldDelegate.shapeType != shapeType;
  }
}
