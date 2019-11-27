import 'drawer.dart';

class AppState {

  static final AppState _singleton = new AppState._internal();
  Section selectedDrawerItem;
  int pusherSubscribedConversation;

  factory AppState() {
    return _singleton;
  }

  AppState._internal() {
    selectedDrawerItem = Section.DRAWER_MOVIES;
  }

}