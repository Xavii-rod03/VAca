import 'package:flutter/material.dart';
import '../models/module_model.dart';
import '../database/db_helper.dart';
import 'module_repository.dart';

class SQLiteModuleRepository implements ModuleRepository {
  final DBHelper _dbHelper = DBHelper();

  @override
  Future<List<Module>> getModules() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('modules');

    return List.generate(maps.length, (i) {
      return Module(
        id: maps[i]['id'],
        title: maps[i]['title'],
        subtitle: maps[i]['subtitle'] ?? '',
        color: Color(maps[i]['color']),
        iconPath: maps[i]['iconPath'],
        isHighlight: maps[i]['isHighlight'] == 1,
      );
    });
  }
}
