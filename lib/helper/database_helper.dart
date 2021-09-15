import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database _database;
//checks weather there is a existing database
  Future<Database> get databse async {
    if (_database != null) return _database;
    _database = await database();
    return _database;
  }

  static Future database() async {
    final databasePath = await getDatabasesPath();

    return openDatabase(join(databasePath, 'movies_database.db'),
        onCreate: (database, version) {
      return database.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, movie TEXT, director TEXT, imagePath TEXT)');
    }, version: 1);
  }

  static Future insert(Map<String, Object> data) async {
    final database = await DatabaseHelper.database();

    database.insert("movies", data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getMoviesFromDB() async {
    final database = await DatabaseHelper.database();

    return database.query("movies", orderBy: "id DESC");
  }

  static Future delete(int id) async {
    final database = await DatabaseHelper.database();

    return database.delete('movies', where: 'id = ?', whereArgs: [id]);
  }
}
