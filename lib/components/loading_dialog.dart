import 'dart:ui';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'ff_dialog.dart';

class LoadingDialog {
  String text;
  BuildContext context;

  LoadingDialog(this.text, this.context);

  Widget buildLoadingDialog() {
    return new SimpleDialog(
      backgroundColor: FFColors.loginPageBackground,
      children: <Widget>[
        new Container(
          child: new Center(
            child: new SpinKitWave(color: FFColors.colorPrimaryRed),
          ),
          margin: const EdgeInsets.only(bottom: 20.0),
        ),
        new Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)
      ],
    );
  }

  void showLoadingDialog() {
    FFDialog.showDialog(context: context, child: buildLoadingDialog());
  }
}

