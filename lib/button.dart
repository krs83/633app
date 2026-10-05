import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.tip,
    required this.onPressed,
    required this.iconButton,
  });

  final String tip;
  final void Function() onPressed;
  final IconData iconButton;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tip,
      child: Icon(iconButton),
    );
  }
}
