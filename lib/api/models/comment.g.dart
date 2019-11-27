// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    json['comment'] as String,
    json['commentId'] as int,
    json['data'] as String,
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['movie'] == null
        ? null
        : Movie.fromJson(json['movie'] as Map<String, dynamic>),
    json['rating'] as int,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'comment': instance.comment,
      'commentId': instance.commentId,
      'data': instance.data,
      'user': instance.user,
      'movie': instance.movie,
      'rating': instance.rating,
    };
