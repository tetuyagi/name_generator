import 'package:flutter/material.dart';
import 'package:name_generator/models/admob/admob_interstitial_ad.dart';
import 'package:name_generator/models/admob/admob_rewarded_ad.dart';
import 'package:name_generator/models/admob/admob_banner_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: import_of_legacy_library_into_null_safe

import 'package:name_generator/models/name_builder.dart';
import 'package:name_generator/models/admob/ad_manager.dart';
import 'package:name_generator/models/constants.dart';

const int generateNumber = 10;
final ButtonStyle buttonStyle = TextButton.styleFrom(primary: Colors.white);

class RandomWordsView extends StatefulWidget {
  final String titleName;
  RandomWordsView({Key? key, required this.titleName}) : super(key: key);

  @override
  _RandomWordsViewState createState() => _RandomWordsViewState();
}

class _RandomWordsViewState extends State<RandomWordsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _suggestions = <String>[];
  final _saved = Set<String>();

  final _builder = NameBuilder();

  //late BannerAd _bannerAd;
  //late InterstitialAd _interstitialAd;

  //late bool _isInterstitialAdReady;
  //late bool _isRewardedAdReady;
  AdmobInterstitialAd? _interstitialAd;
  AdmobBannerAd? _bannerAd;
  AdmobRewardedAd? _rewardedAd;

  //初期化
  @override
  void initState() {
    print("init random words widget state");
    super.initState();

    AdManager.initialize();
    String interstitialAdUnitId = AdManager.interstitialAdUnitId;
    _interstitialAd = new AdmobInterstitialAd(interstitialAdUnitId);
    _interstitialAd!.load();

    String bannerAdUnitId = AdManager.bannerAdUnitId;
    _bannerAd = AdmobBannerAd(bannerAdUnitId, size: AdSize.banner);
    _bannerAd!.load();

    String rewardedAdUnitId = AdManager.rewardedAdUnitId;
    _rewardedAd = AdmobRewardedAd(rewardedAdUnitId);
  }

  //終了処理
  void dispose() {
    //_bannerAd.dispose();
    //_interstitialAd.dispose();
    //RewardedVideoAd.instance.listener = null;
    _interstitialAd!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text(widget.titleName), actions: [
          TextButton(
            child: const Text('Interstitial'),
            onPressed: () {
              _onClickedInterstitialButton();
            },
            style: buttonStyle,
          ),
          TextButton(
            child: const Text('Rewarded'),
            onPressed: () {
              _onClickedRewardedButton();
            },
            style: buttonStyle,
          ),
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ]),
        body: SafeArea(
            child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
              _buildSuggestions(),
              Container(
                child: AdWidget(ad: _bannerAd!.ad),
                width: _bannerAd!.ad.size.width.toDouble(),
                height: _bannerAd!.ad.size.height.toDouble(),
              ),
            ])));
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
          style: biggerFont,
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

  void _moveToHome() {
    Navigator.pushNamedAndRemoveUntil(
        _scaffoldKey.currentContext!, '/', (_) => false);
  }

  void _showDialog(RewardItem reward) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Got Reward!"),
            content:
                Text('you got reward item :   ${reward.amount} ${reward.type}'),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  //button events

  Future<void> _onClickedInterstitialButton() async {
    print("on clicked interstitial button");
    await _interstitialAd!.waitUntilReady();
    _interstitialAd!.show();
  }

  Future<void> _onClickedRewardedButton() async {
    print("on clicked rewarded button");
    await _rewardedAd!.load();
    //await _rewardedAd!.waitUntilReady();
    _rewardedAd!.show((reward) => _showDialog(reward));
  }

  void _pushSaved() {
    Navigator.of(context).pushNamed('/saved', arguments: _saved);
  }
}
