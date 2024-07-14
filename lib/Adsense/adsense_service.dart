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
  bool _isBannerAdLoaded = false;
  bool _isRectangleAdLoaded = false;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await _loadBannerAd();
    await _loadRectangleAd();
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

  Widget getBannerAdWidget() {
    if (_isBannerAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
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
      return Container(
        alignment: Alignment.center,
        child: AdWidget(ad: _rectangleAd!),
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
}
