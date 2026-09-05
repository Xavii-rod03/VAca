import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../repositories/level_repository.dart';
import '../repositories/sqlite_level_repository.dart'; // Import para usar la función específica

class LevelController extends ChangeNotifier {
  final LevelRepository repository;
  
  List<Level> levels = [];
  bool isLoading = true;

  LevelController({required this.repository});

  Future<void> loadLevels(int moduleId) async {
    isLoading = true;
    notifyListeners();
    
    levels = await repository.getLevelsForModule(moduleId);
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> completeLevel(Level level, int stars) async {
    if (repository is SQLiteLevelRepository) {
      await (repository as SQLiteLevelRepository).updateLevelProgress(level, stars);
      // Recargar niveles para reflejar el cambio en la UI
      await loadLevels(level.moduleId);
    }
  }
}
