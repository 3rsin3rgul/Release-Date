import 'dart:convert';

import 'package:ReleaseDate/helpers/db_helper.dart';
import 'package:ReleaseDate/models/movies/movies-videos.dart';
import 'package:ReleaseDate/models/movies/movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MoviePageDetail extends StatefulWidget {
  final Movies note;
  MoviePageDetail(this.note);
  @override
  State<StatefulWidget> createState() => new _MoviePageDetailState();
}

class _MoviePageDetailState extends State<MoviePageDetail> {
  MovieVideos movieVideos;
  var db = new DatabaseHelper();
  var isFavorited;

  @override
  void initState() {
    super.initState();
    _makeGetRequest(widget.note.id.toString());
    getSqlGames();
  }

  getSqlGames() async {
    Movies dbMovie = await db.getFavoriteMovie(widget.note.id);
    dbMovie != null ? isFavorited = true : isFavorited = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _makeGetRequest(String url) async {
    var response =
        'http://api.themoviedb.org/3/movie/$url/videos?api_key=45cb6da2e9d2aa49ad58ba63aac2b1a4';

    var res = await http
        .get(Uri.encodeFull(response), headers: {"Accept": "application/json"});
    var responsBody = json.decode(res.body);
    setState(() {
      var mv = MovieVideos.fromJson(responsBody);
      movieVideos = mv;
    });
    return responsBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      coverImage(),
                      gameTitle(),
                      gameReleaseDate(),
                      gameSummary(),
                      movieVideos != null ? gameVideoSizedBox() : Text(''),
                      movieVideos != null ? gameVideo(context) : Text(''),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          child: Icon(Icons.share),
                          onPressed: () {
                            Share.share(
                                'Check out this movie :) ${widget.note.title}');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  gameReleaseDate() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            Text(
              'In theater: ${widget.note.releasedate}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  coverImage() {
    return Align(
      alignment: Alignment.center,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // A fixed-height child.
            height: 500.0,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: widget.note.posterpath != null
                  ? Image.network(
                      "http://image.tmdb.org/t/p/w500/${widget.note.posterpath}",
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
      ),
    );
  }

  gameTitle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text(
              widget.note.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: widget.note.popularity != null
                          ? Text(
                              '${widget.note.popularity}',
                              style: TextStyle(fontSize: 17),
                            )
                          : Text(
                              'No Pulse :(',
                              style: TextStyle(fontSize: 15),
                            ),
                    )
                  ],
                ),
                isFavorited == true
                    ? FlatButton(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text('Remove Favorite'),
                            )
                          ],
                        ),
                        onPressed: () {
                          removeFavorite(widget.note);
                        },
                      )
                    : FlatButton(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text("Add Favorite"))
                          ],
                        ),
                        onPressed: () {
                          addFavorite(widget.note);
                        },
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  removeFavorite(Movies movies) {
    db.deleteMovie(movies.id);
    setState(() {
      isFavorited = false;
    });
  }

  addFavorite(Movies movies) {
    db.addFavoriteMovie(movies);
    setState(() {
      isFavorited = true;
    });
  }

  gameSummary() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          widget.note.overview,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16.0, color: Colors.white60),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  gameVideoSizedBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 30,
        child: Row(
          children: <Widget>[
            Text(
              '* Press image for watch trailer.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  gameVideo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.width > 600
            ? (MediaQuery.of(context).size.height / 2)
            : (MediaQuery.of(context).size.height / 3.5),
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movieVideos.results.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 0, bottom: 0),
              child: GestureDetector(
                onTap: () {
                  _launchURL(
                      'https://www.youtube.com/watch?v=${movieVideos.results[index]['key']}');
                },
                child: new Image.network(
                  "https://img.youtube.com/vi/${movieVideos.results[index]['key']}/0.jpg",
                  fit: BoxFit.cover,
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
