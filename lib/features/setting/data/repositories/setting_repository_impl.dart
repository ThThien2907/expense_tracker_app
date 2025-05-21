import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/features/setting/data/data_sources/setting_remote_datasource.dart';
import 'package:expense_tracker_app/features/setting/domain/repositories/setting_repository.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingRemoteDatasource settingRemoteDatasource;

  SettingRepositoryImpl(this.settingRemoteDatasource);

  @override
  Future<Either> loadCurrentUserSettings() async {
    final response = await settingRemoteDatasource.loadCurrentUserSettings();

    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> updateLanguage({
    required String language,
    required String userId,
  }) async {
    final response = await settingRemoteDatasource.updateLanguage(
      language: language,
      userId: userId,
    );

    return response.fold(
      (ifLeft) {
        return Left(ifLeft);
      },
      (ifRight) {
        return Right(ifRight);
      },
    );
  }

  @override
  Future<Either> updateCurrency({
    required String currency,
    required String userId,
  }) async {
    final response = await settingRemoteDatasource.updateCurrency(
      currency: currency,
      userId: userId,
    );

    return response.fold(
          (ifLeft) {
        return Left(ifLeft);
      },
          (ifRight) {
        return Right(ifRight);
      },
    );
  }
}
