import 'dart:async';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/navigation_utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  bool _visible = true;

  startTime() async {
    var _duration = new Duration(milliseconds: 4000);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    setState(() {
      _visible = !_visible;
    });
    NavigationUtils().goToPageNamedRemovingAll(context, "/login");
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();

    startTime();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: new BoxDecoration(color: FFColors.colorPrimaryBlack),
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 5500),
          curve: Curves.easeOut,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  FadeTransition(
                    opacity: animation,
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.white10.withOpacity(0.2),
                            blurRadius: 55.0,
                            spreadRadius: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(4.0),
                    child: new Image.asset("assets/film_flix_logo.png", width: MediaQuery.of(context).size.width, height: 90.0,),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
