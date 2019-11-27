import 'package:film_fllix/pages/login_page.dart';
import 'package:film_fllix/pages/main_page.dart';
import 'package:film_fllix/pages/movies_page.dart';
import 'package:film_fllix/pages/registration_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../rentals_page.dart';
import '../user_comments_page.dart';
import 'custom_router.dart';


class Routes {
  static final router = new CustomRouter();

  static void defineRoutes() {

    router.define("/main", handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return new MainPage();
        }));

    router.define("/", handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return new LoginPage();
        }));

    router.define("/login", handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return new LoginPage();
        }));

    router.define("/registration", handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return new RegistrationPage();
        }));

    router.define("/movies", handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return new MoviesPage();
        }));

    router.define("/rentals", handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return new RentalsPage();
        }));

    router.define("/comment/user", handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return new UserCommentsPage();
        }));
  }

  static MaterialPageRoute createPageRoute(
      Widget page, RouteSettings settings) {
    return new MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
