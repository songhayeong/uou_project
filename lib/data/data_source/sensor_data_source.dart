import 'dart:async';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:light/light.dart';
import 'package:sensors_plus/sensors_plus.dart';

const platform = MethodChannel('example.com/wifi_signal_strength');

@singleton
class SensorDataSource {
  const SensorDataSource();

  // parameter로 필요한 값이 존재하는가 ? 일단 모르겠음.

  int getLuxValue(int luxValue) {
    return luxValue; // 얘네들은 테스트 해봐야함.
  }

  void startListening() {
    final light = Light();
    try {
      final subscription = light.lightSensorStream.listen(getLuxValue);
    } on LightException catch (e) {
      print(e.toString());
    }
  }

  Future<int> getLigthValue() async {
    final light = Light();
    int lux = await light.lightSensorStream.first;
    return lux;
  }

  List<double> getMagnetometer() {
    List<double> mag = [];
    magnetometerEvents.listen((event) {
      mag.add(event.x);
      mag.add(event.y);
      mag.add(event.z);
    });
    return mag;
  }

  Future<double> getAtmosPressure() {
    final environmentSensors = EnvironmentSensors();
    return environmentSensors.pressure.first;
  }

  Future<int?> getWifiRssi() async {
    try {
      final int getWifiRssi = await platform.invokeMethod('getValue');
      return getWifiRssi;
    } on PlatformException catch (error) {
      print("Failed to get wifi signal strength ${error.message}");
      return null;
    }
  }

  Future<int?> getCellTowerValue() async {
    try {
      final int getCellularSignal = await platform.invokeMethod('getCellular');
      return getCellularSignal;
    } on PlatformException catch (error) {
      print("Failed to get cellular signal strength : ${error.message}");
      return null;
    }
  }
}
