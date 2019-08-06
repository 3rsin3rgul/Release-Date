import 'package:ReleaseDate/controller/game/fullscreen_image.dart';
import 'package:ReleaseDate/helpers/db_helper.dart';
import 'package:ReleaseDate/models/games/game.dart';
import 'package:ReleaseDate/models/games/game_modes.dart';
import 'package:ReleaseDate/models/games/genres.dart';
import 'package:ReleaseDate/models/games/release_date.dart';
import 'package:ReleaseDate/models/games/screenshots.dart';
import 'package:ReleaseDate/models/games/similar_games.dart';
import 'package:ReleaseDate/models/games/videos.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteNoteScreen extends StatefulWidget {
  final Game note;
  FavoriteNoteScreen(this.note);
  @override
  State<StatefulWidget> createState() => new _FavoriteNoteScreenState();
}

class _FavoriteNoteScreenState extends State<FavoriteNoteScreen> {
  var db = new DatabaseHelper();
  var isFavorited;
  List<ReleaseDate> releaseDates = [];
  List<SimilarGames> similarGamesArray = [];

  final List<ScreenshotsSQL> _screenshots = <ScreenshotsSQL>[];
  final List<Game> _gameList = <Game>[];
  final List<GameModes> _gameModes = <GameModes>[];
  final List<Genres> _genres = <Genres>[];
  final List<VideoSQL> _video = <VideoSQL>[];
  final List<ReleaseDateSQL> _releaseDate = <ReleaseDateSQL>[];

  @override
  void initState() {
    super.initState();
    getSqlGames();
  }

  getSqlGames() async {
    var id = widget.note.id;
    Game dbGame = await db.getGame(widget.note.id);
    dbGame != null ? isFavorited = true : isFavorited = false;
    List sqlGames = await db.getFavoriteGames();
    List sqlScreenshots =
        await db.getFavoriteGamesWithOtherData(id, "screenshots");
    List sqlGameModes = await db.getFavoriteGamesWithOtherData(id, "gameModes");
    List sqlGenres = await db.getFavoriteGamesGenres(id, "genres");
    List sqlVideo = await db.getFavoriteGamesWithOtherData(id, "video");
    List sqlReleaseDate =
        await db.getFavoriteGamesWithOtherData(id, "releaseDate");

    sqlGames.forEach((games) {
      setState(() {
        _gameList.add(Game.map(games));
      });
    });

    sqlScreenshots.forEach((screenshot) {
      setState(() {
        _screenshots.add(ScreenshotsSQL.map(screenshot));
      });
    });

    sqlReleaseDate.forEach((releaseDate) {
      setState(() {
        _releaseDate.add(ReleaseDateSQL.map(releaseDate));
      });
    });

    sqlVideo.forEach((videos) {
      setState(() {
        _video.add(VideoSQL.map(videos));
      });
    });

    sqlGenres.forEach((genres) {
      setState(() {
        _genres.add(Genres.map(genres));
      });
    });

    sqlGameModes.forEach((gameModes) {
      setState(() {
        _gameModes.add(GameModes.map(gameModes));
      });
    });
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
                      coverImage(),
                      gameTitle(),
                      //FIX
                      platformRows(),
                      gameSummary(),
                      gameGenresSizedBox(),
                      //FIX
                      gameGenres(),
                      gameModeSizedBox(),
                      //FIX
                      gameModes(),
                      gameVideoSizedBox(),
                      gameVideo(context),
                      gameScreenshotsSizedBox(),
                      gameScreenshots(),
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
            // A fixed-height child.
            height: 500.0,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                width: 400,
                height: 500,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
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
                        color: isFavorited == true ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        isFavorited == true
                            ? removeFavorite(widget.note)
                            : addFavorite(widget.note);
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
      height: 250.0,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _screenshots.length,
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
                height: 250,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                imageUrl: "https://images.igdb"
                    ".com/igdb/image/upload/t_screenshot_med_2x/${_screenshots[index].imageId}.jpg",
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
              style: TextStyle(fontSize: 18),
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
          itemCount: _genres.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " ${_genres[index].name} ",
                  style: TextStyle(fontSize: 18.0),
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
              style: TextStyle(fontSize: 18),
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
          itemCount: _gameModes.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " ${_gameModes[index].name} ",
                  style: TextStyle(fontSize: 18.0),
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
      height: 250.0,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _video.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 0, bottom: 0),
            child: GestureDetector(
              onTap: () {
                _launchURL('https://www.youtube'
                    '.com/watch?v=${_video[index].videoId}');
              },
              child: _video != null
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
                          "https://img.youtube.com/vi/${_video[index].videoId}/0.jpg",
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
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  checkNintendoPlatform() {
    var xbox = _releaseDate.where((i) => i.platform == 130).toList().length;
    var xbox2 = _releaseDate.where((i) => i.platform == 130).toList();

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
    var xbox = _releaseDate.where((i) => i.platform == 49).toList().length;
    var xbox2 = _releaseDate.where((i) => i.platform == 49).toList();

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
    var xbox = _releaseDate.where((i) => i.platform == 48).toList().length;
    var xbox2 = _releaseDate.where((i) => i.platform == 48).toList();

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
    var xbox = _releaseDate.where((i) => i.platform == 6).toList().length;
    var xbox2 = _releaseDate.where((i) => i.platform == 6).toList();
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
