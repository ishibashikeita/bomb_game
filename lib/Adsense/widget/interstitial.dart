import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// インステ広告を表示するためのクラス（動画広告）
class AdmobInterstitialWidget {
  static final AdmobInterstitialWidget _instance =
      AdmobInterstitialWidget._internal();

  InterstitialAd? _interstitialAd;

  factory AdmobInterstitialWidget() {
    return _instance;
  }

  AdmobInterstitialWidget._internal();

  /// インタースティシャル広告をロードする
  void loadAd() {
    InterstitialAd.load(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/5135589807'
          : 'ca-app-pub-8594832520315352/3809545891',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // 広告が正常にロードされたときに呼ばれます。
        onAdLoaded: (InterstitialAd ad) {
          if (kDebugMode) {
            print('🤖 >> interstitial ad loaded');
          }
          _interstitialAd = ad;
        },
        // 広告のロードが失敗した際に呼ばれます。
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('🤖 >> interstitial ad error: $error');
          }
          _interstitialAd = null;
        },
      ),
    );
  }

  /// 広告を表示する
  /// onAdShowedFullScreenContent: 広告が表示されたときに呼ばれる
  /// onAdDismissedFullScreenContent: 広告が閉じられたときに呼ばれる
  Future<void> showAd(
      {Function(dynamic)? onAdShowedFullScreenContent,
      Function(dynamic)? onAdDismissedFullScreenContent}) async {
    if (_interstitialAd == null) {
      if (kDebugMode) {
        print('🤖 >> Warning: attempt to show interstitial before loaded.');
      }
      loadAd();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        if (kDebugMode) {
          print("🤖 >> interstitial ad onAdShowedFullscreen");
        }
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        if (kDebugMode) {
          print("🤖 >> interstitial ad Disposed");
        }
        ad.dispose();
        loadAd();
        onAdDismissedFullScreenContent;
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError adError) {
        if (kDebugMode) {
          print('🤖 >> $ad OnAdFailed $adError');
        }
        ad.dispose();
        loadAd();
      },
    );

    // 広告の表示には.show()を使う
    await _interstitialAd!.show();
    _interstitialAd = null;
  }
}
