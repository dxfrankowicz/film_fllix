import 'package:film_fllix/api/middleware/utils/http_logger.dart';
import 'package:http_middleware/http_middleware.dart';

class HttpLoggerMiddleware implements MiddlewareContract {
  HttpLogger logger;

  HttpLoggerMiddleware({logLevel, maxBodySize}) {
    logger = HttpLogger(logLevel: logLevel, maxBodySize: maxBodySize);
  }

  @override
  void interceptRequest({RequestData data}) {
    logger.logRequest(data: data);
  }

  @override
  void interceptResponse({ResponseData data}) {
    logger.logResponse(data: data);
  }

  void setLogLevel(LogLevel value) {
    logger.logLevel = value;
  }
}