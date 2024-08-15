import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// レクタングルのアドモブを表示するためのクラス
/// アダプティブじゃなくでごめんね
class AdmobRectangleWidget extends StatelessWidget {
  const AdmobRectangleWidget({super.key, this.onLoaded});

  final VoidCallback? onLoaded;

  @override
  Widget build(BuildContext context) {
    final adUnitId = kDebugMode
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-8594832520315352/6947780909';
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context, constraint) {
      return HookBuilder(builder: (context) {
        final bannerLoaded = useState(false);
        final bannerAd = useFuture(
          useMemoized(
            () async {
              final adWidth = 320;
              final adSize =
                  AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
                      adWidth);

              return BannerAd(
                size: AdSize.mediumRectangle,
                adUnitId: adUnitId,
                listener: BannerAdListener(
                  onAdFailedToLoad: (ad, error) {
                    ad.dispose();
                    bannerLoaded.value = false;
                    String domain = error.domain;
                    int code = error.code;
                    String message = error.message;
                    ResponseInfo? responseInfo = error.responseInfo;
                  },
                  onAdLoaded: (ad) {
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
          return const SizedBox(
            height: 250,
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
            : const SizedBox(
                height: 250,
              );
      });
    });
  }
}
