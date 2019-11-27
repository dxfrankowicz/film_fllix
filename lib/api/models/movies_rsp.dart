import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/utils/navigation_utils.dart';

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
      try {
        for (var value in json) {
          l.add(new Movie.fromJson(value));
        }
      }
      catch(e){
        Storage.deleteAll().then((value) {});
      }
      return new MoviesRsp(l);
    }
  }
}