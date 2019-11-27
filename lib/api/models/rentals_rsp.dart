import 'package:film_fllix/api/models/rental.dart';


class RentalsRsp {
  // ignore: conflicting_dart_import
  List<Rental> rentals;

  RentalsRsp(this.rentals);

  factory RentalsRsp.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      List<Rental> l = new List();
      for (var value in json) {
        l.add(new Rental.fromJson(value));
      }
      return new RentalsRsp(l);
    }
  }
}