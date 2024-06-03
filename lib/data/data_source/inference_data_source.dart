import 'package:detail_location_detector/domain/friend/usecase/dto/sensor_data_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

@singleton
class InferenceDataSource {
  const InferenceDataSource();

// 이때 sensor data dto의 entity를 통해 데이터를 전달 받고 그 data를 사용하면 될듯 싶다.

  Future<void> loadedModel(SensorDataDto dataDto) async {
    final interpreter =
        await Interpreter.fromAsset('assets/tf_model/ConcatDense1.tflite');
    var input = [
      [
        dataDto.lux,
        dataDto.cellTowerValue,
        dataDto.wifiRssiValue,
        dataDto.atmosPressure,
        dataDto.magX,
        dataDto.magY,
        dataDto.magZ,
      ]
    ];
    List<dynamic> output = List.filled(1 * 3, 0).reshape([1, 3]);
    interpreter.run(input, output);
    print(output);
  }

  Future<dynamic> loadedGoogleModel(double altitude, double earthNum) async {
    final interpreter =
    await Interpreter.fromAsset('assets/tf_model/ConcatDense_PredFloor.tflite');

      var input = [altitude, earthNum];
      var output = List.filled(1*1, 0).reshape([1,1]);
      interpreter.run(input, output);
      print(output[0][0]);
      var outputFloor = output[0][0];

      // 이 데이터를 가공해서 다시 return 할지 그대로 return 할지...
      return outputFloor;
  }
}
