import 'dart:ui';

import 'package:http_middleware/http_middleware.dart';

class HttpLanguageMiddleware implements MiddlewareContract {
  Locale currentLocale;

  @override
  void interceptRequest({RequestData data}) {
    data.headers["Accept-Language"] = currentLocale?.languageCode?.toString();
  }

  @override
  void interceptResponse({ResponseData data}) {
    
  }
}
