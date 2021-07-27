import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';

const int maxFailedLoadAttemps = 3;

class AdmobRewardedAd {
  RewardedAd? _rewardedAd;
  late VoidCallback? _onLoaded;
  late VoidCallback? _onDismissed;
  late VoidCallback? _onFailedToLoad;
  late String _adUnitId;
  int _numLoadAttemps = 0;

  AdmobRewardedAd(String adUnitId,
      {VoidCallback? onLoaded,
      VoidCallback? onDismissed,
      VoidCallback? onFailedToLoad}) {
    this._adUnitId = adUnitId;
    this._onLoaded = onLoaded;
    this._onDismissed = onDismissed;
    this._onFailedToLoad = onFailedToLoad;
  }

  void dispose() {
    _rewardedAd!.dispose();
  }

  Future<void> load() async {
    print("load rewarded ad");
    return await RewardedAd.load(
        adUnitId: this._adUnitId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            this._rewardedAd = ad;
            _numLoadAttemps = 0;
            this._onLoaded!();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numLoadAttemps++;
            if (_numLoadAttemps <= maxFailedLoadAttemps) {
              load();
            } else {
              this._onFailedToLoad!();
            }
          },
        ));
  }

  Future<void> waitUntilReady() async {
    print('wait until ready');
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    await Future.doWhile(() async {
      print('stopwatch = ${stopwatch.elapsed}');
      await Future.delayed(Duration(milliseconds: 100));
      return Future<bool>(() {
        return _rewardedAd == null;
      });
    });
  }

  void show(void Function(RewardItem reward) onRewarded) {
    if (_rewardedAd == null) {
      print('rewardedAd not ready');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        load();
        _onDismissed!();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        load();
      },
    );
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      onRewarded(reward);
    });
    _rewardedAd = null;
  }
}
