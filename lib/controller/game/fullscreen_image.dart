import 'package:ReleaseDate/models/games/game.dart';
import 'package:ReleaseDate/models/games/similar_games.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  final Game game;
  final SimilarGames similarGames;
  FullScreen(this.game, this.similarGames);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            // A fixed-height child.
            height: MediaQuery.of(context).size.height / 2.3,
            child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: game == null
                  ? similarGames.screenshots.length
                  : game.screenshots.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 2.0),
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
                        "https://images.igdb.com/igdb/image/upload/t_screenshot_med_2x/${game == null ? similarGames.screenshots[index]['image_id'] : game.screenshots[index]['image_id']}.jpg",
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
