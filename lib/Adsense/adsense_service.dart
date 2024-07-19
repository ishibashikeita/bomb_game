import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsenseService {
  static final AdsenseService _instance = AdsenseService._internal();
  factory AdsenseService() {
    return _instance;
  }

  AdsenseService._internal();

  AdManagerBannerAd? _bannerAd;
  AdManagerBannerAd? _rectangleAd;
  InterstitialAd? _interstitialAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool _isBannerAdLoaded = false;
  bool _isRectangleAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedInterstitialAdLoaded = false;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await _loadBannerAd();
    await _loadRectangleAd();
    await _loadInterstitialAd();
    await _loadRewardedInterstitialAd();
  }

  Future<void> _loadBannerAd() async {
    _bannerAd = AdManagerBannerAd(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-8594832520315352/5532590056',
      sizes: [AdSize.banner],
      request: AdManagerAdRequest(),
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner ad loaded: ${ad.adUnitId}');
          _isBannerAdLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Banner ad failed to load: $error');
        },
      ),
    );
    await _bannerAd!.load();
  }

  Future<void> _loadRectangleAd() async {
    _rectangleAd = AdManagerBannerAd(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-8594832520315352/5532590056',
      sizes: [AdSize.mediumRectangle],
      request: AdManagerAdRequest(),
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Rectangle ad loaded: ${ad.adUnitId}');
          _isRectangleAdLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Rectangle ad failed to load: $error');
        },
      ),
    );
    await _rectangleAd!.load();
  }

  Future<void> _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-8594832520315352/2934735716',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Interstitial ad loaded: ${ad.adUnitId}');
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          _isInterstitialAdLoaded = false;
        },
      ),
    );
  }

  Future<void> _loadRewardedInterstitialAd() async {
    await RewardedInterstitialAd.load(
      adUnitId: kDebugMode
          ? 'ca-app-pub-3940256099942544/5354046379'
          : 'ca-app-pub-8594832520315352/4468752511',
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          print('Rewarded Interstitial ad loaded: ${ad.adUnitId}');
          _rewardedInterstitialAd = ad;
          _isRewardedInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Rewarded Interstitial ad failed to load: $error');
          _isRewardedInterstitialAdLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdLoaded = false;
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }

  void showRewardedInterstitialAd() {
    if (_isRewardedInterstitialAdLoaded && _rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
          ad.dispose();
          _loadRewardedInterstitialAd();
        },
        onAdFailedToShowFullScreenContent:
            (RewardedInterstitialAd ad, AdError error) {
          ad.dispose();
          _loadRewardedInterstitialAd();
        },
      );
      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: ${reward.amount}');
        },
      );
      _rewardedInterstitialAd = null;
      _isRewardedInterstitialAdLoaded = false;
    } else {
      print('Rewarded Interstitial ad is not ready yet.');
    }
  }

  Widget getBannerAdWidget() {
    if (_isBannerAdLoaded && _bannerAd != null) {
      final adWidget = AdWidget(ad: _bannerAd!);
      return Container(
        alignment: Alignment.center,
        child: adWidget,
        width: _bannerAd!.sizes[0].width.toDouble(),
        height: _bannerAd!.sizes[0].height.toDouble(),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: AdSize.banner.width.toDouble(),
        height: AdSize.banner.height.toDouble(),
        child: const CircularProgressIndicator(),
      );
    }
  }

  Widget getRectangleAdWidget() {
    if (_isRectangleAdLoaded && _rectangleAd != null) {
      final adWidget = AdWidget(ad: _rectangleAd!);
      return Container(
        alignment: Alignment.center,
        child: adWidget,
        width: _rectangleAd!.sizes[0].width.toDouble(),
        height: _rectangleAd!.sizes[0].height.toDouble(),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: AdSize.mediumRectangle.width.toDouble(),
        height: AdSize.mediumRectangle.height.toDouble(),
        child: const CircularProgressIndicator(),
      );
    }
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded = false;
  }

  void disposeRectangleAd() {
    _rectangleAd?.dispose();
    _rectangleAd = null;
    _isRectangleAdLoaded = false;
  }

  Future<void> reloadBannerAd() async {
    disposeBannerAd();
    await _loadBannerAd();
  }

  Future<void> reloadRectangleAd() async {
    disposeRectangleAd();
    await _loadRectangleAd();
  }
}
