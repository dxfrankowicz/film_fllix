import 'package:film_fllix/theme/FF_colors.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;

  EmptyView(this.message, {this.icon, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SizedBox(height: 8.0,),
            new Icon(
              icon == null ? Icons.mail_outline : icon,
              size: iconSize == null ? 140.0 : iconSize,
              color: FFColors.colorPrimaryRed,
            ),
            new SizedBox(
              height: 16.0,
            ),
            new Text(message, textAlign: TextAlign.center),
            new SizedBox(height: 8.0,),
          ],
        ),
      ),
    );
  }
}
