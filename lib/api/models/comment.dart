import 'package:film_fllix/api/models/movie.dart';
import 'package:film_fllix/api/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String comment;
  final int commentId;
  final String data;
  final User user;
  final Movie movie;
  final int rating;

  Comment(this.comment, this.commentId, this.data, this.user, this.movie, this.rating);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      json != null ? _$CommentFromJson(json) : null;

  Map<String, dynamic> toJson() => _$CommentToJson(this);

}