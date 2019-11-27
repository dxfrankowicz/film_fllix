import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarUtils {
  static void show(BuildContext context, {String message, String title, IconData icon, double iconSize, Color color, int duration}) {
    Flushbar(
      title: title,
      message: message ?? S.of(context).dialogErrorTitle,
      icon: Icon(
        icon ?? Icons.info_outline,
        size: iconSize ?? 28,
        color: color ?? FFColors.colorPrimaryRed,
      ),
      leftBarIndicatorColor: color ?? FFColors.colorPrimaryRed,
      duration: Duration(seconds: duration ?? 3),
    )..show(context);
  }
}