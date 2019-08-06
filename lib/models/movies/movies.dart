import 'package:firebase_database/firebase_database.dart';

class Movies {
  int id;
  bool adult;
  String key;
  String backdroppath;
  String originallanguage;
  String originaltitle;
  String overview;
  double popularity;
  String posterpath;
  String releasedate;
  String title;
  bool video;
  int voteaverage;
  int votecount;

  Movies(
      {this.adult,
      this.backdroppath,
      this.id,
      this.originallanguage,
      this.originaltitle,
      this.overview,
      this.popularity,
      this.posterpath,
      this.releasedate,
      this.title,
      this.video,
      this.voteaverage,
      this.votecount});

  Movies.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.backdroppath = map['backdroppath'];
    this.originallanguage = map['originallanguage'];
    this.originaltitle = map['originaltitle'];
    this.overview = map['overview'];
    this.popularity = map['popularity'];
    this.posterpath = map['posterpath'];
    this.releasedate = map['releasedate'];
    this.title = map['title'];
    this.voteaverage = map['voteaverage'];
    this.votecount = map['votecount'];
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    // map['adult'] = adult;
    map['backdroppath'] = backdroppath;
    map['originallanguage'] = originallanguage;
    map['originaltitle'] = originaltitle;
    map['overview'] = overview;
    map['popularity'] = popularity;
    map['posterpath'] = posterpath;
    map['releasedate'] = releasedate;
    map['title'] = title;
    // map['video'] = video;
    map['voteaverage'] = voteaverage;
    map['votecount'] = votecount;
    return map;
  }

  Movies.map(dynamic obj) {
    this.id = obj['id'];
    this.backdroppath = obj['backdroppath'];
    this.originallanguage = obj['originallanguage'];
    this.originaltitle = obj['originaltitle'];
    this.overview = obj['overview'];
    this.popularity = obj['popularity'];
    this.posterpath = obj['posterpath'];
    this.releasedate = obj['releasedate'];
    this.title = obj['title'];
    this.voteaverage = obj['voteaverage'];
    this.votecount = obj['votecount'];
  }

  Movies.mapForDetail(dynamic obj) {
    this.id = obj['id'];
    this.backdroppath = obj['backdrop_path'];
    this.originallanguage = obj['originallanguage'];
    this.originaltitle = obj['original_title'];
    this.overview = obj['overview'];
    this.popularity = obj['popularity'];
    this.posterpath = obj['poster_path'];
    this.releasedate = obj['release_date'];
    this.title = obj['title'];
    this.votecount = obj['vote_count'];
  }

  Movies.fromSnapshot(DataSnapshot snapshot)
      : adult = snapshot.value['adult'],
        backdroppath = snapshot.value['backdrop_path'],
        id = snapshot.value['id'],
        originallanguage = snapshot.value['original_language'],
        originaltitle = snapshot.value['original_title'],
        overview = snapshot.value['overview'],
        popularity = snapshot.value['popularity'],
        posterpath = snapshot.value['poster_path'],
        releasedate = snapshot.value['release_date'],
        title = snapshot.value['title'],
        video = snapshot.value['video'],
        voteaverage = snapshot.value['vote_average'],
        votecount = snapshot.value['vote_count'];
}
