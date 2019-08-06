import 'package:ReleaseDate/controller/favorites/details.dart';
import 'package:ReleaseDate/helpers/db_helper.dart';
import 'package:ReleaseDate/models/games/game.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FavoriteGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FavoriteGameState();
}

final notesReference = FirebaseDatabase.instance.reference();

class FavoriteGameState extends State<FavoriteGame> {
  List<Game> games;
  var db = new DatabaseHelper();
  final List<Game> _gameList = <Game>[];

  @override
  void initState() {
    super.initState();
    games = new List();
    getSqlGames();
  }

  getSqlGames() async {
    List sqlGames = await db.getFavoriteGames();
    sqlGames.forEach((games) {
      setState(() {
        _gameList.add(Game.map(games));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  gridBuilder(int value, int axis) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: axis,
          childAspectRatio: MediaQuery.of(context).size.height / value),
      itemCount: _gameList.length,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: GestureDetector(
            onTap: () {
              _navigateToNote(context, _gameList[index]);
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
                      child: Image.network(
                        "https://images.igdb.com/igdb/image/upload/t_cover_small_2x/${_gameList[index].imageCoverId}.jpg",
                        fit: BoxFit.cover,
                        height: 300,
                        width: 300,
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

  emptyWidget() {
    return SizedBox(
      child: Center(
        child: Text(
          "Plase add games on your favorites",
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_gameList.length == 0) {
      return emptyWidget();
    } else {
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
  }

  void _navigateToNote(BuildContext context, Game note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoriteNoteScreen(note)),
    );
  }
}
