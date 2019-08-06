import 'package:ReleaseDate/controller/movie/details.dart';
import 'package:ReleaseDate/helpers/db_helper.dart';
import 'package:ReleaseDate/models/movies/movies.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FavoriteMovie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FavoriteMovieState();
}

final notesReference = FirebaseDatabase.instance.reference();

class FavoriteMovieState extends State<FavoriteMovie> {
  List<Movies> movies;
  var db = new DatabaseHelper();
  final List<Movies> _movieList = <Movies>[];

  @override
  void initState() {
    super.initState();
    movies = new List();
    getSqlMovies();
  }

  getSqlMovies() async {
    List sqlMovies = await db.getFavoriteMovies();
    sqlMovies.forEach((movies) {
      setState(() {
        _movieList.add(Movies.map(movies));
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
      itemCount: _movieList.length,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: GestureDetector(
            onTap: () {
              _navigateToNote(context, _movieList[index]);
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
                        "http://image.tmdb.org/t/p/w185/${_movieList[index].posterpath}",
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
          "Plase add movies on your favorites",
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_movieList.length == 0) {
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

  void _navigateToNote(BuildContext context, Movies movies) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MoviePageDetail(movies)),
    );
  }
}
