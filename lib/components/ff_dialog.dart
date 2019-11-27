import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FFDialog {
  static Future<T> showDialog<T>({
    @required BuildContext context,
    bool barrierDismissible: true,
    @required Widget child,
  }) {
    return Navigator.of(context, rootNavigator: true).push(new _DialogRoute<T>(
      child: child,
      theme: Theme.of(context, shadowThemeOnly: true),
    ));
  }
}

class _DialogRoute<T> extends PopupRoute<T> {
  _DialogRoute({
    @required this.theme,
    bool barrierDismissible: true,
    this.barrierLabel,
    @required this.child,
  })
      : assert(barrierDismissible != null),
        _barrierDismissible = barrierDismissible;

  final Widget child;
  final ThemeData theme;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  Color get barrierColor => Colors.black54;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: new Builder(builder: (BuildContext context) {
        return theme != null ? new Theme(data: theme, child: child) : child;
      }),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }
}
