// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['name'] as String,
    json['surname'] as String,
    json['login'] as String,
    json['password'] as String,
    json['userId'] as int,
    (json['comment'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['rentals'] as List)
        ?.map((e) =>
            e == null ? null : Rental.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['roles'] as List)
        ?.map(
            (e) => e == null ? null : Role.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'login': instance.login,
      'password': instance.password,
      'userId': instance.userId,
      'comment': instance.comment,
      'rentals': instance.rentals,
      'roles': instance.roles,
    };
