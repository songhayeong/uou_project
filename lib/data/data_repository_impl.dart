import 'package:detail_location_detector/data/data_source/auth_data_source.dart';
import 'package:detail_location_detector/domain/auth/entity/user_profile.dart';
import 'package:detail_location_detector/domain/data_repository.dart';
import 'package:detail_location_detector/domain/result.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DataRepository)
class DataRepositoryImpl implements DataRepository {
  final AuthDataSource _authDataSource;

  DataRepositoryImpl(this._authDataSource);

  @override
  Future<Result<UserProfile>> getUser() => executeSafe(() async {
        final user = await _authDataSource.getCurrentUser();
        return UserProfile(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      });

  @override
  Future<Result<bool>> isLogin() => executeSafe(() async {
    final isSignedIn = await _authDataSource.isSignedIn();
    return isSignedIn;
  });

  @override
  Future<Result<UserProfile>> login(String email, String password) =>
      executeSafe(() async {
        final user =
            await _authDataSource.signInWithEmailAndPassword(email, password);
        return UserProfile(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      });

  @override
  Future<Result<void>> logout() => executeSafe(() async {
        await _authDataSource.signOut();
      });

  @override
  Future<Result<UserProfile>> register(
          String email, String password, String name) =>
      executeSafe(() async {
        final user = await _authDataSource.registerUser(email, password, name);
        return UserProfile(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      });
}
