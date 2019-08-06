import 'dart:io';
import 'package:ReleaseDate/controller/favorites/favorite_game.dart';
import 'package:ReleaseDate/controller/favorites/favorite_movie.dart';
import 'package:ReleaseDate/helpers/db_helper.dart';
import 'package:ReleaseDate/models/games/game.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoriteTab extends StatelessWidget {
  const FavoriteTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FavoriteTabApp();
  }
}

class FavoriteTabApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavoriteTabState();
  }
}

class FavoriteTabState extends State<FavoriteTabApp> {
  var db = DatabaseHelper();

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

  checkGame() async {
    List sqlGames = await db.getFavoriteGames();
    sqlGames.forEach((games) {
      var gameMap = Game.map(games);
      for (var releaseDate in gameMap.releaseDate) {
        print(releaseDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: DefaultTabController(
        length: 2,
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
                    child: Text(
                      'Games',
                      style: TextStyle(fontSize: 13, color: Colors.white30),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Movies',
                      style: TextStyle(fontSize: 13, color: Colors.white30),
                    ),
                  ),
                ],
              )),
          body: TabBarView(
            children: [
              FavoriteGame(),
              FavoriteMovie(),
            ],
          ),
        ),
      ),
    );
  }
}
