import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final String actors;
  final String description;
  final String genere;
  final int movieId;
  final String originalTitle;
  final String polishTitle;
  final num price;
  final String imageUrl;
  final int duration;
  double rating;
  @JsonKey(ignore: true, required: false)
  bool isRented;

  Movie(this.actors, this.description, this.genere, this.movieId,
      this.originalTitle, this.polishTitle, this.price, this.imageUrl, this.duration, this.rating);

  factory Movie.fromJson(Map<String, dynamic> json) =>
      json != null ? _$MovieFromJson(json) : null;

  Map<String, dynamic> toJson() => _$MovieToJson(this);

}
