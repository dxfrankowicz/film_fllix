import 'dart:async';
import 'package:film_fllix/components/app_state.dart';
import 'package:film_fllix/components/drawer.dart';
import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/utils/base_state/base_nav_state.dart';
import 'package:film_fllix/utils/flushbar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NavigationUtils {
  final Logger logger = new Logger("NavigationUtils");
  static final NavigationUtils _singleton = new NavigationUtils._internal();
  bool isInitialized = false;

  Type currentPage;

  factory NavigationUtils() {
    return _singleton;
  }

  NavigationUtils._internal() {
    isInitialized = false;
  }

  void init(BuildContext context) {
    if (isInitialized) {
      isInitialized = true;
    }
  }

  void logout(BuildContext context) {
    Storage.deleteAll().then((value) {
      Navigator.of(context).pushNamedAndRemoveUntil("/movies", (Route<dynamic> route) => false);
      FlushbarUtils.show(context, message: S.of(context).loginLoggedOutSuccessfully, color: Colors.lightGreen, icon: Icons.check_circle);
    });
  }

  void goToPage(BuildContext context, Widget page) {
    if (page == null) return;

    logger.info("Navigating to ${page.runtimeType}");
    
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return page;
        }));
  }

  void goToPageNamed(BuildContext context, String routeName) {
    if (routeName == null) return;

    logger.info("Navigating to $routeName");

    Navigator.pushNamed(context, routeName);
  }

  void goToPageNamedReplace(BuildContext context, String routeName) {
    if (routeName == null) return;

    logger.info("Navigating to $routeName with replace");

    Navigator.pushReplacementNamed(context, routeName);
  }

  void goToPageNamedRemovingAll(BuildContext context, String routeName) {
    if (routeName == null) return;

    logger.info("Navigating to $routeName. Removing all route");

    Navigator.of(context)
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<T> openDialog<T>(BuildContext context, Widget dialog) async {
    if (dialog == null) return null;

    logger.info("Opening dialog ${dialog.runtimeType}");

    return Navigator.push(
        context,
        new MaterialPageRoute<T>(
          builder: (BuildContext context) => dialog,
          fullscreenDialog: true,
        ));
  }


  void openWebView(BuildContext context, String url,
      {String title = "FILMFLIX"}) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
          return new WebviewScaffold(
            url: url,
            appBar: new AppBar(
              title: new Text(title),
            ),
          );
        }));
  }
}
