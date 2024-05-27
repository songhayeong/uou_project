import 'package:detail_location_detector/domain/data_repository.dart';
import 'package:detail_location_detector/domain/result.dart';
import 'package:detail_location_detector/domain/usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckIsLoginUseCase implements UseCase<bool, void> {
  final DataRepository _dataRepository;

  CheckIsLoginUseCase({required DataRepository dataRepository}) : _dataRepository = dataRepository;

  @override
  Future<bool> call(void params, {required ResultErrorCallback onError}) async {
    final result = await _dataRepository.isLogin();
    if (result is ResultError) {
      onError(result.error!);
    }
    return result.data!;
  }

}