import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fllix/api/api_client.dart';
import 'package:film_fllix/api/models/movies_rsp.dart';
import 'package:film_fllix/api/models/movie.dart';
import 'package:film_fllix/api/models/rental.dart';
import 'package:film_fllix/api/models/rentals_rsp.dart';
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
import 'package:ribbon/ribbon.dart';

import 'movie_detail_page.dart';

class RentalsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RentalsPageState();
}

class RentalsPageState extends BaseNavState<RentalsPage> {
  RentalsRsp _rsp;
  var _futureBody;

  @override
  void initState() {
    super.initState();
    _createFuture();
  }

  void _createFuture() {
    _futureBody = new FutureBuilder<RentalsRsp>(
      future: new ApiClient().getRentals(),
      builder: (BuildContext context, AsyncSnapshot<RentalsRsp> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new LoadingView();
          default:
            if (snapshot.hasError)
              return new ErrorView(
                route: "/rentals",
                exception: snapshot.error.toString(),
              );
            else {
              if (snapshot.data == null ||
                  snapshot.data?.rentals?.length == 0) {
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


  _buildListView(RentalsRsp rsp) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            Rental m = rsp.rentals[index];
            return movieTile(m);
          },
          itemCount: rsp.rentals.length,
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

  Widget movieTile(Rental rental){
    return GestureDetector(
      onTap: ()=>NavigationUtils().goToPage(context, MovieDetailPage(rental.movie, isRented: true,)),
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
                new Stack(
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height / 5,
                      margin: EdgeInsets.only(right: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(12.0)),
                        child: CachedNetworkImage(
                          imageUrl: rental.movie.imageUrl ?? "",
                          fit: BoxFit.fitHeight,
                          placeholder: (context, url) => new LoadingView(),
                          errorWidget: (context, url, error) => new Icon(Icons.movie, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      child: new Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height / 25,
                        decoration: BoxDecoration(
                          color: FFColors.btnAccept.withOpacity(0.8),
                        ),
                        margin: EdgeInsets.only(right: 4.0),
                        child: new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(Icons.check_circle, color: Colors.white, size: 15.0,),
                            ),
                            new Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: new AutoSizeText(
                                rental.rentalDate, maxLines: 1,
                                minFontSize: 6.0,
                                style: textTheme.body2.copyWith(
                                    color: Colors.white),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
                                    new Expanded(child: new AutoSizeText(rental.movie.polishTitle ?? "",
                                        minFontSize: 6.0,
                                        style: textTheme.title.copyWith(
                                            color: Colors.white), maxLines: 1))
                                  ],
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Expanded(child: new AutoSizeText(
                                        rental.movie.originalTitle ?? "",
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
                                  new Text(rental.movie.rating?.toString() ?? "-", style: textTheme.body2.copyWith(color: Colors.white))
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
                            Expanded(child: iconInfoRow(Icons.monetization_on, rental.movie.price?.toStringAsFixed(2) ?? "")),
                            Expanded(child: iconInfoRow(Icons.timelapse, "${rental.movie.duration ?? "0"} min")),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Expanded(
                          child: new Row(
                            children: <Widget>[
                              Expanded(child: iconInfoRow(Icons.category, rental.movie.genere ?? "")),
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