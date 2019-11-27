import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  String buttonName;
  final VoidCallback onTap;

  double height;
  double width;
  double bottomMargin;
  double borderWidth;
  Color buttonColor;
  IconData iconData;

  TextStyle textStyle = const TextStyle(
      color: const Color(0XFFFFFFFF),
      fontSize: 16.0,
      fontWeight: FontWeight.bold);

  //passing props in react style
  RoundedButton(
      {this.buttonName,
        this.onTap,
        this.height,
        this.bottomMargin,
        this.borderWidth,
        this.width,
        this.buttonColor,
        this.iconData});

  @override
  Widget build(BuildContext context) {
    if (borderWidth != 0.0)
      return (new InkWell(
        onTap: onTap,
        child: new Container(
          width: width,
          height: height,
          margin: new EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
              color: buttonColor,
              borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
              border: new Border.all(
                  color: const Color.fromRGBO(221, 221, 221, 1.0),
                  width: borderWidth)),
          child: iconData == null ? new Text(buttonName, style: textStyle) : new Icon(iconData),
        ),
      ));
    else
      return (new InkWell(
        onTap: onTap,
        child: new Container(
          width: width,
          height: height,
          margin: new EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: buttonColor,
            borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
          ),
          child: iconData == null ? new Text(buttonName, style: textStyle) : new Icon(iconData),
        ),
      ));
  }
}
