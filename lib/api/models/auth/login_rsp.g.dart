// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_rsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRsp _$LoginRspFromJson(Map<String, dynamic> json) {
  return LoginRsp(
    json['username'] as String,
    json['token'] as String,
    json['expires_in'] as int,
    json['expiration_date'] == null
        ? null
        : DateTime.parse(json['expiration_date'] as String),
  );
}

Map<String, dynamic> _$LoginRspToJson(LoginRsp instance) => <String, dynamic>{
      'username': instance.username,
      'token': instance.token,
      'expires_in': instance.expiresIn,
      'expiration_date': instance.expirationDate?.toIso8601String(),
    };
