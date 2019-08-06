import 'package:ReleaseDate/controller/favorites/tabs.dart';
import 'package:ReleaseDate/controller/game/tabs.dart';
import 'package:ReleaseDate/controller/movie/tabs.dart';
import 'package:flutter/material.dart';

class MyTabApp extends StatelessWidget {
  MyTabApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Release Date',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Key keyOne = PageStorageKey('pageOne');
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');
  final Key keyFour = PageStorageKey('pageFour');
  double size;

  int currentTab = 0;
  HomeTab one;
  MovieTab two;
  // BookTab three;
  FavoriteTab four;
  List<Widget> pages;
  Widget currentPage;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    one = HomeTab(key: keyOne);
    two = MovieTab(key: keyTwo);
    // three = BookTab(key: keyThree);
    four = FavoriteTab(key: keyFour);
    pages = [one, two, four];
    currentPage = one;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            title: Text('Games'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            title: Text("Movies"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Favorites"),
          ),
        ],
      ),
    );
  }
}
