import 'package:film_fllix/theme/FF_colors.dart';
import 'package:flutter/material.dart';

class FFScaffold {
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  static set scaffoldKey(GlobalKey<ScaffoldState> value) {
    _scaffoldKey = value;
  }

  static GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  static Widget get(BuildContext context,
      {appBar,
      body,
      resizeToAvoidBottomPadding,
      resizeToAvoidBottomInset,
      floatingActionButton,
      floatingActionButtonLocation,
      floatingActionButtonAnimator,
      persistentFooterButtons,
      drawer,
      endDrawer,
      botNavBar,
      bottomSheet,
      backgroundColor,
      scaffoldKey}) {

    return new Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: resizeToAvoidBottomInset,
        resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
        backgroundColor: backgroundColor ?? FFColors.loginPageBackground,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        endDrawer: endDrawer,
        appBar: appBar ?? FFScaffold.appBar(context),
        drawer: drawer,
        bottomSheet: bottomSheet,
        bottomNavigationBar: botNavBar,
        body: body);
  }

  static AppBar appBar(BuildContext context, {actions}) => new AppBar(
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: new Container(
                  padding: EdgeInsets.all(6.0),
                  child: new Image.asset(
                    "assets/film_flix_logo.png", fit: BoxFit.fitHeight,),
                ),
              ),
            ]
        ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: actions,
      );
}
