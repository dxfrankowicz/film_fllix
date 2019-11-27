import 'package:film_fllix/components/rounded_button.dart';
import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RedErrorCustomView extends StatelessWidget {

  final FlutterErrorDetails error;

  RedErrorCustomView(this.error);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => new Container(
        color: FFColors.loginPageBackground,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: new Icon(
                MdiIcons.emoticonSad,
                size: 120.0,
                color: FFColors.gpColor,
              ),
            ),
            new Text(
              S.of(context).errorCustomPageOops.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: FFColors.gpColor),
            ),
            new Text(
              error.summary.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white),
            ),
            SizedBox(
              height: 12.0,
            ),
            new Text(
              S.of(context).errorCustomPageUnexpectedErrorOccurred,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: new RoundedButton(
                buttonName: S.of(context).commonReturn.toUpperCase(),
                onTap: () {
                  NavigationUtils().goBack(context);
                },
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                bottomMargin: 10.0,
                borderWidth: 0.0,
                buttonColor: FFColors.btnAccept,
              ),
            ),
          ],
        ),
      ),
    );
  }
}