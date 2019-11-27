import 'package:film_fllix/api/models/comment.dart';
import 'package:film_fllix/api/models/rental.dart';
import 'package:film_fllix/api/models/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String surname;
  final String login;
  final String password;
  final int userId;
  List<Comment> comment;
  List<Rental> rentals;
  List<Role> roles;

  User(this.name, this.surname, this.login, this.password,
      this.userId, this.comment, this.rentals, this.roles);

  factory User.fromJson(Map<String, dynamic> json) =>
      json != null ? _$UserFromJson(json) : null;

  Map<String, dynamic> toJson() => _$UserToJson(this);

}
