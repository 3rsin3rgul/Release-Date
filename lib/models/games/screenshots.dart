import 'package:firebase_database/firebase_database.dart';

class Screenshots {
  String _id;
  String _imageId;

  Screenshots(this._id, this._imageId);

  Screenshots.map(dynamic obj) {
    this._id = obj['id'];
    this._imageId = obj['image_id'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['image_id'] = _imageId;
    return map;
  }

  String get id => _id;
  String get imageId => _imageId;

  Screenshots.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.value['id'];
    _imageId = snapshot.value['image_id'];
  }
}

class ScreenshotsSQL {
  int id;
  String imageId;
  int gameId;

  ScreenshotsSQL(this.id, this.imageId, this.gameId);

  ScreenshotsSQL.map(dynamic obj) {
    this.id = obj['id'];
    this.imageId = obj['imageId'];
    this.gameId = obj['gameId'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['imageId'] = imageId;
    map['gameId'] = gameId;
    return map;
  }
}
