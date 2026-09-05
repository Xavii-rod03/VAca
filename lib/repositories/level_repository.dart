import '../models/level_model.dart';

abstract class LevelRepository {
  Future<List<Level>> getLevelsForModule(int moduleId);
  Future<void> updateLevelProgress(Level level, int stars);
}

class MockLevelRepository implements LevelRepository {
  @override
  Future<List<Level>> getLevelsForModule(int moduleId) async {
    // Simulamos una carga rápida
    await Future.delayed(const Duration(milliseconds: 300));

    // Generamos 10 niveles de prueba.
    // Nivel 1 y 2 completados, Nivel 3 actual, del 4 al 10 bloqueados.
    return List.generate(10, (index) {
      final levelNumber = index + 1;
      LevelStatus status;
      int stars = 0;

      if (levelNumber < 3) {
        status = LevelStatus.completed;
        stars = 3; // Suponemos puntuación perfecta para la demo
      } else if (levelNumber == 3) {
        status = LevelStatus.current;
      } else {
        status = LevelStatus.locked;
      }

      return Level(
        id: levelNumber,
        moduleId: moduleId,
        title: 'Nivel $levelNumber',
        status: status,
        stars: stars,
      );
    });
  }

  @override
  Future<void> updateLevelProgress(Level level, int stars) async {}
}
