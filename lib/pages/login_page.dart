import 'dart:ui';
import 'package:animator/animator.dart';
import 'package:film_fllix/api/api_client.dart';
import 'package:film_fllix/components/input_field.dart';
import 'package:film_fllix/components/loading_dialog.dart';
import 'package:film_fllix/components/rounded_button.dart';
import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/pages/registration_page.dart';
import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/theme/style.dart';
import 'package:film_fllix/utils/base_state/base_nav_state.dart';
import 'package:film_fllix/utils/base_state/base_scaffold.dart';
import 'package:film_fllix/utils/event_bus_utils.dart';
import 'package:film_fllix/utils/flushbar_utils.dart';
import 'package:film_fllix/utils/navigation_utils.dart';
import 'package:film_fllix/utils/toast_utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class LoginPage extends StatefulWidget {

  final bool confirmationLogin;
  final String activationLink;

  LoginPage({this.confirmationLogin = false, this.activationLink});

  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends BaseNavState<LoginPage> with TickerProviderStateMixin {
  final Logger logger = new Logger("LoginPageState");
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  bool isLoading = false;
  String token;

  AnimationController controller;
  Animation<double> animation;

  AnimationController controllerOpen;
  Animation<double> animationOpen;

  @override
  void initState() {
    super.initState();

    controllerOpen = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animationOpen =
        CurvedAnimation(parent: controllerOpen, curve: Curves.easeIn);

    controllerOpen.forward();
    animationOpen.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.forward();
      }
    });

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
    //controller.forward();
  }

  @override
  void dispose() {
    controllerOpen.dispose();
    controller.dispose();
    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      _performLogin();
    }
  }

  void _performLogin() {
    if (!validateFields()) {
      return;
    }

    new LoadingDialog(S.of(context).loginLogging, context).showLoadingDialog();

    new ApiClient().login(_email, _password).then((rsp) {
      if(rsp){
        Navigator.of(context).pop();
        NavigationUtils().goToPageNamedRemovingAll(context, "/movies");
        FlushbarUtils.show(context, message: S.of(context).loginLoggedSuccessfully, color: Colors.lightGreen, icon: Icons.check_circle);
      }
      else{
        Navigator.of(context).pop();
        FlushbarUtils.show(context, message: S.of(context).loginWrongPassword);
      }
    }).catchError((ex) {
      Navigator.of(context).pop();
      String msg = "Wystąpił błąd. Sprawdź połączenie sieciowe";
      print(ex.toString());
      showDialog<Null>(
          context: context,
          child: new AlertDialog(
            title: new Text(S.of(context).dialogErrorTitle),
            content: new Text(msg),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("OK"))
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size screenSize = MediaQuery.of(context).size;
    final logo = new Column(
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
            Animator(
              tween: Tween<double>(begin: -0.1, end: 0.1),
              curve: Curves.bounceInOut,
              cycles: 0,
              builder: (anim) =>
                  Transform.rotate(
                    angle: anim.value,
                    child: new Container(
                      padding: const EdgeInsets.all(12.0),
                      child: new Image.asset(
                        "assets/film_flix_logo.png", fit: BoxFit.fitWidth,),
                    ),
                  ),
            )
          ],
        ),
      ],
    );
    return FFScaffold.get(
      context,
      scaffoldKey: scaffoldKey,
      body: new SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom*0.5),
          decoration: new BoxDecoration(color: FFColors.loginPageBackground),
          child: FadeTransition(
            opacity: animationOpen,
            child: new Column(
              children: <Widget>[
                SizedBox(
                  height: 8.0,
                ),
                logo,
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: FFColors.colorPrimaryRed.withOpacity(0.7),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(S.of(context).drawerLogin.toUpperCase(), style: textTheme.title.copyWith(color: Colors.white))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                new Container(
                  margin: new EdgeInsets.only(
                      bottom: 70.0, left: 16.0, right: 16.0),
                  child: new Form(
                    key: formKey,
                    autovalidate: true,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new InputField(
                            hintText: S.of(context).login,
                            obscureText: false,
                            textInputType: TextInputType.text,
                            textStyle: textStyle,
                            textFieldColor: textFieldColor,
                            icon: Icons.person,
                            hintStyle: new TextStyle(
                                color: Colors.white.withAlpha(100)),
                            iconColor: Colors.white,
                            bottomMargin: 20.0,
                            onSaved: (String email) {
                              _email = email;
                            }),
                        new InputField(
                            hintText: S.of(context).loginPassword,
                            obscureText: true,
                            textInputType: TextInputType.text,
                            textStyle: textStyle,
                            hintStyle: new TextStyle(
                                color: Colors.white.withAlpha(100)),
                            textFieldColor: textFieldColor,
                            icon: Icons.lock_outline,
                            iconColor: Colors.white,
                            bottomMargin: 30.0,
                            onSaved: (String password) {
                              _password = password;
                            }),
                        new RoundedButton(
                          buttonName: S.of(context).login,
                          onTap: _submit,
                          width: screenSize.width,
                          height: 50.0,
                          bottomMargin: 10.0,
                          borderWidth: 0.0,
                          buttonColor: primaryColor,
                        ),
                        new RoundedButton(
                          buttonName: S.of(context).loginRegister,
                          onTap: _launchRegisterUrl,
                          width: screenSize.width,
                          height: 50.0,
                          bottomMargin: 10.0,
                          borderWidth: 1.0,
                          buttonColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchRegisterUrl() async {
    NavigationUtils().goToPage(context, RegistrationPage());
  }

  bool validateFields() {
    bool validation = true;
    if((_email == null || _email.isEmpty) && (_password == null || _password.isEmpty)){
      validation = false;
      FlushbarUtils.show(context, message: S.of(context).loginEmptyLoginAndPassword, title: S.of(context).dialogErrorTitle);
    }
    else if (_email == null || _email.isEmpty) {
      validation = false;
      FlushbarUtils.show(context, message: S.of(context).loginEmptyLogin, title: S.of(context).dialogErrorTitle);
    } else if (_password == null || _password.isEmpty) {
      validation = false;
      FlushbarUtils.show(context, message: S.of(context).loginEmptyPassword, title: S.of(context).dialogErrorTitle);
    }

    return validation;
  }
}
