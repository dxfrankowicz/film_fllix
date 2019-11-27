import 'package:film_fllix/api/middleware/utils/http_logger.dart';
import 'package:film_fllix/api/models/auth/access.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:logging/logging.dart';

class AuthMiddleware implements MiddlewareContract {
  final Logger logger = new Logger("AuthMiddleware");

  LogLevel logLevel;
  String baseUrl;
  String token;
  Access access;

  AuthMiddleware(this.baseUrl);

  @override
  void interceptRequest({RequestData data}) {
    if (!data.url.contains("login") && !data.url.contains("register")) {
      data.headers["Authorization"] = "Bearer ${token ?? "brak"}";
      logger.info("Bearer${token ?? "brak"}");
      logger.info("Access ${access?.user?.name ?? "brak"} ${access?.user?.surname ?? "brak"}");
    }
  }

  @override
  void interceptResponse({ResponseData data}) {
  }
}