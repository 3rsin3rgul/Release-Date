import 'package:ReleaseDate/helpers/db_helper.dart';
import 'package:ReleaseDate/models/games/release_date.dart';
import 'package:ReleaseDate/models/games/similar_games.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ReleaseDate/models/games/game.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fullscreen_image.dart';
import 'more_details.dart';

class NoteScreen extends StatefulWidget {
  final Game note;
  NoteScreen(this.note);
  @override
  State<StatefulWidget> createState() => new _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  var db = new DatabaseHelper();
  var isFavorited;
  List<ReleaseDate> releaseDates = [];
  List<SimilarGames> similarGamesArray = [];

  @override
  void initState() {
    super.initState();

    for (var x in widget.note.releaseDate) {
      var maps = ReleaseDate.fromJson(x);
      releaseDates.add(maps);
    }

    for (var x in widget.note.similarGames) {
      if (x['cover'] is int) {
        //RETURN FALSE
      } else if (x['cover'] == null) {
        //RETURN FALSE
      } else {
        var similarGames = SimilarGames.fromJson(x);
        similarGamesArray.add(similarGames);
      }
    }

    getSqlGames();
  }

  getSqlGames() async {
    Game dbGame = await db.getGame(widget.note.id);
    dbGame != null ? isFavorited = true : isFavorited = false;
  }

  @override
  void dispose() {
    super.dispose();
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
                      widget.note.imageCoverId == null
                          ? Text('')
                          : coverImage(),
                      widget.note.name == null ? Text('') : gameTitle(),
                      widget.note.platforms == null ? Text('') : platformRows(),
                      widget.note.summary == null ? Text('') : gameSummary(),
                      widget.note.genres == null
                          ? Text('')
                          : gameGenresSizedBox(),
                      widget.note.genres == null ? Text('') : gameGenres(),
                      widget.note.gameModes == null
                          ? Text('')
                          : gameModeSizedBox(),
                      widget.note.gameModes == null ? Text('') : gameModes(),
                      widget.note.videos == null
                          ? Text('')
                          : gameVideoSizedBox(),
                      widget.note.videos == null
                          ? Text('')
                          : gameVideo(context),
                      widget.note.screenshots == null
                          ? Text('')
                          : gameScreenshotsSizedBox(),
                      widget.note.screenshots == null
                          ? Text('')
                          : gameScreenshots(),
                      widget.note.similarGames == null
                          ? Text('')
                          : similarGamesSizedBox(),
                      widget.note.similarGames == null
                          ? Text('')
                          : similarGames(),
                      SizedBox(
                        height: 50,
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

  coverImage() {
    return Align(
      alignment: Alignment.center,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height / 1.7,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white60,
                  ),
                ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                imageUrl:
                    "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${widget.note.imageCoverId}.jpg",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.note.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
            favoriteSection()
          ],
        ),
      ),
    );
  }

  favoriteSection() {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    IconButton(
                      tooltip: 'Add your favorite',
                      icon: Icon(
                        Icons.favorite,
                        color: isFavorited == true ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        var game = widget.note;
                        isFavorited == true
                            ? removeFavorite(game)
                            : addFavorite(game);
                      },
                    ),
                    isFavorited == true
                        ? Text('Remove Favorite')
                        : Text("Add Favorite"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.share),
                      tooltip: 'Share this game',
                      onPressed: () {
                        Share.share(
                            'Check out this game :) ${widget.note.name}');
                      },
                    ),
                    Text("Share"),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  removeFavorite(Game game) {
    db.deleteGame(game.id);
    setState(() {
      isFavorited = false;
    });
  }

  addFavorite(Game game) {
    db.addFavorite(game, true);
    print(game);
    setState(() {
      isFavorited = true;
    });
  }

  platformRows() {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                checkPs4Platform(),
                checkXboxPlatform(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[checkPCPlatform(), checkNintendoPlatform()],
            ),
          )
        ],
      ),
    );
  }

  gameSummary() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          widget.note.summary,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16.0, color: Colors.white60),
        ),
      ),
    );
  }

  gameScreenshots() {
    return SizedBox(
      height: MediaQuery.of(context).size.width > 600
          ? (MediaQuery.of(context).size.height / 2)
          : (MediaQuery.of(context).size.height / 3.5),
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.note.screenshots.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: GestureDetector(
              onTap: () {
                _navigateToFullScreen(ctxt, widget.note);
              },
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                imageUrl:
                    "https://images.igdb.com/igdb/image/upload/t_screenshot_med_2x/${widget.note.screenshots[index]['image_id']}.jpg",
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToFullScreen(BuildContext context, Game game) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FullScreen(game, null)),
    );
  }

  gameGenresSizedBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 30,
        child: Row(
          children: <Widget>[
            Text(
              '* Genres',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  gameGenres() {
    return SizedBox(
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(5),
          itemCount: widget.note.genres.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " ${widget.note.genres[index]['name']} ",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  gameModeSizedBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 30,
        child: Row(
          children: <Widget>[
            Text(
              '* Game Modes',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  gameModes() {
    return SizedBox(
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(5),
          itemCount: widget.note.gameModes.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " ${widget.note.gameModes[index]['name']} ",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  gameScreenshotsSizedBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 30,
        child: Row(
          children: <Widget>[
            Text(
              '* Swipe left to see more screenshots.',
              style: TextStyle(fontSize: 16),
            ),
          ],
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

  gameVideo(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width > 600
          ? (MediaQuery.of(context).size.height / 2)
          : (MediaQuery.of(context).size.height / 3.5),
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.note.videos.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 0, bottom: 0),
            child: GestureDetector(
              onTap: () {
                _launchURL(
                    'https://www.youtube.com/watch?v=${widget.note.videos[index]['video_id']}');
              },
              child: widget.note.videos != null
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      imageUrl:
                          "https://img.youtube.com/vi/${widget.note.videos[index]['video_id']}/0.jpg",
                    )
                  : Image.asset('assets/dummy.png'),
            ),
          );
        },
      ),
    );
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
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNote(BuildContext context, SimilarGames note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MoreDetailScreen(note)),
    );
  }

  similarGames() {
    return SizedBox(
      height: 250.0,
      child: new ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: similarGamesArray.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 120,
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  child: GestureDetector(
                    onTap: () {
                      //?
                      _navigateToNote(context, similarGamesArray[index]);
                    },
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      width: 120,
                      height: 150,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      imageUrl:
                          "https://images.igdb.com/igdb/image/upload/t_cover_small_2x/${similarGamesArray[index].cover.imageId}.jpg",
                    ),
                  ),
                ),
                Text(
                  similarGamesArray[index].name,
                  style: TextStyle(fontSize: 10.0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  similarGamesSizedBox() {
    if (widget.note.similarGames.length >= 1) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 30,
          child: Row(
            children: <Widget>[
              Text(
                '* Similar Games',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      );
    }
  }

  checkNintendoPlatform() {
    var xbox = releaseDates.where((i) => i.platform == 130).toList().length;
    var xbox2 = releaseDates.where((i) => i.platform == 130).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          xbox >= 1
              ? Image.asset(
                  'assets/platforms/nintendo.png',
                  color: Colors.white,
                  height: 50,
                  width: 50,
                )
              : Text(''),
          xbox >= 1
              ? Column(
                  children: <Widget>[
                    Text(
                      xbox2.last.human,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                )
              : Text('')
        ],
      ),
    );
  }

  checkPCPlatform() {
    var xbox = releaseDates.where((i) => i.platform == 49).toList().length;
    var xbox2 = releaseDates.where((i) => i.platform == 49).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          xbox >= 1
              ? Image.asset(
                  'assets/platforms/pc.png',
                  color: Colors.white,
                  height: 50,
                  width: 50,
                )
              : Text(''),
          xbox >= 1
              ? Column(
                  children: <Widget>[
                    Text(
                      xbox2.last.human,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                )
              : Text('')
        ],
      ),
    );
  }

  checkXboxPlatform() {
    var xbox = releaseDates.where((i) => i.platform == 48).toList().length;
    var xbox2 = releaseDates.where((i) => i.platform == 48).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          xbox >= 1
              ? Image.asset(
                  'assets/platforms/xbox.png',
                  color: Colors.white,
                  height: 50,
                  width: 50,
                )
              : Text(''),
          xbox >= 1
              ? Column(
                  children: <Widget>[
                    Text(
                      xbox2.last.human,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                )
              : Text('')
        ],
      ),
    );
  }

  checkPs4Platform() {
    var xbox = releaseDates.where((i) => i.platform == 6).toList().length;
    var xbox2 = releaseDates.where((i) => i.platform == 6).toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          xbox >= 1
              ? Image.asset(
                  'assets/platforms/ps4.png',
                  color: Colors.white,
                  height: 50,
                  width: 50,
                )
              : Text(''),
          xbox >= 1
              ? Column(
                  children: <Widget>[
                    Text(
                      xbox2.last.human,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                )
              : Text('')
        ],
      ),
    );
  }
}
