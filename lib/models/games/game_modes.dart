import 'package:firebase_database/firebase_database.dart';

class GameModes {
  int id;
  String name;

  int gameId;

  GameModes(this.id, this.name, this.gameId);
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['gameId'] = id;
    map['name'] = name;
    map['gameId'] = gameId;
    return map;
  }

  GameModes.map(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
  }

  GameModes.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.value['id'];
    name = snapshot.value['name'];
  }
}
