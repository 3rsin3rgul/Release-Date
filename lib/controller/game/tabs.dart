import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeTabApp();
  }
}

class HomeTabApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeTabState();
  }
}

class HomeTabState extends State<HomeTabApp> {
  BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid ? "" : '',
    size: AdSize.banner,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  double getSmartBannerHeight(MediaQueryData mediaQuery) {
    if (Platform.isAndroid) {
      if (mediaQuery.size.height > 720) return 90.0;
      if (mediaQuery.size.height > 400) return 50.0;
      return 32.0;
    }
    if (Platform.isIOS) {
      if (mediaQuery.orientation == Orientation.portrait) return 50.0;
      return 32.0;
    }
    return 50.0;
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      myBanner
        ..load()
        ..show(
          anchorOffset: 50.0,
          anchorType: AnchorType.bottom,
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: DefaultTabController(
        length: 6,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
              brightness: Brightness.dark,
              centerTitle: true,
              actions: <Widget>[
                Expanded(
                  child: Image.asset(
                    'assets/brand.png',
                    color: Colors.white60,
                    filterQuality: FilterQuality.high,
                    scale: 1.2,
                  ),
                )
              ],
              bottom: TabBar(
                indicatorColor: Colors.white60,
                labelColor: Colors.white60,
                tabs: [
                  Tab(
                    child: Text(
                      'July',
                      style: TextStyle(fontSize: 15, color: Colors.white60),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Aug',
                      style: TextStyle(fontSize: 15, color: Colors.white60),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Sep',
                      style: TextStyle(fontSize: 15, color: Colors.white60),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Oct',
                      style: TextStyle(fontSize: 15, color: Colors.white60),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Nov',
                      style: TextStyle(fontSize: 15, color: Colors.white60),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Dec',
                      style: TextStyle(fontSize: 15, color: Colors.white60),
                    ),
                  ),
                ],
              )),
          body: TabBarView(
            children: [
              Home(
                "7",
              ),
              Home(
                "8",
              ),
              Home(
                "9",
              ),
              Home(
                "10",
              ),
              Home(
                "11",
              ),
              Home(
                "12",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
