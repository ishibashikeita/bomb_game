import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// リワード広告を表示するためのクラス（動画広告）
class AdmobRewardWidget {
  static final AdmobRewardWidget _instance = AdmobRewardWidget._internal();

  RewardedAd? _rewardedAd;

  factory AdmobRewardWidget() {
    return _instance;
  }

  AdmobRewardWidget._internal();

  /// リワード広告をロードする
  void loadAd() {
    RewardedAd.load(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-8594832520315352/5417671847',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // 広告が正常にロードされたときに呼ばれます。
        onAdLoaded: (RewardedAd ad) {
          if (kDebugMode) {
            print('🤖 >> rewarded ad loaded');
          }
          _rewardedAd = ad;
        },
        // 広告のロードが失敗した際に呼ばれます。
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('🤖 >> rewarded ad error : $error');
          }
          _rewardedAd = null;
        },
      ),
    );
  }

  /// リワード広告を表示する
  /// onAdShowedFullScreenContent: 広告が表示されたときに呼ばれる
  /// onUserEarnedReward: リワードを受け取ったときに呼ばれる
  /// onAdDismissedFullScreenContent: 広告が閉じられたときに呼ばれる
  /// それぞれのFunctionの引数は、必要なデータ型に指定してね！ただし使う目的のない場合はそのままでもOK！voidにすると上手く動かなくなる
  Future<void> showAd({
    Function(dynamic)? onAdShowedFullScreenContent,
    Function(dynamic)? onUserEarnedReward,
    Function(dynamic)? onAdDismissedFullScreenContent,
    Function(dynamic)? onAdFailedToShowFullScreenContent,
  }) async {
    if (_rewardedAd == null) {
      if (kDebugMode) {
        print('🤖 >> Warning: attempt to show rewarded before loaded.');
      }
      loadAd();
      if (onAdFailedToShowFullScreenContent != null) {
        onAdFailedToShowFullScreenContent(true);
      }
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        if (kDebugMode) {
          print("🤖 >> rewarded ad onAdShowedFullscreen");
        }
        if (onAdShowedFullScreenContent != null) {
          onAdShowedFullScreenContent(true);
        }
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        if (kDebugMode) {
          print("🤖 >> rewarded ad Disposed");
        }
        loadAd();
        ad.dispose();
        if (onAdDismissedFullScreenContent != null) {
          onAdDismissedFullScreenContent(true);
        }
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        if (kDebugMode) {
          print('🤖 >> $ad OnAdFailed $error');
        }
        loadAd();
        ad.dispose();
        if (onAdFailedToShowFullScreenContent != null) {
          onAdFailedToShowFullScreenContent(true);
        }
      },
    );

    // 広告の表示には.show()を使う
    await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      if (kDebugMode) {
        print('🤖 >> rewarded onUserEarnedReward');
      }
      if (onUserEarnedReward != null) {
        onUserEarnedReward(true);
      }
      _rewardedAd = null;
    });
  }
}
