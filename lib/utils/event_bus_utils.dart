import 'dart:ui';

import 'package:event_bus/event_bus.dart';


class EventBusUtils {
  static final EventBusUtils _singleton = new EventBusUtils._internal();
  EventBus eventBus;


  factory EventBusUtils() {
    return _singleton;
  }

  EventBusUtils._internal() {
    eventBus = new EventBus();
  }
}

class ActiveAccessChanged {

}