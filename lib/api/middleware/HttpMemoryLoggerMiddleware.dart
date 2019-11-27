import 'package:http_middleware/http_middleware.dart';

class HttpMemoryLoggerMiddleware implements MiddlewareContract {
  final List<Map<String, String>> log = [];
  static const nonLoggableBodies = ["storage"];
  static const int MAX_LOG_HISTORY = 50;
  bool shouldLog = false;

  HttpMemoryLoggerMiddleware();

  @override
  void interceptRequest({RequestData data}) {
    _log(Type.REQ, data.method.toString(), data.url, data.body);
  }

  @override
  void interceptResponse({ResponseData data}) {
    _log(Type.RSP, data.method.toString(), data.url, data.body);
  }

  void _log(Type type, String method, String url, dynamic body) {
    if (!shouldLog)
      return;

    log.add({
      "date": new DateTime.now().toIso8601String(),
      "type": type.toString(),
      "method": method,
      "url": url,
      "body": nonLoggableBodies.any((t) => url.contains(t)) ? "FILTERED" : body?.toString()
    });

    if (log.length >= MAX_LOG_HISTORY) {
      log.removeAt(0);
    }
  }
}

enum Type { REQ, RSP }
