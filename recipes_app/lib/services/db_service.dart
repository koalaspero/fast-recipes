import 'package:recipes_app/models/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'recipes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            name TEXT,
            thumbnail TEXT,
            instructions TEXT,
            ingredients TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertRecipe(Recipe recipe) async {
    final db = await database;
    await db.insert('favorites', recipe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Recipe>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');
    return maps.map((m) => Recipe.fromMap(m)).toList();
  }

  static Future<void> deleteRecipe(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }
}
