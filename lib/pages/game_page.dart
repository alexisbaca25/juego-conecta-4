import 'dart:math';
import 'package:flutter/material.dart';
import '../logic/board.dart';
import '../logic/minimax.dart';
import '../models/difficulty.dart';
import '../widgets/board_grid.dart';

class GamePage extends StatefulWidget {
  final Difficulty level;

  const GamePage({super.key, required this.level});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Board _board;
  bool _thinking = false;
  bool _gameOver = false;
  String? _resultMessage;
  Set<Point<int>>? _winningCells;
  int _moves = 0; // ✅ solo jugadas humanas

  late Difficulty _level;
  final _ai = AiPlayer();

  @override
  void initState() {
    super.initState();
    _level = widget.level;
    _reset();
  }

  void _reset() {
    _board = Board.empty();
    _thinking = false;
    _gameOver = false;
    _resultMessage = null;
    _winningCells = null;
    _moves = 0;
    setState(() {});
  }

  Future<void> _aiTurn() async {
    setState(() => _thinking = true);
    await Future.delayed(const Duration(milliseconds: 250));

    final col = _ai.chooseMove(_board.copy(), _level); // ✅ IA fuerte
    if (!_gameOver) {
      _board.drop(col, Board.ai);
    }

    if (_board.hasWinner(Board.ai)) {
      _gameOver = true;
      _winningCells = _board.winningCellsFor(Board.ai).toSet();
      _resultMessage = 'La IA gana. ¡Inténtalo de nuevo!';
    } else if (_board.isFull) {
      _gameOver = true;
      _resultMessage = 'Empate';
    }

    _thinking = false;
    setState(() {});
  }

  void _humanPlay(int col) {
    if (_thinking || _gameOver) return;
    if (!_board.isValidColumn(col)) return;

    setState(() {
      _board.drop(col, Board.human);
      _moves++; // ✅ solo jugadas humanas
    });

    if (_board.hasWinner(Board.human)) {
      _gameOver = true;
      _winningCells = _board.winningCellsFor(Board.human).toSet();
      _resultMessage = '¡Felicidades, has ganado! ';
      setState(() {});
      return;
    } else if (_board.isFull) {
      _gameOver = true;
      _resultMessage = 'no puede ser, empate';
      setState(() {});
      return;
    }

    _aiTurn();
  }

  @override
  Widget build(BuildContext context) {
    final isThinking = _thinking;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF1565C0)], // ✅ degradado azul más vivo
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior con logo y botón salir
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 40,
                    ),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                      onPressed: () async {
                        final shouldExit = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Salir"),
                            content: const Text("¿Seguro que quieres salir al inicio?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Sí, salir"),
                              ),
                            ],
                          ),
                        );
                        if (shouldExit == true && mounted) Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),

              // Indicadores
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Dificultad: ',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          _level == Difficulty.easy
                              ? 'Fácil'
                              : _level == Difficulty.medium
                                  ? 'Medio'
                                  : 'Difícil',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        if (isThinking)
                          const Row(
                            children: [
                              SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                              SizedBox(width: 8),
                              Text('Pensando...', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tus movimientos: $_moves",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Tablero más arriba y más grande
              Expanded(
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.95,
                    heightFactor: 0.82, // ✅ tablero un poco más alto
                    child: BoardGrid(
                      board: _board,
                      onColumnTap: _humanPlay,
                      winningCells: _winningCells,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Resultado y botón reiniciar
              if (_resultMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent.shade700,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(blurRadius: 6, color: Colors.black26, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _resultMessage!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text("Reiniciar"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
