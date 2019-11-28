import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fllix/api/api_client.dart';
import 'package:film_fllix/api/models/movies_rsp.dart';
import 'package:film_fllix/api/models/movie.dart';
import 'package:film_fllix/components/loading_view.dart';
import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/base_state/base_nav_state.dart';
import 'package:film_fllix/utils/base_state/base_scaffold.dart';
import 'package:film_fllix/utils/navigation_utils.dart';
import 'package:film_fllix/utils/toast_utils.dart';
import 'package:flutter/material.dart';

import 'movie_detail_page.dart';

class MoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MoviesPageState();
}

class MoviesPageState extends BaseNavState<MoviesPage> {
  MoviesRsp _rsp;
  List<String> genresSetList;
  String chosenGenre;


  @override
  void initState() {
    super.initState();
    setLoadingState();
    genresSetList = new List();
    genresSetList.add("All");
    chosenGenre = genresSetList.first;
    getMovies();
    //_createFuture();
  }

  void getMovies({String genre}){
    setLoadingState();
    var req;
    if(genre!=null && genre!="All"){
      req = new ApiClient().moviesFromGenre(genre);
      chosenGenre = genre;
    }
    else{
      req = new ApiClient().allMovies();
    }
    req.then((movies){
      _rsp = movies;
      _rsp.movies.forEach((m){
        m.genere.split(",").forEach((v){
          if(!genresSetList.contains(v.trim()))
          genresSetList.add(v.trim());
        });
      });
      genresSetList.sort((a, b){
        return a.toLowerCase().compareTo(b.toLowerCase());
      });

      Storage.getCurrentAccess().then((v){
        if(v!=null){
          checkMoviesRentals();
        }
        else{
          setShowingState();
        }
      });
    });
  }

  void _createFuture() {
//    _futureBody = new FutureBuilder<MoviesRsp>(
//      future: new ApiClient().allMovies(),
//      builder: (BuildContext context, AsyncSnapshot<MoviesRsp> snapshot) {
//        switch (snapshot.connectionState) {
//          case ConnectionState.none:
//          case ConnectionState.waiting:
//            return new LoadingView();
//          default:
//            if (snapshot.hasError)
//              return new ErrorView(
//                route: "/movies",
//                exception: snapshot.error.toString(),
//              );
//            else {
//              if (snapshot.data == null ||
//                  snapshot.data?.movies?.length == 0) {
//                return new EmptyView("No movies");
//              }
//              _rsp = snapshot.data;
//              return _buildListView(snapshot.data);
//            }
//        }
//      },
//    );
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
        actions: <Widget>[
          new Flexible(child: buildGenreDropDown(context))
        ],
        title: new Row(
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
      body: _buildListView()
    );
  }


  void checkMoviesRentals(){
    setLoadingState();
    List<Future> list = new List();

    _rsp.movies.forEach((m){
        list.add(new ApiClient().isRented(m.movieId).then((rented){
          m.isRented=rented;
        }));
      });

    Future.wait(list).then((v1){
      setShowingState();
    }).catchError((e){
      ToastUtils.showShort(e.toString());
      setShowingState();
    });
  }

  Widget buildGenreDropDown(BuildContext context) {
    return Container(
      width: 100.0,
      child: Theme(
        data: ThemeData.dark(),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton<String>(
            isExpanded: true,
            hint: Container(
                width: 100.0,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new AutoSizeText(
                          chosenGenre,
                          textAlign: TextAlign.center,
                          minFontSize: 6.0,
                          maxFontSize: 15.0,
                          maxLines: 1,
                          style: textTheme.body1.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                )),
            items: genresSetList.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (value != chosenGenre) {
                setState(() {
                  chosenGenre = value;
                  getMovies(genre: value);
                });
              }
            },
          ),
        ),
      ),
    );
  }

  _buildListView() {
    return isLoadingState() ? LoadingView() : Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: _rsp.movies.map((m){
            return movieTile(m);
          }).toList(),
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

  Widget movieTile(Movie movie){
    return GestureDetector(
      onTap: () async {
        new NavigationUtils().openDialog(context, MovieDetailPage(movie, onRentedChange: (rented) {
          setState(() {
            movie.isRented = rented;
          });
        }));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 6.0),
        margin: EdgeInsets.only(bottom: 4.0),
        height: MediaQuery.of(context).size.height/5,
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
            child: new Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height / 5,
                      margin: EdgeInsets.only(right: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(12.0)),
                        child: CachedNetworkImage(
                          imageUrl: movie.imageUrl ?? "",
                          fit: BoxFit.fitHeight,
                          placeholder: (context, url) => new LoadingView(),
                          errorWidget: (context, url, error) => new Icon(Icons.movie, color: Colors.white),
                        ),
                      ),
                    ),
                    movie.isRented!=null && movie.isRented ? Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      child: new Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height / 25,
                        decoration: BoxDecoration(
                          color: FFColors.btnAccept.withOpacity(0.8),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.0))
                        ),
                        margin: EdgeInsets.only(right: 4.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.check_circle, color: Colors.white, size: 15.0,),
                            ),
                            new Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: new AutoSizeText(
                                  S.of(context).moviesRented, maxLines: 1,
                                  minFontSize: 6.0,
                                  style: textTheme.body2.copyWith(
                                      color: Colors.white),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
                new Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Expanded(child: new Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Expanded(child: new AutoSizeText(movie.polishTitle ?? "",
                                        minFontSize: 6.0,
                                        style: textTheme.title.copyWith(
                                            color: Colors.white), maxLines: 1))
                                  ],
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Expanded(child: new AutoSizeText(
                                        movie.originalTitle ?? "",
                                        minFontSize: 6.0,
                                        style: textTheme.subtitle.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic),
                                        maxLines: 1))
                                  ],
                                )
                              ],
                            )),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Icon(Icons.star, color: Colors.yellow),
                                  new Text(movie.rating?.toInt()?.toStringAsFixed(1) ?? "-", style: textTheme.body2.copyWith(color: Colors.white))
                                ],
                              ),
                            )
                          ],
                        ),
                        new Divider(
                          color: Colors.white,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(child: iconInfoRow(Icons.monetization_on, movie.price?.toStringAsFixed(2) ?? "")),
                            Expanded(child: iconInfoRow(Icons.timelapse, "${movie.duration ?? "-"} min")),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Expanded(
                          child: new Row(
                            children: <Widget>[
                              Expanded(child: iconInfoRow(Icons.category, movie.genere ?? "")),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}