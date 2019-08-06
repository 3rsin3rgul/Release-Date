class MovieVideos {
  dynamic results = List<Result>();

  MovieVideos({
    this.results,
  });

  factory MovieVideos.fromJson(dynamic json) {
    return MovieVideos(
      results: List.from(json["results"]) == null ? null : json["results"],
    );
  }
}

class Result {
  String key;

  Result({
    this.key,
  });

  factory Result.fromJson(dynamic json) {
    return Result(
      key: json["key"] == null ? null : json["key"],
    );
  }
}
