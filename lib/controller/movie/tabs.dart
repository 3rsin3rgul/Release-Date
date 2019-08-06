import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'movie.dart';

class MovieTab extends StatelessWidget {
  const MovieTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MovieTabApp();
  }
}

class MovieTabApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieTabState();
  }
}

class MovieTabState extends State<MovieTabApp> {
  BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? "ca-app-pub-3880549918490153/6939948373"
        : 'ca-app-pub-3880549918490153/6294609797',
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
        length: 10,
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
                indicatorColor: Colors.white30,
                labelColor: Colors.white30,
                tabs: [
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                  Tab(
                    child: Icon(
                      Icons.local_movies,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ),
                ],
              )),
          body: TabBarView(
            children: [
              Movie(
                "1",
              ),
              Movie(
                "2",
              ),
              Movie(
                "3",
              ),
              Movie(
                "4",
              ),
              Movie(
                "5",
              ),
              Movie(
                "6",
              ),
              Movie(
                "7",
              ),
              Movie(
                "8",
              ),
              Movie(
                "9",
              ),
              Movie(
                "10",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
