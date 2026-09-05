import '../models/level_model.dart';
import '../database/db_helper.dart';
import 'level_repository.dart';

class SQLiteLevelRepository implements LevelRepository {
  final DBHelper _dbHelper = DBHelper();

  @override
  Future<List<Level>> getLevelsForModule(int moduleId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'levels',
      where: 'moduleId = ?',
      whereArgs: [moduleId],
      orderBy: 'levelNumber ASC',
    );

    return List.generate(maps.length, (i) {
      return Level(
        id: maps[i]['id'], // Usamos el ID único de la tabla, no el levelNumber, o ambos. Para el modelo actual el ID es el número de nivel visual
        moduleId: maps[i]['moduleId'],
        title: maps[i]['title'],
        status: LevelStatus.values.firstWhere((e) => e.name == maps[i]['status']),
        stars: maps[i]['stars'],
      );
    });
  }

  // Método específico para actualizar el progreso
  Future<void> updateLevelProgress(Level level, int stars) async {
    final db = await _dbHelper.database;
    
    // 1. Marcar nivel actual como completado
    await db.update(
      'levels',
      {
        'status': LevelStatus.completed.name,
        'stars': stars,
      },
      where: 'id = ?',
      whereArgs: [level.id],
    );

    // 2. Buscar si existe el siguiente nivel en el mismo módulo para desbloquearlo
    final nextLevelMap = await db.query(
      'levels',
      where: 'moduleId = ? AND levelNumber = ?',
      whereArgs: [level.moduleId, (level.id % 10) + 1], // Logica asumiendo id == levelNumber en este módulo
      limit: 1,
    );

    if (nextLevelMap.isNotEmpty) {
      // Solo desbloquear si estaba bloqueado (para no reiniciar progreso de uno completado)
      if (nextLevelMap.first['status'] == LevelStatus.locked.name) {
        await db.update(
          'levels',
          {'status': LevelStatus.current.name},
          where: 'id = ?',
          whereArgs: [nextLevelMap.first['id']],
        );
      }
    }
  }
}
