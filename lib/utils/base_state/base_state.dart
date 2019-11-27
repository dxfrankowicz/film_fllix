import 'dart:async';
import 'dart:io';

import 'package:film_fllix/utils/base_state/state_utils.dart';
import 'package:film_fllix/utils/event_bus_utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'base_presenter.dart';
import 'screen_state.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    implements BaseViewContract {

  final Logger logger = new Logger("BaseState");

  ThemeData theme;
  TextTheme textTheme;
  StreamSubscription activeAccessChangedSubscription;
  ScreenState _state;
  dynamic _lastException;

  @override
  void initState() {
    super.initState();

    StateUtils.runOnPostFrame(() {
      initAfterPostFrame();
    });

    activeAccessChangedSubscription =
        new EventBusUtils().eventBus.on<ActiveAccessChanged>().listen((event) {
          logger.info("Got event. Active access changed");
          onActiveAccessChanged();
        });
  }

  void initAfterPostFrame() {
//    Config().initLanguage(context);
//
//    if (Platform.isAndroid) {
//      AppUpdateService().checkForForceUpdate(context, openUpdatePage: true);
//    }
  }

  @override
  void dispose() {
    activeAccessChangedSubscription?.cancel();
    super.dispose();
  }

  @override
  @mustCallSuper
  // ignore: missing_return
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    textTheme = theme.textTheme;
  }

  void onActiveAccessChanged() {}

  void onUnreadDataChanged() {}

  void onFeedContentChanged() {}

  @override
  void setLoadingState() {
    setState(() {
      _state = ScreenState.LOADING;
    });
  }

  @override
  void setErrorState({exception}) {
    setState(() {
      _lastException = exception;
      _state = ScreenState.ERROR;
    });
  }

  @override
  void setShowingState() {
    setState(() {
      _state = ScreenState.SHOWING;
    });
  }

  bool isLoadingState() {
    return _state == ScreenState.LOADING;
  }

  bool isShowingState() {
    return _state == ScreenState.SHOWING;
  }

  bool isErrorState() {
    return _state == ScreenState.ERROR;
  }

  ScreenState get state => _state;

  dynamic get lastException => _lastException;
}