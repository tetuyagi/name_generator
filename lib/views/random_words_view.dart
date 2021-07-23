import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_admob/firebase_admob.dart';

import 'package:name_generator/models/name_builder.dart';
import 'package:name_generator/models/ad_manager.dart';

const double fontSize = 18.0;
const int generateNumber = 10;

class RandomWordsWidget extends StatefulWidget {
  final String titleName;
  RandomWordsWidget({Key? key, required this.titleName}) : super(key: key);

  @override
  _RandomWordsWidgetState createState() => _RandomWordsWidgetState();
}

class _RandomWordsWidgetState extends State<RandomWordsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _suggestions = <String>[];
  final _saved = Set<String>();
  final _biggerFont = TextStyle(fontSize: fontSize);
  final _builder = NameBuilder();

  late BannerAd _bannerAd;
  late InterstitialAd _interstitialAd;

  late bool _isInterstitialAdReady;
  late bool _isRewardedAdReady;

  //初期化
  @override
  void initState() {
    print("init random words widget state");
    super.initState();

    //バナー広告初期化
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );

    _loadBannerAd();

    //インタースティシャル広告初期化
    _isInterstitialAdReady = false;
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    _loadInterstitialAd();

    //リワード広告初期化
    _isRewardedAdReady = false;
    RewardedVideoAd.instance.listener = _onRewardedAdEvent;
    _loadRewardedAd();
  }

  //終了処理
  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    RewardedVideoAd.instance.listener = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text(widget.titleName), actions: [
          FlatButton(
            child: const Text('Interstitial'),
            onPressed: () {
              _onClickedInterstitialButton();
            },
          ),
          FlatButton(
              child: const Text('Rewarded'),
              onPressed: () {
                _onClickedRewardedButton();
              }),
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ]),
        body: FutureBuilder<void>(
            future: _initAdMob(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return _buildSuggestions();
            }));
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(_builder.buildWords(generateNumber));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(String word) {
    final alreadySaved = _saved.contains(word);
    return ListTile(
        title: Text(
          word,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(word);
            } else {
              _saved.add(word);
            }
          });
        });
  }

  //AdMobの初期化
  Future<void> _initAdMob() {
    // Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  //バナーのロードと表示
  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _loadRewardedAd() {
    RewardedVideoAd.instance.load(
      targetingInfo: MobileAdTargetingInfo(),
      adUnitId: AdManager.rewardedAdUnitId,
    );
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        //_isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        _moveToHome();
        break;
      default:
        break;
    }
  }

  void _onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType = "", int rewardAmount = 0}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          print("rewarded ad loaded");
          _isRewardedAdReady = true;
        });
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          //_isRewardedAdReady = false;
        });
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          print("rewarded ad failed to load");
          //_isRewardedAdReady = false;
        });
        break;
      case RewardedVideoAdEvent.rewarded:
        print("rewarded!");
        break;

      default:
        break;
    }
  }

  void _moveToHome() {
    Navigator.pushNamedAndRemoveUntil(
        _scaffoldKey.currentContext!, '/', (_) => false);
  }

  //button events

  void _onClickedInterstitialButton() {
    print("on clicked interstitial button");
    if (_isInterstitialAdReady == true) {
      print("show interstitial ad");
      _interstitialAd.show();
    }
  }

  void _onClickedRewardedButton() {
    print("on clicked rewarded button");
    if (_isRewardedAdReady == true) {
      print("show rewarded ad");
      RewardedVideoAd.instance.show();
    } else {
      print("reward ad is not ready");
    }
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        final tiles = _saved.map((String word) {
          return ListTile(
              title: Text(
            word,
            style: _biggerFont,
          ));
        });
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          body: ListView(children: divided),
        );
      }),
    );
  }
}
