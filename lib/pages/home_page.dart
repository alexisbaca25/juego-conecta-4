import 'package:flutter/material.dart';
import '../models/difficulty.dart';
import 'game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _startGame(BuildContext context, Difficulty level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePage(level: level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // LOGO DEL JUEGO
            Center(
              child: Image.asset(
                "assets/logo.png",
                height: 140,
              ),
            ),

            const SizedBox(height: 20),

            // TÍTULO DIVERTIDO
            Text(
              " Estas listo?",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
                shadows: const [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Elige tu nivel de dificultad",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),

            const Spacer(),

            // BOTONES DE DIFICULTAD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _startGame(context, Difficulty.easy),
                    child: const Text("😺 Fácil", style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _startGame(context, Difficulty.medium),
                    child:
                        const Text("😼 Medio", style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _startGame(context, Difficulty.hard),
                    child:
                        const Text("😾 Difícil", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // PIE DE PÁGINA DIVERTIDO
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "¡Reta a la IA y demuestra tu estrategia! 🤖",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.indigo.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
