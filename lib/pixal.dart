import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Pixal extends StatelessWidget {
  var color;
  Pixal({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color,
      ),
    );
  }
}
