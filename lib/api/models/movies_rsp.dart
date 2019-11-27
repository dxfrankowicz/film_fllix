import 'movie.dart';

class MoviesRsp {
  // ignore: conflicting_dart_import
  List<Movie> movies;

  MoviesRsp(this.movies);

  factory MoviesRsp.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      List<Movie> l = new List();
      for (var value in json) {
        l.add(new Movie.fromJson(value));
      }
      return new MoviesRsp(l);
    }
  }
}