import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fllix/api/api_client.dart';
import 'package:film_fllix/api/models/comment.dart';
import 'package:film_fllix/api/models/comments_rsp.dart';
import 'package:film_fllix/api/models/movies_rsp.dart';
import 'package:film_fllix/api/models/movie.dart';
import 'package:film_fllix/components/empty_view.dart';
import 'package:film_fllix/components/error_view.dart';
import 'package:film_fllix/components/loading_view.dart';
import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/base_state/base_nav_state.dart';
import 'package:film_fllix/utils/base_state/base_scaffold.dart';
import 'package:film_fllix/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'movie_detail_page.dart';

class UserCommentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new UserCommentsPageState();
}

class UserCommentsPageState extends BaseNavState<UserCommentsPage> {
  CommentsRsp _rsp;
  var _futureBody;

  @override
  void initState() {
    super.initState();
    _createFuture();
  }

  void _createFuture() {
    _futureBody = new FutureBuilder<CommentsRsp>(
      future: new ApiClient().commentForUser(),
      builder: (BuildContext context, AsyncSnapshot<CommentsRsp> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new LoadingView();
          default:
            if (snapshot.hasError)
              return new ErrorView(
                route: "/comment/user",
                exception: snapshot.error.toString(),
              );
            else {
              if (snapshot.data == null ||
                  snapshot.data?.comments?.length == 0) {
                return new EmptyView("No movies");
              }
              _rsp = snapshot.data;
              return _buildListView(snapshot.data);
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FFScaffold.get(
      context,
      scaffoldKey: scaffoldKey,
      drawer: drawer,
      appBar: AppBar(
        backgroundColor: FFColors.loginPageBackground,
        actions: <Widget>[],
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(6.0),
                child: new Image.asset(
                  "assets/film_flix_logo.png", fit: BoxFit.fitHeight,),
              ),
            ]
        ),
      ),
      body: _rsp != null ? _buildListView(_rsp) : _futureBody
    );
  }


  _buildListView(CommentsRsp rsp) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            Comment c = rsp.comments[index];
            return movieTile(c);
          },
          itemCount: rsp.comments.length,
        )
    );
  }

  Widget iconInfoRow(IconData icon, String text){
    return new Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: new Icon(
              icon, color: Colors.white),
        ),
        new Expanded(child: new AutoSizeText(text ?? "",
            maxLines: 2,
            minFontSize: 6.0,
            style: textTheme.body1.copyWith(
                color: Colors.white))),
      ],
    );
  }

  Widget movieTile(Comment comment){
    return GestureDetector(
      onTap: (){
        //NavigationUtils().goToPage(context, MovieDetailPage(movie));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 6.0),
        margin: EdgeInsets.only(bottom: 4.0),
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: new Container(
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                    color: Colors.white70,
                    blurRadius: 2.0,
                    spreadRadius: 0.0
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: FFColors.colorDrawerSelected,
            ),
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(child: new AutoSizeText(comment.data.toString() ?? "",
                          maxLines: 1,
                          minFontSize: 6.0,
                          style: textTheme.body1.copyWith(
                              color: Colors.white))),
                    ],
                  ),
                ),
                new Divider(color: Colors.white),
                new Row(
                  children: <Widget>[
                    new Container(
                      height: 50.0,
                      width: 40.0,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: CachedNetworkImage(
                        imageUrl: comment.movie.imageUrl ?? "",
                        fit: BoxFit.fitHeight,
                        placeholder: (context, url) => new LoadingView(),
                        errorWidget: (context, url, error) => new Icon(Icons.movie, color: Colors.white),
                      ),
                    ),
                    new Expanded(child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Expanded(child: new AutoSizeText(
                                  comment.movie.polishTitle ?? "",
                                  minFontSize: 6.0,
                                  style: textTheme.title.copyWith(
                                      color: Colors.white), maxLines: 1))
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              new Expanded(child: new AutoSizeText(
                                  comment.movie.originalTitle ?? "",
                                  minFontSize: 6.0,
                                  style: textTheme.subtitle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic),
                                  maxLines: 1))
                            ],
                          ),
                          comment.rating!=null ? StarRating(starCount: 10, rating: comment.rating.toDouble()) : Container(),
                        ],
                      ),
                    )),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(child: new AutoSizeText(
                              comment.comment ?? "",
                              maxLines: 3,
                              minFontSize: 6.0,
                              style: textTheme.body1.copyWith(
                                  color: Colors.white))),
                        ],
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}