import 'package:ReleaseDate/helpers/db_helper.dart';
import 'package:ReleaseDate/models/games/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'details.dart';

class Home extends StatefulWidget {
  final String month;
  Home(this.month);
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State<Home> {
  List item = [];
  List _list = [];
  var isLargeScreen = false;
  var db = new DatabaseHelper();
  final List<Game> _gameList = <Game>[];

  var notesReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();

    _readGameList();
    notesReference
        .child("games")
        .child("2019")
        .child("${widget.month}")
        .child("games")
        .once()
        .then((DataSnapshot snapshot) {
      _list = snapshot.value;
      _list.forEach((movie) {
        setState(() {
          item.add(movie);
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _readGameList() async {
    List games = await db.getGames();
    games.forEach((game) {
      setState(() {
        _gameList.add(Game.map(game));
      });
    });
  }

  gridBuilder(int value, int axis) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: axis,
          childAspectRatio: (MediaQuery.of(context).size.height) / value),
      itemCount: item.length,
      padding: EdgeInsets.only(top: 10.0, bottom: 30, right: 10, left: 10),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: GestureDetector(
            onTap: () {
              var game = Game.mapForDetail(item[index]);
              _navigateToNote(context, game);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: item[index]['cover'] != null
                          ? CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 300,
                              placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                              width: 300,
                              imageUrl:
                                  "https://images.igdb.com/igdb/image/upload/t_cover_small_2x/${item[index]['cover']['image_id']}.jpg")
                          : Image.asset(
                              'assets/noimageavailable.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.all(2.0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 400) {
      return Scaffold(
          resizeToAvoidBottomPadding: false, body: gridBuilder(900, 2));
    } else {
      return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: MediaQuery.of(context).size.width > 600
              ? gridBuilder(1200, 3)
              : gridBuilder(1100, 2));
    }
  }

  void _navigateToNote(BuildContext context, Game note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );
  }
}
