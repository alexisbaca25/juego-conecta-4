import 'dart:math';
import 'package:flutter/material.dart';
import '../logic/board.dart';
import 'disc_cell.dart';

class BoardGrid extends StatelessWidget {
  final Board board;
  final void Function(int column) onColumnTap;

  // NUEVO: celdas ganadoras (opcional)
  final Set<Point<int>>? winningCells;

  const BoardGrid({
    super.key,
    required this.board,
    required this.onColumnTap,
    this.winningCells,
  });

  @override
  Widget build(BuildContext context) {
    final cols = Board.cols;
    final rows = Board.rows;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * (rows / cols);

        return SizedBox(
          width: width,
          height: height,
          child: AspectRatio(
            aspectRatio: cols / rows,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(blurRadius: 8, offset: Offset(0, 4), color: Colors.black26)],
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) {
                  final r = index ~/ cols;
                  final c = index % cols;
                  final value = board.cell(r, c);
                  final isWinCell = winningCells?.contains(Point(r, c)) ?? false;

                  return GestureDetector(
                    onTap: () => onColumnTap(c),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: isWinCell
                            ? Border.all(
                                color: Colors.limeAccent,
                                width: 3,
                              )
                            : null,
                        boxShadow: isWinCell
                            ? const [BoxShadow(blurRadius: 8, color: Colors.yellowAccent)]
                            : const [BoxShadow(blurRadius: 4, color: Colors.black26)],
                      ),
                      child: Center(child: DiscCell(value: value)),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
