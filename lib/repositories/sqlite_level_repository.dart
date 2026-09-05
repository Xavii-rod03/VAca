import 'package:shared_preferences/shared_preferences.dart';
import '../models/level_model.dart';
import '../database/db_helper.dart';
import 'level_repository.dart';

class SQLiteLevelRepository implements LevelRepository {
  final DBHelper _dbHelper = DBHelper();

  @override
  Future<List<Level>> getLevelsForModule(int moduleId) async {
    final prefs = await SharedPreferences.getInstance();

    // Intentamos cargar desde SQLite primero
    List<Level> levelsFromDb = [];
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'levels',
        where: 'moduleId = ?',
        whereArgs: [moduleId],
        orderBy: 'levelNumber ASC',
      );

      levelsFromDb = List.generate(maps.length, (i) {
        return Level(
          id: maps[i]['levelNumber'] ?? (i + 1),
          moduleId: maps[i]['moduleId'],
          title: maps[i]['title'],
          status: LevelStatus.values.firstWhere(
            (e) => e.name == maps[i]['status'],
            orElse: () => LevelStatus.locked,
          ),
          stars: maps[i]['stars'] ?? 0,
        );
      });
    } catch (_) {}

    // Si la DB está vacía o falló en web, generamos los 10 niveles y cruzamos con SharedPreferences
    List<Level> levels = levelsFromDb.isNotEmpty
        ? levelsFromDb
        : List.generate(10, (index) {
            final levelNum = index + 1;
            return Level(
              id: levelNum,
              moduleId: moduleId,
              title: 'Nivel $levelNum',
              status: levelNum == 1 ? LevelStatus.current : LevelStatus.locked,
              stars: 0,
            );
          });

    // Sobrescribimos con los valores guardados en SharedPreferences (Persistencia Web/Nativa)
    return levels.map((l) {
      final statusKey = 'level_status_${l.moduleId}_${l.id}';
      final starsKey = 'level_stars_${l.moduleId}_${l.id}';

      final savedStatusStr = prefs.getString(statusKey);
      final savedStars = prefs.getInt(starsKey);

      LevelStatus status = l.status;
      if (savedStatusStr != null) {
        status = LevelStatus.values.firstWhere(
          (e) => e.name == savedStatusStr,
          orElse: () => l.status,
        );
      }

      return Level(
        id: l.id,
        moduleId: l.moduleId,
        title: l.title,
        status: status,
        stars: savedStars ?? l.stars,
      );
    }).toList();
  }

  @override
  Future<void> updateLevelProgress(Level level, int stars) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Guardar estado completado en SharedPreferences
    await prefs.setString('level_status_${level.moduleId}_${level.id}', LevelStatus.completed.name);
    await prefs.setInt('level_stars_${level.moduleId}_${level.id}', stars);

    // 2. Desbloquear el siguiente nivel en SharedPreferences
    final nextLevelNum = level.id + 1;
    if (nextLevelNum <= 10) {
      final nextStatusKey = 'level_status_${level.moduleId}_$nextLevelNum';
      final currentNextStatus = prefs.getString(nextStatusKey);
      if (currentNextStatus == null || currentNextStatus == LevelStatus.locked.name) {
        await prefs.setString(nextStatusKey, LevelStatus.current.name);
      }
    }

    // 3. Sincronizar en SQLite
    try {
      final db = await _dbHelper.database;
      await db.update(
        'levels',
        {
          'status': LevelStatus.completed.name,
          'stars': stars,
        },
        where: 'moduleId = ? AND levelNumber = ?',
        whereArgs: [level.moduleId, level.id],
      );

      if (nextLevelNum <= 10) {
        await db.update(
          'levels',
          {'status': LevelStatus.current.name},
          where: 'moduleId = ? AND levelNumber = ? AND status = ?',
          whereArgs: [level.moduleId, nextLevelNum, LevelStatus.locked.name],
        );
      }
    } catch (_) {}
  }
}
