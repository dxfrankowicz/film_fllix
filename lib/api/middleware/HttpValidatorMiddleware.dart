import 'package:http_middleware/http_middleware.dart';

class HttpValidatorMiddleware implements MiddlewareContract {
  static const Map<String, String> errorWhitelist = {

  };

  @override
  void interceptRequest({RequestData data}) {}

  @override
  void interceptResponse({ResponseData data}) {
    if (data != null && (data.statusCode < 200 || data.statusCode > 300)) {
      errorWhitelist.forEach((url, rsp) {
        if (data.url.contains(url) && data.body.contains(rsp)) {
          return;
        }
      });

      //throw data.body;
    }
  }
}
