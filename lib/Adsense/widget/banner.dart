import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobBannerWidget extends StatelessWidget {
  const AdmobBannerWidget({super.key, this.onLoaded});

  final VoidCallback? onLoaded;

  @override
  Widget build(BuildContext context) {
    final adUnitId = kDebugMode
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-8594832520315352/5532590056';
    final deviceWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraint) {
      return HookBuilder(builder: (context) {
        final bannerLoaded = useState(false);
        final bannerAd = useFuture(
          useMemoized(
            () async {
              final adWidth = constraint.maxWidth.truncate();
              final adSize = await AdSize.getAnchoredAdaptiveBannerAdSize(
                MediaQuery.of(context).orientation,
                adWidth,
              ) as AdSize;
              return BannerAd(
                size: adSize,
                adUnitId: adUnitId,
                listener: BannerAdListener(
                  onAdFailedToLoad: (ad, error) {
                    if (kDebugMode) {
                      print("🤖 banner >> onAdFailedToLoad: $error");
                    }
                    ad.dispose();
                    bannerLoaded.value = false;
                  },
                  onAdLoaded: (ad) {
                    if (kDebugMode) {
                      print("🤖 banner >> onAdLoaded");
                    }
                    bannerLoaded.value = true;
                    onLoaded?.call();
                  },
                ),
                request: const AdRequest(),
              );
            },
          ),
        ).data;

        if (bannerAd == null) {
          return SizedBox(
            height: deviceWidth.toInt() * 50 / 320,
          );
        }

        useEffect(() {
          bannerAd.load();
          return () async => await bannerAd.dispose();
        }, [bannerAd]);

        return bannerLoaded.value
            ? Container(
                color: Colors.white,
                width: bannerAd.size.width.toDouble(),
                height: bannerAd.size.height.toDouble(),
                child: AdWidget(ad: bannerAd),
              )
            : SizedBox(
                height: deviceWidth.toInt() * 50 / 320,
              );
      });
    });
  }
}
