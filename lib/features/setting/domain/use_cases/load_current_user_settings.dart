import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/usecase/usecase.dart';
import 'package:expense_tracker_app/features/setting/domain/repositories/setting_repository.dart';

class LoadCurrentUserSettings extends UseCase<Either, NoParams>{
  final SettingRepository settingRepository;

  LoadCurrentUserSettings(this.settingRepository);

  @override
  Future<Either> call({NoParams? params}) async {
    final response = await settingRepository.loadCurrentUserSettings();

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