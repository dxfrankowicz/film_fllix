import 'package:film_fllix/api/models/user.dart';

class Access {
  final User user;

  Access(this.user);

  factory Access.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      return new Access(
          User.fromJson(json),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return this.user.toJson();
  }
}
