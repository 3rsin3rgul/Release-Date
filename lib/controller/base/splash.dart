import 'dart:async';
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  MobileAdEvent event;

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: Platform.isAndroid
        ? "ca-app-pub-3880549918490153/3000703364"
        : "ca-app-pub-3880549918490153/7165425063",
    listener: (MobileAdEvent event) {},
  );

  checkState(MobileAdEvent event) {
    if (event == MobileAdEvent.closed) {
      startTime();
    } else if (event == MobileAdEvent.failedToLoad) {
      startTime();
    } else if (event == MobileAdEvent.clicked) {
      startTime();
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    myInterstitial.listener =
        (MobileAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == MobileAdEvent.closed) {
        checkState(event);
      } else if (event == MobileAdEvent.failedToLoad) {
        checkState(event);
      }
    };

    String admobId = Platform.isAndroid
        ? 'ca-app-pub-3880549918490153~3407117226'
        : 'ca-app-pub-3880549918490153~4874303643';

    FirebaseAdMob.instance.initialize(appId: admobId);
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Center(
        child: new Image.asset(
          'icon/icon.png',
          width: MediaQuery.of(context).size.width - 100,
        ),
      ),
    );
  }
}
