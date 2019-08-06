import 'package:ReleaseDate/models/movies/movies.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'details.dart';

class Movie extends StatefulWidget {
  final String month;
  Movie(this.month);
  @override
  State<StatefulWidget> createState() => new MovieState();
}

final notesReference = FirebaseDatabase.instance.reference();

class MovieState extends State<Movie> {
  List<Movies> items;
  List item = [];
  List _list = [];

  @override
  void initState() {
    super.initState();
    notesReference
        .child("movies")
        .child("2019")
        .child("${widget.month}")
        .child("movies")
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

  gridBuilder(int value, int axis) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: axis,
          childAspectRatio: MediaQuery.of(context).size.height / value),
      itemCount: item.length,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: GestureDetector(
            onTap: () {
              var movie = Movies.mapForDetail(item[index]);
              _navigateToNote(context, movie);
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
                      child: item[index]['poster_path'] != null
                          ? Image.network(
                              "http://image.tmdb.org/t/p/w185/${item[index]['poster_path']}",
                              fit: BoxFit.cover,
                              height: 300,
                              width: 300,
                            )
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

  void _navigateToNote(BuildContext context, Movies note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MoviePageDetail(note)),
    );
  }
}
