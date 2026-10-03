import 'package:app_633/constants.dart';

import 'db_helper.dart';

Future<int> insertPlate(String number) async {
  final db = await DbHelper.instance.database;
  return db.insert(table, {'number': number});
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
