// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rental _$RentalFromJson(Map<String, dynamic> json) {
  return Rental(
    json['rentalDate'] as String,
    json['rentalId'] as int,
    json['movie'] == null
        ? null
        : Movie.fromJson(json['movie'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RentalToJson(Rental instance) => <String, dynamic>{
      'rentalDate': instance.rentalDate,
      'rentalId': instance.rentalId,
      'movie': instance.movie,
      'user': instance.user,
    };
