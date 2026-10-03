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
        number TEXT NOT NULL
      )
    ''';

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(sqlTable);

    //начальные данные
    final batch = db.batch();
    for (final plates in seedPlates) {
      batch.insert(table, {'number': plates});
    }
    await batch.commit(noResult: true);
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
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
}
