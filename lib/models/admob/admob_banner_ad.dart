import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';

const int maxFailedLoadAttemps = 3;

class AdmobBannerAd {
  late BannerAd? _bannerAd;
  late VoidCallback? _onLoaded;
  late VoidCallback? _onFailedToLoad;
  late VoidCallback? _onOpened;
  late VoidCallback? _onClosed;
  late String _adUnitId = "";

  AdmobBannerAd(String adUnitId,
      {AdSize size = AdSize.banner,
      VoidCallback? onLoaded,
      VoidCallback? onFailedToLoad,
      VoidCallback? onOpened,
      VoidCallback? onClosed}) {
    this._adUnitId = adUnitId;
    this._onLoaded = onLoaded;
    this._onFailedToLoad = onFailedToLoad;
    this._onOpened = onOpened;
    this._onClosed = onClosed;

    _bannerAd = BannerAd(
      size: size,
      request: AdRequest(),
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          this._onLoaded!();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          this._onFailedToLoad!();
        },
        onAdOpened: (Ad ad) {
          print('$BannerAd onAdOpend.');
          this._onOpened!();
        },
        onAdClosed: (Ad ad) {
          print('$BannerAd onAdClosed.');
          this._onClosed!();
        },
      ),
    );
  }

  BannerAd get ad {
    return _bannerAd!;
  }

  void dispose() {
    _bannerAd!.dispose();
  }

  Future<void> load() {
    return _bannerAd!.load();
  }
}
