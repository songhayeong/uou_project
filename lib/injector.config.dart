// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:detail_location_detector/data/data_repository_impl.dart' as _i8;
import 'package:detail_location_detector/data/data_source/auth_data_source.dart'
    as _i6;
import 'package:detail_location_detector/data/data_source/location_data_source.dart'
    as _i4;
import 'package:detail_location_detector/data/data_source/sensor_data_source.dart'
    as _i5;
import 'package:detail_location_detector/di/app_module.dart' as _i14;
import 'package:detail_location_detector/di/firebase_service.dart' as _i3;
import 'package:detail_location_detector/domain/auth/usecase/check_is_login_usecase.dart'
    as _i13;
import 'package:detail_location_detector/domain/auth/usecase/get_user_usecase.dart'
    as _i9;
import 'package:detail_location_detector/domain/auth/usecase/login_usecase.dart'
    as _i10;
import 'package:detail_location_detector/domain/auth/usecase/logout_usecase.dart'
    as _i11;
import 'package:detail_location_detector/domain/auth/usecase/register_usecase.dart'
    as _i12;
import 'package:detail_location_detector/domain/data_repository.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i3.FirebaseService>(
      () => appModule.firebaseService,
      preResolve: true,
    );
    gh.singleton<_i4.LocationDataSource>(() => const _i4.LocationDataSource());
    gh.singleton<_i5.SensorDataSource>(() => const _i5.SensorDataSource());
    gh.singleton<_i6.AuthDataSource>(
        () => _i6.AuthDataSource(gh<_i3.FirebaseService>()));
    gh.factory<_i7.DataRepository>(() => _i8.DataRepositoryImpl(
          gh<_i6.AuthDataSource>(),
          gh<_i5.SensorDataSource>(),
        ));
    gh.factory<_i9.GetUserUseCase>(
        () => _i9.GetUserUseCase(gh<_i7.DataRepository>()));
    gh.factory<_i10.LoginUseCase>(
        () => _i10.LoginUseCase(gh<_i7.DataRepository>()));
    gh.factory<_i11.LogoutUseCase>(
        () => _i11.LogoutUseCase(gh<_i7.DataRepository>()));
    gh.factory<_i12.RegisterUseCase>(
        () => _i12.RegisterUseCase(gh<_i7.DataRepository>()));
    gh.factory<_i13.CheckIsLoginUseCase>(() =>
        _i13.CheckIsLoginUseCase(dataRepository: gh<_i7.DataRepository>()));
    return this;
  }
}

class _$AppModule extends _i14.AppModule {}
