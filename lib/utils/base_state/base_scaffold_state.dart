import 'package:film_fllix/main.dart';
import 'package:film_fllix/utils/base_state/base_scaffold.dart';
import 'package:film_fllix/utils/navigation_utils.dart';
import 'package:flutter/material.dart';

import 'base_state.dart';


abstract class BaseScaffoldState<T extends StatefulWidget> extends BaseState<T> with RouteAware {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    activeAccessChangedSubscription?.cancel();
    super.dispose();
  }

  @override
  void didPush() {
    FFScaffold.scaffoldKey = scaffoldKey;
    logger.info("Did push ${context.toString()}");
    NavigationUtils().currentPage = context?.widget?.runtimeType ?? null;

  }

  @override
  void didPopNext() {
    FFScaffold.scaffoldKey = scaffoldKey;

    logger.info("Did popNext ${context.toString()}");
    NavigationUtils().currentPage = context?.widget?.runtimeType ?? null;
  }
}