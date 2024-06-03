import 'package:detail_location_detector/domain/auth/entity/user_profile.dart';
import 'package:detail_location_detector/domain/location/entity/location.dart';
import 'package:detail_location_detector/domain/result.dart';
import 'package:detail_location_detector/domain/sensor/entity/sensor_data.dart';

abstract class DataRepository {

  Future<Result<UserProfile>> login(String email, String password);

  Future<Result<void>> logout();

  Future<Result<UserProfile>> register(String email, String password, String name);

  Future<Result<UserProfile>> getUser();

  Future<Result<bool>> isLogin();

  Future<Result<int>> getLuxValue();

  Future<Result<List<double?>>> getMagnetometer();

  Future<Result<int?>> getCellTowerValue();

  Future<Result<int?>> getWifiRssiValue();

  Future<Result<double?>> getPressureValue();

  Future<Result<SensorData>?> getCurrentSensorData();

  Future<Result<Location>?> getLocation();

}

