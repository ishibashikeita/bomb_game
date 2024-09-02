import 'dart:math';

import 'package:bomb_game/Adsense/adsense_service.dart';
import 'package:bomb_game/View/game_screen_view.dart';
import 'package:bomb_game/View/top_screen_view.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key, required this.buttonPressCount});

  int buttonPressCount;

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    _playSound();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound() async {
    await _audioPlayer.setSource(AssetSource('sounds/victory.mp3'));
    await _audioPlayer.setVolume(1.0);
    await _audioPlayer.play(AssetSource('sounds/victory.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/top_background.png'),
          ),
        ),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.2,
                        child: Center(
                          child: SizedBox(
                            width: size.width * 0.7,
                            child: Image.asset('assets/images/result_logo.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: size.width,
                          height: size.height * 0.3,
                          color: Colors.black.withOpacity(0.8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '押せた回数は',
                                style: GoogleFonts.reggaeOne(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 40,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.buttonPressCount}',
                                    style: GoogleFonts.reggaeOne(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 60,
                                    ),
                                  ),
                                  Text(
                                    '回でした。',
                                    style: GoogleFonts.reggaeOne(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '動画を視聴すると爆弾が',
                                    style: GoogleFonts.reggaeOne(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '2倍',
                                    style: GoogleFonts.reggaeOne(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.greenAccent,
                                      fontSize: 26,
                                    ),
                                  ),
                                  Text(
                                    'に！？',
                                    style: GoogleFonts.reggaeOne(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: FractionallySizedBox(
                              widthFactor: 0.7,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TopScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      'assets/images/home_button.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FractionallySizedBox(
                              widthFactor: 0.7,
                              child: GestureDetector(
                                onTap: () {
                                  AdsenseService.showInterstitialVideo();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GameScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      'assets/images/regame_button.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FractionallySizedBox(
                              widthFactor: 0.7,
                              child: GestureDetector(
                                onTap: () {
                                  AdsenseService.showRewardedVideo();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GameScreen(
                                        isReward: true,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      'assets/images/video_button.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.red,
                          child: AdsenseService.showRectangle(),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi / 2,
                    maxBlastForce: 5,
                    minBlastForce: 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 10,
                    gravity: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
