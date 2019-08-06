import 'dart:async';
import 'dart:io';

import 'package:ReleaseDate/models/games/game.dart';
import 'package:ReleaseDate/models/games/game_modes.dart';
import 'package:ReleaseDate/models/games/genres.dart';
import 'package:ReleaseDate/models/games/release_date.dart';
import 'package:ReleaseDate/models/games/screenshots.dart';
import 'package:ReleaseDate/models/games/similar_games.dart';
import 'package:ReleaseDate/models/games/videos.dart';
import 'package:ReleaseDate/models/movies/movies.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableName = "game";
  final String columnId = "id";
  final String columnItemName = "name";
  final String columnDateCreated = "dateCreated";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "game_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    print("DB PATH IS $path");
    return ourDb;
  }

  String title;
  String publisher;
  String publishedDate;
  String description;
  int pageCount;
  String smallThumbnail;
  String thumbnail;
  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableName(id INTEGER PRIMARY KEY,hypes INTEGER, updatedAt INTEGER, pulseCount INTEGER, coverCoverId INTEGER, versionParent INTEGER, popularity INTEGER, firstReleaseDate INTEGER, key TEXT , url TEXT, name TEXT, slug TEXT, summary TEXT, imageCoverId TEXT, versionTitle TEXT)');
    await db.execute(
        'CREATE TABLE favoriteGame(id INTEGER PRIMARY KEY,hypes INTEGER, updatedAt INTEGER, pulseCount INTEGER, coverCoverId INTEGER, versionParent INTEGER, popularity INTEGER, firstReleaseDate INTEGER, key TEXT , url TEXT, name TEXT, slug TEXT, summary TEXT, imageCoverId TEXT, versionTitle TEXT)');
    await db.execute(
        'CREATE TABLE favoriteMovies(id INTEGER PRIMARY KEY,adult BOOL, key TEXT, backdroppath TEXT, originallanguage TEXT, originalTitle TEXT, overview TEXT, popularity INTEGER, posterpath TEXT , releasedate TEXT, title TEXT, video BOOL, voteaverage INTEGER, votecount INTEGER)');
    await db.execute(
        'CREATE TABLE favoriteBooks(title TEXT PRIMARY KEY, publisher TEXT, publishedDate TEXT, description TEXT, pageCount INTEGER, smallThumbnail TEXT, thumbnail TEXT)');
    await db.execute(
        'CREATE TABLE gameModes(id INTEGER, name TEXT, gameId INTEGER)');
    await db
        .execute('CREATE TABLE genres(id INTEGER , name TEXT,gameId INTEGER)');
    await db.execute('CREATE TABLE platforms(id INTEGER,gameId INTEGER)');
    await db.execute(
        'CREATE TABLE video(id INTEGER, game INTEGER, name TEXT, videoId TEXT ,gameId INTEGER)');
    await db.execute(
        'CREATE TABLE releaseDate(id INTEGER, human TEXT, platform INTEGER,gameId INTEGER)');
    await db.execute(
        'CREATE TABLE screenshots(id INTEGER, imageId TEXT,gameId INTEGER)');
    await db.execute(
        'CREATE TABLE similarGames(id INTEGER, cover TEXT, name TEXT, slug TEXT, summary TEXT)');
    await db.execute(
        'CREATE TABLE similarGamesGameModes(id INTEGER, name TEXT, gameId INTEGER)');
    await db.execute(
        'CREATE TABLE similarGamesGenres(id INTEGER , name TEXT,gameId INTEGER)');
    await db.execute(
        'CREATE TABLE similarGamesVideo(id INTEGER, game INTEGER, name TEXT, videoId TEXT ,gameId INTEGER)');
    await db.execute(
        'CREATE TABLE similarGamesReleaseDate(id INTEGER, human TEXT, platform INTEGER,gameId INTEGER)');
    await db.execute(
        'CREATE TABLE similarGamesScreenshots(id INTEGER, imageId TEXT,gameId INTEGER)');
  }

  Future<List> getFavoriteBooks() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM favoriteBooks ORDER BY publishedDate ASC");
    return result.toList();
  }

  //GAME DB
  Future<int> saveGame(Game game) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", game.toMap());
    return res;
  }

  Future<List> getFavoriteGames() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM favoriteGame ORDER BY $columnItemName ASC");
    return result.toList();
  }

  Future<int> saveFavoriteGame(Game game) async {
    var dbClient = await db;
    int res = await dbClient.insert("favoriteGame", game.toMap());
    return res;
  }

  Future<List> getFavoriteGamesGenres(int id, String table) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM genres WHERE gameId = $id");
    return result.toList();
  }

  Future<List> getFavoriteGamesWithOtherData(int id, String table) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table WHERE gameId = "
        "$id");

    if (result.length == 0) return null;
    return result.toList();
  }

  Future<int> saveGameModes(GameModes gameModes, String table) async {
    var dbClient = await db;
    int res = await dbClient.insert("$table", gameModes.toMap());
    return res;
  }

  Future<int> saveGenres(Genres genres, String table) async {
    var dbClient = await db;
    int res = await dbClient.insert("$table", genres.toMap());
    return res;
  }

  Future<int> savePlatforms(Platforms platforms, String table) async {
    var dbClient = await db;
    int res = await dbClient.insert("$table", platforms.toMap());
    return res;
  }

  Future<int> saveReleaseDates(ReleaseDateSQL releaseDate, String table) async {
    var dbClient = await db;
    int res = await dbClient.insert("$table", releaseDate.toMap());
    return res;
  }

  Future<int> saveScreenshots(ScreenshotsSQL screenshots, String table) async {
    var dbClient = await db;
    int res = await dbClient.insert("$table", screenshots.toMap());
    return res;
  }

  Future<int> saveVideos(VideoSQL videos, String table) async {
    var dbClient = await db;
    int res = await dbClient.insert("$table", videos.toMap());
    return res;
  }

  Future<int> saveSimilarGames(SimilarGamesSQL similarGames) async {
    var dbClient = await db;
    int res = await dbClient.insert("similarGames", similarGames.toMap());
    return res;
  }

  saveGames(List<Game> games) async {
    var dbClient = await db;
    for (var game in games) {
      await dbClient.insert("$tableName", game.toMap());
    }
  }

  addFavorite(Game game, bool isFavorite) {
    Game gameDb = new Game(
      coverCoverId: game.coverCoverId ?? "",
      firstReleaseDate: game.firstReleaseDate ?? 0,
      hypes: game.hypes ?? 0,
      id: game.id ?? 0,
      imageCoverId: game.imageCoverId ?? "",
      keywords: game.key ?? "",
      name: game.name ?? "",
      popularity: game.popularity ?? 0,
      pulseCount: game.pulseCount ?? 0,
      slug: game.slug ?? "",
      summary: game.summary ?? "",
      updatedAt: game.updatedAt ?? 0,
      url: game.url ?? "",
      versionParent: game.versionParent ?? 0,
      versionTitle: game.versionTitle ?? "",
    );

    for (var x in game.similarGames) {
      var similarGames = SimilarGames.fromJson(x);
      saveSimilarGamesLocally(game, similarGames);
    }
    saveGameLocally(game);

    isFavorite == false ? saveGame(gameDb) : saveFavoriteGame(game);
  }

  saveSimilarGamesLocally(Game game, SimilarGames similarGames) {
    SimilarGamesSQL gameDb = new SimilarGamesSQL(
        cover: similarGames.cover.imageId ?? "",
        id: similarGames.id ?? 0,
        name: similarGames.name ?? 0,
        slug: similarGames.slug ?? "",
        summary: similarGames.summary ?? "");

    if (similarGames.gameModes != null) {
      for (var gameMode in similarGames.gameModes) {
        GameModes modes = new GameModes(
            gameMode['id'] ?? 0, gameMode['name'] ?? "", similarGames.id);
        saveGameModes(modes, "similarGamesGameModes");
      }
    }

    if (similarGames.videos != null) {
      for (var videos in similarGames.videos) {
        VideoSQL video = new VideoSQL(videos['id'] ?? 0, videos['game'] ?? 0,
            videos['name'] ?? "", videos['video_id'] ?? "", similarGames.id);
        saveVideos(video, "similarGamesVideo");
      }
    }

    if (similarGames.genres != null) {
      for (var genres in similarGames.genres) {
        Genres genre = new Genres(
            genres['id'] ?? 0, genres['name'] ?? "", similarGames.id);
        saveGenres(genre, "similarGamesGenres");
      }
    }

    if (similarGames.releaseDate != null) {
      for (var releaseDates in similarGames.releaseDate) {
        ReleaseDateSQL releaseDate = new ReleaseDateSQL(
            releaseDates['human'] ?? "",
            releaseDates['id'] ?? 0,
            releaseDates['platform'] ?? 0,
            similarGames.id);
        saveReleaseDates(releaseDate, "similarGamesReleaseDate");
      }
    }

    if (similarGames.screenshots != null) {
      for (var screenshot in similarGames.screenshots) {
        ScreenshotsSQL screenshotsSQL = new ScreenshotsSQL(
            screenshot['id'] ?? 0,
            screenshot['image_id'] ?? "",
            similarGames.id);
        saveScreenshots(screenshotsSQL, "similarGamesScreenshots");
      }
    }

    saveSimilarGames(gameDb);
  }

  saveGameLocally(Game game) {
    if (game.gameModes != null) {
      for (var gameMode in game.gameModes) {
        GameModes modes =
            new GameModes(gameMode['id'] ?? 0, gameMode['name'] ?? "", game.id);
        saveGameModes(modes, "gameModes");
      }
    }

    if (game.genres != null) {
      for (var genres in game.genres) {
        Genres genre =
            new Genres(genres['id'] ?? 0, genres['name'] ?? "", game.id);
        saveGenres(genre, "genres");
      }
    }

    if (game.platforms != null) {
      for (var platforms in game.platforms) {
        print(platforms);
        Platforms platform = new Platforms(platforms ?? 0, game.id);
        savePlatforms(platform, "platforms");
      }
    }

    if (game.releaseDate != null) {
      for (var releaseDates in game.releaseDate) {
        ReleaseDateSQL releaseDate = new ReleaseDateSQL(
            releaseDates['human'] ?? "",
            releaseDates['id'] ?? 0,
            releaseDates['platform'] ?? 0,
            game.id);
        saveReleaseDates(releaseDate, "releaseDate");
      }
    }

    if (game.screenshots != null) {
      for (var screenshot in game.screenshots) {
        ScreenshotsSQL screenshotsSQL = new ScreenshotsSQL(
            screenshot['id'] ?? 0, screenshot['image_id'] ?? "", game.id);
        saveScreenshots(screenshotsSQL, "screenshots");
      }
    }

    if (game.videos != null) {
      for (var videos in game.videos) {
        VideoSQL video = new VideoSQL(videos['id'] ?? 0, videos['game'] ?? 0,
            videos['name'] ?? "", videos['video_id'] ?? "", game.id);
        saveVideos(video, "video");
      }
    }
  }

  Future<List> getGames() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName ORDER BY $columnItemName ASC");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future<Game> getGame(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM favoriteGame WHERE id = $id");
    if (result.length == 0) return null;
    return Game.fromMapObject(result.first);
  }

  Future<int> deleteGame(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete('favoriteGame', where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateGame(Game game) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", game.toMap(),
        where: "$columnId = ?", whereArgs: [game.id]);
  }

  //MOVIE DB
  Future<int> saveFavoriteMovie(Movies movies) async {
    var dbClient = await db;
    int res = await dbClient.insert("favoriteMovies", movies.toMap());
    return res;
  }

  Future<int> deleteMovie(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete('favoriteMovies', where: "id = ?", whereArgs: [id]);
  }

  addFavoriteMovie(Movies movies) {
    Movies movieDb = new Movies(
        adult: movies.adult,
        backdroppath: movies.backdroppath,
        id: movies.id,
        originallanguage: movies.originallanguage,
        originaltitle: movies.originaltitle,
        overview: movies.overview,
        popularity: movies.popularity,
        posterpath: movies.posterpath,
        releasedate: movies.releasedate,
        title: movies.title,
        video: movies.video,
        voteaverage: movies.voteaverage,
        votecount: movies.votecount);
    saveFavoriteMovie(movieDb);
  }

  Future<List> getFavoriteMovies() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM favoriteMovies ORDER BY releasedate ASC");
    return result.toList();
  }

  Future<Movies> getFavoriteMovie(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM favoriteMovies WHERE id = $id");
    if (result.length == 0) return null;
    return Movies.fromMapObject(result.first);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
