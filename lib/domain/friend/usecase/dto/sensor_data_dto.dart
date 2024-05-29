class SensorDataDto {
  final int lux;
  final int cellTowerValue;
  final int wifiRssiValue;
  final double atmosPressure;
  final double magX;
  final double magY;
  final double magZ;

  const SensorDataDto(
      {required this.lux,
      required this.cellTowerValue,
      required this.wifiRssiValue,
      required this.atmosPressure,
      required this.magX,
      required this.magY,
      required this.magZ});
  // 이 객체를 통해서 센서 데이터를 주고 받아야함.
}
