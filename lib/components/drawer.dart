
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fllix/api/models/auth/access.dart';
import 'package:film_fllix/components/app_state.dart';
import 'package:film_fllix/components/error_view.dart';
import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/navigation_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'loading_view.dart';

class FFDrawer extends StatefulWidget {
  FFDrawer();
  @override
  State<StatefulWidget> createState() => new FFDrawerState();
}

class FFDrawerState extends State<FFDrawer>
    with SingleTickerProviderStateMixin {

  final Logger logger = new Logger("PTUDrawerState");
  ScreenState screenState = ScreenState.LOADING;
  Access access;

  @override
  void initState() {
    super.initState();
    getCurrentAccess();
  }

  void getCurrentAccess(){
    setState(() {
      screenState = ScreenState.LOADING;
    });
    Storage.getCurrentAccess().then((a){
      logger.info("access123: " + a.toString());
      access = a;
      setState(() {
        screenState = ScreenState.SHOWING;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return new Drawer(
        child: new Container(
          decoration: new BoxDecoration(color: FFColors.loginPageBackground),
          child: new Container(
            child: createBody(context, textTheme),
          ),
        ));
  }

  Widget createBody(BuildContext context, TextTheme textTheme) {
    return screenState == ScreenState.LOADING
        ? new LoadingView() : ListView(
      children: <Widget>[
        access != null
            ? new Column(
          children: <Widget>[
            createAvatarName(context, textTheme),
            createMenuDivider(),
            createMoviesMenu(context),
            createUserCommentsMenu(context),
            createUserRentalsMenu(context)
          ],
        ) : Container(),
        access == null ? new Column(
          children: <Widget>[
            createAuthMenu(context, textTheme),
            createMenuDivider(),
            createMoviesMenu(context),
          ],
        ) : Container(),
        createMenuDivider(),
        access != null ? createLogoutMenu(context) : Container(),
        createExitMenu(context)
      ],
    );
  }

  Widget createAvatarName(BuildContext context, TextTheme textTheme)  {
    logger.info("access1232 " + access.toString());
    return Container(
      color: FFColors.colorPrimaryRed.withOpacity(0.5),
      padding: const EdgeInsets.only(right: 12.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: 70.0,
            height: 70.0,
            margin: EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.all(6.0),
            child: Icon(MdiIcons.shieldAccount, size: 40.0, color: Colors.white),
          ),
          Expanded(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Flexible(
                      child: new AutoSizeText(access?.user?.name?.toString() ?? "",
                        style: textTheme.title.copyWith(color: Colors.white),
                        maxLines: 1,
                      ),)
                  ],
                ),
                SizedBox(height: 4.0),
                new Row(
                  children: <Widget>[
                    new Flexible(
                      child: new AutoSizeText(access?.user?.surname.toString() ?? "",
                      style: textTheme.title.copyWith(color: Colors.white),
                      maxLines: 1,
                    ),)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createAuthMenu(BuildContext context, TextTheme textTheme) {
    return new Column(
      children: drawerIAuthItems.map((item) {
        return new DrawerListTile(
          context,
          item,
        );
      }).toList(),
    );
  }

  Divider createMenuDivider() {
    return new Divider(
      color: Colors.white,
    );
  }
}


DrawerListTile createLogoutMenu(BuildContext context) =>
    new DrawerListTile(context, LOGOUT);

DrawerListTile createExitMenu(BuildContext context) =>
    new DrawerListTile(context, EXIT);

DrawerListTile createMoviesMenu(BuildContext context) =>
    new DrawerListTile(context, MOVIES);

DrawerListTile createUserCommentsMenu(BuildContext context) =>
    new DrawerListTile(context, USER_COMMENTS);

DrawerListTile createUserRentalsMenu(BuildContext context) =>
    new DrawerListTile(context, USER_RENTALS);

const DrawerItem LOGOUT = const DrawerItem(
    id: Section.DRAWER_LOGOUT,
    icon: MdiIcons.logout,
    path: "/login");

const DrawerItem EXIT = const DrawerItem(
    id: Section.DRAWER_EXIT,
    icon: MdiIcons.power);

const DrawerItem MOVIES = const DrawerItem(
  id: Section.DRAWER_MOVIES,
  icon: MdiIcons.libraryMovie,
  path: "/movies",
  drawerSubmenu: DrawerSubmenu.DIARY,
);

const DrawerItem USER_COMMENTS = const DrawerItem(
  id: Section.DRAWER_USER_COMMENTS,
  icon: Icons.comment,
  path: "/comment/user",
  drawerSubmenu: DrawerSubmenu.DIARY,
);

const DrawerItem USER_RENTALS = const DrawerItem(
  id: Section.DRAWER_RENTALS,
  icon: MdiIcons.movieOpen,
  path: "/rentals",
  drawerSubmenu: DrawerSubmenu.DIARY,
);

class DrawerItem {
  const DrawerItem(
      {this.id,
        this.icon,
        this.path,
        this.drawerSubmenu,
        this.showTile});

  final Section id;
  final IconData icon;
  final String path;
  final DrawerSubmenu drawerSubmenu;
  final bool showTile;
}

List<DrawerItem> drawerIAuthItems = <DrawerItem>[
  const DrawerItem(
      id: Section.DRAWER_LOGIN,
      icon: Icons.person,
      path: "/login",
      drawerSubmenu: DrawerSubmenu.DIARY),
  const DrawerItem(
      id: Section.DRAWER_REGISTRATION,
      icon: MdiIcons.accountPlus,
      path: "/registration",
      drawerSubmenu: DrawerSubmenu.DIARY),
];

enum Section {
  DRAWER_LOGIN,
  DRAWER_REGISTRATION,
  DRAWER_MOVIES,
  DRAWER_EXIT,
  DRAWER_LOGOUT,
  DRAWER_USER_COMMENTS,
  DRAWER_RENTALS
}

String getTranslatedTitle(BuildContext context, DrawerItem item) {
  switch (item.id) {
    case Section.DRAWER_LOGIN:
      return S.of(context).drawerLogin;
    case Section.DRAWER_REGISTRATION:
      return S.of(context).drawerSignUp;
    case Section.DRAWER_LOGOUT:
      return S.of(context).drawerLogOut;
    case Section.DRAWER_MOVIES:
      return S.of(context).drawerMovies;
    case Section.DRAWER_EXIT:
      return S.of(context).drawerExit;
    case Section.DRAWER_USER_COMMENTS:
      return S.of(context).drawerComments;
    case Section.DRAWER_RENTALS:
      return S.of(context).drawerRentals;
    default:
      return "ADD TRANSLATION";
  }
}

class DrawerListTile extends StatelessWidget {
  final BuildContext context;
  final DrawerItem drawerItem;
  final bool showTile;

  DrawerListTile(this.context, this.drawerItem, {this.showTile=true});

  @override
  Widget build(BuildContext context) {
    var isSelected = AppState().selectedDrawerItem != null &&
        drawerItem.id == AppState().selectedDrawerItem;
    return Container(
      child: ListTile(
          title: new Text(getTranslatedTitle(context, drawerItem).toUpperCase(),
              style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white)),
          leading: new Icon(drawerItem.icon, color: Colors.white),
          selected: isSelected,
          enabled: !isSelected,
          onTap: () {
            if(drawerItem.id != Section.DRAWER_LOGIN && drawerItem.id != Section.DRAWER_REGISTRATION && drawerItem.id != Section.DRAWER_EXIT)
              AppState().selectedDrawerItem = drawerItem.id;
            if (drawerItem.id == Section.DRAWER_LOGOUT) {
              new NavigationUtils().logout(context);
            }
            else if (drawerItem.id == Section.DRAWER_EXIT){
              new NavigationUtils().logout(context);
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
            else {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(drawerItem.path);
            }
          }),
      decoration: BoxDecoration(
          color: isSelected
              ? FFColors.colorPrimaryRed.withOpacity(0.5)
              : FFColors.loginPageBackground),
    );
  }
}

enum DrawerSubmenu { ROLES, PERSONAL, DIARY, CLUB, SETTINGS }
enum ScreenState { LOADING, SHOWING, ERROR, EMPTY }
