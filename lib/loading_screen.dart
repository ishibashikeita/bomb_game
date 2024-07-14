import 'package:bomb_game/View/game_screen_view.dart';
import 'package:bomb_game/View/top_screen_view.dart';
import 'package:bomb_game/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    // 初回ロード時間
    await Future.delayed(const Duration(seconds: 10));

    // アプリバージョンを取得
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;

    // 広告をロード
    await Future.delayed(const Duration(seconds: 1));

    // 画面遷移
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TopScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '※注意書き',
              textAlign: TextAlign.center,
              style: GoogleFonts.reggaeOne(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'ゲームには強い光や急激な画面の変化を伴う爆発エフェクトが含まれます。\n光過敏性てんかんをお持ちの方はプレイをお控えください。',
                textAlign: TextAlign.center,
                style: GoogleFonts.reggaeOne(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}