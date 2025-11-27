import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const Conecta4App());
}

class Conecta4App extends StatelessWidget {
  const Conecta4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conecta 4 con IA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
