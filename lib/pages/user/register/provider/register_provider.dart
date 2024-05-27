import 'package:detail_location_detector/domain/auth/usecase/dto/register_dto.dart';
import 'package:detail_location_detector/domain/auth/usecase/register_usecase.dart';
import 'package:detail_location_detector/injector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// 제출 부분
class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState.initial());

  Future<void> register(RegisterDto dto) async {
    state = RegisterState.loading();
    final registerUseCase = locator<RegisterUseCase>();
    await registerUseCase(dto, onError: (error) {
      state = RegisterState.error(error.toString());
    });
    state = RegisterState.success();
  }
}

final registerNotifierProvider =
StateNotifierProvider<RegisterNotifier, RegisterState>(
        (_) => RegisterNotifier());

class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const RegisterState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  factory RegisterState.initial() => const RegisterState();

  factory RegisterState.loading() => const RegisterState(isLoading: true);

  factory RegisterState.success() => const RegisterState(isSuccess: true);

  factory RegisterState.error(String errorMessage) =>
      RegisterState(errorMessage: errorMessage);
}
