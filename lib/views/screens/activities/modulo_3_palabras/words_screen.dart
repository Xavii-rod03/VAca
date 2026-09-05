import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/level_model.dart';
import '../../../../controllers/level_controller.dart';
import '../../../../core/level_data.dart';
import '../activity_layout.dart';

class WordsScreen extends StatefulWidget {
  final Level level;
  final LevelController controller;

  const WordsScreen({
    super.key,
    required this.level,
    required this.controller,
  });

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  FeedbackState _feedbackState = FeedbackState.none;
  final List<String> _assembledLetters = [];
  int _currentRound = 1;
  final int _totalRounds = 5;

  void _tapLetter(String letter, String targetWord) {
    if (_assembledLetters.length < targetWord.length) {
      setState(() {
        _assembledLetters.add(letter);
      });
    }
  }

  void _removeLetter(int index) {
    setState(() {
      _assembledLetters.removeAt(index);
      _feedbackState = FeedbackState.none;
    });
  }

  void _verifyWord(String targetWord) {
    final currentWord = _assembledLetters.join();
    setState(() {
      if (currentWord == targetWord) {
        _feedbackState = FeedbackState.success;
      } else {
        _feedbackState = FeedbackState.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelData = LevelDataCatalog.getWordData(widget.level.id);

    return ActivityLayout(
      progress: _currentRound / _totalRounds.toDouble(),
      totalStars: widget.level.stars,
      instructionText: '${levelData.instruction} ($_currentRound/$_totalRounds)',
      onAudioPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Forma la palabra: "${levelData.word}"', style: GoogleFonts.baloo2()),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      onClose: () => Navigator.of(context).pop(),
      feedbackState: _feedbackState,
      onContinue: () async {
        if (_feedbackState == FeedbackState.success) {
          if (_currentRound < _totalRounds) {
            setState(() {
              _currentRound++;
              _assembledLetters.clear();
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
            _assembledLetters.clear();
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // Ilustración/Imagen del objeto
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 3),
              ),
              child: Icon(
                levelData.icon,
                size: 75,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),

            // Casillas de la palabra armada
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(levelData.word.length, (index) {
                final hasLetter = index < _assembledLetters.length;
                final letter = hasLetter ? _assembledLetters[index] : '';

                return GestureDetector(
                  onTap: hasLetter ? () => _removeLetter(index) : null,
                  child: Container(
                    width: 55,
                    height: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: hasLetter ? const Color(0xFF4A90E2) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF4A90E2),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: GoogleFonts.baloo2(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const Spacer(),

            // Fichas de letras disponibles
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: levelData.letters.map((letter) {
                return ElevatedButton(
                  onPressed: () => _tapLetter(letter, levelData.word),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF39C12),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    letter,
                    style: GoogleFonts.baloo2(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            if (_assembledLetters.length == levelData.word.length && _feedbackState == FeedbackState.none)
              ElevatedButton.icon(
                onPressed: () => _verifyWord(levelData.word),
                icon: const Icon(Icons.check_rounded, color: Colors.white),
                label: Text(
                  '¡Listo!',
                  style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
