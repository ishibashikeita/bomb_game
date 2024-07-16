import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:bomb_game/Adsense/adsense_service.dart';
import 'package:bomb_game/View/top_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'result_screen_view.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AdsenseService adsenseService = AdsenseService();
  late int gameOverButtonIndex;
  bool isGameOver = false;
  List<bool> buttonPressed = List.filled(25, false);

  @override
  void initState() {
    super.initState();
    gameOverButtonIndex = Random().nextInt(25); // 0から24までのランダムな整数
    adsenseService.initialize();
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
      if (mounted) {
        Navigator.of(context).pop(); // 爆発エフェクトを閉じる
        _navigateToResultScreen();
      }
    });
  }

  void _navigateToResultScreen() {
    try {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ResultScreen(),
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
    } catch (e) {
      print(e);
    }
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
          backgroundColor: Colors.black54,
          actions: [
            IconButton(
                onPressed: () {
                  // ゲームを辞めますか？のダイアログを表示
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        surfaceTintColor: Colors.white,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(
                                    Icons.warning,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                              Text(
                                'ゲームを中断して\nタイトル画面に戻りますか？',
                                style: GoogleFonts.reggaeOne(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Text(
                                          'キャンセル',
                                          style: GoogleFonts.reggaeOne(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TopScreen()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          '終了',
                                          style: GoogleFonts.reggaeOne(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.12, bottom: 5.12),
                                    width: 300,
                                    height: 250,
                                    child: FittedBox(
                                      child:
                                          adsenseService.getRectangleAdWidget(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.pause,
                  color: Colors.white,
                ))
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: 25,
                      itemBuilder: (context, index) {
                        return AnimatedOpacity(
                          opacity: buttonPressed[index] ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 100),
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
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: adsenseService.getBannerAdWidget(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
