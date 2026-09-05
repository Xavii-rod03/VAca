import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/level_model.dart';
import '../../../controllers/level_controller.dart';
import '../../../core/level_data.dart';
import 'activity_layout.dart';

class ShortTextsScreen extends StatefulWidget {
  final Level level;
  final LevelController controller;

  const ShortTextsScreen({
    super.key,
    required this.level,
    required this.controller,
  });

  @override
  State<ShortTextsScreen> createState() => _ShortTextsScreenState();
}

class _ShortTextsScreenState extends State<ShortTextsScreen> {
  FeedbackState _feedbackState = FeedbackState.none;
  int _highlightedWordIndex = -1;
  bool _isPlaying = false;
  String? _selectedAnswer;
  int _currentRound = 1;
  final int _totalRounds = 5;

  void _startKaraokeReading(List<String> words) async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);

    for (int i = 0; i < words.length; i++) {
      if (!mounted) return;
      setState(() {
        _highlightedWordIndex = i;
      });
      await Future.delayed(const Duration(milliseconds: 600));
    }

    if (mounted) {
      setState(() {
        _highlightedWordIndex = -1;
        _isPlaying = false;
      });
    }
  }

  void _checkAnswer(String option, String correctAnswer) {
    setState(() {
      _selectedAnswer = option;
      if (option == correctAnswer) {
        _feedbackState = FeedbackState.success;
      } else {
        _feedbackState = FeedbackState.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelData = LevelDataCatalog.getShortTextData(widget.level.id);

    return ActivityLayout(
      progress: _currentRound / _totalRounds.toDouble(),
      totalStars: widget.level.stars,
      instructionText: '${levelData.instruction} ($_currentRound/$_totalRounds)',
      onAudioPressed: () => _startKaraokeReading(levelData.words),
      onClose: () => Navigator.of(context).pop(),
      feedbackState: _feedbackState,
      onContinue: () async {
        if (_feedbackState == FeedbackState.success) {
          if (_currentRound < _totalRounds) {
            setState(() {
              _currentRound++;
              _selectedAnswer = null;
              _feedbackState = FeedbackState.none;
            });
          } else {
            await widget.controller.completeLevel(widget.level, 3);
            if (mounted && context.mounted) {
              Navigator.of(context).pop();
            }
          }
        } else {
          setState(() {
            _feedbackState = FeedbackState.none;
            _selectedAnswer = null;
          });
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Ilustración del cuento/texto
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF4A90E2), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book_rounded, size: 55, color: Color(0xFF4A90E2)),
                  const SizedBox(height: 6),
                  Text(
                    'Lectura Nivel ${widget.level.id}',
                    style: GoogleFonts.baloo2(
                      fontSize: 16,
                      color: const Color(0xFF4A90E2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Texto con Resaltado (Karaoke Style)
            Wrap(
              spacing: 8,
              children: List.generate(levelData.words.length, (index) {
                final isHighlighted = _highlightedWordIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isHighlighted ? Colors.amber : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    levelData.words[index],
                    style: GoogleFonts.baloo2(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isHighlighted ? Colors.black : const Color(0xFF2C3E50),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            // Pregunta de comprensión
            Text(
              levelData.question,
              style: GoogleFonts.baloo2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(height: 14),

            // Opciones de respuesta
            Column(
              children: levelData.options.map((option) {
                final isSelected = _selectedAnswer == option;
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(option, levelData.correctAnswer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? (option == levelData.correctAnswer
                              ? const Color(0xFF2ECC71)
                              : const Color(0xFFE74C3C))
                          : Colors.white,
                      foregroundColor: isSelected ? Colors.white : const Color(0xFF2C3E50),
                      side: const BorderSide(color: Color(0xFF4A90E2), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      option,
                      style: GoogleFonts.baloo2(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
