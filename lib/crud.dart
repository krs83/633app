import 'package:app_633/constants.dart';
import 'package:sqflite/sqflite.dart';

import 'db_helper.dart';

Future<int?> insertPlate(String number) async {
  try {
    final db = await DbHelper.instance.database;
    return await db.insert(table, {'number': number});
  } on DatabaseException catch (e) {
    if (e.isUniqueConstraintError()) return null;
    rethrow;
  }
}

Future<List<String>> getAllPlates() async {
  final db = await DbHelper.instance.database;
  final rows = await db.query(table, columns: ['number'], orderBy: 'id');
  return rows.map((row) => row['number'] as String).toList();
}

Future<int> deletePlate(String number) async {
  final db = await DbHelper.instance.database;
  return db.delete(table, where: 'number = ?', whereArgs: [number]);
}
