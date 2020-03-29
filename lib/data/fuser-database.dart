import 'package:fuser/data/patterns/kirby.dart';
import 'package:fuser/data/patterns/link.dart';
import 'package:fuser/data/patterns/mario.dart';
import 'package:fuser/data/patterns/pikachu.dart';
import 'package:fuser/data/patterns/yoshi.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FuserDatabase {
  static const DATABASE_NAME = 'fuser-database.db';
  static const DATABASE_VERSION = 1;

  static final FuserDatabase _singleton = FuserDatabase._();
  static Database _database;

  FuserDatabase._();

  factory FuserDatabase() {
    return _singleton;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }

    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), DATABASE_NAME);

    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE rectangularPatterns (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        width INTEGER NOT NULL,
        height INTEGER NOT NULL,
        colors TEXT
      )
    ''');

    await database.insert('rectangularPatterns', pikachu.toMap());
    await database.insert('rectangularPatterns', yoshi.toMap());
  }
}