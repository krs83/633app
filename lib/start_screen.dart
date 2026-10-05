import 'package:flutter/material.dart';

import 'button.dart';
import 'constants.dart';
import 'crud.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.title});

  final String title;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  List<String> carPlates = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPlates();
  }

  Future<void> _loadPlates() async {
    final plates = await getAllPlates();
    setState(() => carPlates = plates);
  }

  String normalizePlate(String raw) {
    final s = raw.trim().toUpperCase();

    // Регулярка: буква, [3 цифры], 2 буквы, [1-3 цифры], [хвост]
    final regex = RegExp(
      r'^([А-Я])\s*(\d{3})?\s*([А-Я]{2})\s*(\d{1,3})?\s*(.*)$',
    );
    final match = regex.firstMatch(s);
    if (match == null) return s;

    final letter = match.group(1)!;
    final digits = match.group(2);
    final letters = match.group(3)!;
    final region = match.group(4);
    final comment = match.group(5)!.trim();

    final parts = <String>[
      letter,
      ?digits,
      letters,
      ?region,
      if (comment.isNotEmpty) comment,
    ];

    return parts.join(' ');
  }

  Future<void> _confirmDelete(String plate) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('$del?'),
        content: Text(plate),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(del),
          ),
        ],
      ),
    );
    if (ok == true) _deletePlate(plate);
  }

  Future<void> _deletePlate(String plate) async {
    await deletePlate(plate);
    await _loadPlates();
  }

  Future<void> _addCarPlate() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(newPlate),

        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: const Text(add),
          ),
        ],
      ),
    );

    if (result == null || result.trim().isEmpty) return;

    await insertPlate(normalizePlate(result.trim()));
    await _loadPlates();
  }

  List<String> get _visiblePlates {
    final query = _searchQuery.trim().toUpperCase();
    if (query.isEmpty) return [...carPlates]..sort();

    return carPlates.where((p) => p.toUpperCase().startsWith(query)).toList()
      ..sort();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visiblePlates;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Text(widget.title),
              SizedBox(width: 20),
              Icon(Icons.directions_car),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: search,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: visible.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(
                  '${(i + 1).toString().padRight(tablePadding)}${visible[i]}',
                ),
                onLongPress: () => _confirmDelete(visible[i]),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: .end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Button(
              tip: 'Поиск',
              onPressed: () {
                _addCarPlate();
              },
              iconButton: Icons.find_in_page,
            ),
          ),
        ],
      ),
    );
  }
}
