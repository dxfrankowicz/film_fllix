import 'dart:async';
import 'dart:convert';

import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/utils/event_bus_utils.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'middleware/AuthMiddleware.dart';
import 'middleware/HttpLanguageMiddleware.dart';
import 'middleware/HttpLoggerMiddleware.dart';
import 'middleware/HttpMemoryLoggerMiddleware.dart';
import 'middleware/HttpValidatorMiddleware.dart';
import 'middleware/HttpWithMiddleware.dart';
import 'middleware/utils/http_logger.dart';
import 'models/auth/access.dart';


class BaseApiClient {
  final Logger logger = new Logger("BaseApiClient");

  static String baseUrl = "https://filmflix.herokuapp.com";

  AuthMiddleware _authMiddleware = AuthMiddleware(baseUrl);
  HttpLanguageMiddleware _languageMiddleware = HttpLanguageMiddleware();
  HttpMemoryLoggerMiddleware _httpMemoryLogger = HttpMemoryLoggerMiddleware();
  HttpLoggerMiddleware _httpLoggerMiddleware = HttpLoggerMiddleware(
      logLevel: LogLevel.BODY,
      maxBodySize: 1024);
  HttpValidatorMiddleware _httpValidatorMiddleware = HttpValidatorMiddleware();
  HttpWithMiddleware _inner;

  String _token;
  Access _currentAccess;
  StreamSubscription _activeAccessChangedSubscription;

  bool _clientFullyInitialized = false;

  BaseApiClient() {
    logger.info("Creating new ApiClient");

    _inner = HttpWithMiddleware.build(middlewares: [
      _languageMiddleware,
      _authMiddleware,
      _httpLoggerMiddleware,
      _httpMemoryLogger,
      _httpValidatorMiddleware
    ]);

    _activeAccessChangedSubscription = EventBusUtils()
        .eventBus
        .on<ActiveAccessChanged>()
        .listen(_onActiveAccessChanged);
  }

  void _onActiveAccessChanged(event) async {
    logger.info("Got event. Active access changed. Refreshing access in API");
    await _loadCurrentAccess(force: true);
  }

  Future<String> getBaseUrl() async {
    await reloadApiUrl();
    return baseUrl;
  }

  Future<Null> _init() async {
    if (_clientFullyInitialized) return;

    await reloadApiUrl();

    logger.info("Fully initialized ApiClient");
    _clientFullyInitialized = true;
  }

  Future<Null> reloadApiUrl() async {
    var url = await Storage.getApiUrl();
    BaseApiClient.baseUrl = url;
    logger.info("Initializing api client with url=${BaseApiClient.baseUrl}");
  }

  Future<Response> get(String url, {Map<String, String> headers}) async {
    await _loadAll(url);
    return _inner.get(baseUrl + url, headers: headers);
  }

  Future<Response> download(String url) async {
    await _loadAll(url);
    return _inner.get(url);
  }

  Future<Response> post(String url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    await _loadAll(url);
    return _inner.post(baseUrl + url,
        headers: headers, body: body, encoding: encoding);
  }

  Future<Response> put(String url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    await _loadAll(url);
    return _inner.put(baseUrl + url,
        headers: headers, body: body, encoding: encoding);
  }

  Future<Response> delete(String url, {Map<String, String> headers}) async {
    await _loadAll(url);
    return _inner.delete(baseUrl + url, headers: headers);
  }

  Future<Response> multipart(String url,
      {Map<String, String> headers, body, Encoding encoding, MultipartFile multipartFile}) async {
    await _loadAll(url);
    return _inner.multipart(baseUrl + url,
        headers: headers, body: body, encoding: encoding, multipartFile: multipartFile);
  }

  Future<Access> _loadCurrentAccess({force = false}) async {
    if (_currentAccess == null || force) {
      _currentAccess = await Storage.getCurrentAccess();
    }

    _authMiddleware.access = _currentAccess;
    return _currentAccess;
  }

  Future<void> _loadAll(String url) async {
    await _init();

    if (!url.contains("login") && !url.contains("register")) {
      await _loadToken();
      await _loadCurrentAccess();
    }
  }

  Future<String> _loadToken({force = false}) async {
    _token = await _getToken();
    _authMiddleware.token = _token;
    return _token;
  }

  Future<String> _getToken() async {
    var token = await Storage.getToken();
//    if (token.expirationDate.isBefore(new DateTime.now())) {
//      return await _refreshToken(token);
//    }
    return token ?? "";
  }

//  Future<Pair<String, DateTime>> _refreshToken(LoginRsp token) async {
//    logger.info("Refreshing token");
//    return Client().post("$baseUrl/auth/refresh",
//        headers: {"Authorization": "Bearer ${token.token}"}).then((rsp) {
//      if (rsp.statusCode == 200) {
//        var js = json.decode(rsp.body);
//        var rsp2 = new LoginRsp.fromJson(js);
//        rsp2.expirationDate =
//            new DateTime.now().add(new Duration(seconds: rsp2.expiresIn));
//        Storage.setToken(rsp2);
//        logger
//            .info("Got refreshed token ${rsp2.token}, ${rsp2.expirationDate}");
//        return new Pair(rsp2.token, rsp2.expirationDate);
//      } else {
//        throw rsp.body; //todo should full logout
//      }
//    });
//  }

  List<Map<String, String>> get log => _httpMemoryLogger.log;

  void clearCache() {
    _token = null;
    _currentAccess = null;
  }

}
