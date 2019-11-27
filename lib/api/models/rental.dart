import 'package:film_fllix/api/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'movie.dart';
part 'rental.g.dart';

@JsonSerializable()
class Rental {
  final String rentalDate;
  final int rentalId;
  final Movie movie;
  final User user;

  Rental(this.rentalDate, this.rentalId, this.movie, this.user);

  factory Rental.fromJson(Map<String, dynamic> json) =>
      json != null ? _$RentalFromJson(json) : null;

  Map<String, dynamic> toJson() => _$RentalToJson(this);

}
