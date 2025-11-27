import 'dart:math';
import '../models/difficulty.dart';
import 'board.dart';

class AiPlayer {
  final Random _rng = Random();

  int chooseMove(Board board, Difficulty level) {
    final valid = board.validColumns();

    // 1) Ganar ahora si se puede
    for (final c in valid) {
      final tmp = board.copy();
      tmp.drop(c, Board.ai);
      if (tmp.hasWinner(Board.ai)) return c;
    }
    // 2) Bloquear derrota inmediata
    for (final c in valid) {
      final tmp = board.copy();
      tmp.drop(c, Board.human);
      if (tmp.hasWinner(Board.human)) return c;
    }

    switch (level) {
      case Difficulty.easy:
        if (_rng.nextDouble() < 0.5) {
          return valid[_rng.nextInt(valid.length)];
        } else {
          final res = _minimax(board.copy(), 2, -1 << 30, 1 << 30, true);
          return res.$1 ?? valid[_rng.nextInt(valid.length)];
        }

      case Difficulty.medium:
        final resM = _minimax(board.copy(), 4, -1 << 30, 1 << 30, true);
        return resM.$1 ?? valid[_rng.nextInt(valid.length)];

      case Difficulty.hard:
        final resH = _minimax(board.copy(), 5, -1 << 30, 1 << 30, true);
        return resH.$1 ?? valid[_rng.nextInt(valid.length)];
    }
  }

  /// Devuelve un record POSICIONAL: (columna, puntuación)
  (int? col, int score) _minimax(
    Board b,
    int depth,
    int alpha,
    int beta,
    bool maximizing,
  ) {
    if (depth == 0 || b.isTerminal) {
      if (b.hasWinner(Board.ai)) return (null, 1000000000);
      if (b.hasWinner(Board.human)) return (null, -1000000000);
      return (null, b.scorePosition(Board.ai));
    }

    final moves = Board.orderColumns(b.validColumns());

    if (maximizing) {
      int bestVal = -1 << 30;
      int? bestCol;
      for (final c in moves) {
        final next = b.copy()..drop(c, Board.ai);
        final res = _minimax(next, depth - 1, alpha, beta, false);
        final val = res.$2; // <-- antes .score
        if (val > bestVal) {
          bestVal = val;
          bestCol = c;
        }
        alpha = max(alpha, bestVal);
        if (alpha >= beta) break;
      }
      return (bestCol, bestVal);
    } else {
      int bestVal = 1 << 30;
      int? bestCol;
      for (final c in moves) {
        final next = b.copy()..drop(c, Board.human);
        final res = _minimax(next, depth - 1, alpha, beta, true);
        final val = res.$2; // <-- antes .score
        if (val < bestVal) {
          bestVal = val;
          bestCol = c;
        }
        beta = min(beta, bestVal);
        if (alpha >= beta) break;
      }
      return (bestCol, bestVal);
    }
  }
}
