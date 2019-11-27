import 'package:film_fllix/theme/FF_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SpinKitRing(
      color: FFColors.colorPrimaryRed,
      size: 50.0,
    );
  }
}