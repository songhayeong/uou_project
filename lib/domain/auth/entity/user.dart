import 'package:detail_location_detector/domain/location/entity/location.dart';

class User {
  final String name;
  final Location location;

  User({required this.name, required this.location});

  factory User.fromMap(Map<String, dynamic> json) => User(
    name: json['name'],
    location: Location.fromMap(json['location'])
  );
}