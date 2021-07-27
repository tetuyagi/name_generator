import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static const String _androidTestAppId = "";

  static const String _androidAppId = "ca-app-pub-5461091111350349~4799262895";
  static const String _iosAppId = "";

  static const String _androidTestBannerAdUnitId =
      "ca-app-pub-3940256099942544/6300978111";
  static const String _androidTestInterstitialAdUnitId =
      "ca-app-pub-3940256099942544/1033173712";
  static const String _androidTestRewardedAdUnitId =
      "ca-app-pub-3940256099942544/5224354917";

  static const String _iosTestBannerAdUnitId = "";
  static const String _iosTestInterstitialAdUnitId = "";
  static const String _iosTestRewardedAdUnitId = "";

  static const String _androidBannerAdUnitId =
      "ca-app-pub-5461091111350349/9109208845";
  static const String _androidInterstitialAdUnitId =
      "ca-app-pub-5461091111350349/8128967962";
  static const String _androidRewardedAdUnitId =
      "ca-app-pub-5461091111350349/3315624988";

  static void initialize() {
    MobileAds.instance.initialize();
  }

  static String get appId {
    if (Platform.isAndroid) {
      return _androidAppId;
    } else if (Platform.isIOS) {
      return _iosAppId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _androidTestBannerAdUnitId;
    } else if (Platform.isIOS) {
      return _iosTestBannerAdUnitId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _androidTestInterstitialAdUnitId;
    } else if (Platform.isIOS) {
      return _iosTestInterstitialAdUnitId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return _androidTestRewardedAdUnitId;
    } else if (Platform.isIOS) {
      return _iosTestRewardedAdUnitId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
