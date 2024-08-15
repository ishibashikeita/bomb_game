import 'package:bomb_game/Adsense/widget/banner.dart';
import 'package:bomb_game/Adsense/widget/interstitial.dart';
import 'package:bomb_game/Adsense/widget/rectangle.dart';
import 'package:bomb_game/Adsense/widget/reward.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsenseService {
  static Future<void> initialize() async {
    await MobileAds.instance.initialize(); // admobを有効にする
    // 動画広告のロード（インステ・リワード）
    AdmobInterstitialWidget().loadAd();
    AdmobRewardWidget().loadAd();
  }

  /// バナーを表示する
  static Widget showBanner() {
    return const AdmobBannerWidget();
  }

  /// レクタングルを表示する
  static Widget showRectangle() {
    return const AdmobRectangleWidget();
  }

  /// インステ広告を表示する
  static void showInterstitialVideo({
    Function(dynamic)? onAdShowed,
    Function(dynamic)? onAdDismissed,
  }) async {
    await AdmobInterstitialWidget().showAd(
      onAdShowedFullScreenContent: onAdShowed,
      onAdDismissedFullScreenContent: onAdDismissed,
    );
  }

  static void showRewardedVideo({
    Function(dynamic)? onAdShowed,
    Function(dynamic)? onUserEarnedReward,
    Function(dynamic)? onAdDismissed,
    Function(dynamic)? onAdFailedToShow,
  }) {
    AdmobRewardWidget().showAd(
      onAdShowedFullScreenContent: onAdShowed,
      onUserEarnedReward: onUserEarnedReward,
      onAdDismissedFullScreenContent: onAdDismissed,
      onAdFailedToShowFullScreenContent: onAdFailedToShow,
    );
  }
}
