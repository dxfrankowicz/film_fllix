import 'dart:convert';

import 'package:film_fllix/api/models/comments_rsp.dart';
import 'package:film_fllix/api/models/movie.dart';
import 'package:film_fllix/api/models/movies_rsp.dart';
import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/utils/date_utils.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'base_api_client.dart';
import 'models/auth/access.dart';
import 'models/auth/login_rsp.dart';
import 'models/rentals_rsp.dart';

class ApiClient{
  final Logger logger = new Logger("ApiClient");
  final Client client = new Client();
  BaseApiClient baseApiClient;
  static ApiClient _singleton = new ApiClient._internal();
  bool seasonsNotAvailable = true;

  factory ApiClient() {
    return _singleton;
  }

  List<Map<String, String>> get log => baseApiClient.log;

  ApiClient._internal() {
    logger.info("Initializing API CLIENT");
    this.baseApiClient = new BaseApiClient();
  }

  void reloadApiUrl() {
    this.baseApiClient.reloadApiUrl();
  }

  convertToJson(Response rsp) =>
      rsp.body != null ? json.decode(rsp.body) : null;

  Map<String, dynamic> prepareForUpdate(
      Map<String, dynamic> body, List<String> fields) {
    body.removeWhere((k, v) {
      return v == null;
      // || !fields.contains(k); todo wlaczyc walidacje
    });

    body = body.map((k, v) {
      return new MapEntry(
          k,
          v?.toString());
    });
    return body;
  }

  Future<String> register(String name, String surname, String login,
      String password) {
    var body = {
      'login': login,
      'password': password,
      'name': name,
      'surname': surname
    };

    return baseApiClient.post("/user/register", body: jsonEncode(body))
        .then((rsp) {
      var json = convertToJson(rsp);
      return json["message"];
    });
  }

  Future<LoginRsp> login(String login, String password) {
    var body = {
      'login': login,
      'password': password,
    };

    return baseApiClient.post("/user/login", body: jsonEncode(body))
        .then((rsp) {
      var json = convertToJson(rsp);
      LoginRsp loginRsp = LoginRsp.fromJson(json);
      Storage.setToken(loginRsp.token).then((token){
        me().then((access){
          Storage.setCurrentAccess(access);
        });
      });
      return loginRsp;
    });
  }

  Future<Access> me() {
    return baseApiClient.get("/user")
        .then((rsp) {
      var json = convertToJson(rsp);
      return Access.fromJson(json);
    });
  }


  Future<MoviesRsp> allMovies() async {
    return baseApiClient.get("/movie").then((rsp) {
      var json = convertToJson(rsp);
      return new MoviesRsp.fromJson(json);
    });
  }

  Future<MoviesRsp> moviesFromGenre(String genre) async {
    return baseApiClient.get("/movie/category/${genre.toLowerCase()}").then((rsp) {
      var json = convertToJson(rsp);
      return new MoviesRsp.fromJson(json);
    });
  }

  Future<bool> isRented(int movieId) async {
    return baseApiClient.get("/movie/$movieId").then((rsp) {
      return rsp.body.toLowerCase()=='true';
    });
  }

  Future<CommentsRsp> commentForMovie(int movieId) async {
    return baseApiClient.get("/comment/$movieId").then((rsp) {
      var json = convertToJson(rsp);
      return new CommentsRsp.fromJson(json);
    });
  }

  Future<CommentsRsp> commentForUser() async {
    int userId;
    await Storage.getCurrentAccess().then((a){
      userId = a.user.userId;
    });
    return baseApiClient.get("/comment/user/$userId").then((rsp) {
      var json = convertToJson(rsp);
      return new CommentsRsp.fromJson(json);
    });
  }

  Future<void> postRental(Movie movie) async {
    var user;
    await Storage.getCurrentAccess().then((a){
      user = a.toJson();
    });
    String date = DateUtils.formatApiDate(DateTime.now());

    var body = {
      'rentalDate': date,
      'user' : user,
      'movie': movie.toJson()
    };

    return baseApiClient.post("/rental", body: jsonEncode(body))
        .then((rsp) {
      return rsp;
    });
  }

  Future<RentalsRsp> getRentals() async {
    return baseApiClient.get("/rental")
        .then((rsp) {
      var json = convertToJson(rsp);
      return new RentalsRsp.fromJson(json);
    });
  }

  Future<void> postComment(String comment, int rating, Movie movie) async {
    var user;
    await Storage.getCurrentAccess().then((a){
      user = a.toJson();
    });

    String date = DateUtils.formatApiDate(DateTime.now());

    var body = {
      'data': date,
      'rating': rating?.toString() ?? null,
      'comment': comment,
      'user' : user,
      'movie': movie.toJson()
    };

    return baseApiClient.post("/comment", body: jsonEncode(body))
        .then((rsp) {
      return rsp;
    });
  }
}