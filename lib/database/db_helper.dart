import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/level_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'lectoescritura_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Tabla Usuarios
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL
      )
    ''');

    // 2. Tabla Módulos
    await db.execute('''
      CREATE TABLE modules(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subtitle TEXT,
        color INTEGER NOT NULL,
        iconPath TEXT NOT NULL,
        isHighlight INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 3. Tabla Niveles
    await db.execute('''
      CREATE TABLE levels(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        moduleId INTEGER NOT NULL,
        levelNumber INTEGER NOT NULL,
        title TEXT NOT NULL,
        status TEXT NOT NULL,
        stars INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (moduleId) REFERENCES modules (id)
      )
    ''');

    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    // Insertar Módulos iniciales
    final modules = [
      {'title': 'Trazos', 'subtitle': '', 'color': 0xFF4A90E2, 'iconPath': 'pencil', 'isHighlight': 1},
      {'title': 'Letras y sílabas', 'subtitle': 'ba', 'color': 0xFFE0E0E0, 'iconPath': 'letters', 'isHighlight': 0},
      {'title': 'Palabras', 'subtitle': 'SOL', 'color': 0xFFE0E0E0, 'iconPath': 'word', 'isHighlight': 0},
      {'title': 'Libros', 'subtitle': '', 'color': 0xFFE0E0E0, 'iconPath': 'book', 'isHighlight': 0},
    ];

    for (int i = 0; i < modules.length; i++) {
      int moduleId = await db.insert('modules', modules[i]);

      // Generar 10 niveles por cada módulo
      for (int j = 1; j <= 10; j++) {
        // El nivel 1 de cada módulo inicia desbloqueado ('current')
        String initialStatus = (j == 1) ? LevelStatus.current.name : LevelStatus.locked.name;
        
        await db.insert('levels', {
          'moduleId': moduleId,
          'levelNumber': j,
          'title': 'Nivel $j',
          'status': initialStatus,
          'stars': 0,
        });
      }
    }
  }
}
