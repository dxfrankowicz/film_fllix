import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/base_state/base_nav_state.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends BaseNavState<MainPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
            appBar: AppBar(
              backgroundColor: FFColors.loginPageBackground,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(6.0),
                      child: new Image.asset(
                        "assets/film_flix_logo.png", fit: BoxFit.fitHeight,),
                    ),
                  ]
              ),
            ),
            drawer: drawer,
            body: Container(
              decoration: BoxDecoration(color: FFColors.loginPageBackground),
            ));
  }
}