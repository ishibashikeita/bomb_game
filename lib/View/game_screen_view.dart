import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'result_screen_view.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int gameOverButtonIndex;
  bool isGameOver = false;
  List<bool> buttonPressed = List.filled(25, false);

  @override
  void initState() {
    super.initState();
    gameOverButtonIndex = Random().nextInt(25); // 0から24までのランダムな整数
  }

  void _playSound(String sound) async {
    final player = AudioPlayer();
    await player.setSource(AssetSource(sound));
    await player.setVolume(1.0);
    await player.play(AssetSource(sound));
  }

  void _handleButtonPress(int index) {
    if (index == gameOverButtonIndex) {
      setState(() {
        isGameOver = true;
      });
      _playSound('sounds/bomb.mp3'); // ゲームオーバー時の効果音再生
      _showExplosionEffect(); // 爆発エフェクトを表示
    } else {
      setState(() {
        buttonPressed[index] = true;
      });
      _playSound('sounds/button_click.mp3'); // 通常ボタン押下時の効果音再生
    }
  }

  void _showExplosionEffect() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Image.asset('assets/animations/explosion.gif'),
        );
      },
    );

    // アニメーションの持続時間に合わせて遅延させた後に結果画面に遷移
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // 爆発エフェクトを閉じる
      _navigateToResultScreen();
    });
  }

  void _navigateToResultScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ResultScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = 0.0;
          var end = 1.0;
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/game_background.png'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Flutter Game'),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              width: size.width,
              height: size.width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                image: const DecorationImage(
                  image: AssetImage('assets/images/danger.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: buttonPressed[index] ? 0.0 : 1.0,
                    duration: const Duration(seconds: 1),
                    child: GestureDetector(
                      onTap: buttonPressed[index]
                          ? null
                          : () => _handleButtonPress(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/button.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}