import 'package:ReleaseDate/models/games/release_date.dart';
import 'package:ReleaseDate/models/games/similar_games.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fullscreen_image.dart';

class MoreDetailScreen extends StatefulWidget {
  final SimilarGames note;
  MoreDetailScreen(this.note);
  @override
  State<StatefulWidget> createState() => new _MoreDetailScreenState();
}

class _MoreDetailScreenState extends State<MoreDetailScreen> {
  List<ReleaseDate> releaseDates = [];
  final ps4Image = 'assets/platforms/ps4.png';
  final xboxImage = 'assets/platforms/xbox.png';
  final pcImage = 'assets/platforms/pc.png';
  final nintendoImage = 'assets/platforms/nintendo.png';

  @override
  void initState() {
    super.initState();
    for (var x in widget.note.releaseDate) {
      var maps = ReleaseDate.fromJson(x);
      releaseDates.add(maps);
    }
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
                    backgroundColor: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                imageUrl:
                    "https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${widget.note.cover.imageId}.jpg",
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
        child: Text(
          widget.note.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }

  void _navigateToFullScreen(BuildContext context, SimilarGames game) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FullScreen(null, game)),
    );
  }

  platformRows() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          checkPs4Platform(),
          checkXboxPlatform(),
          checkPCPlatform(),
          checkNintendoPlatform()
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
                height: 250,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
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
      height: 80.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: new ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.note.genres.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Text(
              "${widget.note.genres[index]['name']}",
              style: TextStyle(fontSize: 16.0),
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
              style: TextStyle(fontSize: 18),
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

  gameVideo() {
    return SizedBox(
      height: 250.0,
      child: widget.note.videos == null
          ? Image.asset('assets/novideo.png')
          : new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  widget.note.videos == null ? 0 : widget.note.videos.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 0, bottom: 0),
                  child: GestureDetector(
                    onTap: () {
                      _launchURL(widget.note.videos == null
                          ? null
                          : 'https://www.youtube.com/watch?v=${widget.note.videos[index]['video_id']}');
                    },
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      imageUrl:
                          "https://img.youtube.com/vi/${widget.note.videos[index]['video_id']}/0.jpg",
                    ),
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
              '* Press play for watch to trailer.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              bottom: false,
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
                        platformRows(),
                        gameSummary(),
                        gameGenresSizedBox(),
                        gameGenres(),
                        gameVideoSizedBox(),
                        gameVideo(),
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
            ),
          );
        },
      ),
    );
  }

  checkNintendoPlatform() {
    var xbox = releaseDates.where((i) => i.platform == 130).toList().length;
    var xbox2 = releaseDates.where((i) => i.platform == 130).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
