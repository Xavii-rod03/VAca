import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../database/db_helper.dart';
import 'user_repository.dart';

class SQLiteUserRepository implements UserRepository {
  final DBHelper _dbHelper = DBHelper();

  @override
  Future<void> saveUser(User user) async {
    final db = await _dbHelper.database;
    // Borramos datos anteriores para mantener solo un usuario (Single User App)
    await db.delete('users'); 
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<User?> getUser() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null; // Si no hay usuario, retornará null y la app debería pedir registro
  }
}
