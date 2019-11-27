// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return Movie(
    json['actors'] as String,
    json['description'] as String,
    json['genere'] as String,
    json['movieId'] as int,
    json['originalTitle'] as String,
    json['polishTitle'] as String,
    json['price'] as num,
    json['imageUrl'] as String,
    json['duration'] as int,
    (json['rating'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'actors': instance.actors,
      'description': instance.description,
      'genere': instance.genere,
      'movieId': instance.movieId,
      'originalTitle': instance.originalTitle,
      'polishTitle': instance.polishTitle,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'duration': instance.duration,
      'rating': instance.rating,
    };
