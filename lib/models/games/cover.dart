import 'package:firebase_database/firebase_database.dart';

class Cover {
  int id;
  String imageId;

  Cover({this.id, this.imageId});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['imageId'] = imageId;
    return map;
  }

  factory Cover.fromJson(dynamic json) {
    return Cover(
      id: json["id"] == null ? null : json["id"],
      imageId: json["image_id"] == null ? null : json["image_id"],
    );
  }
}

class Keyword {
  int _id;

  Keyword(this._id);

  Keyword.map(dynamic obj) {
    this._id = obj['id'];
  }

  int get id => _id;

  Keyword.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.value['id'];
  }
}
