class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        lat: json['lat'],
        lng: json['lng'],
      );
}
