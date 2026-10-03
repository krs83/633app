import 'package:app_633/constants.dart';
import 'package:app_633/start_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App633());
}

class App633 extends StatelessWidget {
  const App633({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Номера 633',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.teal)),
      home: SafeArea(child: const StartScreen(title: appTitle)),
    );
  }
}
