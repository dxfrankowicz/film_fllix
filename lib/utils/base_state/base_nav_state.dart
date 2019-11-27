import 'package:film_fllix/components/drawer.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/base_state/base_scaffold_state.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

abstract class BaseNavState<T extends StatefulWidget>
    extends BaseScaffoldState<T> {
  int _currentIndex = 0;
  BottomNavigationBar botNavBar;
  VoidCallback errorCallback;
  static double topMargin = 3.0;
  List<BottomNavigationBarItem> _navigationViews;

  FFDrawer get drawer => FFDrawer();
  AppBar get appBar => AppBar(
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
  );


  @override
  void initState() {
    super.initState();
    _buildNavigationViews();
  }

  @override
  void initAfterPostFrame() {
    super.initAfterPostFrame();
  }

  @override
  void onUnreadDataChanged() {
    setState(() {
      _buildNavigationViews(force: true);
      build(context);
    });
  }

  void _buildNavigationViews({bool force = false}) {
    _navigationViews = <BottomNavigationBarItem>[
      new BottomNavigationBarItem(
        icon: new Container(
          margin: EdgeInsets.only(top: topMargin),
          child: Icon(MdiIcons.calendar, color: Colors.grey),
        ),
        title: new Container(height: 0.0),
      ),
      new BottomNavigationBarItem(
        icon: new Container(
          margin: EdgeInsets.only(top: topMargin),
          child: Icon(MdiIcons.messageTextOutline, color: Colors.grey),
        ),
        title: new Container(height: 0.0),
      ),
      new BottomNavigationBarItem(
        icon: new Container(
          margin: EdgeInsets.only(top: topMargin),
          child: Icon(MdiIcons.homeOutline, color: Colors.grey),
        ),
        title: new Container(height: 0.0),
      ),
      new BottomNavigationBarItem(
        icon: new Container(
          margin: EdgeInsets.only(top: topMargin),
          child: Icon(MdiIcons.bellRingOutline, color: Colors.grey),
        ),
        title: new Container(height: 0.0),
      ),
      new BottomNavigationBarItem(
        icon: new Container(
          margin: EdgeInsets.only(top: topMargin),
          child: Icon(MdiIcons.accountDetails, color: Colors.grey),
        ),
        title: new Container(height: 0.0),
      )
    ];
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    super.build(context);

    botNavBar = new BottomNavigationBar(
      items: _navigationViews,
      type: BottomNavigationBarType.fixed,
      iconSize: 28.0,
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
