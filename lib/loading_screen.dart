import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bomb_game/Adsense/adsense_service.dart';
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
    // ATTの許可を取得
    await initPlugin();

    // アプリバージョンを取得
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;

    // 広告をロード
    await AdsenseService.initialize();

    // 3秒まつ
    await Future.delayed(const Duration(seconds: 2));

    // 画面遷移
    _navigateToNextScreen();
  }

  Future<void> initPlugin() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
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
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage('assets/images/loading_background.png'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
        ),
      ),
    );
  }
}
