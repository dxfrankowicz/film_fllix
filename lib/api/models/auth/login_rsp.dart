import 'package:json_annotation/json_annotation.dart';

part 'login_rsp.g.dart';

@JsonSerializable()
class LoginRsp {
  final String username;
  final String token;
  @JsonKey(name: "expires_in")
  final int expiresIn;
  @JsonKey(name: "expiration_date")
  DateTime expirationDate;

  LoginRsp(this.username, this.token, this.expiresIn, this.expirationDate);

  factory LoginRsp.fromJson(Map<String, dynamic> json) =>
      json != null ? _$LoginRspFromJson(json) : null;

  Map<String, dynamic> toJson() => _$LoginRspToJson(this);

  @override
  String toString() {
    return 'LoginRsp{username: $username, token: $token, expiresIn: $expiresIn, expirationDate: $expirationDate}';
  }


}
