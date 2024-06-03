import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detail_location_detector/data/data_source/location_data_source.dart';
import 'package:detail_location_detector/data/data_source/sensor_data_source.dart';
import 'package:detail_location_detector/di/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthDataSource {
  final FirebaseService _firebaseService;

  const AuthDataSource(this._firebaseService);

  // user class 중복발생 여기서는 firebase auth의 user를 사용해야함.
  Future<User> registerUser(String email, String password, String name) async {
    final UserCredential userCredential = await _firebaseService.auth
        .createUserWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference documentReference =
          firestore.collection('users').doc(user.uid);

      Map<String, dynamic> userData = {
        'uid': user.uid,
        'name': name,
        'email': user.email,
        'status': 'Unavailable',
        'current_sensor_data': {}
      };

      documentReference.set(userData);

      await user.updateDisplayName(name);
      await user.reload();
      User? updateUser = _firebaseService.auth.currentUser;

      if (updateUser == null) throw Exception('User registration failed');
      return updateUser;
    } else {
      throw Exception('User registration failed');
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseService.auth
        .signInWithEmailAndPassword(email: email, password: password);

    final User? user = userCredential.user;

    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      const _sensorDataSource =  SensorDataSource();

      const _locationDataSource = LocationDataSource();

      // var cellTowerValue = await _sensorDataSource.getCellTowerValue();

      var lux = await _sensorDataSource.getLigthValue();
      var wifiRssiValue = await _sensorDataSource.getWifiRssi();
      var atmosPressure = await _sensorDataSource.getAtmosPressure();
      var magnetometerValue = await _sensorDataSource.getMagnetometer();
      var currentLocation = await _locationDataSource.getCurrentLocation();

      var latitude = currentLocation.lat;
      var longitude = currentLocation.lng;
      var altitude = currentLocation.altitude;

      print('lux value = $lux');
      // print('cell tower value value = $cellTowerValue');
      print('wifi rssi value = $wifiRssiValue');
      print('atmos pressure value = $atmosPressure');
      print('magnetometer value = $magnetometerValue');

      print('current Location = $latitude $longitude $altitude');
      // 이게 들어오는지 확인 하려면 실제 기기가 있어야함.

      DocumentReference documentReference = firestore
          .collection('users')
          .doc(user.uid)
          .collection('sensor_data')
          .doc('current_data');

      DocumentReference documentReferenceLocation = firestore
          .collection('users')
          .doc(user.uid)
          .collection('location')
          .doc('current_location');

      Map<String, dynamic> currentSensorData = {
        'lux': lux,
        'wifi_rssi': wifiRssiValue,
        'atmos_pressure':atmosPressure,
        'cell_tower_value': 0,
        'mag_x':magnetometerValue[0],
        'mag_y':magnetometerValue[1],
        'mag_z':magnetometerValue[2],
      };

      Map<String, dynamic> currentLocationData = {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
      };

      documentReference.set(currentSensorData);

      documentReferenceLocation.set(currentLocationData);


      return user;
    } else {
      throw Exception('Sign in failed');
    }
  }

  Future<User> getCurrentUser() async {
    final User? user = _firebaseService.auth.currentUser;

    if (user != null) {
      return user;
    } else {
      throw Exception('No user logged in');
    }
  }

  Future<bool> isSignedIn() async {
    final User? user = _firebaseService.auth.currentUser;
    return user != null;
  }

  Future<void> signOut() => _firebaseService.auth.signOut();
}
