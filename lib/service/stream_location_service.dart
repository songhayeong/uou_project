import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class StreamLocationService {
  static const LocationSettings _locationSettings = LocationSettings(distanceFilter: 1);
  static bool _isLocatinoGranted = false;

  static Stream<Position>? get onLocatinoChanged {
    if (_isLocatinoGranted) {
      return Geolocator.getPositionStream(locationSettings: _locationSettings);
    }
    return null;
  }

  static Future<bool> askLocationPermission() async {
    _isLocatinoGranted = await Permission.location.request().isGranted;
    return _isLocatinoGranted;
  }
}