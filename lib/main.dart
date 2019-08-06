import 'package:ReleaseDate/controller/base/splash.dart';
import 'package:ReleaseDate/helpers/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'controller/base/base.dart';
import 'models/games/game.dart';
import 'models/games/release_date.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new Splash(),
    routes: <String, WidgetBuilder>{
      '/HomeScreen': (BuildContext context) => new MyApp()
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var db = DatabaseHelper();
  final List<Game> _gameList = <Game>[];
  final List<ReleaseDateSQL> _releaseDate = <ReleaseDateSQL>[];

  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _showDailyAtTime();
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: const Text('Here is your payload'),
              content: new Text("Payload : $payload"),
            ));
  }

  Future<void> _showDailyAtTime() async {
    var time = new Time(12, 00, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'Hey There!',
        'Did you check new games, movies and books',
        Day.Sunday,
        time,
        platformChannelSpecifics);
  }

  checkGameDate() async {
    List sqlGames = await db.getFavoriteGames();
    sqlGames.forEach((games) {
      setState(() {
        _gameList.add(Game.map(games));
      });
    });

    _gameList.forEach((game) async {
      List sqlReleaseDate =
          await db.getFavoriteGamesWithOtherData(game.id, "releaseDate");
      sqlReleaseDate.forEach((releaseDate) {
        setState(() {
          print(releaseDate);
          _releaseDate.add(ReleaseDateSQL.map(releaseDate));
        });
      });
    });

    _releaseDate.forEach((releaseDate) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      releaseDate.human == formattedDate
          ? print("DATE IS NOT EQUAL")
          : print("DATE IS NOT EQUAL");
    });
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyTabApp();
  }
}
