class Genres {
  int id;
  String name;
  int gameId;

  Genres(this.id, this.name, this.gameId);

  Genres.map(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.gameId = obj['gameId'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['gameId'] = gameId;
    return map;
  }
}

class Platforms {
  int id;
  int gameId;

  Platforms(this.id,this.gameId);

  Platforms.map(dynamic obj) {
    this.id = obj['id'];
    this.gameId = obj['gameId'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['gameId'] = gameId;
    return map;
  }
}
