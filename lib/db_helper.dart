import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import 'start_plates_data.dart';

import 'constants.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  Future<Database>? _db;

  String sqlTable =
      '''
      CREATE TABLE $table(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        number TEXT NOT NULL UNIQUE
      )
    ''';

  Future<void> _seed(Database db) async {
    //начальные данные
    final batch = db.batch();
    for (final plates in seedPlates) {
      batch.insert(table, {'number': plates});
    }
    await batch.commit(noResult: true);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(sqlTable);
    await _seed(db);
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<Database> get database async {
    _db ??= _open();
    return _db!;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''CREATE TABLE ${table}_2(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          number TEXT NOT NULL UNIQUE)''');
      await db.execute('''
      INSERT INTO ${table}_2 (id, number)
      SELECT id, number FROM $table ''');
      await db.execute('DROP TABLE $table');
      await db.execute('ALTER TABLE ${table}_2 RENAME TO $table ');
    }
  }
}
