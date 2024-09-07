import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Model/genre_model.dart';

class GenreDatabase {
  static final GenreDatabase instance = GenreDatabase._init();

  static Database? _database;

  GenreDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('genres.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE genres (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
    ''');
  }

  Future<int> insertGenre(Genre genre) async {
    final db = await instance.database;
    return await db.insert(
      'genres',
      genre.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeGenre(int id) async {
    final db = await instance.database;
    return await db.delete(
      'genres',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Genre>> getGenres() async {
    final db = await instance.database;

    final result = await db.query('genres');
    return result.map((json) => Genre.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
