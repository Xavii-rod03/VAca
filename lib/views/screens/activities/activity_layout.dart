import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum FeedbackState { none, success, error }

class ActivityLayout extends StatelessWidget {
  final double progress; // 0.0 a 1.0
  final int totalStars;
  final String instructionText;
  final VoidCallback onAudioPressed;
  final VoidCallback onClose;
  final Widget child; // El juego o actividad específica

  // Feedback Bottom Sheet
  final FeedbackState feedbackState;
  final VoidCallback onContinue;

  const ActivityLayout({
    super.key,
    required this.progress,
    required this.totalStars,
    required this.instructionText,
    required this.onAudioPressed,
    required this.onClose,
    required this.child,
    this.feedbackState = FeedbackState.none,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB), // Crema suave
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            _buildInstructionHeader(),
            Expanded(
              // Aquí se inyecta el canvas de trazos, letras, etc.
              child: child,
            ),
          ],
        ),
      ),
      bottomSheet: _buildFeedbackPanel(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Botón de salir
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Color(0xFFBDC3C7), size: 32),
            onPressed: onClose,
          ),
          
          // Barra de progreso
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)), // Verde
                ),
              ),
            ),
          ),
          
          // Estrellas acumuladas en el nivel
          Row(
            children: [
              Text(
                '$totalStars',
                style: GoogleFonts.baloo2(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const Icon(Icons.star_rounded, color: Colors.amber, size: 32),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón de Audio
          GestureDetector(
            onTap: onAudioPressed,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD), // Azul clarito
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4A90E2), width: 2),
              ),
              child: const Icon(Icons.volume_up_rounded, color: Color(0xFF4A90E2), size: 32),
            ),
          ),
          const SizedBox(width: 16),
          // Texto de instrucción
          Expanded(
            child: Text(
              instructionText,
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C3E50),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildFeedbackPanel(BuildContext context) {
    if (feedbackState == FeedbackState.none) return null;

    final isSuccess = feedbackState == FeedbackState.success;
    final bgColor = isSuccess ? const Color(0xFFD5F5E3) : const Color(0xFFFADBD8);
    final textColor = isSuccess ? const Color(0xFF27AE60) : const Color(0xFFC0392B);
    final message = isSuccess ? '¡Excelente!' : '¡Casi! Inténtalo de nuevo';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: GoogleFonts.baloo2(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSuccess ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                isSuccess ? 'Siguiente' : 'Repetir',
                style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
