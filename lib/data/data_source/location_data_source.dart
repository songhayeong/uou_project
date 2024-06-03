
import 'dart:async';

import 'package:detail_location_detector/domain/location/entity/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@singleton
class LocationDataSource {

  const LocationDataSource();

  Future<Location> getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return Future.error("Location Permissions are denied");
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return Location(lat: position.latitude, lng: position.longitude, altitude: position.altitude);
  }
}