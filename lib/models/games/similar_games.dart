import 'cover.dart';
import 'game_modes.dart';
import 'genres.dart';
import 'release_date.dart';
import 'screenshots.dart';
import 'videos.dart';

class SimilarGames {
  Cover cover;
  int id;
  String name;
  String slug;
  String summary;
  dynamic gameModes = List<GameModes>();
  dynamic genres = List<Genres>();
  dynamic releaseDate = List<ReleaseDate>();
  dynamic screenshots = List<Screenshots>();
  dynamic videos = List<Video>();

  SimilarGames(
      {this.cover,
      this.id,
      this.name,
      this.slug,
      this.summary,
      this.gameModes,
      this.genres,
      this.screenshots,
      this.releaseDate,
      this.videos});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['cover']['image_id'] = cover;
    map['name'] = name;
    map['slug'] = slug;
    map['summary'] = summary;
    return map;
  }

  factory SimilarGames.fromJson(dynamic json) {
    return SimilarGames(
      cover: json["cover"] is int ? null : Cover.fromJson(json["cover"]),
      id: json["id"],
      name: json["name"] == null ? "" : json['name'],
      slug: json["slug"] == null ? "" : json['slug'],
      summary: json["summary"] == null ? "" : json['summary'],
      gameModes:
          json["game_modes"] == null ? null : List.from(json["game_modes"]),
      genres: List.from(json["genres"]),
      screenshots:
          json["screenshots"] == null ? null : List.from(json["screenshots"]),
      videos: json["videos"] == null ? null : List.from(json["videos"]),
      releaseDate: json["release_dates"] == null
          ? ReleaseDate.fromJson(json)
          : List.from(json['release_dates']),
    );
  }
}

class SimilarGamesSQL {
  String cover;
  int id;
  String name;
  String slug;
  String summary;

  SimilarGamesSQL({this.cover, this.id, this.name, this.slug, this.summary});

  SimilarGamesSQL.map(dynamic obj) {
    this.id = obj['id'];
    this.cover = obj['cover'];
    this.name = obj['name'];
    this.slug = obj['slug'];
    this.summary = obj['summary'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['cover'] = cover;
    map['name'] = name;
    map['slug'] = slug;
    map['summary'] = summary;
    return map;
  }
}
