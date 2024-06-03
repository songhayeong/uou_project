import 'package:detail_location_detector/domain/auth/entity/user_profile.dart';
import 'package:detail_location_detector/domain/auth/usecase/get_user_usecase.dart';
import 'package:detail_location_detector/domain/result.dart';
import 'package:detail_location_detector/injector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetUserNotifier extends StateNotifier {

  GetUserNotifier() : super(GetUserState.initial());

  Future<UserProfile> getUser(void params) async {
    state = GetUserState.loading();
    final getUserUseCase = locator<GetUserUseCase>();
    final result = await getUserUseCase(params, onError: (error) {
      state = GetUserState.error(error.toString());
    });

    state = GetUserState.success(result);
    return state;
  }

}

final locationNotifierProvider = StateNotifierProvider((_) => GetUserNotifier());

class GetUserState {
  final bool isLoading;
  final UserProfile? userProfile;
  final String? errorMessage;

  GetUserState({
    this.isLoading = false,
    this.userProfile,
    this.errorMessage,
  });

  factory GetUserState.initial() => GetUserState();

  factory GetUserState.loading() => GetUserState(isLoading: true);

  factory GetUserState.success(UserProfile userProfile) =>
      GetUserState(userProfile: userProfile);

  factory GetUserState.error(String errorMessage) =>
      GetUserState(errorMessage: errorMessage);
}
