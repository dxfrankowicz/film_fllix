import 'package:film_fllix/api/api_client.dart';
import 'package:film_fllix/components/custom_red_error.dart';
import 'package:film_fllix/pages/login_page.dart';
import 'package:film_fllix/pages/main_page.dart';
import 'package:film_fllix/pages/movies_page.dart';
import 'package:film_fllix/pages/routes/routes.dart';
import 'package:film_fllix/pages/splash_screen.dart';
import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/logger_utils.dart';
import 'package:film_fllix/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/i18n.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Routes.defineRoutes();
  LoggerUtils.init();
  try{
    Storage.getToken().then((value) {
      if(value==null) runApp(MyApp());
      else{
        new ApiClient().me().then((v){
          runApp(MyApp());
        });
      }
    });
  }catch(e){
    Storage.deleteAll().then((value) {
      runApp(MyApp());
    });
  }
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  void setErrorBuilder(context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return Scaffold(
        body: RedErrorCustomView(errorDetails),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //locale: widget.changedLocale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales:  S.delegate.supportedLocales,
      title: 'FilmfliX',
      theme: new ThemeData(
        platform: TargetPlatform.android,
        primarySwatch: FFColors.materialColorPrimary,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: FFColors.materialColorPrimary,
        backgroundColor: FFColors.materialColorPrimary,
        accentColor: FFColors.colorAccent,
      ),
      home: MoviesPage(),
      navigatorObservers: [routeObserver],
      onGenerateRoute: Routes.router.generator,
      builder: (BuildContext _context, Widget widget) {
        setErrorBuilder(context);
        return widget;
      },
    );
  }
}

