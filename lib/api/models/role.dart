import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
  final String role;

  Role(this.role);

  factory Role.fromJson(Map<String, dynamic> json) =>
      json != null ? _$RoleFromJson(json) : null;

  Map<String, dynamic> toJson() => _$RoleToJson(this);

}
