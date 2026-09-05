import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../database/db_helper.dart';
import 'user_repository.dart';

class SQLiteUserRepository implements UserRepository {
  final DBHelper _dbHelper = DBHelper();

  @override
  Future<void> saveUser(User user) async {
    // 1. Guardar en SharedPreferences (Garantiza persistencia en Web/LocalStorage)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', user.name);
    await prefs.setInt('user_age', user.age);

    // 2. Guardar en SQLite
    try {
      final db = await _dbHelper.database;
      await db.delete('users');
      await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {}
  }

  @override
  Future<User?> getUser() async {
    // 1. Intentar desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final age = prefs.getInt('user_age');

    if (name != null && name.isNotEmpty && age != null) {
      return User(name: name, age: age);
    }

    // 2. Intentar desde SQLite
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);
      if (maps.isNotEmpty) {
        final u = User.fromMap(maps.first);
        // Guardar en SharedPreferences para mantener sincronizado
        await prefs.setString('user_name', u.name);
        await prefs.setInt('user_age', u.age);
        return u;
      }
    } catch (_) {}

    return null;
  }
}
