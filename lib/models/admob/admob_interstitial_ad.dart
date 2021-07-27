import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

const int maxFailedLoadAttemps = 3;

class AdmobInterstitialAd {
  late InterstitialAd? _interstitialAd;
  late VoidCallback? _onLoaded;
  late VoidCallback? _onDismissed;
  late VoidCallback? _onFailedToLoad;
  late String _adUnitId;
  int _numLoadAttemps = 0;

  AdmobInterstitialAd(String adUnitId,
      {VoidCallback? onLoaded,
      VoidCallback? onDismissed,
      VoidCallback? onFailedToLoad}) {
    this._adUnitId = adUnitId;
    this._onLoaded = onLoaded;
    this._onDismissed = onDismissed;
    this._onFailedToLoad = onFailedToLoad;
  }

  void dispose() {
    _interstitialAd!.dispose();
  }

  Future<void> waitUntilReady() async {
    print('wait until ready');
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    await Future.doWhile(() async {
      print('stopwatch = ${stopwatch.elapsed}');
      await Future.delayed(Duration(milliseconds: 100));
      return Future<bool>(() {
        return _interstitialAd == null;
      });
    });
  }

  Future<void> load() {
    print("load interstitial ad");
    return InterstitialAd.load(
        adUnitId: this._adUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('InterstitialAd loaded.');
            this._interstitialAd = ad;
            _numLoadAttemps = 0;
            this._onLoaded!();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
            _numLoadAttemps++;
            _interstitialAd = null;
            if (_numLoadAttemps <= maxFailedLoadAttemps) {
              load();
            } else {
              this._onFailedToLoad!();
            }
          },
        ));
  }

  void show() {
    if (_interstitialAd == null) {
      print('not initialized');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        load();
        _onDismissed!();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        load();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
