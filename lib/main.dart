import 'package:bomb_game/View/game_screen_view.dart';
import 'package:bomb_game/View/top_screen_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TopScreen(),
    );
  }
}
