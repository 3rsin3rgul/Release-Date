import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'cover.dart';
import 'game_modes.dart';
import 'genres.dart';
import 'release_date.dart';
import 'screenshots.dart';
import 'similar_games.dart';
import 'videos.dart';

class Game {
  int id;
  int hypes;
  int updatedAt;
  int pulseCount;
  int coverCoverId;
  int versionParent;
  double popularity;
  int firstReleaseDate;
  String key;
  String url;
  String name;
  String slug;
  String summary;
  String imageCoverId;
  String versionTitle;
  dynamic keywords = List<Keyword>();
  dynamic videos = List<Video>();
  dynamic genres = List<Genres>();
  dynamic gameModes = List<GameModes>();
  dynamic releaseDate = List<ReleaseDate>();
  dynamic screenshots = List<Screenshots>();
  dynamic similarGames = List<SimilarGames>();
  dynamic platforms = List<Platform>();

  Game(
      {this.coverCoverId,
      this.imageCoverId,
      this.firstReleaseDate,
      this.gameModes,
      this.genres,
      this.hypes,
      this.id,
      this.keywords,
      this.name,
      this.platforms,
      this.popularity,
      this.pulseCount,
      this.releaseDate,
      this.screenshots,
      this.similarGames,
      this.slug,
      this.summary,
      this.updatedAt,
      this.url,
      this.versionParent,
      this.versionTitle,
      this.videos});

  Game.fromSnapshot(DataSnapshot snapshot)
      : coverCoverId = snapshot.value['cover']['id'],
        imageCoverId = snapshot.value['cover']['image_id'],
        firstReleaseDate = snapshot.value['first_release_date'],
        gameModes = List.from(snapshot.value['game_modes']),
        genres = List.from(snapshot.value['genres']),
        hypes = snapshot.value['hypes'],
        id = snapshot.value['id'],
        keywords = snapshot.value['keywords'],
        name = snapshot.value['name'],
        platforms = List.from(snapshot.value['platforms']),
        popularity = snapshot.value['popularity'],
        pulseCount = snapshot.value['pulse_count'],
        releaseDate = List.from(snapshot.value['release_dates']),
        screenshots = List.from(snapshot.value['screenshots']),
        similarGames = List.from(snapshot.value['similar_games']),
        slug = snapshot.value['slug'],
        summary = snapshot.value['summary'],
        updatedAt = snapshot.value['updated_at'],
        url = snapshot.value['url'],
        versionParent = snapshot.value['version_parent'],
        versionTitle = snapshot.value['version_title'],
        videos = List.from(snapshot.value['videos']);

  Game.mapForDetail(dynamic obj) {
    this.coverCoverId = obj['cover']['id'] ?? null;
    this.imageCoverId = obj['cover']['image_id'] ?? null;
    this.firstReleaseDate = obj['first_release_date'] ?? null;
    this.gameModes = obj['game_modes'] ?? null;
    this.genres = obj['genres'] ?? null;
    this.hypes = obj['hypes'] ?? null;
    this.id = obj['id'] ?? null;
    this.keywords = obj['keywords'] ?? null;
    this.name = obj['name'] ?? null;
    this.platforms = obj['platforms'] ?? null;
    this.popularity = obj['popularity'] ?? null;
    this.pulseCount = obj['pulse_count'] ?? null;
    this.releaseDate = obj['release_dates'] ?? null;
    this.screenshots = obj['screenshots'] ?? null;
    this.similarGames = obj['similar_games'] ?? null;
    this.slug = obj['slug'] ?? null;
    this.summary = obj['summary'] ?? null;
    this.updatedAt = obj['updated_at'] ?? null;
    this.url = obj['url'] ?? null;
    this.versionParent = obj['version_parent'] ?? null;
    this.versionTitle = obj['version_title'] ?? null;
    this.videos = obj['videos'] ?? null;
  }

  Game.map(dynamic obj) {
    this.coverCoverId =
        obj['coverCoverId'] == null ? null : obj['coverCoverId'];
    this.imageCoverId =
        obj['imageCoverId'] == null ? null : obj['imageCoverId'];
    this.firstReleaseDate =
        obj['firstReleaseDate'] == null ? null : obj['firstReleaseDate'];
    this.gameModes = obj['gameModes'] == null ? null : obj['gameModes'];
    this.genres = obj['genres'] == null ? null : obj['genres'];
    this.hypes = obj['hypes'] == null ? null : obj['hypes'];
    this.id = obj['id'] == null ? null : obj['id'];
    this.keywords = obj['keywords'] == null ? null : obj['keywords'];
    this.name = obj['name'] == null ? null : obj['name'];
    this.platforms = obj['platforms'] == null ? null : obj['platforms'];
    this.popularity = obj['popularity'] == null ? null : obj['popularity'];
    this.pulseCount = obj['pulseCount'] == null ? null : obj['pulseCount'];
    this.releaseDate = obj['releaseDate'] == null ? null : obj['releaseDate'];
    this.screenshots = obj['screenshots'] == null ? null : obj['screenshots'];
    this.similarGames =
        obj['similarGames'] == null ? null : obj['similarGames'];
    this.slug = obj['slug'] == null ? null : obj['slug'];
    this.summary = obj['summary'] == null ? null : obj['summary'];
    this.updatedAt = obj['updatedAt'] == null ? null : obj['updatedAt'];
    this.url = obj['url'] == null ? null : obj['url'];
    this.versionParent =
        obj['versionParent'] == null ? null : obj['versionParent'];
    this.versionTitle =
        obj['versionTitle'] == null ? null : obj['versionTitle'];
    this.videos = obj['videos'] == null ? null : obj['videos'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['coverCoverId'] = coverCoverId;
    map['imageCoverId'] = imageCoverId;
    map['firstReleaseDate'] = firstReleaseDate;
    map['hypes'] = hypes;
    map['id'] = id;
    map['name'] = name;
    map['popularity'] = popularity;
    map['pulseCount'] = pulseCount;
    map['slug'] = slug;
    map['summary'] = summary;
    map['updatedAt'] = updatedAt;
    map['url'] = url;
    map['versionParent'] = versionParent;
    map['versionTitle'] = versionTitle;
    return map;
  }

  // map['gameModes'] = [gameModes];
  // map['genres'] = genres;
  // map['keywords'] = keywords;
  // map['platforms'] = platforms;
  // map['releaseDate'] = releaseDate;
  // map['screenshots'] = screenshots;
  // map['similarGames'] = similarGames;
  // map['videos'] = videos;

  // Extract a Note object from a Map object
  Game.fromMapObject(Map<String, dynamic> map) {
    this.coverCoverId = map['coverCoverId'];
    this.imageCoverId = map['imageCoverId'];
    this.firstReleaseDate = map['firstReleaseDate'];
    this.gameModes = map['gameModes'];
    this.genres = map['genres'];
    this.hypes = map['hypes'];
    this.id = map['id'];
    this.keywords = map['keywords'];
    this.name = map['name'];
    this.platforms = map['platforms'];
    this.popularity = map['popularity'];
    this.pulseCount = map['pulseCount'];
    this.releaseDate = map['releaseDate'];
    this.screenshots = map['screenshots'];
    this.similarGames = map['similarGames'];
    this.slug = map['slug'];
    this.summary = map['summary'];
    this.updatedAt = map['updatedAt'];
    this.url = map['url'];
    this.versionParent = map['versionParent'];
    this.versionTitle = map['versionTitle'];
    this.videos = map['videos'];
  }
}
