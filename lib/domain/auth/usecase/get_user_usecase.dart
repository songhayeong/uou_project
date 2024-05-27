import 'package:detail_location_detector/domain/auth/entity/user_profile.dart';
import 'package:detail_location_detector/domain/data_repository.dart';
import 'package:detail_location_detector/domain/result.dart';
import 'package:detail_location_detector/domain/usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserUseCase implements UseCase<UserProfile, void> {
  final DataRepository _dataRepository;

  const GetUserUseCase(this._dataRepository);

  @override
  Future<UserProfile> call(void params, {required ResultErrorCallback onError}) async {
    final result = await _dataRepository.getUser();
    if (result is ResultError) {
      onError(result.error!);
    }
    return result.data!;
  }
}