import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Model/movie_model.dart';

class MovieDatabase {
  static final MovieDatabase instance = MovieDatabase._init();

  static Database? _database;

  MovieDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE movies (
      id INTEGER,
      title TEXT PRIMARY KEY,
      original_title TEXT,
      overview TEXT,
      release_date TEXT,
      backdrop_path TEXT,
      poster_path TEXT,
      vote_average REAL,
      vote_count INTEGER,
      genre_ids TEXT,
      popularity REAL,
      adult INTEGER,
      video INTEGER
    )
    ''');
  }

  Future<int> insertMovie(Movie movie) async {
    final db = await instance.database;
    return await db.insert(
      'movies',
      movie.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertMovies(List<Movie> movieList) async {
    final db = await instance.database;
    Batch batch = db.batch();
    for (var movie in movieList) {
      batch.insert('movies', movie.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<List<Movie>> getMovies() async {
    final db = await instance.database;

    final result = await db.query('movies');
    return result.map((json) => Movie.fromJson(json)).toList();
  }


  Future<int> removeMovie({required int id,required String title}) async {
    final db = await instance.database;

    if (id != null) {
      return await db.delete(
        'movies',
        where: 'id = ?',
        whereArgs: [id],
      );
    } else if (title != null) {
      return await db.delete(
        'movies',
        where: 'title = ?',
        whereArgs: [title],
      );
    } else {
      throw ArgumentError('Either id or title must be provided');
    }
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
