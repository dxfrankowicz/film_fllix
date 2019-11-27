import 'dart:io';
import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:flutter/material.dart';


class ErrorView extends StatelessWidget {
  final VoidCallback voidCallback;
  final String route;
  final dynamic exception;

  ErrorView({this.voidCallback, this.route, this.exception});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: voidCallback != null ? voidCallback : () {
        if (route != null) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.error_outline,
              size: 140.0,
              color: FFColors.colorAccent,
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            new Text("Błąd autoryzacji", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }
}

class ExceptionTranslator {
  static String getErrorInfo(BuildContext context, ex) {
    if (ex != null && ex is SocketException) {
      return "Błąd sieciowy";
    }
    else if(ex.toString().contains("unauthorized")){
      return "Błąd autoryzacji";
    }
    else {
      return "Error";
    }
  }
}