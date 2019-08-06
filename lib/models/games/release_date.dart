class ReleaseDate {
  String human;
  int id;
  int platform;

  ReleaseDate({this.human, this.id, this.platform});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['human'] = human;
    map['platform'] = platform;
    return map;
  }

  factory ReleaseDate.fromJson(dynamic json) {
    return ReleaseDate(
      human: json['human'],
      id: json['id'],
      platform: json['platform'],
    );
  }
}

class ReleaseDateSQL {
  String human;
  int id;
  int platform;
  int gameId;

  ReleaseDateSQL(this.human, this.id, this.platform, this.gameId);
  ReleaseDateSQL.map(dynamic obj) {
    this.id = obj['id'];
    this.human = obj['human'];
    this.platform = obj['platform'];
    this.gameId = obj['gameId'];
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['human'] = human;
    map['platform'] = platform;
    map['gameId'] = gameId;
    return map;
  }
}
