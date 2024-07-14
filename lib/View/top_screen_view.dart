import 'package:audioplayers/audioplayers.dart';
import 'package:bomb_game/View/game_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({super.key});

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  late AudioPlayer _bgmPlayer;
  late AudioPlayer _sfxPlayer;
  bool _isNavigating = false; // フラグを追加

  @override
  void initState() {
    super.initState();
    _bgmPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    _playBGM();
  }

  @override
  void dispose() {
    _stopBGM();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  void _playBGM() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('audio/bgm.mp3'));
  }

  void _stopBGM() {
    _bgmPlayer.stop();
  }

  void _playButtonClickSound() async {
    await _sfxPlayer.play(
      AssetSource('sounds/title_button.mp3'),
    );
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.white.withOpacity(0.7),
                        width: size.width * 0.3,
                        height: 30,
                        child: Center(
                          child: Text(
                            'v1.0.0',
                            style: GoogleFonts.reggaeOne(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // レビューへ
                        },
                        child: Container(
                          color: Colors.white.withOpacity(0.7),
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.storefront_sharp,
                            size: 35,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (_isNavigating) return; // フラグをチェック
                  setState(() {
                    _isNavigating = true; // フラグを設定
                  });
                  _playButtonClickSound();
                  await Future.delayed(
                      Duration(milliseconds: 300)); // 効果音が鳴るのを待つ
                  _stopBGM();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(),
                    ),
                  ).then((_) {
                    setState(() {
                      _isNavigating = false; // フラグをリセット
                    });
                  });
                },
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: size.width,
                    height: size.width * 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.width * 0.7,
                          child: Image.asset('assets/images/title_logo.png'),
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          height: size.width * 0.3,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child:
                                Image.asset('assets/images/title_button.png'),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.2,
                          child:
                              Image.asset('assets/animations/top_to_start.gif'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
