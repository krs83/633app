import 'package:flutter/material.dart';

const dbName = 'plates_633.db';
const table = 'plates_633';
const appTitle = 'Номера 633';
const add = 'Добавить';
const del = 'Удалить';
const cancel = 'Отмена';
const newPlate = 'Новый номер';
const search = 'Поиск';
const tablePadding = 10;
const plateExistText = SnackBar(
  content: Text('Такой номер уже есть!'),
  backgroundColor: Colors.red,
);
const plateAddedText = SnackBar(
  content: Text('Номер добавлен'),
  backgroundColor: Colors.green,
);
