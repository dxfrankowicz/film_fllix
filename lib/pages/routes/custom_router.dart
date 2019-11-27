import 'package:fluro/fluro.dart';
import 'package:meta/meta.dart';

class CustomRouter extends Router {
  void defineMultiplePaths(List<String> routePath, {@required Handler handler}) {
    routePath.forEach((path) => define(path, handler: handler));
  }
}