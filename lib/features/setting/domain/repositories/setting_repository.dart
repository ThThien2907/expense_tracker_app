import 'package:dartz/dartz.dart';

abstract class SettingRepository {
  Future<Either> loadCurrentUserSettings();

  Future<Either> updateLanguage({
    required String language,
    required String userId,
  });

  Future<Either> updateCurrency({
    required String currency,
    required String userId,
  });
}