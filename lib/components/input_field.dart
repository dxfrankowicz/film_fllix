import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextInputType textInputType;
  final Color textFieldColor, iconColor;
  final bool obscureText;
  final double bottomMargin;
  final TextStyle textStyle, hintStyle;
  var validateFunction;
  var onSaved;
  final Key key;
  final bool editable;
  final String initialValue;

  InputField({this.key,
    this.hintText,
    this.obscureText,
    this.textInputType,
    this.textFieldColor,
    this.icon,
    this.iconColor,
    this.bottomMargin,
    this.textStyle,
    this.validateFunction,
    this.onSaved,
    this.hintStyle,
    this.editable = true,
    this.initialValue});

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: MediaQuery.of(context).size.width,
        margin: new EdgeInsets.only(bottom: bottomMargin),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
          color: textFieldColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: new Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.white10.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: new Icon(
                icon,
                color: iconColor,
              ),
            ),
            Expanded(
              child: new TextFormField(
                enabled: editable,
                style: textStyle,
                key: key,
                obscureText: obscureText,
                keyboardType: textInputType,
                validator: validateFunction,
                onSaved: onSaved,
                initialValue: initialValue,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: hintStyle,
                ),
              ),
            )
          ],
        ));
  }
}
