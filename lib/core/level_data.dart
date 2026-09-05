import 'package:flutter/material.dart';

class TracingLevelData {
  final String instruction;
  final String shapeType; // 'line_v', 'line_h', 'A', 'E', 'I', 'O', 'U', 'M', 'P', 'S'

  TracingLevelData({required this.instruction, required this.shapeType});
}

class SyllableLevelData {
  final String instruction;
  final String target;
  final List<String> options;

  SyllableLevelData({required this.instruction, required this.target, required this.options});
}

class WordLevelData {
  final String instruction;
  final String word;
  final List<String> letters;
  final IconData icon;

  WordLevelData({
    required this.instruction,
    required this.word,
    required this.letters,
    required this.icon,
  });
}

class ShortTextLevelData {
  final String instruction;
  final List<String> words;
  final String question;
  final List<String> options;
  final String correctAnswer;

  ShortTextLevelData({
    required this.instruction,
    required this.words,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class LevelDataCatalog {
  // Módulo 1: Trazos (10 Niveles)
  static TracingLevelData getTracingData(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return TracingLevelData(instruction: 'Sigue la línea vertical hacia abajo', shapeType: 'line_v');
      case 2:
        return TracingLevelData(instruction: 'Sigue la línea horizontal hacia un lado', shapeType: 'line_h');
      case 3:
        return TracingLevelData(instruction: 'Traza la vocal A', shapeType: 'A');
      case 4:
        return TracingLevelData(instruction: 'Traza la vocal E', shapeType: 'E');
      case 5:
        return TracingLevelData(instruction: 'Traza la vocal I', shapeType: 'I');
      case 6:
        return TracingLevelData(instruction: 'Traza la vocal O', shapeType: 'O');
      case 7:
        return TracingLevelData(instruction: 'Traza la vocal U', shapeType: 'U');
      case 8:
        return TracingLevelData(instruction: 'Traza la letra M', shapeType: 'M');
      case 9:
        return TracingLevelData(instruction: 'Traza la letra P', shapeType: 'P');
      case 10:
      default:
        return TracingLevelData(instruction: 'Traza la letra S', shapeType: 'S');
    }
  }

  // Módulo 2: Sílabas (10 Niveles)
  static SyllableLevelData getSyllableData(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return SyllableLevelData(instruction: 'Toca la sílaba "MA"', target: 'MA', options: ['PA', 'MA', 'TA', 'LA']);
      case 2:
        return SyllableLevelData(instruction: 'Toca la sílaba "PA"', target: 'PA', options: ['MA', 'PA', 'SA', 'TA']);
      case 3:
        return SyllableLevelData(instruction: 'Toca la sílaba "SA"', target: 'SA', options: ['LA', 'RA', 'SA', 'PA']);
      case 4:
        return SyllableLevelData(instruction: 'Toca la sílaba "LA"', target: 'LA', options: ['TA', 'LA', 'MA', 'NA']);
      case 5:
        return SyllableLevelData(instruction: 'Toca la sílaba "TA"', target: 'TA', options: ['PA', 'TA', 'CA', 'BA']);
      case 6:
        return SyllableLevelData(instruction: 'Toca la sílaba "ME"', target: 'ME', options: ['PE', 'ME', 'TE', 'LE']);
      case 7:
        return SyllableLevelData(instruction: 'Toca la sílaba "PE"', target: 'PE', options: ['ME', 'PE', 'SE', 'TE']);
      case 8:
        return SyllableLevelData(instruction: 'Toca la sílaba "MI"', target: 'MI', options: ['PI', 'MI', 'TI', 'LI']);
      case 9:
        return SyllableLevelData(instruction: 'Toca la sílaba "PO"', target: 'PO', options: ['MO', 'PO', 'TO', 'SO']);
      case 10:
      default:
        return SyllableLevelData(instruction: 'Toca la sílaba "LU"', target: 'LU', options: ['MU', 'PU', 'LU', 'TU']);
    }
  }

  // Módulo 3: Palabras (10 Niveles)
  static WordLevelData getWordData(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return WordLevelData(instruction: 'Forma la palabra "SOL"', word: 'SOL', letters: ['O', 'S', 'L', 'M'], icon: Icons.wb_sunny_rounded);
      case 2:
        return WordLevelData(instruction: 'Forma la palabra "MAR"', word: 'MAR', letters: ['M', 'A', 'R', 'P'], icon: Icons.waves_rounded);
      case 3:
        return WordLevelData(instruction: 'Forma la palabra "PAN"', word: 'PAN', letters: ['P', 'A', 'N', 'T'], icon: Icons.bakery_dining_rounded);
      case 4:
        return WordLevelData(instruction: 'Forma la palabra "OSO"', word: 'OSO', letters: ['O', 'S', 'O', 'A'], icon: Icons.pets_rounded);
      case 5:
        return WordLevelData(instruction: 'Forma la palabra "MESA"', word: 'MESA', letters: ['M', 'E', 'S', 'A', 'P'], icon: Icons.table_restaurant_rounded);
      case 6:
        return WordLevelData(instruction: 'Forma la palabra "CASA"', word: 'CASA', letters: ['C', 'A', 'S', 'A', 'O'], icon: Icons.home_rounded);
      case 7:
        return WordLevelData(instruction: 'Forma la palabra "PAPA"', word: 'PAPA', letters: ['P', 'A', 'P', 'A', 'M'], icon: Icons.person_rounded);
      case 8:
        return WordLevelData(instruction: 'Forma la palabra "LUNA"', word: 'LUNA', letters: ['L', 'U', 'N', 'A', 'S'], icon: Icons.bedtime_rounded);
      case 9:
        return WordLevelData(instruction: 'Forma la palabra "GATO"', word: 'GATO', letters: ['G', 'A', 'T', 'O', 'P'], icon: Icons.catching_pokemon_rounded);
      case 10:
      default:
        return WordLevelData(instruction: 'Forma la palabra "LIBRO"', word: 'LIBRO', letters: ['L', 'I', 'B', 'R', 'O', 'A'], icon: Icons.menu_book_rounded);
    }
  }

  // Módulo 4: Textos Cortos (10 Niveles)
  static ShortTextLevelData getShortTextData(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['El', 'oso', 'toma', 'miel.'],
          question: '¿Qué toma el oso?',
          options: ['Miel', 'Agua', 'Sopa'],
          correctAnswer: 'Miel',
        );
      case 2:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['La', 'luna', 'es', 'brillante.'],
          question: '¿Qué es brillante?',
          options: ['La luna', 'El sol', 'La estrella'],
          correctAnswer: 'La luna',
        );
      case 3:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['El', 'perro', 'corre', 'rápido.'],
          question: '¿Quién corre rápido?',
          options: ['El perro', 'El gato', 'El ave'],
          correctAnswer: 'El perro',
        );
      case 4:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['Mamá', 'ama', 'a', 'su', 'familia.'],
          question: '¿A quién ama mamá?',
          options: ['A su familia', 'Al perro', 'Al auto'],
          correctAnswer: 'A su familia',
        );
      case 5:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['El', 'gato', 'bebe', 'leche.'],
          question: '¿Qué bebe el gato?',
          options: ['Leche', 'Jugo', 'Café'],
          correctAnswer: 'Leche',
        );
      case 6:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['La', 'casa', 'es', 'azul.'],
          question: '¿De qué color es la casa?',
          options: ['Azul', 'Roja', 'Verde'],
          correctAnswer: 'Azul',
        );
      case 7:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['El', 'sol', 'sale', 'temprano.'],
          question: '¿Cuándo sale el sol?',
          options: ['Temprano', 'En la noche', 'Nunca'],
          correctAnswer: 'Temprano',
        );
      case 8:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['El', 'ave', 'vuela', 'alto.'],
          question: '¿Qué hace el ave?',
          options: ['Vuela alto', 'Corre', 'Nada'],
          correctAnswer: 'Vuela alto',
        );
      case 9:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['La', 'niña', 'lee', 'un', 'libro.'],
          question: '¿Qué lee la niña?',
          options: ['Un libro', 'Una carta', 'Una revista'],
          correctAnswer: 'Un libro',
        );
      case 10:
      default:
        return ShortTextLevelData(
          instruction: 'Lee y responde la pregunta',
          words: ['El', 'pez', 'nada', 'en', 'el', 'agua.'],
          question: '¿Dónde nada el pez?',
          options: ['En el agua', 'En el cielo', 'En la tierra'],
          correctAnswer: 'En el agua',
        );
    }
  }
}
