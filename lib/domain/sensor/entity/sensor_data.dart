class SensorData {
  final int lux;
  final int cellTowerValue;
  final int wifiRssiValue;
  final double atmosPressure;
  final double magX;
  final double magY;
  final double magZ;

  SensorData({
    required this.lux,
    required this.cellTowerValue,
    required this.wifiRssiValue,
    required this.atmosPressure,
    required this.magX,
    required this.magY,
    required this.magZ,
  });
}
