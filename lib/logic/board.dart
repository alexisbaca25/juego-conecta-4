import 'dart:math';

class Board {
  static const int rows = 6;
  static const int cols = 7;

  // OJO: este nombre evita conflicto con Board.empty()
  static const int emptyCell = 0;
  static const int human = 1;
  static const int ai = 2;

  final List<List<int>> grid;

  Board._(this.grid);

  factory Board.empty() {
    return Board._(List.generate(rows, (_) => List.filled(cols, emptyCell)));
  }

  Board copy() => Board._([for (final r in grid) List<int>.from(r)]);

  bool get isFull => grid[0].every((v) => v != emptyCell);
  bool isValidColumn(int c) => grid[0][c] == emptyCell;

  List<int> validColumns() {
    final v = <int>[];
    for (int c = 0; c < cols; c++) {
      if (isValidColumn(c)) v.add(c);
    }
    return v;
  }

  bool drop(int col, int piece) {
    for (int r = rows - 1; r >= 0; r--) {
      if (grid[r][col] == emptyCell) {
        grid[r][col] = piece;
        return true;
      }
    }
    return false;
  }

  /// Celdas ganadoras (4 puntos) para `piece`. Vacío si no hay.
  List<Point<int>> winningCellsFor(int piece) {
    // Horizontal
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols - 3; c++) {
        if (grid[r][c] == piece &&
            grid[r][c + 1] == piece &&
            grid[r][c + 2] == piece &&
            grid[r][c + 3] == piece) {
          return [Point(r, c), Point(r, c + 1), Point(r, c + 2), Point(r, c + 3)];
        }
      }
    }
    // Vertical
    for (int r = 0; r < rows - 3; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] == piece &&
            grid[r + 1][c] == piece &&
            grid[r + 2][c] == piece &&
            grid[r + 3][c] == piece) {
          return [Point(r, c), Point(r + 1, c), Point(r + 2, c), Point(r + 3, c)];
        }
      }
    }
    // Diagonal /
    for (int r = 3; r < rows; r++) {
      for (int c = 0; c < cols - 3; c++) {
        if (grid[r][c] == piece &&
            grid[r - 1][c + 1] == piece &&
            grid[r - 2][c + 2] == piece &&
            grid[r - 3][c + 3] == piece) {
          return [Point(r, c), Point(r - 1, c + 1), Point(r - 2, c + 2), Point(r - 3, c + 3)];
        }
      }
    }
    // Diagonal \
    for (int r = 0; r < rows - 3; r++) {
      for (int c = 0; c < cols - 3; c++) {
        if (grid[r][c] == piece &&
            grid[r + 1][c + 1] == piece &&
            grid[r + 2][c + 2] == piece &&
            grid[r + 3][c + 3] == piece) {
          return [Point(r, c), Point(r + 1, c + 1), Point(r + 2, c + 2), Point(r + 3, c + 3)];
        }
      }
    }
    return const [];
  }

  /// ✅ Método usado por tu UI y minimax
  bool hasWinner(int piece) => winningCellsFor(piece).isNotEmpty;

  // Heurística para IA
  static int _evalWindow(List<int> w, int piece) {
    final opponent = piece == ai ? human : ai;
    final cf = w.where((x) => x == piece).length;
    final cv = w.where((x) => x == emptyCell).length;
    final co = w.where((x) => x == opponent).length;
    int score = 0;

    if (cf == 4) score += 100000;
    else if (cf == 3 && cv == 1) score += 100;
    else if (cf == 2 && cv == 2) score += 10;

    if (co == 3 && cv == 1) score -= 80;
    else if (co == 2 && cv == 2) score -= 5;

    return score;
  }

  int scorePosition(int piece) {
    int score = 0;

    // centro
    final centerCol = cols ~/ 2;
    int centerCount = 0;
    for (int r = 0; r < rows; r++) {
      if (grid[r][centerCol] == piece) centerCount++;
    }
    score += centerCount * 6;

    // horizontales
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols - 3; c++) {
        score += _evalWindow([grid[r][c], grid[r][c + 1], grid[r][c + 2], grid[r][c + 3]], piece);
      }
    }
    // verticales
    for (int c = 0; c < cols; c++) {
      for (int r = 0; r < rows - 3; r++) {
        score += _evalWindow([grid[r][c], grid[r + 1][c], grid[r + 2][c], grid[r + 3][c]], piece);
      }
    }
    // diagonales /
    for (int r = 3; r < rows; r++) {
      for (int c = 0; c < cols - 3; c++) {
        score += _evalWindow([grid[r][c], grid[r - 1][c + 1], grid[r - 2][c + 2], grid[r - 3][c + 3]], piece);
      }
    }
    // diagonales \
    for (int r = 0; r < rows - 3; r++) {
      for (int c = 0; c < cols - 3; c++) {
        score += _evalWindow([grid[r][c], grid[r + 1][c + 1], grid[r + 2][c + 2], grid[r + 3][c + 3]], piece);
      }
    }

    return score;
  }

  static List<int> orderColumns(List<int> colsValidas) {
    final center = cols ~/ 2;
    final ordered = [...colsValidas];
    ordered.sort((a, b) => (a - center).abs().compareTo((b - center).abs()));
    return ordered;
  }

  // (opcional) Por si lo usas en minimax:
  bool get isTerminal => hasWinner(human) || hasWinner(ai) || isFull;

  int cell(int row, int col) => grid[row][col];
}
