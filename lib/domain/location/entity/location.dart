class Location {
  final double lat;
  final double lng;
  final double altitude;

  Location({required this.lat, required this.lng, required this.altitude});

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        lat: json['lat'],
        lng: json['lng'],
        altitude: json['altitude'],
      );
}
