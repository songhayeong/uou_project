class UserAndSensor {
  final double altitude;
  final double atmosPressure;
  final int cellTowerValue;
  final String email;
  final bool isAdmin;
  final double latitude;
  final double longitude;
  final int lux;
  final double magX;
  final double magY;
  final double magZ;
  final String name;
  final String uid;
  final int wifiRssi;

  UserAndSensor({
    required this.altitude,
    required this.atmosPressure,
    required this.cellTowerValue,
    required this.email,
    required this.isAdmin,
    required this.latitude,
    required this.longitude,
    required this.lux,
    required this.magX,
    required this.magY,
    required this.magZ,
    required this.name,
    required this.uid,
    required this.wifiRssi,
  });

  factory UserAndSensor.fromMap(Map<String, dynamic> json) => UserAndSensor(
    altitude: json['altitude'],
    atmosPressure: json['atmos_pressure'],
    cellTowerValue: json['cell_tower_value'],
    email: json['email'],
    isAdmin: json['isAdmin'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    lux: json['lux'],
    magX: json['mag_x'],
    magY: json['mag_y'],
    magZ: json['mag_z'],
    name: json['name'],
    uid: json['uid'],
    wifiRssi: json['wifi_rssi']
  );
}
