import 'package:detail_location_detector/domain/auth/entity/user_profile.dart';
import 'package:detail_location_detector/domain/auth/usecase/dto/login_dto.dart';
import 'package:detail_location_detector/domain/auth/usecase/login_usecase.dart';
import 'package:detail_location_detector/injector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState.initial());
  
  Future<void> login(LoginDto dto) async {
    state = LoginState.loading();
    final loginUseCase = locator<LoginUseCase>();
    final result = await loginUseCase(dto, onError: (error) {
      state = LoginState.error(error.toString());
    });

    state = LoginState.success(result);
  }
}

final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>((_) => LoginNotifier());

class LoginState {
  final bool isLoading;
  final UserProfile? userProfile;
  final String? errorMessage;

  LoginState({
    this.isLoading = false,
    this.userProfile,
    this.errorMessage,
  });

  factory LoginState.initial() => LoginState();

  factory LoginState.loading() => LoginState(isLoading: true);

  factory LoginState.success(UserProfile userProfile) =>
      LoginState(userProfile: userProfile);

  factory LoginState.error(String errorMessage) =>
      LoginState(errorMessage: errorMessage);
}
