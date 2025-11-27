import 'package:flutter/material.dart';
import '../logic/board.dart';

class DiscCell extends StatelessWidget {
  final int value; // Board.empty / human / ai

  const DiscCell({super.key, required this.value});

  Color _discColor(int v) {
    switch (v) {
      case Board.human:
        return Colors.amber;
      case Board.ai:
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _discColor(value),
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
            border: Border.all(color: Colors.black12),
          ),
        ),
      ),
    );
  }
}
