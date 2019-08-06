import 'package:firebase_database/firebase_database.dart';

class Video {
  int _id;
  int _game;
  String _name;
  String _videoId;

  Video(this._id, this._game, this._name, this._videoId);

  Video.map(dynamic obj) {
    this._id = obj['id'];
    this._game = obj['game'];
    this._name = obj['name'];
    this._videoId = obj['video_id'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<dynamic, dynamic>();
    map['id'] = id.toString();
    map['game'] = game.toString();
    map['name'] = name;
    map['video_id'] = videoId;
    return map;
  }

  int get id => _id;
  String get videoId => _videoId;
  int get game => _game;
  String get name => _name;

  Video.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.value['id'];
    _game = snapshot.value['game'];
    _name = snapshot.value['name'];
    _videoId = snapshot.value['video_id'];
  }
}

class VideoSQL {
  int id;
  int game;
  String name;
  String videoId;
  int gameId;

  VideoSQL(this.id, this.game, this.name, this.videoId, this.gameId);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['game'] = game;
    map['name'] = name;
    map['videoId'] = videoId;
    map['gameId'] = gameId;
    return map;
  }

  VideoSQL.map(dynamic obj) {
    this.id = obj['id'];
    this.game = obj['game'];
    this.name = obj['name'];
    this.videoId = obj['videoId'];
    this.gameId = obj['gameId'];
  }
}
