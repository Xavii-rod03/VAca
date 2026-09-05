import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/level_model.dart';
import '../../../controllers/level_controller.dart';
import '../../../core/level_data.dart';
import 'activity_layout.dart';

class SyllablesScreen extends StatefulWidget {
  final Level level;
  final LevelController controller;

  const SyllablesScreen({
    super.key,
    required this.level,
    required this.controller,
  });

  @override
  State<SyllablesScreen> createState() => _SyllablesScreenState();
}

class _SyllablesScreenState extends State<SyllablesScreen> {
  FeedbackState _feedbackState = FeedbackState.none;
  String? _selectedSyllable;
  int _currentRound = 1;
  final int _totalRounds = 5;

  void _checkAnswer(String syllable, String target) {
    setState(() {
      _selectedSyllable = syllable;
      if (syllable == target) {
        _feedbackState = FeedbackState.success;
      } else {
        _feedbackState = FeedbackState.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelData = LevelDataCatalog.getSyllableData(widget.level.id);

    return ActivityLayout(
      progress: _currentRound / _totalRounds.toDouble(),
      totalStars: widget.level.stars,
      instructionText: '${levelData.instruction} ($_currentRound/$_totalRounds)',
      onAudioPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Escucha: "${levelData.target}"', style: GoogleFonts.baloo2()),
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
              _selectedSyllable = null;
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
            _selectedSyllable = null;
          });
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
            ),
            itemCount: levelData.options.length,
            itemBuilder: (context, index) {
              final option = levelData.options[index];
              final isSelected = _selectedSyllable == option;

              return GestureDetector(
                onTap: () => _checkAnswer(option, levelData.target),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (option == levelData.target
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFFE74C3C))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF4A90E2),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: GoogleFonts.baloo2(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
