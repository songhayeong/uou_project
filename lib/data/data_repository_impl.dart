import 'package:detail_location_detector/data/data_source/auth_data_source.dart';
import 'package:detail_location_detector/data/data_source/sensor_data_source.dart';
import 'package:detail_location_detector/domain/auth/entity/user_profile.dart';
import 'package:detail_location_detector/domain/data_repository.dart';
import 'package:detail_location_detector/domain/location/entity/location.dart';
import 'package:detail_location_detector/domain/result.dart';
import 'package:detail_location_detector/domain/sensor/entity/sensor_data.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DataRepository)
class DataRepositoryImpl implements DataRepository {
  final AuthDataSource _authDataSource;
  final SensorDataSource _sensorDataSource;

  DataRepositoryImpl(this._authDataSource, this._sensorDataSource);

  @override
  Future<Result<UserProfile>> getUser() => executeSafe(() async {
        final user = await _authDataSource.getCurrentUser();
        return UserProfile(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      });

  @override
  Future<Result<bool>> isLogin() => executeSafe(() async {
        final isSignedIn = await _authDataSource.isSignedIn();
        return isSignedIn;
      });

  @override
  Future<Result<UserProfile>> login(String email, String password) =>
      executeSafe(() async {
        final user =
            await _authDataSource.signInWithEmailAndPassword(email, password);
        return UserProfile(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      });

  @override
  Future<Result<void>> logout() => executeSafe(() async {
        await _authDataSource.signOut();
      });

  @override
  Future<Result<UserProfile>> register(
          String email, String password, String name) =>
      executeSafe(() async {
        final user = await _authDataSource.registerUser(email, password, name);
        return UserProfile(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      });

  @override
  Future<Result<int?>> getCellTowerValue() => executeSafe(() async {
        final cellTowerValue = await _sensorDataSource.getCellTowerValue();
        return cellTowerValue;
      });

  @override
  Future<Result<int?>> getWifiRssiValue() => executeSafe(() async {
        final wifiRssi = await _sensorDataSource.getWifiRssi();
        return wifiRssi;
      });

  @override
  Future<Result<int>> getLuxValue() => executeSafe(() async {
        final luxValue = await _sensorDataSource.getLigthValue();
        return luxValue;
      });

  @override
  Future<Result<List<double>>> getMagnetometer() => executeSafe(() async {
    final magnetometer = _sensorDataSource.getMagnetometer();
    return magnetometer;
  });

  @override
  Future<Result<double>> getPressureValue() => executeSafe(() async {
    final atmosPressure = _sensorDataSource.getAtmosPressure();
    return atmosPressure;
  });

  // @override
  // Future<Result<SensorData>?> getCurrentSensorData() {
  //   // TODO: implement getCurrentSensorData
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<Result<Location>?> getLocation() {
  //   // TODO: implement getLocation
  //   throw UnimplementedError();
  // }

}
