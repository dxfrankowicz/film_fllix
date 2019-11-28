import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:film_fllix/api/api_client.dart';
import 'package:film_fllix/api/models/comment.dart';
import 'package:film_fllix/api/models/movie.dart';
import 'package:film_fllix/components/loading_view.dart';
import 'package:film_fllix/generated/i18n.dart';
import 'package:film_fllix/storage/storage.dart';
import 'package:film_fllix/theme/FF_colors.dart';
import 'package:film_fllix/utils/base_state/base_nav_state.dart';
import 'package:film_fllix/utils/base_state/base_scaffold.dart';
import 'package:film_fllix/utils/flushbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logging/logging.dart';
import 'package:animator/animator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MovieDetailPage extends StatefulWidget {

  final Movie movie;
  final bool isRented;
  final ValueChanged<bool> onRentedChange;

  MovieDetailPage(this.movie, {this.isRented=false, this.onRentedChange});

  @override
  State<StatefulWidget> createState() {
    return new MovieDetailPageState();
  }
}

class MovieDetailPageState extends BaseNavState<MovieDetailPage> with TickerProviderStateMixin {
  final Logger logger = new Logger("MovieDetailPageState");

  Movie _movie;
  List<Comment> _commentList;
  bool isLoadingComments = false;
  bool addComment = false;
  int starCount = 10;

  bool _isRented;
  bool _isPlaying = false;
  bool _isLogged = false;

  String _comment;
  double _commentRate = 0.0;
  bool isMessageSending = false;
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _movie = widget.movie;
    _isRented = widget.movie.isRented ?? widget.isRented;
    Storage.getCurrentAccess().then((v){
      _isLogged = v!=null;
    });
    loadComments();
  }

  void loadComments() {
    setState(() {
      isLoadingComments = true;
    });
    new ApiClient().commentForMovie(widget.movie.movieId).then((v){
      _commentList = v.comments;
      setState(() {
        _movie.rating = calculateNewRating();
        isLoadingComments = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (widget.isRented != _isRented && _isRented) return true;
    else return false;
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
            maxLines: 1,
            minFontSize: 6.0,
            style: textTheme.body1.copyWith(
                color: Colors.white))),
      ],
    );
  }

  _buildCommentList() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: _commentList!=null && _commentList.isNotEmpty ? new Column(
          children: _commentList.map((c){
            return commentItem(c);
          }).toList(),
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Icon(MdiIcons.commentProcessingOutline, color: FFColors.colorPrimaryRed, size: 40.0,),
            ),
            new Text(S.of(context).movieDetailsNoComments.toUpperCase(), style: textTheme.body2.copyWith(color: Colors.white),)
          ],
        )
    );
  }

  Widget commentItem(Comment comment){
    return Container(
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
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Expanded(child: new AutoSizeText(comment.user?.login ?? "",
                    maxLines: 1,
                    minFontSize: 6.0,
                    style: textTheme.subtitle.copyWith(
                        color: Colors.white))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: new AutoSizeText(comment.data.toString() ?? "",
                      maxLines: 1,
                      minFontSize: 6.0,
                      style: textTheme.body1.copyWith(
                          color: Colors.white)),
                ),
              ],
            ),
            new Divider(
              color: Colors.white,
            ),
            comment.rating != null
                ? StarRating(starCount: starCount, rating: comment.rating.toDouble())
                : Container(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(child: new AutoSizeText(comment.comment ?? "",
                      maxLines: 3,
                      minFontSize: 6.0,
                      style: textTheme.body1.copyWith(
                          color: Colors.white))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playButton() {
    return GestureDetector(
      onTap: (){
        setState(() {
          _isPlaying = !_isPlaying;
        });
      },
      child: AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        child: _isPlaying
            ? new Container(
            key: UniqueKey(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                new BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 10.0,
                    spreadRadius: 5.0
                )
              ],
            ),
            child: new Icon(Icons.pause_circle_filled, size: 75.0,
                color: FFColors.colorAccent))
            : new Container(
            key: UniqueKey(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                new BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 10.0,
                    spreadRadius: 8.0
                )
              ],
            ),
            child: new Icon(Icons.play_circle_filled, size: 75.0,
                color: FFColors.colorPrimaryRed)),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget rentButton() =>
      new GestureDetector(
        onTap: (){
          new ApiClient().postRental(_movie).then((v){
            FlushbarUtils.show(context, title: S.of(context).movieRent, message: S.of(context).movieRented, color: Colors.lightGreen, icon: Icons.check_circle);
            widget.onRentedChange(true);
            setState(() {
              _isRented = true;
            });
          });
        },
        child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: FFColors.colorPrimaryRed,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              boxShadow: [
                new BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 10.0,
                    spreadRadius: 8.0
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Text(S.of(context).movieRent.toUpperCase(), style: textTheme.title.copyWith(color: Colors.white),
            )),
      ));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FFScaffold.get(
      context,
      scaffoldKey: scaffoldKey,
      body: new ListView(
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: _movie.imageUrl ?? "",
                      fit: BoxFit.fill,
                      placeholder: (context, url) => new LoadingView(),
                      errorWidget: (context, url, error) => new Icon(Icons.movie, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                      )),
                ),
                _isPlaying ? Animator(
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    cycles: 0,
                    builder: (anim2) =>
                        Transform.scale(
                          scale: anim2.value,
                          child: Animator(
                            tween: Tween<Offset>(begin: Offset(-1, 0), end: Offset(1, 0)),
                            duration: Duration(seconds: 4),
                            cycles: 0,
                            builder: (anim1) =>
                                SlideTransition(
                                  position: anim1,
                                  child: Animator(
                                    tween: Tween<double>(begin: 0, end: 2 * 3.14),
                                    duration: Duration(seconds: 2),
                                    repeats: 0,
                                    builder: (anim) => Transform(
                                          transform: Matrix4.rotationY(anim.value),
                                          alignment: Alignment.center,
                                          child: Container(
                                            height: MediaQuery.of(context).size.height * 0.4,
                                            width: MediaQuery.of(context).size.width,
                                            child: CachedNetworkImage(
                                              imageUrl: _movie.imageUrl ?? "",
                                              fit: BoxFit.fitHeight,
                                              placeholder: (context, url) => new LoadingView(),
                                              errorWidget: (context, url, error) => new Icon(Icons.movie, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                          ),)) : Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: _movie.imageUrl ?? "",
                    fit: BoxFit.fitHeight,
                    placeholder: (context, url) => new LoadingView(),
                    errorWidget: (context, url, error) => new Icon(Icons.movie, color: Colors.white),
                  ),
                ),
                _isLogged ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: _isRented ? playButton() : rentButton(),
                    )) : Container()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.all(12.0),
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
                                      new Expanded(child: new AutoSizeText(_movie.polishTitle ?? "",
                                          minFontSize: 6.0,
                                          style: textTheme.title.copyWith(
                                              color: Colors.white), maxLines: 1))
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Expanded(child: new AutoSizeText(
                                          _movie.originalTitle ?? "",
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
                                    new Text(_movie.rating?.toInt()?.toStringAsFixed(1) ?? "-", style: textTheme.body2.copyWith(color: Colors.white))
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
                              Expanded(child: iconInfoRow(Icons.monetization_on, _movie.price?.toStringAsFixed(2) ?? "")),
                              Expanded(child: iconInfoRow(Icons.timelapse, "${_movie.duration ?? "0"} min")),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          new Row(
                            children: <Widget>[
                              Expanded(child: iconInfoRow(Icons.category, _movie.genere ?? "")),
                            ],
                          ),
                          new Divider(
                            color: Colors.white,
                          ),
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                  child: new Text(_movie.description ?? "",
                                      textAlign: TextAlign.justify,
                                      style: textTheme.body1.copyWith(
                                          color: Colors.white)))
                            ],
                          ),
                        ],
                      ),
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: new Row(
              children: <Widget>[
                new Expanded(child: new AutoSizeText(S.of(context).drawerComments,
                  style: textTheme.title.copyWith(
                      color: Colors.white), maxLines: 1,)),
                _isLogged ? new GestureDetector(
                    onTap: (){
                      setState(() {
                        addComment = !addComment;
                      });
                    },
                    child: Container(
                      width: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: addComment ? FFColors.colorPrimaryRed : FFColors.btnAccept,
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                        child: new Row(
                          children: <Widget>[
                            Icon(
                                addComment ? Icons.cancel : Icons.add_circle, color: Colors.white
                            ),
                            SizedBox(width: 4.0),
                            Flexible(
                              child: new AutoSizeText(addComment
                                  ? S.of(context).commonCancel.toUpperCase()
                                  : S.of(context).movieDetailsAddComment.toUpperCase(),
                                maxLines: 1,
                                minFontSize: 8.0,
                                style: textTheme.subtitle.copyWith(
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    )) : Container()
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: addComment ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1300),
            child: addComment ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSendComment(),
            ) : Container(),
          ),
          isLoadingComments ? LoadingView() : _buildCommentList()
        ],
      ),
    );
  }

  Widget _buildSendComment(){
    return Container(
      height: 100.0,
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
      margin: const EdgeInsets.only(bottom: 12.0),
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            new Column(
              children: <Widget>[
                StarRating(starCount: starCount, rating: _commentRate, onRatingChanged: (r){
                  setState(() {
                    _commentRate = r;
                  });
                }),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new TextField(
                            controller: _textEditingController,
                            style: textTheme.body1.copyWith(color: Colors.white),
                            onChanged: (text) {
                              _comment = text;
                            },
                            decoration: new InputDecoration(
                              hintText: S.of(context).movieDetailsCommentHint,
                              hintStyle: textTheme.body1.copyWith(color: Colors.white.withOpacity(0.6)),
                            ),
                          )),
                      new GestureDetector(
                        child: new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 8.0),
                          child: new Icon(
                            Icons.send,
                            color: FFColors.colorPrimaryRed,
                            size: 32.0,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isMessageSending = true;
                          });
                          ApiClient().postComment(_comment, _commentRate==0.0 ? null : _commentRate.toInt(), _movie).then((v){
                            setState(() {
                              isMessageSending = false;
                              addComment = false;
                              _comment = null;
                              _textEditingController.clear();
                              _commentRate = 0.0;
                            });
                            loadComments();
                            FlushbarUtils.show(context, message: S.of(context).movieDetailsCommentAdded, color: Colors.lightGreen, icon: Icons.check_circle);
                          }).catchError((e){
                            setState(() {
                              addComment = false;
                              isMessageSending = false;
                            });
                            FlushbarUtils.show(context, title: S.of(context).dialogErrorTitle, message: S.of(context).movieDetailsCommentNotAdded);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            isMessageSending ? new Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).size.width-12.0,
              height: 100.0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 3.0,
                    sigmaY: 3.0,
                  ),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        SpinKitWave(
                          color: FFColors.colorPrimaryRed,
                        ),
                        Text(S.of(context).movieDetailsAddingComment.toUpperCase(), style: textTheme.body2.copyWith(color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ),
            ) : Container()
          ],
        )
      ),
    );
  }

  double calculateNewRating(){
    int sum = 0;
    int l = 0;
    _commentList.forEach((c){
      if(c.rating!=null) {
        sum+=c.rating;
        l+=1;
      }
    });
    return sum/l;
  }
}


typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating({this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Colors.grey,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Colors.yellow,
      );
    }
    return new InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}